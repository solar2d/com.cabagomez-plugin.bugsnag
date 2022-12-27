# com.cabagomez-plugin.bugsnag
NOTE: The iOS version is currently in testing. I will remove this note once I have completed my testing.

1. Add the plugin to your project:   
```
["plugin.bugsnag"] = 
    {
        publisherId = "com.cabagomez"
    }

```    
2. Add your bugsnag key to the build settings:
For Android:
```    
applicationChildElements =
        {
            [[
                <meta-data android:name="com.bugsnag.android.API_KEY"
             android:value="<your api key>"/>
            ]],

            -- Other stuff you might already have.
        }
```    
For iOS and to your plist:
```
        plist =
		{
            bugsnag = {
                apiKey = "xxxxxxxxYourAPIKeyxxxxxxxx"
            },
        }
```   
3. Init plugin.
```
local bugsnag = require( "plugin.bugsnag")
bugsnag.init( <Listerner> ) -- Nothing gets returnd by listerner at this time, but please provide.
```    
4. Send breadcrumb (optional)    
```
bugsnag.leaveBreadcrumb( "<stringofbreadcrumb>" ) -- A scene name, an ad shown.
```
5. Create an exception (optional and please don't deploy with this implemented)    
```
bugsnag.crash()

```


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.