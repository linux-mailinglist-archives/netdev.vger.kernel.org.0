Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4930117AA32
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCEQKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:10:37 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:58706 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgCEQKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:10:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583424635; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=xa/KmK6WhNV8Qaik/yPOJqorbsfZDM0+aKqi1AIQrfk=; b=kfG0bbbfvutRCH3sYLer5Mx+9lmoCUvqzn9hT+5zJs0l51E6yzFPsvl6FIVvFvaWQBfNyDo6
 71Ve5HAb82218jlR/QXRCbMgUclbSiAY3lEIbkuDlvADLped1eptvh04L+IdyzY4uOEcB7Cn
 cqH+QKcefbbsz1zDDN0L1C7xwpk=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e61246a.7fb780057d18-smtp-out-n03;
 Thu, 05 Mar 2020 16:10:18 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 208C8C4479F; Thu,  5 Mar 2020 16:10:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5937AC43383;
        Thu,  5 Mar 2020 16:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5937AC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Joe Perches <joe@perches.com>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with flexible-array member
References: <20200305111216.GA24982@embeddedor>
        <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
        <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
Date:   Thu, 05 Mar 2020 18:10:10 +0200
In-Reply-To: <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com> (Joe
        Perches's message of "Thu, 05 Mar 2020 07:20:04 -0800")
Message-ID: <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Thu, 2020-03-05 at 16:50 +0200, Kalle Valo wrote:
>> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
> []
>> >  drivers/net/wireless/zydas/zd1211rw/zd_usb.h | 8 ++++----
>> >  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> "zd1211rw: " is enough, no need to have the filename in the title.

>> But I asked this already in an earlier patch, who prefers this format?
>> It already got opposition so I'm not sure what to do.
>
> I think it doesn't matter.
>
> Trivial inconsistencies in patch subject and word choice
> don't have much overall impact.

I wrote in a confusing way, my question above was about the actual patch
and not the the title. For example, Jes didn't like this style change:

https://patchwork.kernel.org/patch/11402315/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
