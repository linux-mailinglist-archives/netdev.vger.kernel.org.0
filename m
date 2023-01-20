Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E225867551B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjATM6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjATM6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:58:45 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCFE9AA94
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:58:44 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hw16so13672381ejc.10
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=I8NC3SrgZiT2vGN3GY8ZK4iQBPsnz0nVvIMmtrsawlE=;
        b=Eifg83ck8No3DsFi++vFdIevQRy2cUHcP3q423dLeTt+mOF/AQiQZ2MyUrt58g/YFf
         P0FZPIyrUCD8kqBKGB/d9eFDN+2gUGR1Z+aXYhgUgszBfjcwXJwiDM3WkShp6WIsSpTq
         Hygp1m4sg1tRIEpjYNDo9DfMi5WQaV7e8LnkTNNoKOCXT+jsBszSGHGM08x+I7rsaZJj
         WdSJ345NVN+Xaznx+XSxDfVqcigseg1XuhIYD5GawIhTawy9vgdUTe8vXekA44tq+tB+
         NxwynnFcVUgWeplWcpfvBejOTNVembxbfwJOXznEeNkWwktiluwFJRAfu3crh4klnIFi
         yT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8NC3SrgZiT2vGN3GY8ZK4iQBPsnz0nVvIMmtrsawlE=;
        b=OhrYAA9cit4bebSn2leDNaeMXi5y1rHyxBDp0u6yp6ZWVn0vntLcV5xRfiINv5qIt8
         9wIOu6X5zDAcBlQHE03WfeNcDwCbtYeuomwfgpLIKoPBI6JkRB2Gtf01BBdPe61W/NQB
         RWNRflNua8TDrLDJyPiU5hBtu9AFhULgUwBaciGhh5eRylC8LiVtfIBVrRSq3iMCACk7
         yMr+6aqSfQzPyNqPNYgs0KTeShg+wbaaL/yAuogYdVXFtDdNJ5P8J4kz14HYPna3dF/B
         RsCwHjj3nFlLvkUgcHZkJZsZMJ+3MG2VZS6cM7zG/tfZiaCS4lq5hRXiA++Z9e2hWn9F
         Gm3Q==
X-Gm-Message-State: AFqh2kq5qaP+MW4i/GoQMeI80Yd6Zl8yEkkAvQiyO7ksteiZAsQM0hRs
        gTMkeU2d1zSva1eBJ+h5R99d4TYxusA=
X-Google-Smtp-Source: AMrXdXsmzBMSZPch7UiwYabwQzLapo/soRnALbb1S0J1r7eZWYbNAQgWAatUD9A5tFs5gFZHWqpuPQ==
X-Received: by 2002:a17:906:9c8b:b0:84d:ed5:a406 with SMTP id fj11-20020a1709069c8b00b0084d0ed5a406mr29561495ejc.14.1674219522758;
        Fri, 20 Jan 2023 04:58:42 -0800 (PST)
Received: from [192.168.0.175] ([37.220.41.3])
        by smtp.gmail.com with ESMTPSA id lb24-20020a170907785800b008448d273670sm17670873ejc.49.2023.01.20.04.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:58:42 -0800 (PST)
Message-ID: <46a87c152b967d42ba4af33b2d11791781e9df7f.camel@gmail.com>
Subject: issue with ethernet gigabit ethernet card both on stable and rc
 kernels
From:   vmxevilstar@gmail.com
To:     nic_swsd@realtek.com, netdev@vger.kernel.org
Cc:     hkallweit1@gmail.com
Date:   Fri, 20 Jan 2023 13:58:41 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Mantainers,

I am having an issue with my ethernet card.
It works when the system boots but after around a couple of hours it
disconnects.
I tried different ways to get it working without having to reboot but
nothing else seemed to work.
Even rebooting doesn't solve the problem since again, after a couple of
hours, it stops working again.
I have googled around and found that some people had this same problem
on older kernels but no solution seemed to apply to this rc nor latest
stable kernel versions.
I am probably missing something here.
The issue happened also with recent stable 6.1.7 and rc kernel
versions.
I am actually testing the latest 6.2-rc4 version.

Following are some data I think might be useful but if you feel I
neglected to give enough informations and you need more please just ask
me.

Here some informations about my system :
uname -a
Linux ghost 6.2.0-rc4 #2 SMP PREEMPT_DYNAMIC Tue Jan 17 13:35:46 CET
2023 x86_64 GNU/Linux

gcc --version
gcc (Debian 12.2.0-14) 12.2.0
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is
NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.


/usr/src# lspci|grep -i net
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8125
2.5GbE Controller (rev 05)

description: Ethernet interface
product: RTL8125 2.5GbE Controller
vendor: Realtek Semiconductor Co., Ltd.
physical id: 0
bus info: pci@0000:02:00.0
logical name: enp2s0
version: ff
serial: b0:25:aa:49:a5:3a
size: 1Gbit/s
capacity: 1Gbit/s
width: 32 bits
clock: 66MHz
capabilities: bus_master vga_palette cap_list ethernet physical tp mii
10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
configuration: autonegotiation=3Don broadcast=3Dyes driver=3Dr8169
driverversion=3D6.2.0-rc4 duplex=3Dfull firmware=3Drtl8125b-2_0.0.2 07/13/2=
0
latency=3D255 link=3Dyes maxlatency=3D255 mingnt=3D255 multicast=3Dyes
port=3Dtwisted pair speed=3D1Gbit/s



lsmod|grep r8169
r8169                 110592  0
mdio_devres            16384  1 r8169
libphy                200704  3 r8169,mdio_devres,realtek

the firmware version I am using is linux-firmware-20221214.tar.gz


Here you can find what happens (dmesg -wT)
[Fri Jan 20 11:04:32 2023] userif-3: sent link up event.

[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_chipcmd_cond
=3D=3D 1 (loop: 100, delay: 100).
[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0:
rtl_mac_ocp_e00e_cond =3D=3D 1 (loop: 10, delay: 1000).
[Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_chipcmd_cond
=3D=3D 1 (loop: 100, delay: 100).
[Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
=3D=3D 1 (loop: 100, delay: 10).
[Fri Jan 20 13:20:18 2023] r8169 0000:02:00.0 enp2s0:
rtl_mac_ocp_e00e_cond =3D=3D 1 (loop: 10, delay: 1000).

I would love to provide a patch of any kind but I am afraid I don't
have enough programming skills.

Thanks in advance for your time.
