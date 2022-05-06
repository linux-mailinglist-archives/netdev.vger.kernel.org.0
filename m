Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8117E51D286
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 09:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389682AbiEFHv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 03:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389689AbiEFHv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 03:51:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46941674F6
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 00:47:43 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id y3so12834266ejo.12
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 00:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=zKGL4m4tOsAY5uuE8MMLxzwFEWALxOxUgmZN40z4JCE=;
        b=WVSh85cJQd9BJ8bKwXxaL4eAkOYvBpq/3esrh8Zo9N7uU9WqmGlhWkPU7BjGTpY1Xy
         nh9ZL+PLQXVlNXQ7/T92xH3RBPrvqnFdwvX4c3ARKhWiz2RLSyKFbw2Xek2fCFoW+GRV
         38INwTdx52QZhX9doP42y6ZpkG5/s5t7EF3SBwkw6fl1DCTsICnWtfrxNZyclDi5EuzL
         iZKu2OfpqCxsMvQEt/GZqXAdsAeqBNDRkX0GBxzCBl646EVAuRKwzueAaGUR7HnoLpve
         U5tHOc3fSUlsq8PfXquAiX0mTm1b25jttf8eaqgdZQL/CSQfR3OBfrjrme6MTfC7SmD1
         BGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zKGL4m4tOsAY5uuE8MMLxzwFEWALxOxUgmZN40z4JCE=;
        b=TlPtCzKMR2i51F1awpLtuRI2OoYYv5GYxm6FQZVKkg/ucPTJ4cqmN1kr1P6/jeSZ6t
         /xYdUs7KQ/cIPNNV9GUtv1NXpXKsssQUdGlrlVTSch8tCXExavA00igUvCr92D1Tk5NL
         2QMdQYSy6nkiyt40OXqs4+QTqJhVQxAfq/lB0NNFoCqx7XToSHeS1dbApASw92AB0m1q
         G0sGgNJD3gp93h8Qqj71Bho5KG8URxDQoSVHZfjqDXThVitiq75Sbe/xrRthzW2UxCw9
         VG8gD0PqIQMwg3Y6vlAteTwK20jcUOiVurflgZcAmc8NS9/1uW/Z905rF2X0AEc+AecW
         +dkA==
X-Gm-Message-State: AOAM532kN4l54uCYoUNH3J6GNsJBSc4P/jN8cm015xyy+Sg1+RALkSpM
        596JIQyJiqMDsv9YGAwUKzg=
X-Google-Smtp-Source: ABdhPJwxVq9/G6zl0oAcrCmzq0FulenswlEYx3KJU3yp/+gzaeWU9NKPCEdmJTxFY+ZBtdC4jFleHw==
X-Received: by 2002:a17:907:7247:b0:6f4:ed49:cd3f with SMTP id ds7-20020a170907724700b006f4ed49cd3fmr1991725ejc.172.1651823262528;
        Fri, 06 May 2022 00:47:42 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id d2-20020a170907272200b006f3ef214e21sm1600452ejl.135.2022.05.06.00.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 00:47:42 -0700 (PDT)
Message-ID: <04fa6560-e6f4-005f-cddb-7bc9b4859ba2@gmail.com>
Date:   Fri, 6 May 2022 09:47:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Felix Fietkau <nbd@nbd.name>, Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <2a338e8e-3288-859c-d2e8-26c5712d3d06@nbd.name>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <2a338e8e-3288-859c-d2e8-26c5712d3d06@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5.05.2022 18:46, Felix Fietkau wrote:
> 
> On 05.05.22 18:04, Andrew Lunn wrote:
>>> you'll see that most used functions are:
>>> v7_dma_inv_range
>>> __irqentry_text_end
>>> l2c210_inv_range
>>> v7_dma_clean_range
>>> bcma_host_soc_read32
>>> __netif_receive_skb_core
>>> arch_cpu_idle
>>> l2c210_clean_range
>>> fib_table_lookup
>>
>> There is a lot of cache management functions here. Might sound odd,
>> but have you tried disabling SMP? These cache functions need to
>> operate across all CPUs, and the communication between CPUs can slow
>> them down. If there is only one CPU, these cache functions get simpler
>> and faster.
>>
>> It just depends on your workload. If you have 1 CPU loaded to 100% and
>> the other 3 idle, you might see an improvement. If you actually need
>> more than one CPU, it will probably be worse.
>>
>> I've also found that some Ethernet drivers invalidate or flush too
>> much. If you are sending a 64 byte TCP ACK, all you need to flush is
>> 64 bytes, not the full 1500 MTU. If you receive a TCP ACK, and then
>> recycle the buffer, all you need to invalidate is the size of the ACK,
>> so long as you can guarantee nothing has touched the memory above it.
>> But you need to be careful when implementing tricks like this, or you
>> can get subtle corruption bugs when you get it wrong.
> I just took a quick look at the driver. It allocates and maps rx buffers that can cover a packet size of BGMAC_RX_MAX_FRAME_SIZE = 9724.
> This seems rather excessive, especially since most people are going to use a MTU of 1500.
> My proposal would be to add support for making rx buffer size dependent on MTU, reallocating the ring on MTU changes.
> This should significantly reduce the time spent on flushing caches.

Oh, that's important too, it was changed by commit 8c7da63978f1 ("bgmac:
configure MTU and add support for frames beyond 8192 byte size"):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c7da63978f1672eb4037bbca6e7eac73f908f03

It lowered NAT speed with bgmac by 60% (362 Mbps → 140 Mbps).

I do all my testing with
#define BGMAC_RX_MAX_FRAME_SIZE			1536
