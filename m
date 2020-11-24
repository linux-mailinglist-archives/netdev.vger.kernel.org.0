Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22722C2D16
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390525AbgKXQih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:38:37 -0500
Received: from z5.mailgun.us ([104.130.96.5]:49785 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390341AbgKXQih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:38:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606235916; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=/yuutWrK2u+4K08NALiylBdAyr0QJpYhGwtKtmqhAis=; b=PNdLUmJ8Mw9aNTHNSDy3CqLzE2tNlZ9UfUjH4L886QJ9NS0ddKfcPD1r6rMkAMx0lCAdeScE
 +vfE0z57CmXtkdSz4dQKHegbHKlu9CgNQiwrex+nTj/bT7+nuORMXoEd/GnshE+hSfHT7MmD
 v7F7w7BxJpLUEfb//SSwqkaCQho=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fbd3707b9b39088ed5af70b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 16:38:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 74DE7C433ED; Tue, 24 Nov 2020 16:38:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 18813C433C6;
        Tue, 24 Nov 2020 16:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 18813C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-11-23
References: <20201123161037.C11D1C43460@smtp.codeaurora.org>
        <20201123153002.2200d6be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87im9vql7i.fsf@codeaurora.org>
        <20201124080858.0aa8462b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 24 Nov 2020 18:38:26 +0200
In-Reply-To: <20201124080858.0aa8462b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Tue, 24 Nov 2020 08:08:58 -0800")
Message-ID: <875z5ur9q5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 24 Nov 2020 09:15:45 +0200 Kalle Valo wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>> > On Mon, 23 Nov 2020 16:10:37 +0000 (UTC) Kalle Valo wrote:  
>> >> wireless-drivers fixes for v5.10
>> >> 
>> >> First set of fixes for v5.10. One fix for iwlwifi kernel panic, others
>> >> less notable.
>> >> 
>> >> rtw88
>> >> 
>> >> * fix a bogus test found by clang
>> >> 
>> >> iwlwifi
>> >> 
>> >> * fix long memory reads causing soft lockup warnings
>> >> 
>> >> * fix kernel panic during Channel Switch Announcement (CSA)
>> >> 
>> >> * other smaller fixes
>> >> 
>> >> MAINTAINERS
>> >> 
>> >> * email address updates  
>> >
>> > Pulled, thanks!
>> >
>> > Please watch out for missing sign-offs.  
>> 
>> I assume you refer to commit 97cc16943f23, sorry about that. Currently
>> I'm just manually checking sign-offs and missed this patch. My plan is
>> to implement proper checks to my patchwork script so I'll notice these
>> before I commit the patch (or pull request), just have not yet find the
>> time to do that.
>
> Check out verify_fixes and verify_signoff in Greg's repo:
>
> https://github.com/gregkh/gregkh-linux/tree/master/work

Thanks, I will.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
