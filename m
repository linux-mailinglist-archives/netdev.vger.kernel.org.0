Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084DC51D3CF
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 10:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390299AbiEFI7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 04:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390302AbiEFI7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 04:59:38 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A04964BF3
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:55:55 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p18so7934797edr.7
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 01:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=7KnTd4dnXX981Ovd+1p0hB/lWIebYlzUBozyVmnP8+g=;
        b=Wo4IKxFrV1N1gZasLN9fGB9C9xwvsxR7hKnWvXF6tDvIyzr/8ubJrU1ssUW/+NwS7L
         nQJbAR0Rd5TI/tK9EsR3rAW7b3GizCrgeunxhH9ulLUqgByTt87mXlga1wvCY5j2QDsj
         ZflGyvwXc5atOV6jdVj3Z5MLVnzvQF78b/bJiR/LisFVodCNmKjY4HRAYOHRMRwiTaBQ
         r3vNEhyKrMR1cCRDhuFX1Tw3HyJ5tatxfXgxYan6fK8fKAole2VVsgADNcfkWA5TwV8q
         NQEA/ny+U68dMuECdeCatczYus9wz0pRVlO+MDPqSsLqH9JI4HbvrGfOs6JgT9LBeH/v
         kVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7KnTd4dnXX981Ovd+1p0hB/lWIebYlzUBozyVmnP8+g=;
        b=b0RLjAF9CbTDRhM01way1MUejFNlvZ4iCOIw6/MzspOM0KCynvjTTcDtEepkNEhbkr
         ttstEKbPFW8x0U1JaPN6O2RLIIoGgHn1jXBqWliEuJFRW8ShGLV8r988W3U+P582Qf9S
         SzOU5oS8JIjJaIbs8A9ww/F4khdz/Wx4MgMABZqItS5Gjv4ZMfwPkbB6bfFhT4gX8bAJ
         z0kWzunYDaHqUUiAaWQq7mXyFZ0wyRTGlwH+Dq1O7fhxiszZxzOdLtnoTJXoC9zRcmra
         B2xk6KmHNmsMisMXp9icKprL0qcdcd6oioB6PlUir7tiKr6DmvH2KMhEhwmeh/z3DDpX
         8xtA==
X-Gm-Message-State: AOAM533/KvBNB/ygXQRzb53q6Q+QEu+TBxYIpf485LOt5znC/rnv5Phf
        toOUUa6cjkrh1pDjyedA7PU=
X-Google-Smtp-Source: ABdhPJyTEgs4PbYHcH1EEtoytMMWZ2iYZHrPzVm6X8t0OhxN+K0ffjxJ+2252UZwESRy8V/Y4TAzRQ==
X-Received: by 2002:a50:f69c:0:b0:425:c96a:5c09 with SMTP id d28-20020a50f69c000000b00425c96a5c09mr2409882edn.256.1651827353934;
        Fri, 06 May 2022 01:55:53 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id lh25-20020a170906f8d900b006f3ef214e04sm1658349ejb.106.2022.05.06.01.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 01:55:53 -0700 (PDT)
Message-ID: <306e9713-5c37-8c6a-488b-bc07f8b8b274@gmail.com>
Date:   Fri, 6 May 2022 10:55:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
 <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.05.2022 10:45, Arnd Bergmann wrote:
> On Fri, May 6, 2022 at 9:44 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>>
>> On 5.05.2022 18:04, Andrew Lunn wrote:
>>>> you'll see that most used functions are:
>>>> v7_dma_inv_range
>>>> __irqentry_text_end
>>>> l2c210_inv_range
>>>> v7_dma_clean_range
>>>> bcma_host_soc_read32
>>>> __netif_receive_skb_core
>>>> arch_cpu_idle
>>>> l2c210_clean_range
>>>> fib_table_lookup
>>>
>>> There is a lot of cache management functions here.
> 
> Indeed, so optimizing the coherency management (see Felix' reply)
> is likely to help most in making the driver faster, but that does not
> explain why the alignment of the object code has such a big impact
> on performance.
> 
> To investigate the alignment further, what I was actually looking for
> is a comparison of the profile of the slow and fast case. Here I would
> expect that the slow case spends more time in one of the functions
> that don't deal with cache management (maybe fib_table_lookup or
> __netif_receive_skb_core).
> 
> A few other thoughts:
> 
> - bcma_host_soc_read32() is a fundamentally slow operation, maybe
>    some of the calls can turned into a relaxed read, like the readback
>    in bgmac_chip_intrs_off() or the 'poll again' at the end bgmac_poll(),
>    though obviously not the one in bgmac_dma_rx_read().
>    It may be possible to even avoid some of the reads entirely, checking
>    for more data in bgmac_poll() may actually be counterproductive
>    depending on the workload.
> 
> - The higher-end networking SoCs are usually cache-coherent and
>    can avoid the cache management entirely. There is a slim chance
>    that this chip is designed that way and it just needs to be enabled
>    properly. Most low-end chips don't implement the coherent
>    interconnect though, and I suppose you have checked this already.
> 
> - bgmac_dma_rx_update_index() and bgmac_dma_tx_add() appear
>    to have an extraneous dma_wmb(), which should be implied by the
>    non-relaxed writel() in bgmac_write().
> 
> - accesses to the DMA descriptor don't show up in the profile here,
>    but look like they can get misoptimized by the compiler. I would
>    generally use READ_ONCE() and WRITE_ONCE() for these to
>    ensure that you don't end up with extra or out-of-order accesses.
>    This also makes it clearer to the reader that something special
>    happens here.
> 
>>> Might sound odd,
>>> but have you tried disabling SMP? These cache functions need to
>>> operate across all CPUs, and the communication between CPUs can slow
>>> them down. If there is only one CPU, these cache functions get simpler
>>> and faster.
>>>
>>> It just depends on your workload. If you have 1 CPU loaded to 100% and
>>> the other 3 idle, you might see an improvement. If you actually need
>>> more than one CPU, it will probably be worse.
>>
>> It seems to lower my NAT speed from ~362 Mb/s to 320 Mb/s but it feels
>> more stable now (lower variations). Let me spend some time on more
>> testing.
>>
>>
>> FWIW during all my tests I was using:
>> echo 2 > /sys/class/net/eth0/queues/rx-0/rps_cpus
>> that is what I need to get similar speeds across iperf sessions
>>
>> With
>> echo 0 > /sys/class/net/eth0/queues/rx-0/rps_cpus
>> my NAT speeds were jumping between 4 speeds:
>> 273 Mbps / 315 Mbps / 353 Mbps / 425 Mbps
>> (every time I started iperf kernel jumped into one state and kept the
>>    same iperf speed until stopping it and starting another session)
>>
>> With
>> echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
>> my NAT speeds were jumping between 2 speeds:
>> 284 Mbps / 408 Mbps
> 
> Can you try using 'numactl -C' to pin the iperf processes to
> a particular CPU core? This may be related to the locality of
> the user process relative to where the interrupts end up.

I run iperf on x86 machines connected to router's WAN and LAN ports.
It's meant to emulate end user just downloading from / uploading to
Internet some data.

Router's only task is doing masquarade NAT here.
