Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F112845A4
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgJFFtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:49:12 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:61138 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgJFFtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 01:49:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601963351; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=LTWF++Bn389zksk4oUPZvJlU0ZGQ50MQBidN3ma2aZo=; b=xb0yhv5nvTqhK++pbrlWsb+jIKCWisJD9HSyEgkOdrJN5EP86uJh+gShy1L8E2rnYZC8KdtN
 8K3hp1QRBjixYXekmCd1oWilcMpOb+X5owgzhYYJ55b+BxJJRREW2O9mHVmYoUp7OlijkAtd
 ++9QUyTFhdhS6m5g9QaIpgCaEfk=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f7c0556d6d00c7a9e0c73a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Oct 2020 05:49:10
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6D335C433FF; Tue,  6 Oct 2020 05:49:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C809FC433CA;
        Tue,  6 Oct 2020 05:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C809FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luciano Coelho <luca@coelho.fi>
Subject: Re: [PATCH v2 00/29] [Set 1,2,3] Rid W=1 warnings in Wireless
References: <20200910065431.657636-1-lee.jones@linaro.org>
        <20201002090353.GS6148@dell>
Date:   Tue, 06 Oct 2020 08:49:05 +0300
In-Reply-To: <20201002090353.GS6148@dell> (Lee Jones's message of "Fri, 2 Oct
        2020 10:03:53 +0100")
Message-ID: <87362rdhv2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Thu, 10 Sep 2020, Lee Jones wrote:
>
>> This is a rebased/re-worked set of patches which have been
>> previously posted to the mailing list(s).
>> 
>> This set is part of a larger effort attempting to clean-up W=1
>> kernel builds, which are currently overwhelmingly riddled with
>> niggly little warnings.
>> 
>> There are quite a few W=1 warnings in the Wireless.  My plan
>> is to work through all of them over the next few weeks.
>> Hopefully it won't be too long before drivers/net/wireless
>> builds clean with W=1 enabled.
>> 
>> Lee Jones (29):
>>   iwlwifi: dvm: Demote non-compliant kernel-doc headers
>>   iwlwifi: rs: Demote non-compliant kernel-doc headers
>>   iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
>>   iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
>>   iwlwifi: calib: Demote seemingly unintentional kerneldoc header
>>   wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
>>   iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
>>   iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
>>   iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
>>   iwlwifi: mvm: utils: Fix some doc-rot
>>   iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
>>   iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
>>   iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
>>   iwlwifi: dvm: devices: Fix function documentation formatting issues
>>   iwlwifi: iwl-drv: Provide descriptions debugfs dentries
>>   wil6210: wmi: Fix formatting and demote non-conforming function
>>     headers
>>   wil6210: interrupt: Demote comment header which is clearly not
>>     kernel-doc
>>   wil6210: txrx: Demote obvious abuse of kernel-doc
>>   wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
>>   wil6210: pmc: Demote a few nonconformant kernel-doc function headers
>>   wil6210: wil_platform: Demote kernel-doc header to standard comment
>>     block
>>   wil6210: wmi: Correct misnamed function parameter 'ptr_'
>>   ath6kl: wmi: Remove unused variable 'rate'
>>   ath9k: ar9002_initvals: Remove unused array
>>     'ar9280PciePhy_clkreq_off_L1_9280'
>>   ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
>>   ath9k: ar5008_initvals: Remove unused table entirely
>>   ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are
>>     used
>>   brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
>>   brcmsmac: phy_lcn: Remove unused variable
>>     'lcnphy_rx_iqcomp_table_rev0'
>
> What's happening with all of these iwlwifi patches?
>
> Looks like they are still not applied.

Luca (CCed) takes iwlwifi patches to his iwlwifi tree.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
