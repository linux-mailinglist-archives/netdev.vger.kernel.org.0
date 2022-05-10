Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E1152123B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbiEJKde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiEJKdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:33:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF17D201336
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:29:35 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id i19so31980169eja.11
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=I6uI7kHlCc5QUgYAVZnm+XmGBAePYKXNFME5rh1pCus=;
        b=StHiDv6/VDl44lCizCGAQFd6pTX+gILmR1k+K2MaA5RK1sKuYNB/ooUGd0v4h8Pv2O
         27z79RT9i3YuMNgPPDiOqWN8gF11DgE052rKMXI1GUOSzIJxP5j7m2bThENZxNPJft61
         1SMN1RHezDK6L61GfLT6ihm6YWw1w7HrwsenZ7qj51+kqRl8xsAGCO5kzLLwgxKosRQY
         jqTa8Mvc4dOqu8sjnxPGk2ISkQhRM9u0AvmC71evVtxvJC82ExUzearftsmVOj9UARgb
         4MtflPtgHfhFHOiAYt6e50XeKDIC/bcZ9ZhunR7CmOgfzLvZlDCLAZe5FdoK5MISAAx7
         3YZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I6uI7kHlCc5QUgYAVZnm+XmGBAePYKXNFME5rh1pCus=;
        b=HOUNakTdWRvX9JJt4/ETTtRY4FuVTl6ia7raX+IAa+L/E9zo8656mFOSd2muhmVDr+
         kfIaTGkSRMKxJ6sSsukcW9oAIyeVB0CHuvFePg3LLww2el6tF3Im9PUxaEW4tAdKYZwA
         Y5o+/6p9J0mC4yotc6H1qNcfRGb4HUC7BvkOYCtlWWp7tLLhaBw1/NYJqQHDsbL5qMxL
         ldWpRzKINaV+2Y0boc7/CZhPnn6iMdD25ErEBvtYyi1hXpOoPGDi3DZvOOrKuZmMN5nd
         FaHS5aR6cOfb0n+tnah7zLSK1HpAFU4jbYdi9PX0lqJIVuQ3WDWbaDmtW+ovfS/Yyz+5
         +QwQ==
X-Gm-Message-State: AOAM530x/wcYhx/wF0ML59enfzNWp/eGsEeVF1EVWVJRFKr8RYK3GIqk
        Un2jET0j8hc3x9Tz1VtVJQo=
X-Google-Smtp-Source: ABdhPJzItR3VqKrzZ4ni2hxOujWkEVMpYAEZ9jI6Laum4XLNobxvcQx+AYvusIKXN/QXu89dFAR8lw==
X-Received: by 2002:a17:906:6d91:b0:6f4:5433:72f5 with SMTP id h17-20020a1709066d9100b006f4543372f5mr13173287ejt.414.1652178574239;
        Tue, 10 May 2022 03:29:34 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id nr1-20020a1709068b8100b006f3ef214e6fsm5905769ejc.213.2022.05.10.03.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 03:29:33 -0700 (PDT)
Message-ID: <391ca2d1-6977-0c9b-588c-31ad9bb68c82@gmail.com>
Date:   Tue, 10 May 2022 12:29:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
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
 <04fa6560-e6f4-005f-cddb-7bc9b4859ba2@gmail.com> <YnUXyQbLRn4BmJYr@lunn.ch>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <YnUXyQbLRn4BmJYr@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.05.2022 14:42, Andrew Lunn wrote:
>>> I just took a quick look at the driver. It allocates and maps rx buffers that can cover a packet size of BGMAC_RX_MAX_FRAME_SIZE = 9724.
>>> This seems rather excessive, especially since most people are going to use a MTU of 1500.
>>> My proposal would be to add support for making rx buffer size dependent on MTU, reallocating the ring on MTU changes.
>>> This should significantly reduce the time spent on flushing caches.
>>
>> Oh, that's important too, it was changed by commit 8c7da63978f1 ("bgmac:
>> configure MTU and add support for frames beyond 8192 byte size"):
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c7da63978f1672eb4037bbca6e7eac73f908f03
>>
>> It lowered NAT speed with bgmac by 60% (362 Mbps → 140 Mbps).
>>
>> I do all my testing with
>> #define BGMAC_RX_MAX_FRAME_SIZE			1536
> 
> That helps show that cache operations are part of your bottleneck.
> 
> Taking a quick look at the driver. On the receive side:
> 
>                         /* Unmap buffer to make it accessible to the CPU */
>                          dma_unmap_single(dma_dev, dma_addr,
>                                           BGMAC_RX_BUF_SIZE, DMA_FROM_DEVICE);
> 
> Here is data is mapped read for the CPU to use it.
> 
> 			/* Get info from the header */
>                          len = le16_to_cpu(rx->len);
>                          flags = le16_to_cpu(rx->flags);
> 
>                          /* Check for poison and drop or pass the packet */
>                          if (len == 0xdead && flags == 0xbeef) {
>                                  netdev_err(bgmac->net_dev, "Found poisoned packet at slot %d, DMA issue!\n",
>                                             ring->start);
>                                  put_page(virt_to_head_page(buf));
>                                  bgmac->net_dev->stats.rx_errors++;
>                                  break;
>                          }
> 
>                          if (len > BGMAC_RX_ALLOC_SIZE) {
>                                  netdev_err(bgmac->net_dev, "Found oversized packet at slot %d, DMA issue!\n",
>                                             ring->start);
>                                  put_page(virt_to_head_page(buf));
>                                  bgmac->net_dev->stats.rx_length_errors++;
>                                  bgmac->net_dev->stats.rx_errors++;
>                                  break;
>                          }
> 
>                          /* Omit CRC. */
>                          len -= ETH_FCS_LEN;
> 
>                          skb = build_skb(buf, BGMAC_RX_ALLOC_SIZE);
>                          if (unlikely(!skb)) {
>                                  netdev_err(bgmac->net_dev, "build_skb failed\n");
>                                  put_page(virt_to_head_page(buf));
>                                  bgmac->net_dev->stats.rx_errors++;
>                                  break;
>                          }
>                          skb_put(skb, BGMAC_RX_FRAME_OFFSET +
>                                  BGMAC_RX_BUF_OFFSET + len);
>                          skb_pull(skb, BGMAC_RX_FRAME_OFFSET +
>                                   BGMAC_RX_BUF_OFFSET);
> 
>                          skb_checksum_none_assert(skb);
>                          skb->protocol = eth_type_trans(skb, bgmac->net_dev);
> 
> and this is the first access of the actual data. You can make the
> cache actually work for you, rather than against you, to adding a call to
> 
> 	prefetch(buf);
> 
> just after the dma_unmap_single(). That will start getting the frame
> header from DRAM into cache, so hopefully it is available by the time
> eth_type_trans() is called and you don't have a cache miss.


I don't think that analysis is correct.

Please take a look at following lines:
struct bgmac_rx_header *rx = slot->buf + BGMAC_RX_BUF_OFFSET;
void *buf = slot->buf;

The first we do after dma_unmap_single() call is rx->len read. That
actually points to DMA data. There is nothing we could keep CPU busy
with while preteching data.

FWIW I tried adding prefetch(buf); anyway. I didn't change NAT speed by
a single 1 Mb/s. Speed was exactly the same as without prefetch() call.
