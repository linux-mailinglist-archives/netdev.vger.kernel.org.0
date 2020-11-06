Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4582A91DD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgKFI5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:57:44 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:39850 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgKFI5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:57:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UEPEj-X_1604653060;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEPEj-X_1604653060)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 16:57:40 +0800
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
To:     Joe Perches <joe@perches.com>, andrew@lunn.ch
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
 <71dc38c1646980840fb83d82fc588501af72e05f.camel@perches.com>
 <8e0fac45-9107-cdfe-de9e-ccf3abd416a4@linux.alibaba.com>
 <1662b333dd72369af4c1173035d43590fbc45292.camel@perches.com>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <28a5c53a-a576-7884-85ae-2adba39f2b8f@linux.alibaba.com>
Date:   Fri, 6 Nov 2020 16:57:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1662b333dd72369af4c1173035d43590fbc45292.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2020/11/6 下午4:52, Joe Perches 写道:
> On Fri, 2020-11-06 at 16:28 +0800, Alex Shi wrote:
>>
>> 在 2020/11/6 下午2:36, Joe Perches 写道:
>>> On Fri, 2020-11-06 at 13:37 +0800, Alex Shi wrote:
>>>> There are some macros unused, they causes much gcc warnings. Let's
>>>> remove them to tame gcc.
>>>
>>> I believe these to be essentially poor warnings.
>>>
>>> Aren't these warnings generated only when adding  W=2 to the make
>>> command line?
>>>
>>> Perhaps it's better to move the warning to level 3
>>> ---
>>> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
>>> index 95e4cdb94fe9..5c3c220ddb32 100644
>>> --- a/scripts/Makefile.extrawarn
>>> +++ b/scripts/Makefile.extrawarn
>>> @@ -68,7 +68,6 @@ KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
>>>  KBUILD_CFLAGS += -Wmissing-field-initializers
>>>  KBUILD_CFLAGS += -Wtype-limits
>>>  KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
>>> -KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
>>
>> This changed too much, and impact others. May not good. :)
> 
> Can you clarify what you mean?
> 

Uh, change in this file will impact all kernels not only for net/dsa.
If you want to keep these unused macros, maybe better to put them into comments?

Thanks!
Alex
