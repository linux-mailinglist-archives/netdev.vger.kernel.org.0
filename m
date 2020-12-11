Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F282D7E0F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405608AbgLKS0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:26:18 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:34697 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404590AbgLKS0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:26:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607711140; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2tXlrvEngnz7FDRn0kXCaY3N4A1ABiWiHlW0DRKvuSM=;
 b=H9/oVl9IQvCD/mKb34yBotaJtuuVGCk7IMJkWa7AfKo+AzUsQIleyPPgA6M1HBX3z8yNRuUG
 F39/udlAJFw3+96DFH001rV4Pe8rgZxgZoN5fnlnF+Gb+rD5NzC1IQsiiWHtx9YKakx4N8NP
 OkhiU84r24kIHvPpIyKnBNWA79o=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fd3b98995aeb115f3c553da (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Dec 2020 18:25:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A66ADC43462; Fri, 11 Dec 2020 18:25:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 759ECC433C6;
        Fri, 11 Dec 2020 18:25:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 759ECC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/17] iwlwifi: mvm: rs: Demote non-conformant function
 documentation headers
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201126133152.3211309-3-lee.jones@linaro.org>
References: <20201126133152.3211309-3-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201211182512.A66ADC43462@smtp.codeaurora.org>
Date:   Fri, 11 Dec 2020 18:25:12 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Also add documentation for 'mvm'.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:400: warning: cannot understand function prototype: 'const u16 expected_tpt_legacy[IWL_RATE_COUNT] = '
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'mvm' not described in '_rs_collect_tx_data'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'tbl' not described in '_rs_collect_tx_data'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'scale_index' not described in '_rs_collect_tx_data'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'attempts' not described in '_rs_collect_tx_data'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'successes' not described in '_rs_collect_tx_data'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'window' not described in '_rs_collect_tx_data'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2677: warning: duplicate section name 'NOTE'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'mvm' not described in 'rs_initialize_lq'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'sta' not described in 'rs_initialize_lq'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'lq_sta' not described in 'rs_initialize_lq'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'band' not described in 'rs_initialize_lq'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:3761: warning: Function parameter or member 'mvm' not described in 'rs_program_fix_rate'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:3761: warning: Function parameter or member 'lq_sta' not described in 'rs_program_fix_rate'
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c:4213: warning: Function parameter or member 'mvm' not described in 'iwl_mvm_tx_protection'
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

6 patches applied to wireless-drivers-next.git, thanks.

05d07f2dc9a9 iwlwifi: mvm: rs: Demote non-conformant function documentation headers
dde0a25d06bf iwlwifi: iwl-eeprom-read: Demote one nonconformant function header
220ee462702c iwlwifi: iwl-eeprom-parse: Fix 'struct iwl_eeprom_enhanced_txpwr's header
5a2e2f91e8b5 iwlwifi: iwl-phy-db: Add missing struct member description for 'trans'
fe472e9d47c8 iwlwifi: fw: dbg: Fix misspelling of 'reg_data' in function header
81daab1f8d57 iwlwifi: fw: acpi: Demote non-conformant function headers

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201126133152.3211309-3-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

