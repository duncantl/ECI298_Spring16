
u = "http://www.cnrfc.noaa.gov/ensembleProduct.php?id=EXQC1&prodID=6"
tt = readHTMLTable(u, encoding = "UTF8")
length(tt)




tt = readHTMLTable(u, encoding = "UTF8", which = 8)




doc = htmlParse(u, encoding = "UTF8")
tblNode = getNodeSet(doc, "//table[ contains(tr[1], 'Monthly Streamflow Volume')]")[[ 1 ]] # the only table in the result




removeNodes(tblNode[[1]])




tblNode[[1]]

<tr>
  <td width="5%" bgcolor="#666666" align="center" class="blue-background">
    <b>Prob</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Jun</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Jul</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Aug</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Sep</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Oct</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Nov</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Dec</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Jan</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Feb</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Mar</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Apr</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> May</b>
  </td>
</tr>





tblNode[[ xmlSize(tblNode) ]]

<tr>
  <td colspan="13" align="left" bgcolor="#FFFFFF" class="normalText">Note: MP/Avg is the "Most Probable Monthly Value (50%)" divided by the "Monthly Avg" (displayed as a %)</td>
</tr> 





removeNodes( tblNode[[ xmlSize(tblNode) ]] )




tt = readHTMLTable(tblNode, colClasses = c("character", rep("numeric", 12)))

