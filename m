Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2A4431F69
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhJROYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:24:52 -0400
Received: from out2.migadu.com ([188.165.223.204]:29742 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhJROYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:24:52 -0400
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: compact the file ice_nvm.c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634566959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/ksyZMdAji56dPAfDNw4B0mj9DFTtJ003ib9TAoySs=;
        b=L2lCuaq6/voknrtgSX/EK/kAgQjpd+foWH0RJQQjRPO2TAGHupbgu0ImCL88ypja5haNMi
        LQNOtwqAFnC6Ga94gKPyYgYVwnz87vpQRF9J4K4sqI7/deepFBZ8lcKqwNPkU30mYjUGlq
        lVhHeJoaawKC4m+oHdWC6zShcu5Xjwg=
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20211018131713.3478-1-yanjun.zhu@linux.dev>
 <c1903730-9508-1fef-4232-3a5b62f28d7c@molgen.mpg.de>
 <087710e9-2aeb-c070-cebb-82ae9cb5c20e@linux.dev>
 <10c80bab-db74-b567-505c-95d74763248f@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanjun Zhu <yanjun.zhu@linux.dev>
Message-ID: <2b0dbaf8-1033-b1a3-8976-83a785fbe682@linux.dev>
Date:   Mon, 18 Oct 2021 22:22:28 +0800
MIME-Version: 1.0
In-Reply-To: <10c80bab-db74-b567-505c-95d74763248f@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yanjun.zhu@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/10/18 22:05, Paul Menzel 写道:
> Dear Yanjun,
>
>
> Am 18.10.21 um 16:00 schrieb Yanjun Zhu:
>
>> 在 2021/10/18 21:44, Paul Menzel 写道:
>
>>> Am 18.10.21 um 15:17 schrieb yanjun.zhu@linux.dev:
>>>> From: Zhu Yanjun <yanjun.zhu@linux.dev>
>>>>
>>>> The function ice_aq_nvm_update_empr is not used, so remove it.
>>>
>>> Thank you for the patch. Could you please make the commit message 
>>> summary more descriptive? Maybe:
>>>
>>>> ice: Remove unused `ice_aq_nvm_update_empr()`
>>>
>>> If you find out, what commit removed the usage, that would be also 
>>> good to document, but it’s not that important.
>>
>> Thanks for your suggestion.
>>
>> IMO, removing the unused function is one method of compact file.
>>
>> I agree with you that the commit message summary is not important.
>
> Sorry, you misunderstood me. The commit message summary is my opinion 
> very important, as it’s what shown in `git log --oneline`, and in this 
> case everybody has to read the full commit message to know what the 
> commit actually as *compact* is not conveying this meaning and is 
> ambiguous.
>
> Not as important is finding the commit removing the last user, and 
> adding a Fixes tag with it.
Got it.
>
>> If someone finds more important problem in this commit, I will resend 
>> the
>>
>> patch and change the commit message summary based on your suggestion.
>
> It’d be great, if you sent an improved version.

I will resend the latest version.

Zhu Yanjun

>
>
> Kind regards,
>
> Paul
