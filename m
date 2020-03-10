Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE91717FF96
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgCJN5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:57:00 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:39581 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgCJN47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 09:56:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583848619; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=7SNDskvdVEd15DtsrwRPuJkE2EW0gXby/GtBo14LN2E=; b=PZHOd/jACQ9ptzYzViRdIY8fdGTHKELbl1CSxluB8Dg3v6N/JYqN/aQdaT+1eZQ4tBP1O11f
 +nmwvhTGndOMMy7VO8HKskhs5PBjjyav9qRRtsmBlycQ/jeCh+jHQO+2wmUOwUm/OVLmHc/c
 xC20n8xoKy38vvzpOSYQJ/xVkmY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e679ca5.7fd1a5e56378-smtp-out-n01;
 Tue, 10 Mar 2020 13:56:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 16700C43637; Tue, 10 Mar 2020 13:56:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DAF9AC433CB;
        Tue, 10 Mar 2020 13:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DAF9AC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Joe Perches <joe@perches.com>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jes.Sorensen@gmail.com
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with flexible-array member
References: <20200305111216.GA24982@embeddedor>
        <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
        <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
        <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
        <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
Date:   Tue, 10 Mar 2020 15:56:46 +0200
In-Reply-To: <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com> (Gustavo A.
        R. Silva's message of "Thu, 5 Mar 2020 12:28:27 -0600")
Message-ID: <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ jes

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> Hi,
>
> On 3/5/20 10:10, Kalle Valo wrote:
>> Joe Perches <joe@perches.com> writes:
>> 
>>> On Thu, 2020-03-05 at 16:50 +0200, Kalle Valo wrote:
>>>> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
>>> []
>>>>>  drivers/net/wireless/zydas/zd1211rw/zd_usb.h | 8 ++++----
>>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> "zd1211rw: " is enough, no need to have the filename in the title.
>> 
>>>> But I asked this already in an earlier patch, who prefers this format?
>>>> It already got opposition so I'm not sure what to do.
>>>
>>> I think it doesn't matter.
>>>
>>> Trivial inconsistencies in patch subject and word choice
>>> don't have much overall impact.
>> 
>> I wrote in a confusing way, my question above was about the actual patch
>> and not the the title. For example, Jes didn't like this style change:
>> 
>> https://patchwork.kernel.org/patch/11402315/
>> 
>
> It doesn't seem that that comment adds a lot to the conversation. The only
> thing that it says is literally "fix the compiler". By the way, more than
> a hundred patches have already been applied to linux-next[1] and he seems
> to be the only person that has commented such a thing.

But I also asked who prefers this format in that thread, you should not
ignore questions from two maintainers (me and Jes).

> Qemu guys are adopting this format, too[2][3].
>
> On the other hand, the changelog text explains the reasons why we are
> implementing this change all across the kernel tree. :)
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/?qt=grep&q=flexible-array
> [2] https://lists.nongnu.org/archive/html/qemu-s390x/2020-03/msg00019.html
> [3] https://lists.nongnu.org/archive/html/qemu-s390x/2020-03/msg00020.html

TBH I was leaning more on Jes side on this, but I guess these patches
are ok if they are so widely accepted. Unless anyone objects?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
