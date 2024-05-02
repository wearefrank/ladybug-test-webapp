/*
   Copyright 2024 WeAreFrank!

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
package nl.nn.testtool.storages;

public class ErrorGeneratingStorage extends nl.nn.testtool.storage.memory.Storage {
    public ErrorGeneratingStorage() {
        super();
    }

    @Override
    public String getWarningsAndErrors() {
        return "A simulated error, should show up in the Ladybug GUI";
    }
}
