<aside class="right-side">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			Manage Access
			<small>User Access Management</small>
		</h1>
		<ol class="breadcrumb">
			<li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
			<li class="active">Manage Access</li>
		</ol>
	</section>

	<!-- Main content -->
	<section class="content">

		<!-- Small boxes (Stat box) -->
		<div class="row">
			 <!--Table -->
			 <table id="tblAccess" style="width:70%;margin-left:10px;" border="1">
			  	<thead>
				    <tr>
				    	<th style="text-align:center;">User Name</th>
				    	<th style="text-align:center;">Page Name</th>
					    <th style="text-align:center;">Action</th>
				  	</tr>
				</thead>
				<tbody>
					<tr id="iTemplateAcc"style="display:none" class="loop">
						<input type="hidden" class="hdnUserID" />
						<td class="iUser" style="text-align:center;">
							<select class="ddlUser"></select>
						</td>
						<td class="iPage" style="text-align:center;">
							<select class="ddlPage"></select>
						</td>
						<td class="iAction" style="text-align:center;">
							<a style="cursor:pointer;" class="btnDeleteAccess">Delete</a>
						</td>
					</tr>
				 </tbody>
			</table>
			<!-- End Of Table -->
		</div><!-- /.row -->

	</section><!-- /.content -->
</aside><!-- /.right-side -->

<script src="../../dwhproject/media/js/ContentJS/manageAccess.js"></script>
