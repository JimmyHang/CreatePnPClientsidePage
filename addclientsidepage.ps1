###############
##Add a new client side welcome page, using PnP PowerShell
########
##Connecting to site
$tenant = ‘tenant’
Connect-PnPOnline -Url https://$tenant.sharepoint.com/sites/sitename -Credentials ‘YourCredentials”

#Set variable pagename
$pagename = “Welcome”

#Add 3 new sections to the page
$page = Add-PnPClientSidePage -Name $pagename -LayoutType Home #Using layouttype Home, removes the title and banner zone
Add-PnPClientSidePageSection -Page $page -SectionTemplate OneColumnFullWidth -Order 1 ##OneColumnFullWidth is only available if the site is a Communication site
Add-PnPClientSidePageSection -Page $page -SectionTemplate TwoColumn -Order 2
Add-PnPClientSidePageSection -Page $page -SectionTemplate OneColumn -Order 3

#Add Hero webpart to page
Add-PnPClientSideWebPart -Page $page -DefaultWebPartType “Hero” -Section 1 -Column 1

#Add List webpart to the page, currently we need to provide the List-GUID,
Add-PnPClientSideWebPart -Page $page -DefaultWebPartType “List” -Section 2 -Column 1 -WebPartProperties @{selectedListId=”754c3e51-b7ba-4fbd-8680-fefa77330acc”}

#Add text webpart to page
Add-PnPClientSideText -Page $page -Text “Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue mass a. Fusce posuere, magna sed pulvinar ultricies, purus lectus malesuada libero, sit amet commodo magna eros quis urna.” -Section 2 -Column 1

#Add the list webpart to the page, but stating that it’s a document library then add the library GUID
Add-PnPClientSideWebPart -Page $page -DefaultWebPartType “List” -Section 2 -Column 2 -WebPartProperties @{isDocumentLibrary=”true”;selectedListId=”4546de9f-af03-422f-b396-2be87f3be59d”}

#Add more text to page
Add-PnPClientSideText -Page $page -Text “Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue mass a. Fusce posuere, magna sed pulvinar ultricies, purus lectus malesuada libero, sit amet commodo magna eros quis urna.” -Section 2 -Column 2

#Add the default News webpart
Add-PnPClientSideWebPart -Page $page -DefaultWebPartType “NewsFeed” -Section 3 -Column 1 -WebPartProperties @{layoutId=”GridNews”;title=”News”}

#Add the default event webpart
Add-PnPClientSideWebPart -Page $page -DefaultWebPartType “Events” -Section 3 -Column 1 -WebPartProperties @{layoutId=”FilmStrip”;title=”Upcoming Events”}

#Add the default Highlighted content webpart,
Add-PnPClientSideWebPart -Page $page -DefaultWebPartType “ContentRollup” -Section 3 -column 1 -WebPartProperties @{layoutId=”FilmStrip”;title=”Recently Updated Documents”}

#Set the new clientside page as HomePage and Publish
Set-PnPHomePage -RootFolderRelativeUrl SitePages/$pagename.aspx
Set-PnPClientSidePage -Identity $page -Publish

#The Hero Webpart is still a mystery to me, to Add Content to it I’ve set the PropertiesJson using PnP, but it’s not working the way I wan’t it to yet.
#Simply create another page with Hero webpart on it, extract and resuse the PropertiesJson
$welcomePage = Get-PnPClientSidePage -Identity $pagename
$heroWebPart = $welcomePage.Controls | ? {$_.Title -eq “Hero”}
$heroWebPart.PropertiesJson = ‘{“layoutCategory”:1,”layout”:2,”content”:[{“id”:”abaaab59-08b6-4e5b-a9f7-2b0b96220acd”,”type”:”Web Page”,”color”:4,”description”:””,”showDescription”:false,”showTitle”:true,”imageDisplayOption”:3,”isDefaultImage”:false,”showCallToAction”:false,”isDefaultImageLoaded”:false,”isCustomImageLoaded”:true,”showFeatureText”:false,”previewImage”:{“siteId”:”84a6b67f-2f2b-4b7f-9753-c23c33beca65″,”webId”:”13849cfb-c0e9-4d81-b999-b4efb97e98b1″,”listId”:”181c23ab-6ad7-4770-93d4-cba07d659092″,”id”:”{5B41EDAB-4A2E-4877-988D-90EE8593961D}”},”image”:{“siteId”:”84a6b67f-2f2b-4b7f-9753-c23c33beca65″,”webId”:”13849cfb-c0e9-4d81-b999-b4efb97e98b1″,”listId”:”89a15b2f-54e1-4142-8bec-b4b624d67be3″,”id”:”{51661A7C-623F-4AD2-B19A-8A27F2448DA9}”}},{“id”:”98216f06-d02b-4056-a606-9c78854899cb”,”type”:”UrlLink”,”color”:5,”description”:””,”showDescription”:false,”showTitle”:true,”imageDisplayOption”:2,”isDefaultImage”:false,”showCallToAction”:false,”isDefaultImageLoaded”:false,”isCustomImageLoaded”:true,”showFeatureText”:false,”previewImage”:{},”image”:{“siteId”:”84a6b67f-2f2b-4b7f-9753-c23c33beca65″,”webId”:”13849cfb-c0e9-4d81-b999-b4efb97e98b1″,”listId”:”89a15b2f-54e1-4142-8bec-b4b624d67be3″,”id”:”{FB7042CB-A331-4653-8F55-8CA559660398}”}},{“id”:”d277c086-5636-4bc7-a1f9-7e9648a24ad1″,”type”:”Image”,”color”:4,”description”:””,”showDescription”:false,”showTitle”:true,”imageDisplayOption”:0,”isDefaultImage”:false,”showCallToAction”:false,”isDefaultImageLoaded”:false,”isCustomImageLoaded”:false,”showFeatureText”:false},{“id”:”d9c4117c-3b6d-42bc-b791-0e7517edb99d”,”type”:”Image”,”color”:4,”description”:””,”showDescription”:false,”showTitle”:true,”imageDisplayOption”:0,”isDefaultImage”:false,”showCallToAction”:false,”isDefaultImageLoaded”:false,”isCustomImageLoaded”:false,”showFeatureText”:false},{“id”:”a2dd8929-1a05-4e3a-9f50-ecb9c0b6e81f”,”type”:”Image”,”color”:4,”description”:””,”showDescription”:false,”showTitle”:true,”imageDisplayOption”:0,”isDefaultImage”:false,”showCallToAction”:false,”isDefaultImageLoaded”:false,”isCustomImageLoaded”:false,”showFeatureText”:false}],”isFullWidth”:true}’
$welcomePage.Save()
