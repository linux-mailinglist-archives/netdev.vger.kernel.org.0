Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBFA287A0B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbgJHQhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbgJHQhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 12:37:17 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3FBC061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 09:37:17 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t20so186493edr.11
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 09:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nYdZr7R5VNY5rSikFcYx/uW4NhHlBBbI7EClfyIU570=;
        b=brt2Ns0gn2A2UR+7Lf1Q76ZHeZWo7ph/NlTJdo8/qyyY8Y0bKRzRTcDhmffcHrk5hH
         ltC2z/mEM2h0soZUPlW3AwiMRc1im/I+dy8Qh9673Dmm78lea7GBciwi09TeRuXiDUqB
         0Htq8+uiTuFEjnBuxGPQU3QA8kW5LF6ErJsgyPKjlPUG5jR8yI2NxJgKX5q6LffdBA+8
         PnyOJcTjaNLwmziBYtsgHY6CaSaZ2tgfzczlQ8Ggdo/nBz/OHqjX7ro93jPFizgXpE7e
         E7aOhT6O2A92/72byH5k6AsIu2vHL7kRZn0en3USBt+xg85T/o9ordoVj7SdgzDhxudq
         ALQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nYdZr7R5VNY5rSikFcYx/uW4NhHlBBbI7EClfyIU570=;
        b=iiBksKgmygaJwPDEZuCA4C57L3SMc17U04Qm9yqWzq1k5BbJXZ7CYZGOd8iaWQ+GWk
         1BHlg7ZE8DQrdI95p+7/OLsIzy8KyhFXInoB2IY6eTzDUPPSb5k+6ScO3T8IZdtQVWav
         09PhviV766GeL7CvlzH5B1bpuh+E90kJFGCOYf8c98KAwas5LteWp40wCvBHmyyFVmXk
         Zh4rdASyShZsOVpgk4572Ixs4Wfp411FgAnRamKb4s5eCbYnaME2A8Cbbcu6GBGx3Ccs
         XLUMFSzTuuFtya719w5+tFSl1IrEkYKyuBI4/GNh+oinmJp553nbITfnPyDQJjLuueVZ
         BKlA==
X-Gm-Message-State: AOAM5337Dzbg7mcUBFZPxhTUy5vCtAj8yVK2VvGS7bsKK50Zz0glG0KL
        WPDALBIyyebeXWfyuIA1VQIHsDlQLmTspA==
X-Google-Smtp-Source: ABdhPJxCKcC5fuonhUXmPucYNSXr7RqhNyqMxDZv3KpwM6zxrCm2mVQvHNbgvKziXS9m3/Tt5a4rYw==
X-Received: by 2002:a05:6402:21e9:: with SMTP id ce9mr10079638edb.125.1602175034762;
        Thu, 08 Oct 2020 09:37:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:28bc:8b04:587d:85d4? (p200300ea8f006a0028bc8b04587d85d4.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:28bc:8b04:587d:85d4])
        by smtp.googlemail.com with ESMTPSA id cw15sm4448178ejb.47.2020.10.08.09.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 09:37:14 -0700 (PDT)
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
 <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
 <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
 <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
Date:   Thu, 8 Oct 2020 18:37:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.10.2020 13:48, Eric Dumazet wrote:
> On Fri, Oct 2, 2020 at 1:09 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 02.10.2020 10:46, Eric Dumazet wrote:
>>> On Fri, Oct 2, 2020 at 10:32 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 10/2/20 10:26 AM, Eric Dumazet wrote:
>>>>> On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>>>
>>>>>> I have a problem with the following code in ndo_start_xmit() of
>>>>>> the r8169 driver. A user reported the WARN being triggered due
>>>>>> to gso_size > 0 and gso_type = 0. The chip supports TSO(6).
>>>>>> The driver is widely used, therefore I'd expect much more such
>>>>>> reports if it should be a common problem. Not sure what's special.
>>>>>> My primary question: Is it a valid use case that gso_size is
>>>>>> greater than 0, and no SKB_GSO_ flag is set?
>>>>>> Any hint would be appreciated.
>>>>>>
>>>>>>
>>>>>
>>>>> Maybe this is not a TCP packet ? But in this case GSO should have taken place.
>>>>>
>>>>> You might add a
>>>>> pr_err_once("gso_type=%x\n", shinfo->gso_type);
>>>>>
>>>
>>>>
>>>> Ah, sorry I see you already printed gso_type
>>>>
>>>> Must then be a bug somewhere :/
>>>
>>>
>>> napi_reuse_skb() does :
>>>
>>> skb_shinfo(skb)->gso_type = 0;
>>>
>>> It does _not_ clear gso_size.
>>>
>>> I wonder if in some cases we could reuse an skb while gso_size is not zero.
>>>
>>> Normally, we set it only from dev_gro_receive() when the skb is queued
>>> into GRO engine (status being GRO_HELD)
>>>
>> Thanks Eric. I'm no expert that deep in the network stack and just wonder
>> why napi_reuse_skb() re-initializes less fields in shinfo than __alloc_skb().
>> The latter one does a
>> memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
>>
> 
> memset() over the whole thing is more expensive.
> 
> Here we know the prior state of some fields, while __alloc_skb() just
> got a piece of memory with random content.
> 
>> What I can do is letting the affected user test the following.
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 62b06523b..8e75399cc 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6088,6 +6088,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>>
>>         skb->encapsulation = 0;
>>         skb_shinfo(skb)->gso_type = 0;
>> +       skb_shinfo(skb)->gso_size = 0;
>>         skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
>>         skb_ext_reset(skb);
>>
> 
> As I hinted, this should not be needed.
> 
> For debugging purposes, I would rather do :
> 
> BUG_ON(skb_shinfo(skb)->gso_size);
> 

We did the following for debugging:

diff --git a/net/core/dev.c b/net/core/dev.c
index 62b06523b..4c943b774 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3491,6 +3491,9 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 {
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
+	if (!skb_shinfo(skb)->gso_type)
+		skb_warn_bad_offload(skb);
+
 	if (gso_segs > dev->gso_max_segs)
 		return features & ~NETIF_F_GSO_MASK;

Following skb then triggered the skb_warn_bad_offload. Not sure whether this helps
to find out where in the network stack something goes wrong.


[236222.967236] skb len=134 headroom=778 headlen=134 tailroom=31536
                mac=(778,14) net=(792,20) trans=812
                shinfo(txflags=0 nr_frags=0 gso(size=568 type=0 segs=1))
                csum(0x0 ip_summed=1 complete_sw=0 valid=0 level=0)
                hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=4
[236222.967297] dev name=enp1s0 feat=0x0x00000100000041b2
[236222.967392] skb linear:   00000000: 00 13 3b a0 01 e8 7c d3 0a 2d 1b 3b 08 00 45 00
[236222.967404] skb linear:   00000010: 00 78 e2 e6 00 00 7b 06 52 e1 d8 3a d0 ce c0 a8
[236222.967415] skb linear:   00000020: a0 06 01 bb 8b c6 53 91 be 5e 6e 60 bd e2 80 18
[236222.967426] skb linear:   00000030: 01 13 5c f6 00 00 01 01 08 0a 3d d6 6a a3 63 ea
[236222.967437] skb linear:   00000040: 5c d9 17 03 03 00 3f af 00 01 84 45 e2 36 e4 6a
[236222.967454] skb linear:   00000050: 3d 76 a8 7f d7 12 fa 72 4b d1 d0 74 0d c1 49 77
[236222.967466] skb linear:   00000060: 8b a4 bb 04 e5 aa 03 61 d3 e6 1f c9 0d 3e 46 c8
[236222.967477] skb linear:   00000070: cd 1f 7d ce e8 a7 84 84 01 5d 1f b4 ee 4f 27 63
[236222.967488] skb linear:   00000080: d2 a1 ab 1f 26 1d



> 
> Nothing in GRO stack will change gso_size, unless the packet is queued
> by GRO layer (after this, napi_reuse_skb() wont be called)
> 
> napi_reuse_skb() is only used when a packet has been aggregated to
> another, and at this point gso_size should be still 0.
> 

