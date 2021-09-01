Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC233FD701
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243712AbhIAJmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:42:00 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:34273 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232817AbhIAJmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:42:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Umv2hQ-_1630489260;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Umv2hQ-_1630489260)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Sep 2021 17:41:01 +0800
Subject: Re: [PATCH v2] net: fix NULL pointer reference in cipso_v4_doi_free
To:     David Miller <davem@davemloft.net>
Cc:     paul@paul-moore.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <84262e7b-fda6-9d7d-b0bd-1bb0e945e6f9@linux.alibaba.com>
 <CAHC9VhRPUa-oD_85j6RcAVvp7sLZQEAGGapYYP1fEt7Ax5LMfA@mail.gmail.com>
 <1ed31e79-809b-7ac9-2760-869570ac22ea@linux.alibaba.com>
 <20210901.103033.925382819044968737.davem@davemloft.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <6ca4a2d5-9a9c-1b14-85b4-1f4a0f743104@linux.alibaba.com>
Date:   Wed, 1 Sep 2021 17:41:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901.103033.925382819044968737.davem@davemloft.net>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/1 下午5:30, David Miller wrote:
> From: 王贇 <yun.wang@linux.alibaba.com>
> Date: Wed, 1 Sep 2021 09:51:28 +0800
> 
>>
>>
>> On 2021/8/31 下午9:48, Paul Moore wrote:
>>> On Mon, Aug 30, 2021 at 10:42 PM 王贇 <yun.wang@linux.alibaba.com> wrote:
>>>> On 2021/8/31 上午12:50, Paul Moore wrote:
>>>> [SNIP]
>>>>>>>> Reported-by: Abaci <abaci@linux.alibaba.com>
>>>>>>>> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>>  net/netlabel/netlabel_cipso_v4.c | 4 ++--
>>>>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> I see this was already merged, but it looks good to me, thanks for
>>>>>>> making those changes.
>>>>>>
>>>>>> FWIW it looks like v1 was also merged:
>>>>>>
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=733c99ee8b
>>>>>
>>>>> Yeah, that is unfortunate, there was a brief discussion about that
>>>>> over on one of the -stable patches for the v1 patch (odd that I never
>>>>> saw a patchbot post for the v1 patch?).  Having both merged should be
>>>>> harmless, but we want to revert the v1 patch as soon as we can.
>>>>> Michael, can you take care of this?
>>>>
>>>> As v1 already merged, may be we could just goon with it?
>>>>
>>>> Actually both working to fix the problem, v1 will cover all the
>>>> cases, v2 take care one case since that's currently the only one,
>>>> but maybe there will be more in future.
>>>
>>> No.  Please revert v1 and stick with the v2 patch.  The v1 patch is in
>>> my opinion a rather ugly hack that addresses the symptom of the
>>> problem and not the root cause.
>>>
>>> It isn't your fault that both v1 and v2 were merged, but I'm asking
>>> you to help cleanup the mess.  If you aren't able to do that please
>>> let us know so that others can fix this properly.
>>
>> No problem I can help on that, just try to make sure it's not a
>> meaningless work.
>>
>> So would it be fine to send out a v3 which revert v1 and apply v2?
> 
> Please don't do things this way just send the relative change.

Could you please check the patch:

Revert "net: fix NULL pointer reference in cipso_v4_doi_free"

see if that's the right way?

Regards,
Michael Wang

> 
> Thanks.
> 
