Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DA531562F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhBISlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:41:37 -0500
Received: from mout.gmx.net ([212.227.17.21]:42849 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233465AbhBIS25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:28:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612895218;
        bh=HZ3VAOfNeKCHRzskhHF+i9W/Qlopzn2dENYjTEht/rc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=XZTTja2dw79NbTFC2Ay5/5YhTZh0VN5MRR2nrjS4rm02vD/rYv4KwijBNJz1Vg6ZO
         HmxxLy3WQhMnJZkNf0ZoVyhCbxwkbdDLNGhiYcjtJuQEciEQjL/txvg2OwodvkYekK
         Qb0X/UiyxsPqdKvL/wv3WE2UQAd8ZwdsUsvDE2iE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from MX-Linux-Intel ([79.242.189.146]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MoO6C-1lgQck0ZD6-00ol4Q; Tue, 09
 Feb 2021 19:26:58 +0100
Date:   Tue, 9 Feb 2021 19:26:56 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com
Cc:     netdev@vger.kernel.org
Subject: [REGRESSION] r8169: Cannot restart phy after suspend
Message-ID: <20210209182656.GA14302@MX-Linux-Intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:+NKcRailKUpXqz7YuUB+RkIK8AbuB/I/5wbe221gcjhMQ5coA3c
 +0vLaPsqvtE/GxV4mS1kmjiz6dNjMktlJ7rVd8whEwrefj+QXc3samutKbXc9Kpwwlcvr5d
 oWwlT3xTkMpuNyPwPWMlkeISuEQ6hjAilMCY7vxjZXx5yAHj1uo3Brqa7TbInOCWVZGQxUe
 OyqV6Nbgts+bxVbhGUgnA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Nf+hUCxgZqY=:PmyYwVVe3ZcGVVvtnxyrvP
 NSJYbQaw4nQE16pg5iQbYhtHdBs6Wv3EiRZYiP9H2cLYRbkkg+J4ZX8WSxCJrR9PiRyXvVofe
 W8muVgfA6VD5lBAuXHk7jSj+cctth+7dGdaPS7V6Cz3XT8sX7t3sQzlfLDtoiajxztxO7qVqy
 FRlGT1VkzbWB7MTD6OfgvU8vQUrB6j1YnaNS26VYyMtkcK9BdEVAERmu0RrO2nU4xGhiREEKy
 gwBxwUTjOJWapuFkhIOkM3NdYY/EDg8MyfEVbGyrdse8WY7gb8SWrGaLYXjOsyieHEU2EycRx
 Lii/ycQqHC8m+98n3CXka7it9vUO08VOl70nZYh2HCNVWvhRxz6bqzO0sXSm71mcvQbcYJMoq
 LkohFluTtaw7lbFbeOK3kz0AjEI2eWZZJiZb6Cku9qxeJRMBViCWiPZDmT98c2AGlneCVX/rs
 XgTjtt9ZSrR5n43lcZNe3zns7OAR6rzPUm31rtWkD69o2y7liJDxH57grCF5j45OsHkRG+dig
 FnlCchlh3ocxIWDKR9PjZECeFBPtHhi8GfVMfXcaAyAVYXpRcvNnolNSJz/fhidt4B2hrDWDy
 qvAQoRBpEJLuptVz4Kdg2tM1Ak7eLmagWm69UhpZadiwyFLTaiqgJdHfStvEs+YlHuourOF04
 P9745uR5xxPkNyyDMULr6aX8eEnwQswgnaj6x1dV03aKgN/4nEax3vs4FzAjUaN9h+nbs8F8y
 MFkSzO1LslHLZ8bOOF3z5tkjDGQS2b5TPdsDRFo3J6rOI+JyT/VcL9aGR5hsn/mq0dvzQjGZE
 NWS9vg7fL0IWJSt9mRnS6g1tBzaw6Q66lyHiHVCg8D3Y54nj/uHnKPhM7oIBVwEMY36gAFFSc
 h7nXStqAQTArzZLygVqw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When waking up from suspend, r8169 fails to restart the phy, preventing
any form of networking until a complete reboot. This bug was introduced
in commit

e80bd76fbf563cc7ed8c9e9f3bbcdf59b0897f69 r8169: work around power-saving
bug on some chip versions

and could be reproduced with
- the latest net-next kernel (5.11.0-rc6)
- stable 4.19.0-171

but not with stable 4.19.0-160.

The bug occurs regularly when suspending the maschine, but sometimes
everything works fine after suspend.
However on stable 4.19.0-171 when suspending without any LAN cable
plugged in, the kernel does a partial freeze and needs to be restarted
by the case switch.

dmesg logs at https://bugzilla.kernel.org/show_bug.cgi?id=211659.

cat /proc/version:
Linux version 5.11.0-rc6-net-next+ (wolf@MX-Linux-Intel) (gcc (Debian
8.3.0-6) 8.3.0, GNU ld (GNU Binutils for Debian) 2.31.1) #3 SMP Sat Feb
6 20:41:37 CET 2021

hostnamectl | grep "Operating System":
Operating System: Debian GNU/Linux 10 (buster)

lspci -nn:
00:00.0 Host bridge [0600]: Intel Corporation 2nd Generation Core
Processor Family DRAM Controller [8086:0100] (rev 09)
00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200/2nd Generation
Core Processor Family PCI Express Root Port [8086:0101] (rev 09)
00:02.0 Display controller [0380]: Intel Corporation 2nd Generation Core
Processor Family Integrated Graphics Controller [8086:0102] (rev 09)
00:16.0 Communication controller [0780]: Intel Corporation 6 Series/C200
Series Chipset Family MEI Controller #1 [8086:1c3a] (rev 04)
00:1a.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series
Chipset Family USB Enhanced Host Controller #2 [8086:1c2d] (rev 05)
00:1b.0 Audio device [0403]: Intel Corporation 6 Series/C200 Series
Chipset Family High Definition Audio Controller [8086:1c20] (rev 05)
00:1c.0 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series
Chipset Family PCI Express Root Port 1 [8086:1c10] (rev b5)
00:1c.2 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series
Chipset Family PCI Express Root Port 3 [8086:1c14] (rev b5)
00:1d.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series
Chipset Family USB Enhanced Host Controller #1 [8086:1c26] (rev 05)
00:1f.0 ISA bridge [0601]: Intel Corporation H61 Express Chipset Family
LPC Controller [8086:1c5c] (rev 05)
00:1f.2 SATA controller [0106]: Intel Corporation 6 Series/C200 Series
Chipset Family SATA AHCI Controller [8086:1c02] (rev 05)
00:1f.3 SMBus [0c05]: Intel Corporation 6 Series/C200 Series Chipset
Family SMBus Controller [8086:1c22] (rev 05)
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
[AMD/ATI] Cedar [Radeon HD 7350/8350 / R5 220] [1002:68fa]
01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
Cedar HDMI Audio [Radeon HD 5400/6300/7300 Series] [1002:aa68]
03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8101/2/6E PCI Express Fast/Gigabit Ethernet controller [10ec:8136]
(rev 05)
