# Copyright (c) 2016 HomeAway.com, Inc.
# All rights reserved.  http://www.homeaway.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module HomeAway
  module Storm
    # A container around the response that the Storm API returns.
    # This object extends Hashie::Mash and can be accessed in an identical method
    class Response < Hashie::Mash

      # @private
      def convert_key(key) #:nodoc:
        if key.to_s.include? '_' #naive way of detecting snake case
          HomeAway::Storm::Util::Validators.camel_case(key) #for reads
        else
          HomeAway::Storm::Util::Validators.snake_case(key) #for writes
        end
      end

      # a helper method to determine if this response has
      # any particular fields in its payload, potentially
      # nested
      #
      # @param attrs [Symbol] one or more symbols to search into this response with
      def has?(*attrs)
        entity = self
        attrs.each do |attr|
          return false unless entity.has_key?(attr.to_sym)
          entity = entity.send(attr.to_sym)
        end
        true
      end

      # Returns information about the request that was just made. This includes
      # things such as connection headers and status code
      # @return [HomeAway::Storm::Response] information about the request that was made
      def _metadata
        @metadata ||= HomeAway::Storm::Response.new
      end
    end
  end
end