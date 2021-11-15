Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A252450A31
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhKOQzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhKOQzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:55:36 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88AAC061714
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:52:40 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id o4so15497451pfp.13
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=5jfAVpMeHy/AAGUgjsdV/PTXUjzkO8SsH/ypYE/gSLo=;
        b=ruS/wWEuIHcgcFr8fnh6WHZOhN8OR7ytlIQ6xD2HhUeKPBU11bi8nR7e4Xhg0xuont
         ZI/yemqd2LpdJ/C4rkDx7+8waOEwV8UemDfGnMlvNq8OHOwbP6Qco/8fllK2/2N1iL5V
         0CChka/LYbjBOLq8WVsLKQqmyMpjoyyGPM3hX2xY2BAQQMYF8SOgPOCBCPKUQQoeaXx+
         SWOS/NDOTmMXe/gUKnul7k7jcHguepir21fqLiEgVio8IuYyEvApd3gYXnxCagYqNjG7
         JcvHNgzvf4mcKW6SJz1O6VtIwRoO0m1ic5+aqbeW4mkSjeqBkINwSw72iwMOLiYQHgzi
         s6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=5jfAVpMeHy/AAGUgjsdV/PTXUjzkO8SsH/ypYE/gSLo=;
        b=qIU97IenbL827nMA0+o4m4jT36mN7VcHsuya8qKQmY3uLG3zdHDhsQjOBkKowvafc/
         xfninYbQCrg7i8oAY0EmL9R8W6bJVj9wJgmeGQAyEXQRB1HCIBD5eHG+vUS0PLJww4L+
         sy8A8uRjH6h+jqdIxHBkretECQxuXTcUgW3s3Kv1kVNQ5yabyHEr+cnWawNvK8clmsCA
         jyHTNgwQEic0fax15fOEwTowg64qfgzcv+pQ0zZPszlrs1hC0L6c+jKasZ+ojKT8L3K3
         Vp6VY9tB835nSbzQ+HjEPHtWswpHghRB0fx/DbI2GA6JLnsztB3JKx+PfB3DV6bfV1HH
         LvYw==
X-Gm-Message-State: AOAM530flE2Tjln6MD8JI/FhvhKJ9M/MQlqMwo0CvYsoOZ31OhVQGSob
        4gzGRkza6FqKTmu8K1/kfX2KGzd7l3bCMg==
X-Google-Smtp-Source: ABdhPJzzLJylJzyrdMGdyEGxyrAg8Psz/4D3oUOfPbb/kp0W6RW9E6QKPmXMasSyqNFjaGIgqUeIog==
X-Received: by 2002:aa7:96ba:0:b0:49f:c35f:83f8 with SMTP id g26-20020aa796ba000000b0049fc35f83f8mr34423286pfk.47.1636995159776;
        Mon, 15 Nov 2021 08:52:39 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id n20sm12174455pgc.10.2021.11.15.08.52.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 08:52:39 -0800 (PST)
Date:   Mon, 15 Nov 2021 08:52:36 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215029] New: Clean unregistration of SMSC9500 chip at
 halting system failed
Message-ID: <20211115085236.508df573@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 15 Nov 2021 09:26:30 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215029] New: Clean unregistration of SMSC9500 chip at halting system failed


https://bugzilla.kernel.org/show_bug.cgi?id=215029

            Bug ID: 215029
           Summary: Clean unregistration of SMSC9500 chip at halting
                    system failed
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15.1
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: robert.knebel@automatek.de
        Regression: No

Hi,
after switching from kernel version 5.10.65 to 5.15.1 I recognized a failing
unregistration of the SMSC9500A chip during shut down the system.
We build the kernel and all other needed stuff from scratch for an i.MX6Q
module (armv7l) provided by TQ-Systems GmbH for our own base-board. For this we
are using ptxdist as environment/building tool together with the
OSELAS-Toolchain as cross-compiler.
Since kernel 3.16 we had now issue like that...
Because we just upgrade from LTS to LTS versions, I can only say that the issue
till kernel 5.10.65 does not exist.

Following kernel-messages show the issue with kernel 5.15.1:
[ 4618.628115] systemd-shutdown[1]: Syncing filesystems and block devices.
[ 4618.640864] systemd-shutdown[1]: Sending SIGTERM to remaining processes...
[ 4618.717308] systemd-journald[271]: Received SIGTERM from PID 1
(systemd-shutdow).
[ 4618.796390] systemd-shutdown[1]: Sending SIGKILL to remaining processes...
[ 4618.934280] systemd-shutdown[1]: Unmounting file systems.
[ 4618.943841] systemd-shutdown[1]: All filesystems unmounted.
[ 4618.949521] systemd-shutdown[1]: Deactivating swaps.
[ 4618.955153] systemd-shutdown[1]: All swaps deactivated.
[ 4618.960444] systemd-shutdown[1]: Detaching loop devices.
[ 4618.992064] systemd-shutdown[1]: All loop devices detached.
[ 4618.997715] systemd-shutdown[1]: Stopping MD devices.
[ 4619.004229] systemd-shutdown[1]: All MD devices stopped.
[ 4619.009606] systemd-shutdown[1]: Detaching DM devices.
[ 4619.016161] systemd-shutdown[1]: All DM devices detached.
[ 4619.021697] systemd-shutdown[1]: All filesystems, swaps, loop devices, MD
devices and DM devices detached.
[ 4619.046361] systemd-shutdown[1]: Syncing filesystems and block devices.
[ 4619.058484] systemd-shutdown[1]: Halting system.
[ 4619.068511] ci_hdrc ci_hdrc.1: remove, state 1
[ 4619.075005] usb usb2: USB disconnect, device number 1
[ 4619.080273] usb 2-1: USB disconnect, device number 2
[ 4619.085742] usb 2-1.1: USB disconnect, device number 3
[ 4619.435503] ci_hdrc ci_hdrc.1: USB bus 2 deregistered
[ 4619.445224] ci_hdrc ci_hdrc.0: remove, state 1
[ 4619.449741] usb usb1: USB disconnect, device number 1
[ 4619.455127] usb 1-1: USB disconnect, device number 2
[ 4619.467720] smsc95xx 1-1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.0-1,
smsc95xx USB 2.0 Ethernet
[ 4619.517252] smsc95xx 1-1:1.0 eth1: Link is Down
[ 4619.522698] ------------[ cut here ]------------
[ 4619.527500] WARNING: CPU: 2 PID: 1 at fs/kernfs/dir.c:1535
kernfs_remove_by_name_ns+0x90/0x9c
[ 4619.536207] kernfs: can not remove 'attached_dev', no directory
[ 4619.542428] Modules linked in:
[ 4619.545546] CPU: 2 PID: 1 Comm: systemd-shutdow Not tainted
5.15.1-20211106-g1a66115308ea #1
[ 4619.554017] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[ 4619.560571] Backtrace: 
[ 4619.563055] [<811f171c>] (dump_backtrace) from [<811f1d8c>]
(show_stack+0x20/0x24)
[ 4619.570681]  r7:000005ff r6:00000000 r5:816c2d30 r4:600f0013
[ 4619.576362] [<811f1d6c>] (show_stack) from [<811fcd50>]
(dump_stack_lvl+0x60/0x78)
[ 4619.583975] [<811fccf0>] (dump_stack_lvl) from [<811fcd80>]
(dump_stack+0x18/0x1c)
[ 4619.591585]  r7:000005ff r6:00000009 r5:80484248 r4:816e0960
[ 4619.597265] [<811fcd68>] (dump_stack) from [<8013cee0>] (__warn+0xfc/0x16c)
[ 4619.604272] [<8013cde4>] (__warn) from [<811f2588>]
(warn_slowpath_fmt+0xa8/0xe8)
[ 4619.611799]  r7:80484248 r6:000005ff r5:816e0960 r4:816e0a20
[ 4619.617480] [<811f24e4>] (warn_slowpath_fmt) from [<80484248>]
(kernfs_remove_by_name_ns+0x90/0x9c)
[ 4619.626571]  r8:00000000 r7:81400ddc r6:00000000 r5:8177d02c r4:00000000
[ 4619.633294] [<804841b8>] (kernfs_remove_by_name_ns) from [<8048711c>]
(sysfs_remove_link+0x30/0x34)
[ 4619.642385]  r6:841aa9d4 r5:841aa000 r4:83c90800
[ 4619.647024] [<804870ec>] (sysfs_remove_link) from [<80c78ed0>]
(phy_detach+0x104/0x15c)
[ 4619.655065] [<80c78dcc>] (phy_detach) from [<80c78f74>]
(phy_disconnect+0x4c/0x58)
[ 4619.662671]  r7:81400ddc r6:841aa9d4 r5:841aa700 r4:83c90800
[ 4619.668352] [<80c78f28>] (phy_disconnect) from [<80cd111c>]
(smsc95xx_disconnect_phy+0x30/0x38)
[ 4619.677093]  r5:841aa700 r4:841aa700
[ 4619.680690] [<80cd10ec>] (smsc95xx_disconnect_phy) from [<80cd46f4>]
(usbnet_stop+0x70/0x198)
[ 4619.689255]  r5:841aa700 r4:841aa000
[ 4619.692853] [<80cd4684>] (usbnet_stop) from [<80ef1b74>]
(__dev_close_many+0xb4/0x138)
[ 4619.700820]  r8:00000001 r7:00000001 r6:00000000 r5:8255da0c r4:841aa000
[ 4619.707542] [<80ef1ac0>] (__dev_close_many) from [<80ef1c88>]
(dev_close_many+0x90/0x12c)
[ 4619.715761]  r6:8255da0c r5:8255da24 r4:841aa000
[ 4619.720400] [<80ef1bf8>] (dev_close_many) from [<80ef9a48>]
(unregister_netdevice_many+0x14c/0x534)
[ 4619.729493]  r8:00000001 r7:8255da0c r6:8255da5c r5:8255da24 r4:841aa000
[ 4619.736215] [<80ef98fc>] (unregister_netdevice_many) from [<80ef9edc>]
(unregister_netdevice_queue+0xac/0xf4)
[ 4619.746170]  r10:00000003 r9:83c94880 r8:00000090 r7:83ef0820 r6:00000000
r5:00000000
[ 4619.754024]  r4:841aa000
[ 4619.756580] [<80ef9e30>] (unregister_netdevice_queue) from [<80ef9f4c>]
(unregister_netdev+0x28/0x30)
[ 4619.765836]  r5:841aa000 r4:841aa000
[ 4619.769432] [<80ef9f24>] (unregister_netdev) from [<80cd3c74>]
(usbnet_disconnect+0x64/0xe0)
[ 4619.777908]  r5:841aa000 r4:841aa700
[ 4619.781504] [<80cd3c10>] (usbnet_disconnect) from [<80ced254>]
(usb_unbind_interface+0x94/0x288)
[ 4619.790338]  r5:81c84f7c r4:83ef0820
[ 4619.793935] [<80ced1c0>] (usb_unbind_interface) from [<80bda9d4>]
(__device_release_driver+0x220/0x22c)
[ 4619.803374]  r10:00000003 r9:000000a8 r8:00000090 r7:81c84f7c r6:00000000
r5:81c84f7c
[ 4619.811227]  r4:83ef0820
[ 4619.813781] [<80bda7b4>] (__device_release_driver) from [<80bdaa14>]
(device_release_driver+0x34/0x40)
[ 4619.823128]  r9:000000a8 r8:83c94880 r7:00080000 r6:81c853a4 r5:83ef08b0
r4:83ef0820
[ 4619.830893] [<80bda9e0>] (device_release_driver) from [<80bd9ae8>]
(bus_remove_device+0xf4/0x14c)
[ 4619.839802]  r5:83ef0820 r4:82655c50
[ 4619.843398] [<80bd99f4>] (bus_remove_device) from [<80bd3d04>]
(device_del+0x190/0x3f4)
[ 4619.851448]  r7:00080000 r6:823b9bc8 r5:83ef08b0 r4:83ef0820
[ 4619.857128] [<80bd3b74>] (device_del) from [<80ceabbc>]
(usb_disable_device+0x114/0x234)
[ 4619.865263]  r10:00000003 r9:000000a8 r8:83d91d08 r7:81ce9e88 r6:00000000
r5:83ef0800
[ 4619.873116]  r4:83c94800
[ 4619.875671] [<80ceaaa8>] (usb_disable_device) from [<80ce07b8>]
(usb_disconnect+0x108/0x28c)
[ 4619.884150]  r10:827b54a0 r9:83c94910 r8:83c94880 r7:00000001 r6:83c94800
r5:84104c00
[ 4619.892002]  r4:83b34000
[ 4619.894557] [<80ce06b0>] (usb_disconnect) from [<80ce076c>]
(usb_disconnect+0xbc/0x28c)
[ 4619.902598]  r10:827b54a0 r9:83c95910 r8:83c95880 r7:00000001 r6:83c95800
r5:83b34400
[ 4619.910450]  r4:8255dc58
[ 4619.913004] [<80ce06b0>] (usb_disconnect) from [<812043a4>]
(usb_remove_hcd+0xdc/0x170)
[ 4619.921048]  r10:827b54a0 r9:8176c1f4 r8:00000090 r7:83b37410 r6:8400b040
r5:83c9693c
[ 4619.928900]  r4:83c96800
[ 4619.931455] [<812042c8>] (usb_remove_hcd) from [<80d31b24>]
(host_stop+0x48/0xf4)
[ 4619.938984]  r5:83c96800 r4:8400a040
[ 4619.942580] [<80d31adc>] (host_stop) from [<80d31ee0>]
(ci_hdrc_host_destroy+0x34/0x38)
[ 4619.950624]  r7:83b37410 r6:8400b040 r5:83b37400 r4:8400a040
[ 4619.956304] [<80d31eac>] (ci_hdrc_host_destroy) from [<80d2a0cc>]
(ci_hdrc_remove+0x54/0x130)
[ 4619.964864] [<80d2a078>] (ci_hdrc_remove) from [<80bdd8e0>]
(platform_remove+0x30/0x5c)
[ 4619.972909]  r7:81c8809c r6:00000000 r5:81c8809c r4:83b37410
[ 4619.978590] [<80bdd8b0>] (platform_remove) from [<80bda920>]
(__device_release_driver+0x16c/0x22c)
[ 4619.987588]  r5:81c8809c r4:83b37410
[ 4619.991184] [<80bda7b4>] (__device_release_driver) from [<80bdaa14>]
(device_release_driver+0x34/0x40)
[ 4620.000531]  r9:8176c1f4 r8:827b5410 r7:00000000 r6:81c77240 r5:83b374a0
r4:83b37410
[ 4620.008295] [<80bda9e0>] (device_release_driver) from [<80bd9ae8>]
(bus_remove_device+0xf4/0x14c)
[ 4620.017203]  r5:83b37410 r4:8256d050
[ 4620.020799] [<80bd99f4>] (bus_remove_device) from [<80bd3d04>]
(device_del+0x190/0x3f4)
[ 4620.028844]  r7:00000000 r6:823b9bc8 r5:83b374a0 r4:83b37410
[ 4620.034524] [<80bd3b74>] (device_del) from [<80bddc3c>]
(platform_device_del.part.0+0x20/0x84)
[ 4620.043180]  r10:827b54a0 r9:8176c1f4 r8:81cff018 r7:823b9bc8 r6:827b5410
r5:83b37400
[ 4620.051032]  r4:83b37400
[ 4620.053587] [<80bddc1c>] (platform_device_del.part.0) from [<80bde0a0>]
(platform_device_unregister+0x28/0x34)
[ 4620.063627]  r5:827eb400 r4:83b37400
[ 4620.067224] [<80bde078>] (platform_device_unregister) from [<80d29850>]
(ci_hdrc_remove_device+0x1c/0x30)
[ 4620.076828]  r5:827eb400 r4:00000000
[ 4620.080424] [<80d29834>] (ci_hdrc_remove_device) from [<80d34210>]
(ci_hdrc_imx_remove+0x38/0x120)
[ 4620.089424]  r5:827eb400 r4:827b5400
[ 4620.093020] [<80d341d8>] (ci_hdrc_imx_remove) from [<80d34310>]
(ci_hdrc_imx_shutdown+0x18/0x1c)
[ 4620.101848]  r7:823b9bc8 r6:827b5410 r5:827b4410 r4:827b5414
[ 4620.107530] [<80d342f8>] (ci_hdrc_imx_shutdown) from [<80bdd148>]
(platform_shutdown+0x34/0x38)
[ 4620.116266] [<80bdd114>] (platform_shutdown) from [<80bd80b8>]
(device_shutdown+0x194/0x260)
[ 4620.124739] [<80bd7f24>] (device_shutdown) from [<80171ee8>]
(kernel_halt+0x48/0x1f8)
[ 4620.132617]  r10:00000058 r9:8255c000 r8:fee1dead r7:81a25e94 r6:cdef0123
r5:cdef0123
[ 4620.140470]  r4:000065f4
[ 4620.143025] [<80171ea0>] (kernel_halt) from [<801723bc>]
(__do_sys_reboot+0x218/0x258)
[ 4620.150983]  r7:81a25e94 r6:cdef0123 r5:cdef0123 r4:00000000
[ 4620.156664] [<801721a4>] (__do_sys_reboot) from [<80172414>]
(sys_reboot+0x18/0x1c)
[ 4620.164362]  r8:80100224 r7:00000058 r6:00000000 r5:00000000 r4:00000000
[ 4620.171084] [<801723fc>] (sys_reboot) from [<80100060>]
(ret_fast_syscall+0x0/0x1c)
[ 4620.178777] Exception stack(0x8255dfa8 to 0x8255dff0)
[ 4620.183859] dfa0:                   00000000 00000000 fee1dead 28121969
cdef0123 cdef0123
[ 4620.192064] dfc0: 00000000 00000000 00000000 00000058 00000000 00000003
00000000 00000000
[ 4620.200267] dfe0: 00000058 7eaf4c6c 76c73965 76bf2196
[ 4620.206331] irq event stamp: 651781
[ 4620.209864] hardirqs last  enabled at (651789): [<801bb2a0>]
__up_console_sem+0x60/0x70
[ 4620.218006] hardirqs last disabled at (651798): [<801bb28c>]
__up_console_sem+0x4c/0x70
[ 4620.226135] softirqs last  enabled at (651776): [<80101744>]
__do_softirq+0x384/0x61c
[ 4620.234086] softirqs last disabled at (651759): [<801466d0>]
__irq_exit_rcu+0x144/0x1b8
[ 4620.242212] ---[ end trace 982eb6f2ea72e8bb ]---
[ 4620.350387] ci_hdrc ci_hdrc.0: USB bus 1 deregistered
[ 4620.380489] reboot: System halted

Although we had on our base-board just a SMSC9500A chip there will be mentioned
a "SMSC LAN8710/LAN8720" during establishing a network connection on this port.
If I compare drivers/net/phy/smsc.c for 5.10.65 and 5.15.1 then there were made
some changes - I think of the note:
/* This covers internal PHY (phy_id: 0x0007C0F0) for
 * LAN9500A (PID: 0x9E00), LAN9505A (PID: 0x9E01)
 */

Please ask if you need some further details to understand/solve this issue.
Thanks in advance.
RK

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
