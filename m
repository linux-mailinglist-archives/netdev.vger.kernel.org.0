Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4DA1D1C8F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389990AbgEMRs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732670AbgEMRs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:48:28 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353A5C061A0C;
        Wed, 13 May 2020 10:48:28 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id c24so525092qtw.7;
        Wed, 13 May 2020 10:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=w53WaJJgmcQQ01HlT8AnvxfmHbhcsCg6gxlaqiiFh10=;
        b=Ywiew1D6kVBC+C0NBaJ54n+RLA7kmLnZ3A18d1xhBd5M04X//L5oCVs38ItF0b1bu/
         RahX93s/zZLQM356osfIszVEkTFg1K8Ux+buVtoJDY+0RrooE7Dl/3yd2CV3trUrKllz
         jVqUVI5Hbd+O2dH8sx16gI62mMdcGVgsvCQ6nECzpO+UQRJM1x86J2n2GNANrMozV7NN
         lIxyJjMIyL3DbPORzyUIiRacCbX3QhuCMygAeKAVb0p8euvoC0svCj5cKuARtmP3bOl+
         NZuxlbTHggXDz5AtlSdkZ80QlFiO0SFR2LfS1zIBnAv1anKlp/WkhZhPoRQ5qAbPPE6O
         A0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w53WaJJgmcQQ01HlT8AnvxfmHbhcsCg6gxlaqiiFh10=;
        b=Bhi/IM7Sjnx4zmKUjTqFdaM40ONSXJkbQOP/oeExwAXbgaJF/Q2OirmO0cYWW/actb
         r23KMaI1fkFbxMxtXEopyTEE20xAFMPjzGiN12I6OvYHhS5eqMiouMwq9jlmIkPttaui
         0h1f2c3GRHprE53u4Uzc2JCh9a9Jw8NXroqY+SkaCi7SFh4iCbsR1y50wb8fiY4g9wHx
         eAemhX2Xe9uEoKQYOQGDNx33xjQBZQTeld104xvRC5stK1WWUHTVz1OmK9z/iB2O3wQj
         DgSvJzJmecxlPYdtAYORS0E35oY9KrQ4JIBZH8+0HV7EuVoTaHsOct3XO/9K0hL+hw94
         eApQ==
X-Gm-Message-State: AOAM530U/D00/JSVHo5O3yylcCqZgrMGxpq5hBhnak0M55YmclYpJHRf
        5HbfIAIkWbN7OHlhiZ+6DsI=
X-Google-Smtp-Source: ABdhPJxyD0ubnOPjxRMSGcYwGHZ+mW/FssK3xfXAhMuuTcjAIpWqJIx+y1JcmMPVbEBFRhfb4mYSmw==
X-Received: by 2002:ac8:4645:: with SMTP id f5mr230208qto.379.1589392107367;
        Wed, 13 May 2020 10:48:27 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4082:2138:4ed8:3e6? ([2601:282:803:7700:4082:2138:4ed8:3e6])
        by smtp.googlemail.com with ESMTPSA id 17sm446956qkn.44.2020.05.13.10.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 10:48:26 -0700 (PDT)
Subject: Re: "Forwarding" from TC classifier
To:     Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com>
Date:   Wed, 13 May 2020 11:48:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 10:40 AM, Lorenz Bauer wrote:
> We've recently open sourced a key component of our L4 load balancer:
> cls_redirect [1].
> In the commit description, I call out the following caveat:
> 
>     cls_redirect relies on receiving encapsulated packets directly
> from a router. This is
>     because we don't have access to the neighbour tables from BPF, yet.

Can you explain more about this limitation? Why does access to neighbor
tables solve the problem?

> 
> The code in question lives in forward_to_next_hop() [2], and does the following:
> 1. Swap source and destination MAC of the packet
> 2. Update source and destination IP address
> 3. Transmit the packet via bpf_redirect(skb->ifindex, 0)
> 
> Really, I'd like to get rid of step 1, and instead rely on the network
> stack to switch or route
> the packet for me. The bpf_fib_lookup helper is very close to what I need. I've
> hacked around a bit, and come up with the following replacement for step 1:
> 
>     switch (bpf_fib_lookup(skb, &fib, sizeof(fib), 0)) {
>     case BPF_FIB_LKUP_RET_SUCCESS:
>         /* There is a cached neighbour, bpf_redirect without going
> through the stack. */
>         return bpf_redirect(...);
> 
>     case BPF_FIB_LKUP_RET_NO_NEIGH:
>         /* We have no information about this target. Let the stack handle it. */
>         return TC_ACT_OK;
> 
>     case BPF_FIB_LKUP_RET_FWD_DISABLED:
>         return TC_ACT_SHOT;
> 
>     default:
>         return TC_ACT_SHOT;
>     }
> 
> I have a couple of questions:
> 
> First, I think I can get BPF_FIB_LKUP_RET_NO_NEIGH if the packet needs
> to be routed,
> but there is no neighbour entry for the default gateway. Is that correct?

Correct.

> 
> Second, is it possible to originate the packet from the local machine,
> instead of keeping
> the original source address when passing the packet to the stack on NO_NEIGH?

Network address or MAC address? Swapping the network address is not a
usual part of routing a packet so I presume you mean mac but just making
sure. Swapping mac addresses should be done for all routed packets.

> This is what I get with my current approach:
> 
>   IP (tos 0x0, ttl 64, id 25769, offset 0, flags [DF], proto UDP (17),
> length 124)
>       10.42.0.2.37074 > 10.42.0.4.2483: [bad udp cksum 0x14d3 ->
> 0x3c0d!] UDP, length 96
>   IP (tos 0x0, ttl 63, id 25769, offset 0, flags [DF], proto UDP (17),
> length 124)
>       10.42.0.2.37074 > 10.42.0.3.2483: [no cksum] UDP, length 96
>   IP (tos 0x0, ttl 64, id 51342, offset 0, flags [none], proto ICMP
> (1), length 84)
>       10.42.0.3 > 10.42.0.2: ICMP echo reply, id 33779, seq 0, length 64
> 
> The first and second packet are using our custom GUE header, they
> contain an ICMP echo request. Packet three contains the answer to the
> request. As you can see, the second packet keeps the 10.42.0.2 source
> address instead of using 10.42.0.4.
> 
> Third, what effect does BPF_FIB_LOOKUP_OUTPUT have? Seems like I should set it,
> but I get somewhat sensible results without it as well. Same for LOOKUP_DIRECT.

BPF_FIB_LOOKUP_OUTPUT affects the flow parameters passed to the FIB lookup:
        if (flags & BPF_FIB_LOOKUP_OUTPUT) {
                fl4.flowi4_iif = 1;
                fl4.flowi4_oif = params->ifindex;
        } else {
                fl4.flowi4_iif = params->ifindex;
                fl4.flowi4_oif = 0;
        }

iif / oif set can have an influence on the FIB lookup result - e.g., FIB
rules directing the lookup to a table or requiring the lookup result to
use the specified device.

Usually, 'output' is for locally generated traffic headed out. XDP
programs run on ingress are from an Rx perspective and do the lookup
from the perspective of 'is this forwarded or locally delivered'.

BPF_FIB_LOOKUP_DIRECT is really  only useful for complex FIB setups -
e.g., VRF. It means skip the FIB rules and go direct to the table
associated with the device.

