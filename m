Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68C7538402
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbiE3PNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238486AbiE3PMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:12:07 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B003ABF67
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 07:10:13 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id f9so21140342ejc.0
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 07:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:from:subject
         :content-transfer-encoding;
        bh=fV1WKo6LGeVxUnhQkeKh/SZhJaFdGpzNVS8qNPI9nD8=;
        b=duzoGGaeQJdsCUFytzdF0PB7Nna6SWbPVtOZMtwOMEgdpBQ9aWS4M1XUM9TTk/8b4+
         LueBo370pv9/8Gj5ZAYjTQLuLTe4UBCiURhOakmO5E3cqfOQtoijxOOuXafe7NkmIceg
         CYmwH6B6++U8NXBu5hEpD0Tvbkv4UxtVcb0PFh3HIU3oh2CtObbwFSD/ZkTk3iAtw4Eu
         1Y++y4wG2OdaZ0VOdRnyga9PjIPh28sB38MpIj8ELSoO0Gm38R1k5uG/MrQTq8G3Ambm
         QrxHI8E2OFp3JQPc/vekwPmKuFo5TR+9q5T+Uz9gqldT9TgY2eNbFWCE8lB1pb6FIIKe
         fxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:from
         :subject:content-transfer-encoding;
        bh=fV1WKo6LGeVxUnhQkeKh/SZhJaFdGpzNVS8qNPI9nD8=;
        b=G4N4lo447DURyi3aIS+Sz8HrfCuSe03r+w9LR4LdnwPcX1QY7+oBbzJQevLYX6cuYj
         drwHKPTZJ8v5t/1S2zhqMHcyBXcadpwFj9hcYDrPNrhM0U+xA4+XQwk46qVGZUFvgZcL
         eCrsoY5tNPxEZZjjZINwdma7y0irZ9iUnGgVBNzmFRzjtcv0whRitlSBPVwUh9OEATpY
         LoO2/lfEL3t8Vbz4aCzIuYWFPCG9xmlqOsdCyCVuaH57mbwN79+LXlQT5xykIzoaEl43
         C94NSaFmZdecT3FvJyQ5fdivA3H/lkQXnudiv0lQnKpPdhsnJDS8ajXZfaVCQxeDq8tl
         aOIw==
X-Gm-Message-State: AOAM532iPe+u9T49LOnNfXckQAtno0S6IyUQVvp76qYMMUmRyZogRz4u
        vBRmbD0I49vhuCxY32MpCnM1Trtrc60=
X-Google-Smtp-Source: ABdhPJwNUndcMJkwM137UwVUJQD6JJomMxLCGP/o81oYqe+x9tjH4tdhRx/5B79KSrMowMcIF7uWVg==
X-Received: by 2002:a17:906:c302:b0:6fe:a216:20a4 with SMTP id s2-20020a170906c30200b006fea21620a4mr45816712ejz.556.1653919811448;
        Mon, 30 May 2022 07:10:11 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id h10-20020a50c38a000000b0042617ba6396sm6583736edf.32.2022.05.30.07.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 07:10:10 -0700 (PDT)
Message-ID: <5a04080f-a2eb-6597-091e-6b31c4df1661@gmail.com>
Date:   Mon, 30 May 2022 16:10:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
To:     Network Development <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: r8169: Ethernet speed regressions with RTL8168gu in ThinkPad E480
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've ThinkPad E480 with i3-8130U CPU and 10ec:8168 detected as:
[    8.458515] r8169 0000:03:00.0 eth0: RTL8168gu/8111gu, 8c:16:45:5d:f2:c2, XID 509, IRQ 136
[    8.458521] r8169 0000:03:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
[   12.272352] Generic FE-GE Realtek PHY r8169-0-300:00: attached PHY driver (mii_bus:phy_addr=r8169-0-300:00, irq=MAC)

It's connected to WAN port of BCM4708 based home router running OpenWrt
with kernel 5.4.113. I run "iperf -s" on this E480 for network testing.

***************

After upgrading kernel from 4.12 to 5.18 I noticed Ethernet speed
regression. I bisected it down to two commits:


commit 6b839b6cf9eada30b086effb51e5d6076bafc761
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Thu Oct 18 19:56:01 2018 +0200

     r8169: fix NAPI handling under high load

(introduced in 4.19 and dropped speed by 20 Mb/s = 5%)


commit 288ac524cf70a8e7ed851a61ed2a9744039dae8d
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Sat Mar 30 17:13:24 2019 +0100

     r8169: disable default rx interrupt coalescing on RTL8168

(introduced in 5.1 and dropped speed by 60 Mb/s = 15%)

***************

Is that possible to fix / rework r8169 to provide original higher
Ethernet speed out of the box?

Honestly I'd expect this i3-8130U to handle 1 Gb/s traffic or more and
my guess is that the real bottleneck is my home router here (slow
BCM4708 SoC CPU). Still it seems like r8169 can be a bottleneck on top
of bottleneck.

***************

v5.18
334 Mbits/sec

v5.10
336 Mbits/sec

v5.1 + git revert 288ac524cf70a8e7ed851a61ed2a9744039dae8d
397 Mbits/sec (back to medium speed)

v5.1
335 Mbits/sec (-60 Mb/s)

v5.0
395 Mbits/sec

***************

v4.19 + git revert 6b839b6cf9eada30b086effb51e5d6076bafc761
414 Mbits/sec (back to high speed)

v4.19
395 Mbits/sec (-20 Mb/s)

v4.18
415 Mbits/sec

v4.12
415 Mbits/sec
