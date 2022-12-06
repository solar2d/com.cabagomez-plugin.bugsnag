# com.cabagomez-plugin.bugsnag

1. Add the plugin to your project:   
```
["plugin.bugsnag"] = 
    {
        publisherId = "com.cabagomez",
        supportedPlatforms = { ["android"] = true }
    }

```    
2. Add your bugsnag key to the build settings:
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
2. Init plugin.
```
local bugsnag = require( "plugin.bugsnag")
bugsnag.init( <Listerner> ) -- Nothing gets returnd by listerner at this time, but please provide.
```    
3. Send breadcrumb (optional)    
```
bugsnag.leaveBreadcrumb( "<stringofbreadcrumb>" ) -- A scene name, an ad shown.
```
4. Create an exception (optional and please don't deploy with this implemented)    
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