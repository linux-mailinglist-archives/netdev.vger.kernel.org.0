Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA832B3C6
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1835011AbhCCEGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:06:17 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:15765 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344802AbhCBUDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 15:03:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614715365; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=HWLUwiM42Ktaz6bS5HtEP8D+IsWd4dl57f2ffZtwMMo=; b=VZBqirBKpCKD5M0oemt+wVQrq32VxM9HOgAiGQZzhggGIieXnAuUJLGZ4YrIDWL9LP17QgD0
 FhoJC9Rix2ge9KRDam/EvoNncR8gVnrTCwqpj31yjSKm+JbGkXiq9qt3W0C5oyyChgx2oZ5T
 wf55Ai5o2mqnwo73teBTv8hxX3E=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 603e97014fd7814d5f8b592e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 02 Mar 2021 19:50:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A2A67C433CA; Tue,  2 Mar 2021 19:50:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3A75BC433C6;
        Tue,  2 Mar 2021 19:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3A75BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Coelho\, Luciano" <luciano.coelho@intel.com>,
        "nathan\@kernel.org" <nathan@kernel.org>,
        "gil.adam\@intel.com" <gil.adam@intel.com>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "weiyongjun1\@huawei.com" <weiyongjun1@huawei.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Goodstein\, Mordechay" <mordechay.goodstein@intel.com>,
        "hulkci\@huawei.com" <hulkci@huawei.com>,
        "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id tables
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
        <20210226210640.GA21320@MSI.localdomain>
        <87h7ly9fph.fsf@codeaurora.org>
        <bd1bd942bcccffb9b3453344b611a13876d0e565.camel@intel.com>
        <20210302110559.1809ceaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 02 Mar 2021 21:50:18 +0200
In-Reply-To: <20210302110559.1809ceaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Tue, 2 Mar 2021 11:05:59 -0800")
Message-ID: <877dmp8hdx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 2 Mar 2021 18:31:11 +0000 Coelho, Luciano wrote:
>> On Sat, 2021-02-27 at 08:39 +0200, Kalle Valo wrote:
>> > Nathan Chancellor <nathan@kernel.org> writes:
>> > > We received a report about a crash in iwlwifi when compiled with LTO and
>> > > this fix resolves it.  
>> > 
>> > That information should be added to the commit log.
>> > 
>> > Luca, should I take this to wireless-drivers?  
>> 
>> I just saw Jens' patch now and I don't remember if I acked this one?
>> 
>> In any, I assigned it to you in patchwork, so please take it directly
>> to w-d.
>> 
>> Acked-by: Luca Coelho <luciano.coelho@intel.com>
>
> Thanks, I'm getting pinged, too. It sounded like Kalle would like to
> see the commit log improved

I wrote my comment hastily, I was trying to say that I can add the crash
information to the commit log.

> if Wei doesn't respond could you please step in to make sure this
> fix is part of Dave's next PR to Linus?

Will do. Related to this, what's your pull request schedule to Linus
nowadays? Do you submit it every Thursday?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
