Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647BB18FA4A
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCWQrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:47:05 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:24034 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727281AbgCWQrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 12:47:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584982024; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Xb2zinDQGO+onzyW77lJl6Bc9KqowAWzCfieud9lBEI=; b=N95mVFGzsTNjSsZIHkgStVkgSuzlkwHytk6V7QcWWorpMjgkuFjaY6PLQmwPibBhA1hFTgH8
 BPHjOGlNzD/RgmE4yhotFHii2HmghnhaCCW+maRRmG/y0qelFuq/bOvaiwaaylpUYMmOG9ay
 /YEBesgsbfwd7BoQdbtqzsvw9Gc=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e78e7fa.7fb8e14e5768-smtp-out-n03;
 Mon, 23 Mar 2020 16:46:50 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5EAC4C4478C; Mon, 23 Mar 2020 16:46:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 39E75C433CB;
        Mon, 23 Mar 2020 16:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 39E75C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Joe Perches <joe@perches.com>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with flexible-array member
References: <20200305111216.GA24982@embeddedor>
        <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
        <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
        <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
        <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
        <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
        <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
        <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
        <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
        <361da904-5adf-eb0c-e937-c5d2f69ac8be@gmail.com>
        <e4cfda6c-37f0-3c28-f50b-32200a67d856@embeddedor.com>
        <9700b2c9-1029-60b0-c5d2-684bdcede354@gmail.com>
        <948ec681-c4ee-3479-8d8b-5aa1e358ec04@embeddedor.com>
Date:   Mon, 23 Mar 2020 18:46:45 +0200
In-Reply-To: <948ec681-c4ee-3479-8d8b-5aa1e358ec04@embeddedor.com> (Gustavo A.
        R. Silva's message of "Tue, 10 Mar 2020 17:36:39 -0500")
Message-ID: <87h7yfauiy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> On 3/10/20 5:34 PM, Jes Sorensen wrote:
>> On 3/10/20 6:31 PM, Gustavo A. R. Silva wrote:
>>>
>>>
>>> On 3/10/20 5:20 PM, Jes Sorensen wrote:
>>>> On 3/10/20 6:13 PM, Gustavo A. R. Silva wrote:
>>>>>
>>>>>
>>>>> On 3/10/20 5:07 PM, Jes Sorensen wrote:
>>>>>> As I stated in my previous answer, this seems more code churn than an
>>>>>> actual fix. If this is a real problem, shouldn't the work be put into
>>>>>> fixing the compiler to handle foo[0] instead? It seems that is where the
>>>>>> real value would be.
>>>>>
>>>>> Yeah. But, unfortunately, I'm not a compiler guy, so I'm not able to fix the
>>>>> compiler as you suggest. And I honestly don't see what is so annoying/disturbing
>>>>> about applying a patch that removes the 0 from foo[0] when it brings benefit
>>>>> to the whole codebase.
>>>>
>>>> My point is that it adds what seems like unnecessary churn, which is not
>>>> a benefit, and it doesn't improve the generated code.
>>>>
>>>
>>> As an example of one of the benefits of this is that the compiler won't trigger
>>> a warning in the following case:
>>>
>>> struct boo {
>>> 	int stuff;
>>> 	struct foo array[0];
>>> 	int morestuff;
>>> };
>>>
>>> The result of the code above is an undefined behavior.
>>>
>>> On the other hand in the case below, the compiles does trigger a warning:
>>>
>>> struct boo {
>>> 	int stuff;
>>> 	struct foo array[];
>>> 	int morestuff;
>>> };
>> 
>> Right, this just underlines my prior argument, that this should be fixed
>> in the compiler.
>> 
>
> In the meantime it's not at all harmful to do something about it in the codebase.

Cleanup patches are not always harmful, at least they can create bugs
and conflicts. But I think in this case there are clear benefits for the
churn so I'm going to apply these.

Sorry Jes :)

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
