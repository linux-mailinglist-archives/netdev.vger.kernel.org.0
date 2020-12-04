Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513832CEBF4
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgLDKPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLDKPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:15:10 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31B8C061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 02:14:29 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id x6so815794wro.11
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 02:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PWF1lcYpM9/Kvpsq48lYCABUREF33O69VjFoILX8M84=;
        b=WNtqqXZrGOIdvr0ySYcwp4llb5I7WsiVHo5nx7CRHyk7p2Ptkgq7GCYYUXvLCWpS9R
         VD3oGxCIQAFseN2QdWZhIrGeG3vBPFUrWC1eu4k8flk9vAszQs+/vwj6Yru5Gfv6lGzI
         hz0Njo2zpq247ZBilyDAb6V6FLnZZCo0HaDnvpBrExL2uWKd7EPiNP7ve2ymuOcDib0Q
         DAl1NGj/OqQ4gV2My0c0ic1aIaAlElK1PqjZACI4AziRDcmh+wSRgw6CMgRnkuV+aSsk
         ZPWtgz4Rp/LGIbIoNqEcSTsOAQk/H+I6lrRCzR/t3QKe5hecOSX5t9blzmrS1xxtOdPP
         DHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PWF1lcYpM9/Kvpsq48lYCABUREF33O69VjFoILX8M84=;
        b=bsDys7k4o2lUjNzTathVL2uyPhAGf2Bn5wwlfGiO+AA+BCPo8545kB/MphFBcOBIkf
         t+B+H2SXzi7wZmDKjdHvXi1XC36hTVWOfeCcvAaCUYnYCiyzE/65/jfgNQni1M9ONNFB
         +ProoB7RIW84TbH97NthvpHw3IlrNuInEFPEZbk20+TEb8+PSIHXyEMboRAKBuYctN/I
         oyefo8HoS1rlf1sEHIvUywcP817fApWfN7ix4RQ40efa10kQp1WWDYvhUjSx9kgpnQMp
         NTVf/BJvP4c1XREu2OMF72F+hcvznQprxsg199IS27+B3LtsXQtI0bF0Bju9HxtzJwGR
         iWng==
X-Gm-Message-State: AOAM530stJx3fuTB03sWw2g9bImVwXv83V5n7L6vV3htM5RMj8ST+xGz
        wfXBNko/ohzMOnoESYjOWL4lZuVSNTw=
X-Google-Smtp-Source: ABdhPJxECNV5fzGmEb3Kwo3wcOtL6k2QSiEmXqTSP/8cs18BB9z2JPp6OnP/IebGiaS5TQMeSzeD0A==
X-Received: by 2002:adf:e449:: with SMTP id t9mr3962178wrm.257.1607076868247;
        Fri, 04 Dec 2020 02:14:28 -0800 (PST)
Received: from [192.168.8.116] ([37.166.39.226])
        by smtp.gmail.com with ESMTPSA id h204sm2677021wme.17.2020.12.04.02.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 02:14:27 -0800 (PST)
Subject: Re: [PATCH net-next] bcm63xx_enet: convert to build_skb
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
 <20201204054616.26876-4-liew.s.piaw@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e5e8eee8-b125-f594-2156-ca508cb465eb@gmail.com>
Date:   Fri, 4 Dec 2020 11:14:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204054616.26876-4-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/20 6:46 AM, Sieng Piaw Liew wrote:
> We can increase the efficiency of rx path by using buffers to receive
> packets then build SKBs around them just before passing into the network
> stack. In contrast, preallocating SKBs too early reduces CPU cache
> efficiency.
> 
> Check if we're in NAPI context when refilling RX. Normally we're almost
> always running in NAPI context. Dispatch to napi_alloc_frag directly
> instead of relying on netdev_alloc_frag which still runs
> local_bh_disable/enable.
> 
> Tested on BCM6328 320 MHz and iperf3 -M 512 to measure packet/sec
> performance. Included netif_receive_skb_list and NET_IP_ALIGN
> optimizations.
> 
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-10.00  sec  49.9 MBytes  41.9 Mbits/sec  197         sender
> [  4]   0.00-10.00  sec  49.3 MBytes  41.3 Mbits/sec            receiver
> 
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-30.00  sec   171 MBytes  47.8 Mbits/sec  272         sender
> [  4]   0.00-30.00  sec   170 MBytes  47.6 Mbits/sec            receiver

Please test this again after GRO has been added to this driver.

Problem with build_skb() is that overall skb truesize after GRO might be increased
a lot, since we have sizeof(struct skb_shared_info) added overhead per MSS,
and this can double the truesize depending on device MTU.

This matters on long RTT flows, because an inflation of skb->truesize reduces
TCP receive window quite a lot.

Ideally if you want best performance, this driver should use napi_gro_frags(),
so that skb->len/skb->truesize is the smallest one.

In order to test your change you need to set up a testbed with 
10ms or 50ms delay between the hosts, unless this driver is only used
by hosts on the same LAN (which I doubt)


