Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829F0286F25
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgJHHUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:20:19 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:59971 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgJHHUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 03:20:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602141617; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=xcv5dzo+anLNvdgtjCcQMqFVFBWCEf27U/6mqW7B/Po=; b=PvfRLZiYO/Ub5Bp2Mqn2sCX2XW5p0YyDU6UUUtoq98GKaPNPdhV5WCffBYKty0sGKlPz7ndq
 eV8lwYDohFlcc9h9SXLGekkaUYi5WgdDtvlWVx/94/SiRUqvdGdWnKJ5awUpS3ASbD0rLMig
 nVflCaDBIYjMAdrVI3690zJ+6yQ=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f7ebdb1aad2c3cd1c7df9a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Oct 2020 07:20:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6CA1C43391; Thu,  8 Oct 2020 07:20:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 450B5C433FE;
        Thu,  8 Oct 2020 07:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 450B5C433FE
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 00/29] [Set 1,2,3] Rid W=1 warnings in Wireless
References: <20200910065431.657636-1-lee.jones@linaro.org>
        <20201002090353.GS6148@dell> <87362rdhv2.fsf@codeaurora.org>
        <20201006065617.GX6148@dell> <87lfgjbzin.fsf@codeaurora.org>
        <27f10117a4f26d6f1f528d8e03fe753614dbef1a.camel@coelho.fi>
Date:   Thu, 08 Oct 2020 10:20:11 +0300
In-Reply-To: <27f10117a4f26d6f1f528d8e03fe753614dbef1a.camel@coelho.fi> (Luca
        Coelho's message of "Wed, 07 Oct 2020 09:01:10 +0300")
Message-ID: <87k0w12nh0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> On Tue, 2020-10-06 at 10:10 +0300, Kalle Valo wrote:
>> Lee Jones <lee.jones@linaro.org> writes:
>> 
>> > On Tue, 06 Oct 2020, Kalle Valo wrote:
>> > 
>> > > Lee Jones <lee.jones@linaro.org> writes:
>> > > 
>> > > > On Thu, 10 Sep 2020, Lee Jones wrote:
>> > > > 
>> > > > > This is a rebased/re-worked set of patches which have been
>> > > > > previously posted to the mailing list(s).
>> > > > > 
>> > > > > This set is part of a larger effort attempting to clean-up W=1
>> > > > > kernel builds, which are currently overwhelmingly riddled with
>> > > > > niggly little warnings.
>> > > > > 
>> > > > > There are quite a few W=1 warnings in the Wireless.  My plan
>> > > > > is to work through all of them over the next few weeks.
>> > > > > Hopefully it won't be too long before drivers/net/wireless
>> > > > > builds clean with W=1 enabled.
>> > > > > 
>> > > > > Lee Jones (29):
>> > > > >   iwlwifi: dvm: Demote non-compliant kernel-doc headers
>> > > > >   iwlwifi: rs: Demote non-compliant kernel-doc headers
>> > > > >   iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
>> > > > >   iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
>> > > > >   iwlwifi: calib: Demote seemingly unintentional kerneldoc header
>> > > > >   wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
>> > > > >   iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
>> > > > >   iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
>> > > > >   iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
>> > > > >   iwlwifi: mvm: utils: Fix some doc-rot
>> > > > >   iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
>> > > > >   iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
>> > > > >   iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
>> > > > >   iwlwifi: dvm: devices: Fix function documentation formatting issues
>> > > > >   iwlwifi: iwl-drv: Provide descriptions debugfs dentries
>> > > > >   wil6210: wmi: Fix formatting and demote non-conforming function
>> > > > >     headers
>> > > > >   wil6210: interrupt: Demote comment header which is clearly not
>> > > > >     kernel-doc
>> > > > >   wil6210: txrx: Demote obvious abuse of kernel-doc
>> > > > >   wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
>> > > > >   wil6210: pmc: Demote a few nonconformant kernel-doc function headers
>> > > > >   wil6210: wil_platform: Demote kernel-doc header to standard comment
>> > > > >     block
>> > > > >   wil6210: wmi: Correct misnamed function parameter 'ptr_'
>> > > > >   ath6kl: wmi: Remove unused variable 'rate'
>> > > > >   ath9k: ar9002_initvals: Remove unused array
>> > > > >     'ar9280PciePhy_clkreq_off_L1_9280'
>> > > > >   ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
>> > > > >   ath9k: ar5008_initvals: Remove unused table entirely
>> > > > >   ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are
>> > > > >     used
>> > > > >   brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
>> > > > >   brcmsmac: phy_lcn: Remove unused variable
>> > > > >     'lcnphy_rx_iqcomp_table_rev0'
>> > > > 
>> > > > What's happening with all of these iwlwifi patches?
>> > > > 
>> > > > Looks like they are still not applied.
>> > > 
>> > > Luca (CCed) takes iwlwifi patches to his iwlwifi tree.
>> > 
>> > Thanks Kalle.
>> > 
>> > Luca,
>> > 
>> >   Do you know why these patches have not been applied yet?  Do you
>> > plan on applying them this week?  -rc1 is not due for release for
>> > nearly 3 weeks now that Linus tagged an -rc8.
>> 
>> I can also take Lee's patches directly to wireless-drivers-next, if
>> that's easier for Luca.
>
> Yes, please take these patches directly.  It simplifies things.

Ok, I have assigned all Lee's pending iwlwifi patches to me on
patchwork.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
