Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5D11219FD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfLPTdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:33:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44677 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfLPTdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:33:04 -0500
Received: by mail-pf1-f194.google.com with SMTP id d199so6139893pfd.11;
        Mon, 16 Dec 2019 11:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QFjL5myRIeG9APkgin0CHrAVKzFukbXJqbz2mhi0ULI=;
        b=HqWGZeBT95RQyh/jlcBII89oK9Eq/t9rAUBuX2J1yCY24GkIW9i20TRWMy8ZCr81Sa
         GDnJND/Q+2PHCSTSVPYTWw1rRtMVimwg4r1fmr9VdbKfPk1RrLQqDiYlzUVrJL5aLEK+
         /CFI8xVwp5Kw4YSO9LFK92GX/BKFEat8cKFgledcWUWzUfywz7F7hxWywSuzRpHD4/6D
         OviNbdsnc4w8vL03fkXK4IHnugCZKRW5+05XoVtx8C0cBcaEtGVK/8aoyn/WN/qFz9IC
         OmFTJCvHIfbsnSusqCPXJImMnRVKFxWx6Jk1GgxVuWFbJY69r6GV2MbEKXzwE8NVyLY6
         iKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QFjL5myRIeG9APkgin0CHrAVKzFukbXJqbz2mhi0ULI=;
        b=oc7E8hD2JpHwfjcN8gZl1Vk4a+gzVKD0j1GCdHFF5jxW9f7bbxcnmSpkusf2/91+iU
         JCOWEAdwzaWV8eWSUlLdunGwBwJmWwr82OcH7onEDuwNFphMWFlqFVSMKPhyoc2D9Let
         jSBtLz5qO39+e5a0AqIvpcQZLW9j/cLP7qoml5PZn9w2VW5U7zDxVTpqDJD/7xElX7AB
         oAegFMBi2/V8JlWW4KBBqdUsyw7NXN2TS0SLi+VIg1hAbdyTR6tRf6LYBSFGma9KW8TI
         tORy9dAwfpAXF5FQCNWr8qZZG7aBmgaDku/zJGkXVnvrQbg4quFsKsBkjF2OFyUSSbaN
         d2cw==
X-Gm-Message-State: APjAAAVRYM17t1e+jQThg9iZTBB/e37scV8n5/AB+IcqcSLtoPbgcfKt
        NgnBYYsnt18iTdyj1hCXSCwjLYVa
X-Google-Smtp-Source: APXvYqwzkY23p8Z4wjVyAfXloqd8aiuPtFfhMBVLE+xURH/PJisRzUMUKtxtkuMul0FPdYilGFHd6A==
X-Received: by 2002:a63:48d:: with SMTP id 135mr20174520pge.66.1576524783377;
        Mon, 16 Dec 2019 11:33:03 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id k23sm23491920pgg.7.2019.12.16.11.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 11:33:02 -0800 (PST)
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
To:     Martin Lau <kafai@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
 <20191216191357.ftadvchztbpggcus@kafai-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a2d8d888-16e1-243d-92c9-56ba3a3e1b18@gmail.com>
Date:   Mon, 16 Dec 2019 11:33:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191216191357.ftadvchztbpggcus@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/19 11:14 AM, Martin Lau wrote:
> On Fri, Dec 13, 2019 at 05:59:54PM -0800, Eric Dumazet wrote:
>>
>>
>> On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
>>> This patch adds a helper to handle jiffies.  Some of the
>>> tcp_sock's timing is stored in jiffies.  Although things
>>> could be deduced by CONFIG_HZ, having an easy way to get
>>> jiffies will make the later bpf-tcp-cc implementation easier.
>>>
>>
>> ...
>>
>>> +
>>> +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
>>> +{
>>> +	if (!flags)
>>> +		return get_jiffies_64();
>>> +
>>> +	if (flags & BPF_F_NS_TO_JIFFIES) {
>>> +		return nsecs_to_jiffies(in);
>>> +	} else if (flags & BPF_F_JIFFIES_TO_NS) {
>>> +		if (!in)
>>> +			in = get_jiffies_64();
>>> +		return jiffies_to_nsecs(in);
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> This looks a bit convoluted :)
>>
>> Note that we could possibly change net/ipv4/tcp_cubic.c to no longer use jiffies at all.
>>
>> We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be converted to ms.
> Thanks for the feedbacks!
> 
> I have a few questions that need some helps.
> 
> Does it mean tp->tcp_mstamp can be used as the "now" in cubic?

TCP makes sure to update tp->tcp_mstamp at least once when handling
a particular packet. We did that to avoid calling possibly expensive
kernel time service (Some platforms do not have fast TSC) 

> or tcp_clock_ns() should still be called in cubic, e.g. to replace
> bictcp_clock() and tcp_jiffies32?

Yeah, there is this lsndtime and tcp_jiffies32 thing, but maybe
we can find a way to fetch jiffies32 without having to call a bpf helper ?

> 
> BPF currently has a helper calling ktime_get_mono_fast_ns() which looks
> different from tcp_clock_ns().

That's maybe because of NMI requirements. 

TCP in the other hand is in process or BH context.

But it should not matter, cubic could should not have to call them.
