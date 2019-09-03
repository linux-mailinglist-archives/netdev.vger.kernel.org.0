Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D432A698F
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfICNSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:18:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34028 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICNSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:18:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id s18so17508189wrn.1
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 06:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cTBBvmiTcXl4MQwoKwR6r11ay+tcqNEvv+c/pKpVGX0=;
        b=grEIrVMjVvTzj7Z4N2mI023lnmXgFESADWCu2qe/V4jUhq1wX4rR/oAxsaZw4DrCBL
         94w9oDkXrOY01b6iYzTB9Y0y48JrO6JqBH6GUtn8jTl0sevt+auJdoFfhi+z29yZo0dH
         AySZhc4TTLPUlnimEm07q2D6bzey+/gUSk/88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cTBBvmiTcXl4MQwoKwR6r11ay+tcqNEvv+c/pKpVGX0=;
        b=kwX+Br9NIoRhnBzG18TaUVzMKC5TphPURfzuzVHPgIvf4WoFbx2TEMep/juFyvTUzl
         EBEMc7K9h03EYr5drrVLZYzhgwNGTPD6n3frSX7xquzAhykRqq1w9uqk7+qkV3hs/746
         mIM48cb6CPEJqIu+x98VIF5KR5AFU5mlQGAjx2skOGbd+mvnjihUWdSb+T0j6S2afiIT
         aDQ4F6NyDAotP9Dtg2rMhCeY8WzuJ64Wspd2/g8o2BK24b7iNb2C7LiMRJdo2ZxE8Odf
         wSPYdTzSVcWngmTiyxIIFeMGfy53iVKIg4g3Yu+q1ywmmRS8TFESZArz+GLPwJ23Pdul
         SD3g==
X-Gm-Message-State: APjAAAVEFdQ5/oQWRStrDowG73z1WEIxQNPCTZ9o5WR6A26AP4kjic8Z
        ct3fu6Ny6pHt//QqfrQUJNoljQUL70xxrA==
X-Google-Smtp-Source: APXvYqxs+a9w00bDVk1zqWFFt/p+DjzotKj99O7qA9WVq+xhWPCuGpQdelM//mCUTyjAwz/7t8+MBg==
X-Received: by 2002:adf:f404:: with SMTP id g4mr41931040wro.290.1567516723290;
        Tue, 03 Sep 2019 06:18:43 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s15sm11591944wmh.12.2019.09.03.06.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 06:18:42 -0700 (PDT)
Subject: Re: [PATCH net] ipmr: remove cache_resolve_queue_len
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
 <e0261582-78ce-038f-ed4c-c2694fb70250@cumulusnetworks.com>
 <20190903125547.GH18865@dhcp-12-139.nay.redhat.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <bd3d7ecb-9343-72df-7880-21d594baa22d@cumulusnetworks.com>
Date:   Tue, 3 Sep 2019 16:18:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903125547.GH18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2019 15:55, Hangbin Liu wrote:
> Hi Nikolay,
> 
> Thanks for the feedback, see comments below.
> 
> On Tue, Sep 03, 2019 at 12:15:34PM +0300, Nikolay Aleksandrov wrote:
>> On 03/09/2019 11:43, Hangbin Liu wrote:
>>> This is a re-post of previous patch wrote by David Miller[1].
>>>
>>> Phil Karn reported[2] that on busy networks with lots of unresolved
>>> multicast routing entries, the creation of new multicast group routes
>>> can be extremely slow and unreliable.
>>>
>>> The reason is we hard-coded multicast route entries with unresolved source
>>> addresses(cache_resolve_queue_len) to 10. If some multicast route never
>>> resolves and the unresolved source addresses increased, there will
>>> be no ability to create new multicast route cache.
>>>
>>> To resolve this issue, we need either add a sysctl entry to make the
>>> cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
>>> directly, as we already have the socket receive queue limits of mrouted
>>> socket, pointed by David.
>>>
>>> From my side, I'd perfer to remove the cache_resolve_queue_len instead
>>> of creating two more(IPv4 and IPv6 version) sysctl entry.
>>>
>>> [1] https://lkml.org/lkml/2018/7/22/11
>>> [2] https://lkml.org/lkml/2018/7/21/343
>>>
>>> Reported-by: Phil Karn <karn@ka9q.net>
>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>>> ---
>>>  include/linux/mroute_base.h |  2 --
>>>  net/ipv4/ipmr.c             | 27 ++++++++++++++++++---------
>>>  net/ipv6/ip6mr.c            | 10 +++-------
>>>  3 files changed, 21 insertions(+), 18 deletions(-)
>>>
>>
>> Hi,
>> IMO this is definitely net-next material. A few more comments below.
> 
> I thoug this is a bug fix. But it looks more suitable to net-next as you said.
>>
>> Note that hosts will automatically have this limit lifted to about 270
>> entries with current defaults, some might be surprised if they have
>> higher limits set and could be left with queues allowing for thousands
>> of entries in a linked list.
> 
> I think this is just a cache list and should be expired soon. The cache
> creation would also failed if there is no buffer.
> 
> But if you like, I can write a patch with sysctl parameter.

I wasn't suggesting the sysctl, I'm actually against it as I've said before when
commenting these patches. Just wanted to note that some setups will end up with
the possibility of having thousands of entries in a linked list after updating. Unless
we change the data structure I guess we just have to live with it, I wouldn't want to
add a sysctl or another hard limit that will have to be removed after a while. In the
long run we might update the algorithm used for unres entries.

So to make it clear: I'm fine with this patch as it is, definitely an improvement IMO.

>>
>>> +static int queue_count(struct mr_table *mrt)
>>> +{
>>> +	struct list_head *pos;
>>> +	int count = 0;
>>> +
>>> +	list_for_each(pos, &mrt->mfc_unres_queue)
>>> +		count++;
>>> +	return count;
>>> +}
>>
>> I don't think we hold the mfc_unres_lock here while walking
>> the unresolved list below in ipmr_fill_table().
> 
> ah, yes, I will fix this.
> 
> Thanks
> Hangbin
> 

