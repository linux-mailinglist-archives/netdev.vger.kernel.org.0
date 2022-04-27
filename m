Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E843951173C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiD0MIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiD0MIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:08:11 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A80197
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 05:04:56 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id kq17so2968797ejb.4
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 05:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:from:subject
         :content-transfer-encoding;
        bh=3UdyQIBc6n8hf7M5NKzue0S7L+YH4x8qa8I5uvoMITQ=;
        b=ma9yfJZErCYDaSsZOCTB2tii+s8u3sJBer0fsQH/fuDmuMpWz859vboFlYikaaYkay
         3kl48mB4aQdtoTGA59XzDv5zcCMDK8tSR8uac6G4FUCc+2ugw2mBBMLJ4HikLreYm+DF
         r+FP6TCOaR5WCiz98RXCKgqTU+h9ydC4XJcjSJivAF3V/l1xCbnAEjs4UyXLN8cbVXLf
         xOOQxhtIK9h3EVGtPCkNtxJTZmIqbI8j3Bn8kJGJAS2IMUUojpJxbGxs33rzXDFnLUIZ
         mcvpuMZp4x6bjRFs/Kpwp/FProfTSPunqyqcBwiiS3xw31ZEZCY/rEh9eGZBJqYXimL6
         32yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :from:subject:content-transfer-encoding;
        bh=3UdyQIBc6n8hf7M5NKzue0S7L+YH4x8qa8I5uvoMITQ=;
        b=7QHaQXYXlrK1YkymiQtqFT30vSzEB8Td7wGiMTd1Y3nzq9JdSyyEeNwxsH5/5/edO3
         pt6bw+/gcaPOJGCKzmesgswlMH+duCqiz2QNkcKzzupwiPgA4C/Hqj8FZvh3RljKFY1m
         YdrEnop3LgEjk8Zwtva1B6opIRORaBNWcqFQQYDaq9bY71ueaNBqSmP9GLvgNKrSK2kU
         //NsD1esQUA+J3piSY/KQBcE+MBy+OiSeYTY2ajvIbXvbnbLsgUwySIXIL9qrXToLQOB
         x2/G8XoHfhckld5NnfQ6KXHolxEB1+WGiGxbyBNxQUHFLOkM4eCHt7BoQ5rb1zLK8fd+
         AV3w==
X-Gm-Message-State: AOAM533z3cwNqgfo9bx7jHILokWQAlJYy5958kMvRr45KKA9qNZ25QQ/
        bSx4swkbsMyeSOQFdGQNMCff3L8mkkA=
X-Google-Smtp-Source: ABdhPJzLUkG7Tx161aFtXEcKe5igcT5Af6Df5arVTS2BZ+n7s4jQPktQ088QNIoEOgQ3qSLAX42xiQ==
X-Received: by 2002:a17:906:4787:b0:6f3:7e2a:ebfd with SMTP id cw7-20020a170906478700b006f37e2aebfdmr18207579ejc.243.1651061095136;
        Wed, 27 Apr 2022 05:04:55 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id g15-20020a170906520f00b006cd07ba40absm6641429ejm.160.2022.04.27.05.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 05:04:54 -0700 (PDT)
Message-ID: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
Date:   Wed, 27 Apr 2022 14:04:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
To:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>
Cc:     "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Optimizing kernel compilation / alignments for network performance
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I noticed years ago that kernel changes touching code - that I don't use
at all - can affect network performance for me.

I work with home routers based on Broadcom Northstar platform. Those
are SoCs with not-so-powerful 2 x ARM Cortex-A9 CPU cores. Main task of
those devices is NAT masquerade and that is what I test with iperf
running on two x86 machines.

***

Example of such unused code change:
ce5013ff3bec ("mtd: spi-nor: Add support for XM25QH64A and XM25QH128A").
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce5013ff3bec05cf2a8a05c75fcd520d9914d92b
It lowered my NAT speed from 381 Mb/s to 367 Mb/s (-3,5%).

I first reported that issue it in the e-mail thread:
ARM router NAT performance affected by random/unrelated commits
https://lkml.org/lkml/2019/5/21/349
https://www.spinics.net/lists/linux-block/msg40624.html

Back then it was commit 5b0890a97204 ("flow_dissector: Parse batman-adv
unicast headers")
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9316a9ed6895c4ad2f0cde171d486f80c55d8283
that increased my NAT speed from 741 Mb/s to 773 Mb/s (+4,3%).

***

It appears Northstar CPUs have little cache size and so any change in
location of kernel symbols can affect NAT performance. That explains why
changing unrelated code affects anything & it has been partially proven
aligning some of cache-v7.S code.

My question is: is there a way to find out & force an optimal symbols
locations?

Adding .align 5 to the cache-v7.S is a partial success. I'd like to find
out what other functions are worth optimizing (aligning) and force that
(I guess  __attribute__((aligned(32))) could be used).

I can't really draw any conclusions from comparing System.map before and
after above commits as they relocate thousands of symbols in one go.

Optimizing is pretty important for me for two reasons:
1. I want to reach maximum possible NAT masquerade performance
2. I need stable performance across random commits to detect regressions
