Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F2E180B3A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJWOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:14:02 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.154]:42399 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbgCJWOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:14:02 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 5604C400CDBB5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 17:13:19 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Bn7njTjwxEfyqBn7njW4w1; Tue, 10 Mar 2020 17:13:19 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LGn5R7nio+zIIEI3TW5iV/Xir950f8gqF9dbU/tWSDk=; b=bVXYq8To1DkDJNTngXcJXMIRM5
        ase5kSd7Ka0nMamn7fBQnhFhU6jnHGVLfObdAeewIPItZlxncjnDlBwBZl6ahrZ/Xp1HpuFW3k8R1
        sGcUoB3Xt57vd2FhjBNAriPLX6++KrW7CyQ1SsTvUDdXlvK39ZsNkXDlWJcAnku5Dx7c46YBPr3B5
        nUjMSn8kd78ehQbHk0MAjqb006YssOsGoS2D5mGvyOqJDMm8TgIj/HpIP2RI9kUgqpZaotHxlOIl/
        dY6rzff6s7v+9CmZKcTXD6TSzGmFL5vzzWbE90MH8TSmnRX/h8fLpTL1ywnDx53FA2stxz6/ZDIlr
        c9Ng4/qA==;
Received: from 187-162-252-62.static.axtel.net ([187.162.252.62]:46822 helo=[192.168.0.140])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jBn7m-002Pl2-LT; Tue, 10 Mar 2020 17:13:18 -0500
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
To:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Joe Perches <joe@perches.com>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305111216.GA24982@embeddedor>
 <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
 <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
 <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
 <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
 <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
 <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
 <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Openpgp: preference=signencrypt
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 VtSixD1uOgytAP7RWS474w==
Message-ID: <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
Date:   Tue, 10 Mar 2020 17:13:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.252.62
X-Source-L: No
X-Exim-ID: 1jBn7m-002Pl2-LT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-252-62.static.axtel.net ([192.168.0.140]) [187.162.252.62]:46822
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 5:07 PM, Jes Sorensen wrote:
> On 3/10/20 5:52 PM, Gustavo A. R. Silva wrote:
>>
>>
>> On 3/10/20 8:56 AM, Kalle Valo wrote:
>>> + jes
>>>
>>> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
>>>>> I wrote in a confusing way, my question above was about the actual patch
>>>>> and not the the title. For example, Jes didn't like this style change:
>>>>>
>>>>> https://patchwork.kernel.org/patch/11402315/
>>>>>
>>>>
>>>> It doesn't seem that that comment adds a lot to the conversation. The only
>>>> thing that it says is literally "fix the compiler". By the way, more than
>>>> a hundred patches have already been applied to linux-next[1] and he seems
>>>> to be the only person that has commented such a thing.
>>>
>>> But I also asked who prefers this format in that thread, you should not
>>> ignore questions from two maintainers (me and Jes).
>>>
>>
>> I'm sorry. I thought the changelog text had already the proper information.
>> In the changelog text I'm quoting the GCC documentation below:
>>
>> "The preferred mechanism to declare variable-length types like struct line
>> above is the ISO C99 flexible array member..." [1]
>>
>> I'm also including a link to the following KSPP open issue:
>>
>> https://github.com/KSPP/linux/issues/21
>>
>> The issue above mentions the following:
>>
>> "Both cases (0-byte and 1-byte arrays) pose confusion for things like sizeof(),
>> CONFIG_FORTIFY_SOURCE."
>>
>> sizeof(flexible-array-member) triggers a warning because flexible array members have
>> incomplete type[1]. There are some instances of code in which the sizeof operator
>> is being incorrectly/erroneously applied to zero-length arrays and the result is zero.
>> Such instances may be hiding some bugs. So, the idea is also to get completely rid
>> of those sorts of issues.
> 
> As I stated in my previous answer, this seems more code churn than an
> actual fix. If this is a real problem, shouldn't the work be put into
> fixing the compiler to handle foo[0] instead? It seems that is where the
> real value would be.
> 

Yeah. But, unfortunately, I'm not a compiler guy, so I'm not able to fix the
compiler as you suggest. And I honestly don't see what is so annoying/disturbing
about applying a patch that removes the 0 from foo[0] when it brings benefit
to the whole codebase.

Thanks
--
Gustavo
