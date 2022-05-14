Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB27B5272F2
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiENQdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 12:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbiENQds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 12:33:48 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB21BC90;
        Sat, 14 May 2022 09:33:47 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id v11so10327144pff.6;
        Sat, 14 May 2022 09:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V1R62bJzWYYQOyH9ypmfWz92vQWZ2G8Gt1CdGMt6pyI=;
        b=IA3wCNOxbM4DDXutzc2nj3RvHsn3yOch4q9x6R3AAh8wiHzcDCs2+YCUr1MWJz+XEY
         pX3CaVQ0R+84H5SQC2CiFwkXm8m/6Xherdnzhx0feusrJ6OR3Y5PS7vN7eQGXP/wG/8/
         SLtw5Lg08P5gj1CtDPAqQo5Q2i7LfhfqbjJ6AXsVRrYYN3llnejZCO7CRvFa1KcI0PjU
         5Aw0Yp6/MrJCLEVcWZuqjhcQCdKiit+nGVMbBLnFCM4OdVo56QOC+DrINc4PPmuwteFq
         Awx3bZqlhxsDCEQSCWbHQWXSifTsvuqPsofDGvxd7HELQYZhcp7jv76/W+aFPmIMgmjQ
         K75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V1R62bJzWYYQOyH9ypmfWz92vQWZ2G8Gt1CdGMt6pyI=;
        b=2rWLtsdNDQcf/9hacDwgc8LfvtisUsXZQPN0bERvPSfla2qjHVgGTlS2W86qp6CDmC
         Qa6t3tHxhxUHaHItNaXiCUZuMd0T+tp7MWbYj1MRujX+adVNlVuDQSMOtyf/wh4OLUQR
         LfwqGzFaQbxlusQ/YyWIB4O22yLxHmuwJ5Mh9NJv7neKPU0mhjZefsUUwDD3VesPBqNP
         S+lprtQzeeYBJEyuCHhAiyLLpUb0JX2u4jHAdGECcz32PbhzTFqNwNRigIzc9q8wh0wo
         df7dz8VISNeX8WNE2S1c3Hvp4mhSh5uOANKE4pT2uxiIf3Dp8oiAVxr/5p8ZcnVHpEti
         PY+A==
X-Gm-Message-State: AOAM5307H3u7mNXsyjdK8TthB8HhvQW2Rt6PafhinqHaLHlWwFpOl6XW
        Yr3mdTONNYmS4nP/4JV9Ui4=
X-Google-Smtp-Source: ABdhPJx+/nVQqImVzhjjEqbhk1/X1BCON81UbyDvV2TgT4Ve+nS/lmETRq/iGiBiQdtF5c8RCAuoTQ==
X-Received: by 2002:a63:b24a:0:b0:3db:b454:b5a with SMTP id t10-20020a63b24a000000b003dbb4540b5amr4237667pgo.312.1652546026823;
        Sat, 14 May 2022 09:33:46 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:cd14:4041:168c:7257? ([2600:8802:b00:4a48:cd14:4041:168c:7257])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902b70200b0015f032ec665sm3876448pls.255.2022.05.14.09.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 09:33:46 -0700 (PDT)
Message-ID: <89c52305-71da-843e-b6c5-77648fb2f4d3@gmail.com>
Date:   Sat, 14 May 2022 09:33:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-3-maxime.chevallier@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220514150656.122108-3-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On 5/14/2022 8:06 AM, Maxime Chevallier wrote:
> This tagging protocol is designed for the situation where the link
> between the MAC and the Switch is designed such that the Destination
> Port, which is usually embedded in some part of the Ethernet Header, is
> sent out-of-band, and isn't present at all in the Ethernet frame.
> 
> This can happen when the MAC and Switch are tightly integrated on an
> SoC, as is the case with the Qualcomm IPQ4019 for example, where the DSA
> tag is inserted directly into the DMA descriptors. In that case,
> the MAC driver is responsible for sending the tag to the switch using
> the out-of-band medium. To do so, the MAC driver needs to have the
> information of the destination port for that skb.
> 
> This out-of-band tagging protocol is using the very beggining of the skb
> headroom to store the tag. The drawback of this approch is that the
> headroom isn't initialized upon allocating it, therefore we have a
> chance that the garbage data that lies there at allocation time actually
> ressembles a valid oob tag. This is only problematic if we are
> sending/receiving traffic on the master port, which isn't a valid DSA
> use-case from the beggining. When dealing from traffic to/from a slave
> port, then the oob tag will be initialized properly by the tagger or the
> mac driver through the use of the dsa_oob_tag_push() call.

What I like about your approach is that you have aligned the way an out 
of band switch tag is communicated to the networking stack the same way 
that an "in-band" switch tag would be communicated. I think this is a 
good way forward to provide the out of band tag and I don't think it 
creates a performance problem because the Ethernet frame is hot in the 
cache (dma_unmap_single()) and we already have an "expensive" read of 
the DMA descriptor in coherent memory anyway.

You could possibly optimize the data flow a bit to limit the amount of 
sk_buff data movement by asking your Ethernet controller to DMA into the 
data buffer N bytes into the beginning of the data buffer. That way, if 
you have reserved say, 2 bytes at the front data buffer you can deposit 
the QCA tag there and you do not need to push, process the tag, then pop 
it, just process and pop. Consider using the 2byte stuffing that the 
Ethernet controller might be adding to the beginning of the Ethernet 
frame to align the IP header on a 4-byte boundary to provide the tag in 
there?

If we want to have a generic out of band tagger like you propose, it 
seems to me that we will need to invent a synthetic DSA tagging format 
which is the largest common denominator of the out of band tags that we 
want to support. We could imagine being more compact in the 
representation for instance by using an u8 for storing a bitmask of 
ports (works for both RX and TX then) and another u8 for various packet 
forwarding reasons.

Then we would request the various Ethernet MAC drivers to marshall their 
proprietary tag into the DSA synthetic one on receive, and unmarshall it 
on transmit.

Another approach IMHO which maybe helps the maintainability of the code 
moving forward as well as ensuring that all Ethernet switch tagging code 
lives in one place, is to teach each tagger driver how to optimize their 
data paths to minimize the amount of data movements and checksum 
re-calculations, this is what I had in mind a few years ago:

https://lore.kernel.org/lkml/1438322920.20182.144.camel@edumazet-glaptop2.roam.corp.google.com/T/

This might scale a little less well, and maybe this makes too many 
assumptions as to where and how the checksums are calculated on the 
packet contents, but at least, you don't have logic processing the same 
type of switch tag scattered between the Ethernet MAC drivers (beyond 
copying/pushing) and DSA switch taggers.

I would like to hear other's opinion on this.
-- 
Florian
