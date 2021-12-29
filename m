Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726B248153E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 17:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhL2Qq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 11:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240898AbhL2Qq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 11:46:26 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD91C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 08:46:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id w7so15694898plp.13
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 08:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=n0AOLvSbh4QASEnmwqwAeNvQ39oCjhS/SOzQROosGCE=;
        b=nA1CaTTUFURcNeM07qP8v9apdEymjI7gcwFMR0Gs+BGexudo24Jh3TuVUvBN+lGqZY
         RLUYPzzM9qkExnXh8bQPw7lAd+q2IK9uobZ8ZLDdVl5DILBh/ol8/IpT46HPmRTLcu7N
         mVP77Bev94W754aZdujl1xsFR0VPR6YxYTxbS4/xsl6hjS+afmvOImTJuwbHWeOuJ2WV
         kB86M8ZVeD8L6aj32hdNXFukxKJwQZjEzvA2WtZxfuONa9xNQMAWY+3nnE0aQms77e1d
         iQWwjIORmMGA/aQJIVGM2Qeyx86asZ5lQK226UgIcm4U4gl6k68JOxXG6Q7pJvjSZffp
         OE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=n0AOLvSbh4QASEnmwqwAeNvQ39oCjhS/SOzQROosGCE=;
        b=hpaH7LaBWAyQ0k0Mrlu9UXxgkujpqR1OuRoAAhnBvbrsZ5ZTOjg3T6sOlk0aV1ImWr
         EeSg1NT1VLmPkJNcCj+DERsF/UpmFOhaW/VkxGAVZcHBYtUvluMqjkjSW6z6qxIWOmwo
         7VtC3oeCjf2GGNBqqNydVgxN22Iwu7G5DGPxV6VO6MSlJ6dnzKpmVIa6co8NzHuz5deI
         iMplsKb6m2s+xlh0njT1DeBBM4KdhuuP19tiVusVbEt5Or26cdWqhfEd6/I/426ytmUi
         iDwF0010bOqCX9NffX/hhH3a5gPMib9XehrpFW3kgSw0WWb5e5zNJOnF9XAMp9PvHa9D
         1hbw==
X-Gm-Message-State: AOAM530fAZdVQK0jFZGux91Nz+Tqh+UWGhkuYpsNotC0MGxiQWSzGVtp
        GdKkUK1juv6YjzyKoxsl4uqEOBFTruxWzA==
X-Google-Smtp-Source: ABdhPJzzsWmYbzATRRNu6Pdmf9DhhriAMSwJX2t3xsHWFaWigshwM5SW3e3VJ6zYy55kA84bcr13Zg==
X-Received: by 2002:a17:902:e149:b0:149:9b8e:1057 with SMTP id d9-20020a170902e14900b001499b8e1057mr4640303pla.144.1640796385828;
        Wed, 29 Dec 2021 08:46:25 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x40sm23368110pfu.185.2021.12.29.08.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 08:46:25 -0800 (PST)
Date:   Wed, 29 Dec 2021 08:46:22 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     hkallweit1@gmail.com, swsd@realtek.com
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 215437] New: [r8169] Lots of Rx errors with
 RTL8111/8168/8411 (rev 06)
Message-ID: <20211229084622.49dac13b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 29 Dec 2021 14:52:59 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215437] New: [r8169] Lots of Rx errors with RTL8111/8168/8411 (rev 06)


https://bugzilla.kernel.org/show_bug.cgi?id=215437

            Bug ID: 215437
           Summary: [r8169] Lots of Rx errors with RTL8111/8168/8411 (rev
                    06)
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15.11
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: glaubersm@hotmail.com.br
        Regression: No

Created attachment 300182
  --> https://bugzilla.kernel.org/attachment.cgi?id=300182&action=edit  
full kernel log

Hi

I see lots of Rx errors in the kernel log when using r8169 driver on Arch
Linux.
I do not see these errors when using r8168 driver.

$ uname -a
Linux Arch-PC 5.15.11-arch2-1 #1 SMP PREEMPT Wed, 22 Dec 2021 09:23:54 +0000
x86_64 GNU/Linux

$ sudo lspci -v
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
PCI Express Gigabit Ethernet Controller (rev 06)
        Subsystem: Gigabyte Technology Co., Ltd Onboard Ethernet
        Flags: bus master, fast devsel, latency 0, IRQ 18
        I/O ports at e000 [size=256]
        Memory at f7c00000 (64-bit, non-prefetchable) [size=4K]
        Memory at f0000000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable+ Count=4 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 01-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
        Kernel modules: r8169, r8168


$ sudo dmesg -Tx|grep r8169
kern  :warn  : [qua dez 29 10:10:51 2021] r8169 0000:04:00.0: can't disable
ASPM; OS doesn't have ASPM control
kern  :info  : [qua dez 29 10:10:51 2021] libphy: r8169: probed
kern  :info  : [qua dez 29 10:10:51 2021] r8169 0000:04:00.0 eth0:
RTL8168evl/8111evl, fc:aa:14:fc:4b:1b, XID 2c9, IRQ 30
kern  :info  : [qua dez 29 10:10:51 2021] r8169 0000:04:00.0 eth0: jumbo
features [frames: 9194 bytes, tx checksumming: ko]
kern  :info  : [qua dez 29 10:10:54 2021] r8169 0000:04:00.0 enp4s0: renamed
from eth0
kern  :info  : [qua dez 29 10:11:10 2021] r8169 0000:04:00.0: invalid VPD tag
0x00 (size 0) at offset 0; assume missing optional EEPROM
kern  :info  : [qua dez 29 10:11:11 2021] RTL8211E Gigabit Ethernet
r8169-0-400:00: attached PHY driver (mii_bus:phy_addr=r8169-0-400:00, irq=MAC)
kern  :info  : [qua dez 29 10:11:12 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 10:11:15 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :info  : [qua dez 29 10:11:15 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :warn  : [qua dez 29 10:13:18 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:15:57 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:21:16 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:24:03 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:26:08 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:27:48 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:46:11 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:46:17 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 10:54:48 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :warn  : [qua dez 29 11:16:39 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352c4174
kern  :warn  : [qua dez 29 11:19:08 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 392cc118
kern  :warn  : [qua dez 29 11:20:40 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac5ee
kern  :info  : [qua dez 29 11:21:20 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:21:21 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:21:24 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :info  : [qua dez 29 11:21:25 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :info  : [qua dez 29 11:21:25 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:21:25 2021] RTL8211E Gigabit Ethernet
r8169-0-400:00: attached PHY driver (mii_bus:phy_addr=r8169-0-400:00, irq=MAC)
kern  :info  : [qua dez 29 11:21:25 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:21:29 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :info  : [qua dez 29 11:21:29 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :info  : [qua dez 29 11:24:24 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:24:25 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:24:25 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:24:28 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :info  : [qua dez 29 11:24:28 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:24:28 2021] RTL8211E Gigabit Ethernet
r8169-0-400:00: attached PHY driver (mii_bus:phy_addr=r8169-0-400:00, irq=MAC)
kern  :info  : [qua dez 29 11:24:29 2021] r8169 0000:04:00.0 enp4s0: Link is
Down
kern  :info  : [qua dez 29 11:24:32 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :info  : [qua dez 29 11:24:32 2021] r8169 0000:04:00.0 enp4s0: Link is Up
- 1Gbps/Full - flow control rx/tx
kern  :warn  : [qua dez 29 11:30:23 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac171
kern  :warn  : [qua dez 29 11:30:33 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac143
kern  :warn  : [qua dez 29 11:32:09 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352c4177
kern  :warn  : [qua dez 29 11:37:26 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 392cc165
kern  :warn  : [qua dez 29 11:37:35 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352cc174
kern  :warn  : [qua dez 29 11:41:37 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac20f
kern  :warn  : [qua dez 29 11:45:47 2021] r8169 0000:04:00.0 enp4s0: Rx ERROR.
status = 352ac143

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
