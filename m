Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572702C1EBA
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgKXHQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:16:07 -0500
Received: from z5.mailgun.us ([104.130.96.5]:26821 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729283AbgKXHQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 02:16:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606202166; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=w+M3PJorKwyCBVU1Kq/koy0K88GFFtVnVBJQ9wVlNr8=; b=CFCB3dXd8VnyCPNqHfaP82Te93bhmMn7DW/i+1UokopDCId8n9OGZngboJwlpsPGkH8p7Oor
 EL1YJv8i50hear7UMDO9lnz3YxcgPNOeXuqrlWY0EF8VoN1e4YAItcWYEExQzFl1jneNDY5i
 KM9Bmq8ZUAKNjqmMxaX8waJYorU=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fbcb32577b63cdb341361a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 07:15:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 29283C43460; Tue, 24 Nov 2020 07:15:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 981EBC433C6;
        Tue, 24 Nov 2020 07:15:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 981EBC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-11-23
References: <20201123161037.C11D1C43460@smtp.codeaurora.org>
        <20201123153002.2200d6be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 24 Nov 2020 09:15:45 +0200
In-Reply-To: <20201123153002.2200d6be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Mon, 23 Nov 2020 15:30:02 -0800")
Message-ID: <87im9vql7i.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 23 Nov 2020 16:10:37 +0000 (UTC) Kalle Valo wrote:
>> wireless-drivers fixes for v5.10
>> 
>> First set of fixes for v5.10. One fix for iwlwifi kernel panic, others
>> less notable.
>> 
>> rtw88
>> 
>> * fix a bogus test found by clang
>> 
>> iwlwifi
>> 
>> * fix long memory reads causing soft lockup warnings
>> 
>> * fix kernel panic during Channel Switch Announcement (CSA)
>> 
>> * other smaller fixes
>> 
>> MAINTAINERS
>> 
>> * email address updates
>
> Pulled, thanks!
>
> Please watch out for missing sign-offs.

I assume you refer to commit 97cc16943f23, sorry about that. Currently
I'm just manually checking sign-offs and missed this patch. My plan is
to implement proper checks to my patchwork script so I'll notice these
before I commit the patch (or pull request), just have not yet find the
time to do that.

commit 97cc16943f23078535fdbce4f6391b948b4ccc08
Author:     Avraham Stern <avraham.stern@intel.com>
AuthorDate: Sat Nov 7 10:50:09 2020 +0200
Commit:     Kalle Valo <kvalo@codeaurora.org>
CommitDate: Tue Nov 10 20:45:34 2020 +0200

    iwlwifi: mvm: write queue_sync_state only for sync
    
    We use mvm->queue_sync_state to wait for synchronous queue sync
    messages, but if an async one happens inbetween we shouldn't
    clear mvm->queue_sync_state after sending the async one, that
    can run concurrently (at least from the CPU POV) with another
    synchronous queue sync.
    
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
    Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
    Link: https://lore.kernel.org/r/iwlwifi.20201107104557.51a3148f2c14.I0772171dbaec87433a11513e9586d98b5d920b5f@changeid

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
