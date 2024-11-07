<script>
	// Define state tab index value
	var statesTab = 10;
	// Do not enforce state input client side
	var stateNotRequired = true;
</script>
<script type="text/javascript" src="{$WEB_ROOT}/templates/orderforms/{$carttpl}/js/intlTelInput.min.js"></script>
<script type="text/javascript" src="{$WEB_ROOT}/templates/orderforms/{$carttpl}/js/scripts.min.js?v={$versionHash}"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdown.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/PasswordStrength.js"></script>

<script>
	window.langPasswordStrength = "{$LANG.pwstrength}";
	window.langPasswordWeak = "{$LANG.pwstrengthweak}";
	window.langPasswordModerate = "{$LANG.pwstrengthmoderate}";
	window.langPasswordStrong = "{$LANG.pwstrengthstrong}";
</script>

{if $errormessage}
	<div class="alert alert-danger checkout-error-feedback" role="alert">
		<p>{$LANG.orderForm.correctErrors}:</p>
		<ul>
			{$errormessage}
		</ul>
	</div>
	<div class="clearfix"></div>
{/if}

<form method="post" name="orderfrm" id="frmCheckout">
	<input type="hidden" name="submit" value="true" />
	<input type="hidden"  id="loggedin" value="{$loggedin}" />
	<input type="hidden" name="custtype" id="inputCustType" value="{$custtype}" />

	<div class="customer_error" style="display: none;"></div>
	<div class="TM-card blocks customerinfo">
		<div class="blocks_heading">
			<h2>{$LANG.billingdetails}</h2>
		</div>
		<div class="blocks_body" id="customer_info">
		
			{if $custtype neq "new" && $loggedin}
				<div class="sub-heading">
					<span>
						{lang key='switchAccount.title'}
					</span>
				</div>
				<div id="containerExistingAccountSelect" class="row account-select-container">
					{foreach $accounts as $account}
						<div class="col-sm-{if $accounts->count() == 1}12{else}6{/if}">
							<div class="account{if $selectedAccountId == $account->id} active{/if}">
								<label class="radio-inline" for="account{$account->id}">
									<input id="account{$account->id}" class="account-select{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled{/if}" type="radio" name="account_id" value="{$account->id}"{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled="disabled"{/if}{if $selectedAccountId == $account->id} checked="checked"{/if}>
									<span class="address">
										<strong>
											{if $account->company}{$account->company}{else}{$account->fullName}{/if}
										</strong>
										{if $account->isClosed || $account->noPermission}
											<span class="label label-default">
												{if $account->isClosed}
													{lang key='closed'}
												{else}
													{lang key='noPermission'}
												{/if}
											</span>
										{elseif $account->currencyCode}
											<span class="label label-info">
												{$account->currencyCode}
											</span>
										{/if}
										<br>
										<span class="small">
											{$account->address1}{if $account->address2}, {$account->address2}{/if}<br>
											{if $account->city}{$account->city},{/if}
											{if $account->state} {$account->state},{/if}
											{if $account->postcode} {$account->postcode},{/if}
											{$account->countryName}
										</span>
									</span>
								</label>
							</div>
						</div>
					{/foreach}
					<div class="col-sm-12">
						<div class="account border-bottom{if !$selectedAccountId || !is_numeric($selectedAccountId)} active{/if}">
							<label class="radio-inline">
								<input class="account-select" type="radio" name="account_id" value="new"{if !$selectedAccountId || !is_numeric($selectedAccountId)} checked="checked"{/if}{if $inExpressCheckout} disabled="disabled" class="disabled"{/if}>
								{lang key='orderForm.createAccount'}
							</label>
						</div>
					</div>
				</div>
			{/if}
			{if !$loggedin}
				<div class="user_option">
					<ul>
						<li>
							<label for="newcust">
								<input type="radio" class="no-icheck signups" value="new" name="custtype" {if !$loggedin && $custtype neq "existing"}checked="checked"{/if} id="newcust" onclick="togglesignupform(this);"/>
								<span class="sign-btn">{$LANG.orderForm.createAccount}</span>
							</label>
						</li>
						<li>
							<label for="existingcust">
								<input type="radio" class="no-icheck signups" value="existing" name="custtype" {if $custtype eq "existing" && !$loggedin || $loggedin}checked="checked"{/if} id="existingcust" onclick="togglesignupform(this);"/>
								<span class="sign-btn">{$LANG.orderForm.alreadyRegistered}</span>
							</label>
						</li>
					</ul>
				</div>
			{/if}
			<div class="signupfields signupfields-existing{if $custtype eq "existing" && !$loggedin}{else} w-hidden{/if}" id="loginfrm">             
				
				<h5>{$LANG.orderForm.existingCustomerLogin}</h5>
				
				<div class="row">
					<div class="col-md-5">
						<div class="form-group prepend-icon">
							<label for="inputLoginEmail" class="field-icon">
								<i class="fas fa-envelope"></i>
							</label>
							<input type="text" name="loginemail" id="inputLoginEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$loginemail}">
						</div>
					</div>
					<div class="col-md-5">
						<div class="form-group prepend-icon">
							<label for="inputLoginPassword" class="field-icon">
								<i class="fas fa-lock"></i>
							</label>
							<input type="password" name="loginpassword" id="inputLoginPassword" class="field form-control" placeholder="{$LANG.clientareapassword}">
						</div>
					</div>
					<div class="col-md-2">
						<button type="button" id="btnExistingLogin" class="btn btn-primary btn-md btn-block">
							<span id="existingLoginButton">{lang key='login'}</span>
							<span id="existingLoginPleaseWait" class="w-hidden"><i class="fad fa-circle-notch fa-spin"></i></span>
						</button>
					</div>
				</div>

				{include file="orderforms/{$carttpl}/linkedaccounts.tpl" linkContext="checkout-existing"}
			</div>    
		
			{if $loggedin}
			<div id="containerNewUserSignup" class="signupfields{if $custtype === 'existing' || (is_numeric($selectedAccountId) && $selectedAccountId > 0) || ($loggedin && $accounts->count() > 0 && $selectedAccountId !== 'new')} w-hidden{/if}">
			{else}
			<div class="signupfields{if $custtype eq "existing" && !$loggedin} w-hidden{/if}" id="signupfrm">
			{/if}
					<div{if $loggedin} class="w-hidden"{/if}>
						{include file="orderforms/{$carttpl}/linkedaccounts.tpl" linkContext="checkout-new"}
					</div>


					<h5>{$LANG.orderForm.personalInformation}</h5>

					<div class="row">
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputFirstName" class="field-icon">
									<i class="fas fa-user"></i>
								</label>
								<input type="text" name="firstname" id="inputFirstName" class="field form-control" placeholder="{$LANG.orderForm.firstName}" value="{$clientsdetails.firstname}">
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputLastName" class="field-icon">
									<i class="fas fa-user"></i>
								</label>
								<input type="text" name="lastname" id="inputLastName" class="field form-control" placeholder="{$LANG.orderForm.lastName}" value="{$clientsdetails.lastname}">
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputEmail" class="field-icon">
									<i class="fas fa-envelope"></i>
								</label>
								<input type="email" name="email" id="inputEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$clientsdetails.email}">
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputPhone" class="field-icon">
									<i class="fas fa-phone"></i>
								</label>
								<input type="tel" name="phonenumber" id="inputPhone" class="field form-control" placeholder="{$LANG.orderForm.phoneNumber}" value="{$clientsdetails.phonenumber}">
							</div>
						</div>
					</div>

					<h5>{$LANG.orderForm.billingAddress}</h5>

					<div class="row">
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputCompanyName" class="field-icon">
									<i class="fas fa-building"></i>
								</label>
								<input type="text" name="companyname" id="inputCompanyName" class="field form-control" placeholder="{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})" value="{$clientsdetails.companyname}">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputAddress1" class="field-icon">
									<i class="far fa-building"></i>
								</label>
								<input type="text" name="address1" id="inputAddress1" class="field form-control" placeholder="{$LANG.orderForm.streetAddress}" value="{$clientsdetails.address1}">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputAddress2" class="field-icon">
									<i class="fas fa-map-marker-alt"></i>
								</label>
								<input type="text" name="address2" id="inputAddress2" class="field form-control" placeholder="{$LANG.orderForm.streetAddress2}" value="{$clientsdetails.address2}">
							</div>
						</div>
						<div class="col-sm-4">
							<div class="form-group prepend-icon">
								<label for="inputCity" class="field-icon">
									<i class="far fa-building"></i>
								</label>
								<input type="text" name="city" id="inputCity" class="field form-control" placeholder="{$LANG.orderForm.city}" value="{$clientsdetails.city}">
							</div>
						</div>
						<div class="col-sm-5">
							<div class="form-group prepend-icon">
								<label for="state" class="field-icon" id="inputStateIcon">
									<i class="fas fa-map-signs"></i>
								</label>
								<label for="stateinput" class="field-icon" id="inputStateIcon">
									<i class="fas fa-map-signs"></i>
								</label>
								<input type="text" name="state" id="inputState" class="field form-control" placeholder="{$LANG.orderForm.state}" value="{$clientsdetails.state}">
							</div>
						</div>
						<div class="col-sm-3">
							<div class="form-group prepend-icon">
								<label for="inputPostcode" class="field-icon">
									<i class="fas fa-certificate"></i>
								</label>
								<input type="text" name="postcode" id="inputPostcode" class="field form-control" placeholder="{$LANG.orderForm.postcode}" value="{$clientsdetails.postcode}">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputCountry" class="field-icon" id="inputCountryIcon">
									<i class="fas fa-globe"></i>
								</label>
								 <select name="country" id="inputCountry" class="field form-control">
									{foreach $countries as $countrycode => $countrylabel}
										<option value="{$countrycode}"{if (!$country && $countrycode == $defaultcountry) || $countrycode eq $country} selected{/if}>
											{$countrylabel}
										</option>
									{/foreach}
								</select>
							</div>
						</div>
						{if $showTaxIdField}
							<div class="col-12">
								<div class="form-group prepend-icon">
									<label for="inputTaxId" class="field-icon">
										<i class="fas fa-building"></i>
									</label>
									<input type="text" name="tax_id" id="inputTaxId" class="field form-control" placeholder="{$taxLabel} ({$LANG.orderForm.optional})" value="{$clientsdetails.tax_id}">
								</div>
							</div>
						{/if}
					</div>

					{if $customfields}

						<h5>{$LANG.orderadditionalrequiredinfo} <i><small class="text-muted">{lang key='orderForm.requiredField'}</small></i></h5>
						<div class="row">
							{foreach $customfields as $customfield}
								<div class="col-12">
									<div class="form-group">
										{if $customfield.type eq 'tickbox'}
											<label class=checkbox-inline" for="customfield{$customfield.id}">
												{$customfield.input}
												{$customfield.name} {$customfield.required}
											</lable>
											{if $customfield.description}<span class="field-help-text">{$customfield.description}</span>{/if}
										 {else}
											<label for="customfield{$customfield.id}">{$customfield.name} {$customfield.required}</label>
											{if $customfield.type eq "link"}
											   <div class="input-group-prepend">
													<span class="input-group-text" id="customfield{$customfield.id}"><i class="fas fa-link"></i></span>
													{$customfield.input}
												</div>
											{else}
												{$customfield.input}
											{/if}
											{if $customfield.description}<span class="field-help-text">{$customfield.description}</span>{/if}
										 {/if}
									</div>
								</div>
							{/foreach}
						</div>
					{/if}

			</div>
			
			<div class="domain_config pl-3 pr-3 {if $domainsinorder}{else} w-hidden{/if}">

					<h5>{$LANG.domainregistrantinfo}</h5>

					<p class="small text-muted">{$LANG.orderForm.domainAlternativeContact}</p>

					<div class="row margin-bottom">
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputDCFirstName" class="field-icon">
									<i class="fas fa-user"></i>
								</label>				
								<select name="contact" id="inputDomainContact" class="field form-control">
									<option value="">{$LANG.usedefaultcontact}</option>
									{foreach $domaincontacts as $domcontact}
										<option value="{$domcontact.id}"{if $contact == $domcontact.id} selected{/if}>
											{$domcontact.name}
										</option>
									{/foreach}
									<option value="addingnew"{if $contact == "addingnew"} selected{/if}>
										{$LANG.clientareanavaddcontact}...
									</option>
								</select>
							</div>
						</div>
					</div>

					<div class="row{if $contact neq "addingnew"} w-hidden{/if}" id="domainRegistrantInputFields">
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputDCFirstName" class="field-icon">
									<i class="fas fa-user"></i>
								</label>
								<input type="text" name="domaincontactfirstname" id="inputDCFirstName" class="field form-control" placeholder="{$LANG.orderForm.firstName}" value="{$domaincontact.firstname}">
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputDCLastName" class="field-icon">
									<i class="fas fa-user"></i>
								</label>
								<input type="text" name="domaincontactlastname" id="inputDCLastName" class="field form-control" placeholder="{$LANG.orderForm.lastName}" value="{$domaincontact.lastname}">
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputDCEmail" class="field-icon">
									<i class="fas fa-envelope"></i>
								</label>
								<input type="email" name="domaincontactemail" id="inputDCEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$domaincontact.email}">
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputDCPhone" class="field-icon">
									<i class="fas fa-phone"></i>
								</label>
								<input type="tel" name="domaincontactphonenumber" id="inputDCPhone" class="field form-control" placeholder="{$LANG.orderForm.phoneNumber}" value="{$domaincontact.phonenumber}">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputDCCompanyName" class="field-icon">
									<i class="fas fa-building"></i>
								</label>
								<input type="text" name="domaincontactcompanyname" id="inputDCCompanyName" class="field form-control" placeholder="{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})" value="{$domaincontact.companyname}">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputDCAddress1" class="field-icon">
									<i class="far fa-building"></i>
								</label>
								<input type="text" name="domaincontactaddress1" id="inputDCAddress1" class="field form-control" placeholder="{$LANG.orderForm.streetAddress}" value="{$domaincontact.address1}">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputDCAddress2" class="field-icon">
									<i class="fas fa-map-marker-alt"></i>
								</label>
								<input type="text" name="domaincontactaddress2" id="inputDCAddress2" class="field form-control" placeholder="{$LANG.orderForm.streetAddress2}" value="{$domaincontact.address2}">
							</div>
						</div>
						<div class="col-sm-4">
							<div class="form-group prepend-icon">
								<label for="inputDCCity" class="field-icon">
									<i class="far fa-building"></i>
								</label>
								<input type="text" name="domaincontactcity" id="inputDCCity" class="field form-control" placeholder="{$LANG.orderForm.city}" value="{$domaincontact.city}">
							</div>
						</div>
						<div class="col-sm-5">
							<div class="form-group prepend-icon">
								<label for="inputDCState" class="field-icon">
									<i class="fas fa-map-signs"></i>
								</label>
								<input type="text" name="domaincontactstate" id="inputDCState" class="field form-control" placeholder="{$LANG.orderForm.state}" value="{$domaincontact.state}">
							</div>
						</div>
						<div class="col-sm-3">
							<div class="form-group prepend-icon">
								<label for="inputDCPostcode" class="field-icon">
									<i class="fas fa-certificate"></i>
								</label>
								<input type="text" name="domaincontactpostcode" id="inputDCPostcode" class="field form-control" placeholder="{$LANG.orderForm.postcode}" value="{$domaincontact.postcode}">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputDCCountry" class="field-icon" id="inputCountryIcon">
									<i class="fas fa-globe"></i>
								</label>
								<select name="domaincontactcountry" id="inputDCCountry" class="field form-control">
									{foreach $countries as $countrycode => $countrylabel}
										<option value="{$countrycode}"{if (!$domaincontact.country && $countrycode == $defaultcountry) || $countrycode eq $domaincontact.country} selected{/if}>
											{$countrylabel}
										</option>
									{/foreach}
								</select>
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group prepend-icon">
								<label for="inputDCTaxId" class="field-icon">
									<i class="fas fa-building"></i>
								</label>
								<input type="text" name="domaincontacttax_id" id="inputDCTaxId" class="field form-control" placeholder="{$taxLabel} ({$LANG.orderForm.optional})" value="{$domaincontact.tax_id}">
							</div>
						</div>
					</div>

			</div>
		</div>
	</div>

	{if !$loggedin}
		<div id="containerNewUserSecurity"{if (!$loggedin && $custtype eq "existing") || ($remote_auth_prelinked && !$securityquestions) } class="w-hidden"{/if}>
			<div class="TM-card blocks accountpw">
				<div class="blocks_heading">
					<h2>{$LANG.orderForm.accountSecurity}</h2>
				</div>
				<div class="blocks_body" id="account_pw">

					<div id="containerPassword" class="row{if $remote_auth_prelinked && $securityquestions} w-hidden{/if}">
						<div id="passwdFeedback" style="display: none;" class="alert alert-info text-center col-sm-12"></div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputNewPassword1" class="field-icon">
									<i class="fas fa-lock"></i>
								</label>
								<input type="password" name="password" id="inputNewPassword1" data-error-threshold="{$pwStrengthErrorThreshold}" data-warning-threshold="{$pwStrengthWarningThreshold}" class="field form-control" placeholder="{$LANG.clientareapassword}"{if $remote_auth_prelinked} value="{$password}"{/if}>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group prepend-icon">
								<label for="inputNewPassword2" class="field-icon">
									<i class="fas fa-lock"></i>
								</label>
								<input type="password" name="password2" id="inputNewPassword2" class="field form-control" placeholder="{$LANG.clientareaconfirmpassword}"{if $remote_auth_prelinked} value="{$password}"{/if}>
							</div>
						</div>
						<div class="col-sm-6">
							<button type="button" class="btn btn-default btn-sm generate-password" data-targetfields="inputNewPassword1,inputNewPassword2">
								{$LANG.generatePassword.btnLabel}
							</button>
						</div>
						<div class="col-sm-6">
							<div class="password-strength-meter">
								<div class="progress">
									<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" id="passwordStrengthMeterBar">
									</div>
								</div>
								<p class="text-center small text-muted" id="passwordStrengthTextLabel">{$LANG.pwstrength}: {$LANG.pwstrengthenter}</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			{if $securityquestions}
				<div class="TM-card blocks securityques">
					<div class="blocks_body" id="securityQuestion">
						{if !$loggedin}
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<select name="securityqid" id="inputSecurityQId" class="field form-control">
											<option value="">{$LANG.clientareasecurityquestion}</option>
											{foreach $securityquestions as $question}
												<option value="{$question.id}"{if $question.id eq $securityqid} selected{/if}>
													{$question.question}
												</option>
											{/foreach}
										</select>
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group prepend-icon">
										<label for="inputSecurityQAns" class="field-icon">
											<i class="fas fa-lock"></i>
										</label>
										<input type="password" name="securityqans" id="inputSecurityQAns" class="field form-control" placeholder="{$LANG.clientareasecurityanswer}">
									</div>
								</div>
							</div>
						{/if}
					</div>
				</div>
			{/if}
		</div>
	{/if}

	<div class="blocks paymentinfo">
		{* <div class="blocks_heading">
			<h2>{$LANG.orderForm.paymentDetails}</h2>
		</div>
		*}
		<div class="blocks_body" id="payment_info">

			{if $canUseCreditOnCheckout}
				<div id="applyCreditContainer" class="apply-credit-container" data-apply-credit="{$applyCredit}">		
					<div class="p-3 border rounded mb-3">
						<p class="fw-500 text-muted mb-1 small">{lang key='availcreditbal'}:</p>
						<span class="h2 fw-500 mt-0">{$creditBalance}</span>
					</div>
					{if $creditBalance->toNumeric() >= $total->toNumeric()}
						<label class="radio">
							<input id="useFullCreditOnCheckout" class="cccheckdb" type="radio" name="applycredit" value="1"{if $applyCredit} checked{/if}>
							{lang key='cart.applyCreditAmountNoFurtherPayment' amount=$total}
						</label>
					{else}
						<label class="radio">
							<input id="useCreditOnCheckout" class="cccheckdb" type="radio" name="applycredit" value="1"{if $applyCredit} checked{/if}>
							{lang key='cart.applyCreditAmount' amount=$creditBalance}
						</label>
					{/if}
					<label class="radio">
						<input id="skipCreditOnCheckout" class="cccheckdb" type="radio" name="applycredit" value="0"{if !$applyCredit} checked{/if}>
						{lang key='cart.applyCreditSkip' amount=$creditBalance}
					</label>
				</div>
			{/if}

			{if !$inExpressCheckout}
				<div id="paymentGatewaysContainer" class="form-group"{if $canUseCreditOnCheckout} style="display: none;"{/if}>
					<h4>{$LANG.orderpaymentmethod}</h4>
					<div class="TM-card" id="cros-payment-gateway">
						{foreach $gateways as $gateway}
							<label class="radio-inline{if $selectedgateway eq $gateway.sysname} is-selected{/if}" id="lbl-{$gateway.sysname}" onclick="getApply('{$gateway.sysname}')">
								<span>
									<input type="radio" onclick="getApply(this.value)"
									   name="paymentmethod"
									   value="{$gateway.sysname}"
									   data-payment-type="{$gateway.payment_type}"
									   data-show-local="{$gateway.show_local_cards}"
									   data-remote-inputs="{$gateway.uses_remote_inputs}"
									   class="payment-methods{if $gateway.type eq "CC"} is-credit-card{/if}"
									   {if $selectedgateway eq $gateway.sysname} checked{/if}
									   />
								
									<span class="check-label">{$gateway.name}</span>
								</span>
								{assign var=gatewayIcon value=$gateway.sysname|lower|replace:" ":"-"}
								{if file_exists("templates/orderforms/{$carttpl}/img/gateways/{$gatewayIcon}.png")}     
									<span class="check-icon">
										{if file_exists("templates/orderforms/{$carttpl}/img/gateways/overrides/{$gatewayIcon}.png")}
											<img class="img-responsive" src="templates/orderforms/{$carttpl}/img/gateways/overrides/{$gatewayIcon}.png" alt="{$gateway.name}" />
										{else}
											<img class="img-responsive" src="templates/orderforms/{$carttpl}/img/gateways/{$gatewayIcon}.png" alt="{$gateway.name}" />
										{/if}
									</span>
								{/if}
								
							</label>
						{/foreach}
						{foreach from=$gatewaysoutput item=gatewayname key=wskey}
							{if $gatewayname|strstr:"paypalcheckout"} 
								<label class="radio-inline">
									<input type="radio" name="paymentmethod" value="paypalexpress" data-payment-type="Invoices" data-show-local="" data-remote-inputs="" class="payment-methods">
									PayPal Express Checkout
								</label>
							{/if}
						{/foreach}
					</div>
				</div>

				<div class="alert alert-danger text-center gateway-errors w-hidden"></div>

				<div class="clearfix"></div>
				
				<div class="cc-input-container{if $selectedgatewaytype neq "CC"} w-hidden{/if}" id="creditCardInputFields">
					{if $client}
						<div id="existingCardsContainer" class="existing-cc-grid">
							{include file="orderforms/{$carttpl}/includes/existing-paymethods.tpl"}
						</div>
					{/if}
					<div class="row cvv-input" id="existingCardInfo">
						<div class="col-lg-3 col-sm-4">
							<div class="form-group prepend-icon">
								<label for="inputCardCVV2" class="field-icon">
									<i class="fas fa-barcode"></i>
								</label>
								<div class="input-group">
									<input type="tel" name="cccvv" id="inputCardCVV2" class="field form-control" placeholder="{$LANG.creditcardcvvnumbershort}" autocomplete="cc-cvc">
									<span class="input-group-btn input-group-append">
										<button type="button" class="btn btn-default" data-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />">
											?
										</button>
									</span>
								</div>
								<span class="field-error-msg">{lang key="paymentMethodsManage.cvcNumberNotValid"}</span>
							</div>
						</div>
					</div>

					<ul>
						<li>
							<label class="radio-inline py-2 px-3 border rounded w-100">
								<input type="radio" name="ccinfo" value="new" id="new" {if !$client || $client->payMethods->count() === 0} checked="checked"{/if} />
								&nbsp;{lang key='creditcardenternewcard'}
							</label>
						</li>
					</ul>

					<div class="row" id="newCardInfo">
						<div id="cardNumberContainer" class="col-sm-6 new-card-container">
							<div class="form-group prepend-icon">
								<label for="inputCardNumber" class="field-icon">
									<i class="fas fa-credit-card"></i>
								</label>
								<input type="tel" name="ccnumber" id="inputCardNumber" class="form-control field cc-number-field" placeholder="{$LANG.orderForm.cardNumber}" autocomplete="cc-number" data-message-unsupported="{lang key='paymentMethodsManage.unsupportedCardType'}" data-message-invalid="{lang key='paymentMethodsManage.cardNumberNotValid'}" data-supported-cards="{$supportedCardTypes}" />
								<span class="field-error-msg"></span>
							</div>
						</div>
						<div class="col-sm-3 new-card-container">
							<div class="form-group prepend-icon">
								<label for="inputCardExpiry" class="field-icon">
									<i class="fas fa-calendar-alt"></i>
								</label>
								<input type="tel" name="ccexpirydate" id="inputCardExpiry" class="field form-control" placeholder="MM / YY{if $showccissuestart} ({$LANG.creditcardcardexpires}){/if}" autocomplete="cc-exp">
								<span class="field-error-msg">{lang key="paymentMethodsManage.expiryDateNotValid"}</span>
							</div>
						</div>
						<div class="col-sm-3" id="cvv-field-container">
							<div class="form-group prepend-icon">
								<label for="inputCardCVV" class="field-icon">
									<i class="fas fa-barcode"></i>
								</label>
								<div class="input-group">
									<input type="tel" name="cccvv" id="inputCardCVV" class="field form-control" placeholder="{$LANG.creditcardcvvnumbershort}" autocomplete="cc-cvc">
									<span class="input-group-btn input-group-append">
										<button type="button" class="btn btn-default" data-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />">
											?
										</button>
									</span><br>
								</div>
								<span class="field-error-msg">{lang key="paymentMethodsManage.cvcNumberNotValid"}</span>
							</div>
						</div>
						{if $showccissuestart}
							<div class="col-sm-3 col-sm-offset-6 new-card-container">
								<div class="form-group prepend-icon">
									<label for="inputCardStart" class="field-icon">
										<i class="far fa-calendar-check"></i>
									</label>
									<input type="tel" name="ccstartdate" id="inputCardStart" class="field form-control" placeholder="MM / YY ({$LANG.creditcardcardstart})" autocomplete="cc-exp">
								</div>
							</div>
							<div class="col-sm-3 new-card-container">
								<div class="form-group prepend-icon">
									<label for="inputCardIssue" class="field-icon">
										<i class="fas fa-asterisk"></i>
									</label>
									<input type="tel" name="ccissuenum" id="inputCardIssue" class="field form-control" placeholder="{$LANG.creditcardcardissuenum}">
								</div>
							</div>
						{/if}
					</div>
					<div id="newCardSaveSettings">
						<div class="row form-group new-card-container">
							<div id="inputDescriptionContainer" class="col-md-6">
								<div class="prepend-icon">
									<label for="inputDescription" class="field-icon">
										<i class="fas fa-pencil"></i>
									</label>
									<input type="text" class="field form-control" id="inputDescription" name="ccdescription" autocomplete="off" value="" placeholder="{$LANG.paymentMethods.descriptionInput} {$LANG.paymentMethodsManage.optional}" />
								</div>
							</div>
							{if $allowClientsToRemoveCards}
								<div id="inputNoStoreContainer" class="col-md-6" style="line-height: 32px;">
									<input type="hidden" name="nostore" value="1">
									<input type="checkbox" class="toggle-switch-success no-icheck" data-size="mini" checked="checked" name="nostore" id="inputNoStore" value="0" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
									<label for="inputNoStore" class="checkbox-inline no-padding">
										&nbsp;&nbsp;
										{$LANG.creditCardStore}
									</label>
								</div>
							{/if}
						</div>
					</div>
				</div>
			{else}
				{if $expressCheckoutOutput}
					{$expressCheckoutOutput}
				{else}
					<p align="center">
						{lang key='paymentPreApproved' gateway=$expressCheckoutGateway}
					</p>
				{/if}
			{/if}
			
		</div>
	</div>
</div>

{if $shownotesfield}
	<div class="TM-card blocks additionalinfo">
		<div class="blocks_heading">
			<h2>{$LANG.orderForm.additionalNotes}</h2>
		</div>
		<div class="blocks_body" id="notesfield">
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<textarea name="notes" class="field form-control" rows="4" placeholder="{$LANG.ordernotesdescription}">{$orderNotes}</textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
{/if}

{if $showMarketingEmailOptIn}
	<div class="TM-card blocks additionalinfo">
		<div class="blocks_body" id="MarketingEmailOptIn">
			<p>{$marketingEmailOptInMessage}</p>
			<div class="panel panel-switch {if $marketingEmailOptIn} checked{/if}">
				<div class="panel-body">
					<span class="switch-label">{lang key='emailMarketing.joinOurMailingList'}: </span>
					<label class="switch switch--text">
						<input class="no-icheck switch__checkbox" type="checkbox" name="marketingoptin" value="1"{if $marketingEmailOptIn} checked{/if}>
						<span class="switch__container"><span class="switch__handle"></span></span>
					</label> 
				</div>
			</div>
		</div>
	</div>
{/if}

{*
{if $captcha}
	<div class="margin-bottom">
	   {include file="$template/includes/captcha_spc.tpl"}
   </div>
{/if}
*}
	
<div class="orderform_footer">
	<div class="order_form_tos">
		{if $accepttos}
			<div>
				<label class="checkbox-inline">
					<input type="checkbox" name="accepttos" id="accepttos" />
					{$LANG.ordertosagreement}
					<a href="{$tosurl}" target="_blank">{$LANG.ordertos}</a>
				</label>
			</div>
			<br />
		{/if}
	</div>
	
	<div class="order_form_submit">
		<button type="submit" id="order_submit" class="btn btn-primary btn-lg spinner-on-click{if $captcha}{$captcha->getButtonClass($captchaForm)}{/if}">{if $inExpressCheckout}{$LANG.confirmAndPay}{else}{$LANG.completeorder}{/if}&nbsp;<i class="fas fa-arrow-circle-right"></i></button>			
	</div>
</div>
</form>

{if $servedOverSsl}
<div class="small text-muted mt-3 mb-5">
	<i class="fad fa-lock-alt text-success"></i>&nbsp;{$LANG.ordersecure} (<strong>{$ipaddress}</strong>) {$LANG.ordersecure2}
</div>
{/if}

<script>
jQuery(document).ready(function () {
	var panelSwitch = $('.panel-switch');
	panelSwitch.on('click', function (e) {
		if (!$(this).is('a')) {
			var currCheck = $(this).find('input[type="checkbox"]');
			if (currCheck.is(':checked')) {
				panelSwitch.removeClass('checked');
				currCheck.prop('checked', false);
			} else {
				panelSwitch.addClass('checked');
				currCheck.prop('checked', true);
			}
			var that = $(this);
			setTimeout(function () {
				that.find('.loader').addClass('loading');
			}, 300);
		}
	});
	
	jQuery('.existing-card').change('ifChecked', function (event) {
		 $(this).closest(".card-item").toggleClass('selected', this.checked);
	});
});

// Enable Switches for Checkboxes
if (jQuery.prototype.bootstrapSwitch) {
	jQuery(".toggle-switch-success").bootstrapSwitch({
		onColor: 'success'
	});
}

jQuery('#inputNoStore').on('switchChange.bootstrapSwitch', function(event, state) {
	var descContainer = jQuery('#inputDescription');
	if (!state) {
		descContainer.prop('disabled', true).addClass('disabled');
	}
	if (state) {
		descContainer.removeClass('disabled').prop('disabled', false);
	}
});
	
jQuery("#inputDomainContact").on('change', function() {
	if (this.value == "addingnew") {
		jQuery("#domainRegistrantInputFields").hide().removeClass('w-hidden').slideDown();
	} else {
		jQuery(".domain_config").show().removeClass('w-hidden').slideDown();
		jQuery("#domainRegistrantInputFields").slideUp();
	}
});

//Gateway checkbox
function getApply(obj){
var vDiv=document.getElementById("cros-payment-gateway").children.length;
	for(var i=0;i<vDiv;i++){
		var vObje = document.getElementById("cros-payment-gateway").children[i].id;
		if("lbl-"+obj==vObje){
			document.getElementById("lbl-"+obj).classList.add("is-selected");
		}
		else{
			document.getElementById(vObje).className ="radio-inline";
		}	
	} 
}

// Activate copy to clipboard functionality
jQuery('.copy-to-clipboard').click(WHMCS.ui.clipboard.copy);

// Password Generator
jQuery('.generate-password').click(function(e) {
	jQuery('#frmGeneratePassword').submit();
	jQuery('#modalGeneratePassword')
		.data('targetfields', jQuery(this).data('targetfields'))
		.modal('show');
});
jQuery('#frmGeneratePassword').submit(function(e) {
	e.preventDefault();
	var length = parseInt(jQuery('#inputGeneratePasswordLength').val(), 10);

	// Check length
	if (length < 8 || length > 64) {
		jQuery('#generatePwLengthError').removeClass('w-hidden').show();
		return;
	}

	jQuery('#inputGeneratePasswordOutput').val(WHMCS.utils.generatePassword(length));
});


{if !$loggedin}
if(jQuery("#inputCountry").length)
{
    jQuery("#inputCountry").change(function(){                        
        setTimeout(function(){ recalcheckout(); }, 2500);
    });
}
{/if}

// Default catch for all other popovers
jQuery('[data-toggle="popover"]').popover({
	html: true
});
</script>
<script>
    $('script[src*="stripe.min.js"]').slice(1).remove();
    $('iframe[name*="privateStripe"]').remove();
</script>


{$credit_card_input}
