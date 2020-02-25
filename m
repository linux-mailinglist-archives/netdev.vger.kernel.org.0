Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95D116EF38
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbgBYTow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:44:52 -0500
Received: from hs2.cadns.ca ([149.56.24.197]:55546 "EHLO hs2.cadns.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgBYTov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 14:44:51 -0500
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        by hs2.cadns.ca (Postfix) with ESMTPSA id 5C89E4DC3D
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 14:44:50 -0500 (EST)
Authentication-Results: hs2.cadns.ca;
        spf=pass (sender IP is 209.85.222.175) smtp.mailfrom=sriram.chadalavada@mindleap.ca smtp.helo=mail-qk1-f175.google.com
Received-SPF: pass (hs2.cadns.ca: connection is authenticated)
Received: by mail-qk1-f175.google.com with SMTP id o28so330806qkj.9
 for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 11:44:50 -0800 (PST)
X-Gm-Message-State: APjAAAXYxGX7FCr9f04ySI0p2nCvvo7wR5+SfxqmQVnyvy+2pfj2TcSv
 mgEPmfnft//2/fH3hOU0cKGtCANaAAOay1FKuSo=
X-Google-Smtp-Source: APXvYqweAeRa2n2EIZTylSIJwQcahxZtCuevVr5bWpRHGcu7/uFqjSc4C67MUlKVoVm//3EwjH6m6hNjjbc+7p/ME8Q=
X-Received: by 2002:a37:9587:: with SMTP id x129mr608669qkd.500.1582659889917;
 Tue, 25 Feb 2020 11:44:49 -0800 (PST)
MIME-Version: 1.0
References: <CAOK2joHUDyZvGx6rkMS4D6-Rw0yznc2Q68JXdnUK1e=xN2X9Hw@mail.gmail.com>
 <CAOK2joG_XixQ5EKUcxOph_gECBqfZGuW8=7dwpdskHpgUO5qug@mail.gmail.com>
In-Reply-To: <CAOK2joG_XixQ5EKUcxOph_gECBqfZGuW8=7dwpdskHpgUO5qug@mail.gmail.com>
From:   Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Date:   Tue, 25 Feb 2020 14:44:38 -0500
X-Gmail-Original-Message-ID: <CAOK2joEyyQHmsKz1L6WV_5XmDmP5ZGhucLwFY_CT+U=AiySeNA@mail.gmail.com>
Message-ID: <CAOK2joEyyQHmsKz1L6WV_5XmDmP5ZGhucLwFY_CT+U=AiySeNA@mail.gmail.com>
Subject: Fwd: Kernel crash due to conflict between legacy and current DSA
 mv88e6xxx drivers ?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-PPP-Message-ID: <20200225194450.14621.98241@hs2.cadns.ca>
X-PPP-Vhost: mindleap.ca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following error occurred using 4.19.101 kernel and NOT with our
last stable 4.1.16 kernel on enabling CONFIG_NET_DSA_LEGACY.

[    1.505428] libphy: mdiobus_find: mii bus [igb_enet_mii_bus] found
[    1.505515] sysfs: cannot create duplicate filename '/kernel/marvell/access'
[    1.505529] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.19.101 #0
[    1.505534] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    1.505539] Backtrace:
[    1.505549] Function entered at [<80013a28>] from [<80013d60>]
[    1.505561]  r7:00000000 r6:60000013 r5:00000000 r4:806437b4
[    1.505565] Function entered at [<80013d48>] from [<804e94b4>]
[    1.505570] Function entered at [<804e941c>] from [<8013fffc>]
[    1.505579]  r7:00000000 r6:80575d54 r5:e931a000 r4:eee2d000
[    1.505585] Function entered at [<8013ff9c>] from [<8013fcbc>]
[    1.505593]  r7:00000000 r6:e931a000 r5:ffffffef r4:8063860c
[    1.505599] Function entered at [<8013fb50>] from [<8013fd68>]
[    1.505606]  r6:e932f880 r5:8063860c r4:00000000
[    1.505612] Function entered at [<8013fcf4>] from [<802f3190>]
[    1.505620]  r7:80673f0c r6:00000000 r5:e91df078 r4:00000000
[    1.505626] Function entered at [<802f30f4>] from [<804df104>]
[    1.505638]  r10:e932b940 r9:8052c8e8 r8:00000000 r7:e91df078
r6:00000000 r5:802f30f4
[    1.505644]  r4:80638598
[    1.505649] Function entered at [<804deb8c>] from [<80271310>]
[    1.505661]  r10:00000000 r9:8064366c r8:00000000 r7:80672acc
r6:8064366c r5:eef36410
[    1.505665]  r4:00000000
[    1.505670] Function entered at [<802712c0>] from [<8026f7b0>]
[    1.505679]  r7:80672acc r6:00000000 r5:80672ac8 r4:eef36410
[    1.505684] Function entered at [<8026f65c>] from [<8026fb90>]

On disabling the option CONFIG_NET_DSA_LEGACY,  the crash goes away
but the ethernet interfaces are NOT enumerated.

https://www.spinics.net/lists/netdev/msg556413.html seems to suggest
that legacy DSA is still being used for Marvell 88e6xxx drivers. If
the kernel community intends to move away from that, we would want to
adopt that approach. Please advise on what we might have to
investigate/change that will also enable resolving this kernel crash.
As I understand, one of the things I would need to change is that the
relevant device tree needs to use the "current binding" as opposed to
the "deprecated binding" which is what is being used now.
