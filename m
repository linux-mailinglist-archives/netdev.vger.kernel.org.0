Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EF44600B9
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355717AbhK0RzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355710AbhK0RxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:53:05 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB53C06175C;
        Sat, 27 Nov 2021 09:48:26 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so52771382edd.3;
        Sat, 27 Nov 2021 09:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vOwihHQ2pOLmtOLhpuI7nDqfBhQgvZXDYpaP6pf/gEY=;
        b=ODyWn/j8WFOSG0mUyR2Uqcb6e0n6XOmt/G7sNvrzV+8RkG6dFgGqXZ+U2YXJv5uSOC
         3RGwPWATwvescNCsT7K5OVokqi8RLpy80mQKiFNXTckt/v11cFOMfSIbiBzLB11Jnudb
         B8RJv+zB6h9D00J2ip3kW0BXHrwcBR2AZwEGCN8V/M6Ykn50RGxGY7VnzCGI9V/HVUvQ
         jx3On1Q2XJcSAlWLn8hztKdpR6YAhaf3CVLrMW/XVKTKtwjZzITi4bvP772qBBpzZx9c
         shh83hfx5FC5LLDPIkFH3tgP+454zqY1ADQyLY6DtDDUCkf78ETnucEpo6ML0xOX/+mR
         AGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vOwihHQ2pOLmtOLhpuI7nDqfBhQgvZXDYpaP6pf/gEY=;
        b=tz1VjqeQ0fpy+nT7i0Yoao/dYkX0Tw2+IiGJQ0ZOhQX+oggooN3Upi/4L3zsvzb+/n
         squfZZXPXdyH8fkaIKVJwVhTKQbhxHdXxf2Q3MecaMJGpPbBZ3tHFyUhq62NKHnZFomf
         gp3OmXpngClpfpNeR1rlGukOOsFgto5EhSYLOtsIyitFCRs9bubpf0TyW56GTYiCXpSs
         cqkkBQc4gveDIx/XraFGP6ChAIQK5TPf5Ru6vRKMru435ywnQ9RZtjzhstj8le7/7bVB
         vt8Ob0K7OKKXvO2H4I6uRWQQolGGmco2StpeiS2vNBa5FyBhi93paU2neBOteh9UDqjN
         +zsA==
X-Gm-Message-State: AOAM533z87XKPLIyS+DgxqygZUeGuQaz+Mt2FaLOTjxwBMjGaut0PFRq
        szEQyWlXQHSYT2/SnrS6GENhToBJb8OhrA==
X-Google-Smtp-Source: ABdhPJxNjjvAiGsDlpaNtmpZr7eI15UUfwP4wex2WHdNU9DrJh99Yq+Uz4IKPjD/3L3VhmCgGyP5Ew==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr59529348edd.286.1638035304415;
        Sat, 27 Nov 2021 09:48:24 -0800 (PST)
Received: from ?IPV6:2001:981:6fec:1:2daf:a2ab:db7:6e31? ([2001:981:6fec:1:2daf:a2ab:db7:6e31])
        by smtp.gmail.com with ESMTPSA id gs15sm4378892ejc.42.2021.11.27.09.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 09:48:24 -0800 (PST)
Message-ID: <5cd6fc87-0f8d-0b9b-42be-8180540a94e7@gmail.com>
Date:   Sat, 27 Nov 2021 18:48:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] net: usb: Correct PHY handling of smsc95xx
Content-Language: en-US
To:     Martyn Welch <martyn.welch@collabora.com>, netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
References: <20211122184445.1159316-1-martyn.welch@collabora.com>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <20211122184445.1159316-1-martyn.welch@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Op 22-11-2021 om 19:44 schreef Martyn Welch:
> The smsc95xx driver is dropping phy speed settings and causing a stack
> trace at device unbind:
> 
> [  536.379147] smsc95xx 2-1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.2-1, smsc95xx USB 2.0 Ethernet
> [  536.425029] ------------[ cut here ]------------
> [  536.429650] WARNING: CPU: 0 PID: 439 at fs/kernfs/dir.c:1535 kernfs_remove_by_name_ns+0xb8/0xc0
> [  536.438416] kernfs: can not remove 'attached_dev', no directory
> [  536.444363] Modules linked in: xts dm_crypt dm_mod atmel_mxt_ts smsc95xx usbnet
> [  536.451748] CPU: 0 PID: 439 Comm: sh Tainted: G        W         5.15.0 #1
> [  536.458636] Hardware name: Freescale i.MX53 (Device Tree Support)
> [  536.464735] Backtrace:
> [  536.467190] [<80b1c904>] (dump_backtrace) from [<80b1cb48>] (show_stack+0x20/0x24)
> [  536.474787]  r7:000005ff r6:8035b294 r5:600f0013 r4:80d8af78
> [  536.480449] [<80b1cb28>] (show_stack) from [<80b1f764>] (dump_stack_lvl+0x48/0x54)
> [  536.488035] [<80b1f71c>] (dump_stack_lvl) from [<80b1f788>] (dump_stack+0x18/0x1c)
> [  536.495620]  r5:00000009 r4:80d9b820
> [  536.499198] [<80b1f770>] (dump_stack) from [<80124fac>] (__warn+0xfc/0x114)
> [  536.506187] [<80124eb0>] (__warn) from [<80b1d21c>] (warn_slowpath_fmt+0xa8/0xdc)
> [  536.513688]  r7:000005ff r6:80d9b820 r5:80d9b8e0 r4:83744000
> [  536.519349] [<80b1d178>] (warn_slowpath_fmt) from [<8035b294>] (kernfs_remove_by_name_ns+0xb8/0xc0)
> [  536.528416]  r9:00000001 r8:00000000 r7:824926dc r6:00000000 r5:80df6c2c r4:00000000
> [  536.536162] [<8035b1dc>] (kernfs_remove_by_name_ns) from [<80b1f56c>] (sysfs_remove_link+0x4c/0x50)
> [  536.545225]  r6:7f00f02c r5:80df6c2c r4:83306400
> [  536.549845] [<80b1f520>] (sysfs_remove_link) from [<806f9c8c>] (phy_detach+0xfc/0x11c)
> [  536.557780]  r5:82492000 r4:83306400
> [  536.561359] [<806f9b90>] (phy_detach) from [<806f9cf8>] (phy_disconnect+0x4c/0x58)
> [  536.568943]  r7:824926dc r6:7f00f02c r5:82492580 r4:83306400
> [  536.574604] [<806f9cac>] (phy_disconnect) from [<7f00a310>] (smsc95xx_disconnect_phy+0x30/0x38 [smsc95xx])
> [  536.584290]  r5:82492580 r4:82492580
> [  536.587868] [<7f00a2e0>] (smsc95xx_disconnect_phy [smsc95xx]) from [<7f001570>] (usbnet_stop+0x70/0x1a0 [usbnet])
> [  536.598161]  r5:82492580 r4:82492000
> [  536.601740] [<7f001500>] (usbnet_stop [usbnet]) from [<808baa70>] (__dev_close_many+0xb4/0x12c)
> [  536.610466]  r8:83744000 r7:00000000 r6:83744000 r5:83745b74 r4:82492000
> [  536.617170] [<808ba9bc>] (__dev_close_many) from [<808bab78>] (dev_close_many+0x90/0x120)
> [  536.625365]  r7:00000001 r6:83745b74 r5:83745b8c r4:82492000
> [  536.631026] [<808baae8>] (dev_close_many) from [<808bf408>] (unregister_netdevice_many+0x15c/0x704)
> [  536.640094]  r9:00000001 r8:81130b98 r7:83745b74 r6:83745bc4 r5:83745b8c r4:82492000
> [  536.647840] [<808bf2ac>] (unregister_netdevice_many) from [<808bfa50>] (unregister_netdevice_queue+0xa0/0xe8)
> [  536.657775]  r10:8112bcc0 r9:83306c00 r8:83306c80 r7:8291e420 r6:83744000 r5:00000000
> [  536.665608]  r4:82492000
> [  536.668143] [<808bf9b0>] (unregister_netdevice_queue) from [<808bfac0>] (unregister_netdev+0x28/0x30)
> [  536.677381]  r6:7f01003c r5:82492000 r4:82492000
> [  536.682000] [<808bfa98>] (unregister_netdev) from [<7f000b40>] (usbnet_disconnect+0x64/0xdc [usbnet])
> [  536.691241]  r5:82492000 r4:82492580
> [  536.694819] [<7f000adc>] (usbnet_disconnect [usbnet]) from [<8076b958>] (usb_unbind_interface+0x80/0x248)
> [  536.704406]  r5:7f01003c r4:83306c80
> [  536.707984] [<8076b8d8>] (usb_unbind_interface) from [<8061765c>] (device_release_driver_internal+0x1c4/0x1cc)
> [  536.718005]  r10:8112bcc0 r9:80dff1dc r8:83306c80 r7:83744000 r6:7f01003c r5:00000000
> [  536.725838]  r4:8291e420
> [  536.728373] [<80617498>] (device_release_driver_internal) from [<80617684>] (device_release_driver+0x20/0x24)
> [  536.738302]  r7:83744000 r6:810d4f4c r5:8291e420 r4:8176ae30
> [  536.743963] [<80617664>] (device_release_driver) from [<806156cc>] (bus_remove_device+0xf0/0x148)
> [  536.752858] [<806155dc>] (bus_remove_device) from [<80610018>] (device_del+0x198/0x41c)
> [  536.760880]  r7:83744000 r6:8116e2e4 r5:8291e464 r4:8291e420
> [  536.766542] [<8060fe80>] (device_del) from [<80768fe8>] (usb_disable_device+0xcc/0x1e0)
> [  536.774576]  r10:8112bcc0 r9:80dff1dc r8:00000001 r7:8112bc48 r6:8291e400 r5:00000001
> [  536.782410]  r4:83306c00
> [  536.784945] [<80768f1c>] (usb_disable_device) from [<80769c30>] (usb_set_configuration+0x514/0x8dc)
> [  536.794011]  r10:00000000 r9:00000000 r8:832c3600 r7:00000004 r6:810d5688 r5:00000000
> [  536.801844]  r4:83306c00
> [  536.804379] [<8076971c>] (usb_set_configuration) from [<80775fac>] (usb_generic_driver_disconnect+0x34/0x38)
> [  536.814236]  r10:832c3610 r9:83745ef8 r8:832c3600 r7:00000004 r6:810d5688 r5:83306c00
> [  536.822069]  r4:83306c00
> [  536.824605] [<80775f78>] (usb_generic_driver_disconnect) from [<8076b850>] (usb_unbind_device+0x30/0x70)
> [  536.834100]  r5:83306c00 r4:810d5688
> [  536.837678] [<8076b820>] (usb_unbind_device) from [<8061765c>] (device_release_driver_internal+0x1c4/0x1cc)
> [  536.847432]  r5:822fb480 r4:83306c80
> [  536.851009] [<80617498>] (device_release_driver_internal) from [<806176a8>] (device_driver_detach+0x20/0x24)
> [  536.860853]  r7:00000004 r6:810d4f4c r5:810d5688 r4:83306c80
> [  536.866515] [<80617688>] (device_driver_detach) from [<80614d98>] (unbind_store+0x70/0xe4)
> [  536.874793] [<80614d28>] (unbind_store) from [<80614118>] (drv_attr_store+0x30/0x3c)
> [  536.882554]  r7:00000000 r6:00000000 r5:83739200 r4:80614d28
> [  536.888217] [<806140e8>] (drv_attr_store) from [<8035cb68>] (sysfs_kf_write+0x48/0x54)
> [  536.896154]  r5:83739200 r4:806140e8
> [  536.899732] [<8035cb20>] (sysfs_kf_write) from [<8035be84>] (kernfs_fop_write_iter+0x11c/0x1d4)
> [  536.908446]  r5:83739200 r4:00000004
> [  536.912024] [<8035bd68>] (kernfs_fop_write_iter) from [<802b87fc>] (vfs_write+0x258/0x3e4)
> [  536.920317]  r10:00000000 r9:83745f58 r8:83744000 r7:00000000 r6:00000004 r5:00000000
> [  536.928151]  r4:82adacc0
> [  536.930687] [<802b85a4>] (vfs_write) from [<802b8b0c>] (ksys_write+0x74/0xf4)
> [  536.937842]  r10:00000004 r9:007767a0 r8:83744000 r7:00000000 r6:00000000 r5:82adacc0
> [  536.945676]  r4:82adacc0
> [  536.948213] [<802b8a98>] (ksys_write) from [<802b8ba4>] (sys_write+0x18/0x1c)
> [  536.955367]  r10:00000004 r9:83744000 r8:80100244 r7:00000004 r6:76f47b58 r5:76fc0350
> [  536.963200]  r4:00000004
> [  536.965735] [<802b8b8c>] (sys_write) from [<80100060>] (ret_fast_syscall+0x0/0x48)
> [  536.973320] Exception stack(0x83745fa8 to 0x83745ff0)
> [  536.978383] 5fa0:                   00000004 76fc0350 00000001 007767a0 00000004 00000000
> [  536.986569] 5fc0: 00000004 76fc0350 76f47b58 00000004 76f47c7c 76f48114 00000000 7e87991c
> [  536.994753] 5fe0: 00000498 7e879908 76e6dce8 76eca2e8
> [  536.999922] ---[ end trace 9b835d809816b435 ]---

I am testing this patch on Intel Edison-Arduino with Linux 5.15.1.
I had reported this issue earlier as
https://lore.kernel.org/linux-usb/07628a9b-1370-98b7-c1f3-98b9bf8cc38f@gmail.com/

This patch indeed resolves the above crash on each unplug.

> The driver should not be connecting and disconnecting the PHY when the
> device is opened and closed, it should be stopping and starting the PHY. The
> phy should be connected as part of binding and disconnected during
> unbinding.
> 
> As this results in the PHY not being reset during open, link speed, etc.
> settings set prior to the link coming up are now not being lost.
> 
> It is necessary for phy_stop() to only be called when the phydev still
> exists (resolving the above stack trace). When unbinding, ".unbind" will be
> called prior to ".stop", with phy_disconnect() already having called
> phy_stop() before the phydev becomes inaccessible.

The patch introduces a new error on each unplug:

usb 1-1: USB disconnect, device number 2
usb 1-1.1: USB disconnect, device number 3
smsc95xx 1-1.1:1.0 eth0: unregister 'smsc95xx' usb-xhci-hcd.1.auto-1.1, 
smsc95xx USB 2.0 Ethernet
smsc95xx 1-1.1:1.0 eth0: Link is Down
smsc95xx 1-1.1:1.0 eth0: Failed to read reg index 0x00000114: -19
smsc95xx 1-1.1:1.0 eth0: Error reading MII_ACCESS
smsc95xx 1-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
smsc95xx 1-1.1:1.0 eth0: Failed to read reg index 0x00000114: -19
smsc95xx 1-1.1:1.0 eth0: Error reading MII_ACCESS
smsc95xx 1-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup

Also as reported earlier, (only) on first plug the more worrying but 
possibly unrelated crash still happens:
------------[ cut here ]------------
DMA-API: xhci-hcd xhci-hcd.1.auto: cacheline tracking EEXIST, 
overlapping mappings aren't supported
WARNING: CPU: 0 PID: 23 at kernel/dma/debug.c:570 add_dma_entry+0x1d9/0x270
Modules linked in: rfcomm iptable_nat bnep usb_f_uac2 u_audio 
snd_sof_nocodec usb_f_mass_storage usb_f_eem u_ether spi_pxa2xx_platform 
dw_dmac usb_f_serial u_serial libcomposite intel_mrfld_pwrbtn 
snd_sof_pci_intel_tng pwm_lpss_pci intel_mrfld_adc pwm_lpss snd_sof_pci 
snd_sof_intel_ipc snd_sof_intel_atom dw_dmac_pci dw_dmac_core snd_sof 
snd_sof_xtensa_dsp snd_soc_acpi spi_pxa2xx_pci brcmfmac brcmutil 
hci_uart leds_gpio btbcm ti_ads7950 industrialio_triggered_buffer 
kfifo_buf tun ledtrig_timer ledtrig_heartbeat mmc_block 
extcon_intel_mrfld sdhci_pci cqhci sdhci led_class mmc_core 
intel_soc_pmic_mrfld btrfs libcrc32c xor zstd_compress zlib_deflate raid6_pq
CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 5.15.1-edison-acpi-standard #1
Hardware name: Intel Corporation Merrifield/BODEGA BAY, BIOS 542 
2015.01.21:18.19.48
Workqueue: usb_hub_wq hub_event
RIP: 0010:add_dma_entry+0x1d9/0x270
Code: ff 0f 84 97 00 00 00 4c 8b 67 50 4d 85 e4 75 03 4c 8b 27 e8 39 ff 
52 00 48 89 c6 4c 89 e2 48 c7 c7 f0 ab e7 a7 e8 c7 5c b5 00 <0f> 0b 48 
85 ed 0f 85 a4 b3 b5 00 8b 05 46 38 9f 01 85 c0 0f 85 df
RSP: 0000:ffffb047400cfac8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: ffff9e25fe217478
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9e25fe217470
RBP: ffff9e25c12ff780 R08: ffffffffa83359a8 R09: 0000000000009ffb
R10: 00000000ffffe000 R11: 3fffffffffffffff R12: ffff9e25c8a24040
R13: 0000000000000001 R14: 0000000000000206 R15: 00000000000f8be4
FS:  0000000000000000(0000) GS:ffff9e25fe200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f62c6d586d8 CR3: 0000000002f3c000 CR4: 00000000001006f0
Call Trace:
  dma_map_page_attrs+0xfb/0x250
  ? usb_hcd_link_urb_to_ep+0x14/0xa0
  usb_hcd_map_urb_for_dma+0x3b1/0x4e0
  usb_hcd_submit_urb+0x93/0xbb0
  ? create_prof_cpu_mask+0x20/0x20
  ? arch_stack_walk+0x73/0xf0
  ? usb_hcd_link_urb_to_ep+0x14/0xa0
  ? prepare_transfer+0xff/0x140
  usb_start_wait_urb+0x60/0x160
  usb_control_msg+0xda/0x140
  hub_ext_port_status+0x82/0x100
  hub_event+0x1b1/0x1830
  ? hub_activate+0x58c/0x860
  process_one_work+0x1d4/0x370
  worker_thread+0x48/0x3d0
  ? rescuer_thread+0x360/0x360
  kthread+0x122/0x140
  ? set_kthread_struct+0x40/0x40
  ret_from_fork+0x22/0x30
---[ end trace da6ffcd9fad23a74 ]---
DMA-API: Mapped at:
  debug_dma_map_page+0x60/0xf0
  dma_map_page_attrs+0xfb/0x250
  usb_hcd_map_urb_for_dma+0x3b1/0x4e0
  usb_hcd_submit_urb+0x93/0xbb0
  usb_start_wait_urb+0x60/0x160
usb 1-1.1: new high-speed USB device number 3 using xhci-hcd
usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00, 
bcdDevice= 2.00
usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1.1: Product: LAN9514
usb 1-1.1: Manufacturer: SMSC
usb 1-1.1: SerialNumber: 00951d0d



> Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
> Cc: Steve Glendinning <steve.glendinning@shawell.net>
> Cc: UNGLinuxDriver@microchip.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: stable@kernel.org # v5.15
> ---
>   drivers/net/usb/smsc95xx.c | 55 ++++++++++++++++++--------------------
>   1 file changed, 26 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 26b1bd8e845b..f91dabd65ecd 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1049,6 +1049,14 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
>   	.ndo_set_features	= smsc95xx_set_features,
>   };
>   
> +static void smsc95xx_handle_link_change(struct net_device *net)
> +{
> +	struct usbnet *dev = netdev_priv(net);
> +
> +	phy_print_status(net->phydev);
> +	usbnet_defer_kevent(dev, EVENT_LINK_CHANGE);
> +}
> +
>   static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
>   {
>   	struct smsc95xx_priv *pdata;
> @@ -1153,6 +1161,17 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
>   	dev->net->min_mtu = ETH_MIN_MTU;
>   	dev->net->max_mtu = ETH_DATA_LEN;
>   	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
> +
> +	ret = phy_connect_direct(dev->net, pdata->phydev,
> +				 &smsc95xx_handle_link_change,
> +				 PHY_INTERFACE_MODE_MII);
> +	if (ret) {
> +		netdev_err(dev->net, "can't attach PHY to %s\n", pdata->mdiobus->id);
> +		goto unregister_mdio;
> +	}
> +
> +	phy_attached_info(dev->net->phydev);
> +
>   	return 0;
>   
>   unregister_mdio:
> @@ -1170,47 +1189,25 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
>   {
>   	struct smsc95xx_priv *pdata = dev->driver_priv;
>   
> +	phy_disconnect(dev->net->phydev);
>   	mdiobus_unregister(pdata->mdiobus);
>   	mdiobus_free(pdata->mdiobus);
>   	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
>   	kfree(pdata);
>   }
>   
> -static void smsc95xx_handle_link_change(struct net_device *net)
> -{
> -	struct usbnet *dev = netdev_priv(net);
> -
> -	phy_print_status(net->phydev);
> -	usbnet_defer_kevent(dev, EVENT_LINK_CHANGE);
> -}
> -
>   static int smsc95xx_start_phy(struct usbnet *dev)
>   {
> -	struct smsc95xx_priv *pdata = dev->driver_priv;
> -	struct net_device *net = dev->net;
> -	int ret;
> +	phy_start(dev->net->phydev);
>   
> -	ret = smsc95xx_reset(dev);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = phy_connect_direct(net, pdata->phydev,
> -				 &smsc95xx_handle_link_change,
> -				 PHY_INTERFACE_MODE_MII);
> -	if (ret) {
> -		netdev_err(net, "can't attach PHY to %s\n", pdata->mdiobus->id);
> -		return ret;
> -	}
> -
> -	phy_attached_info(net->phydev);
> -	phy_start(net->phydev);
>   	return 0;
>   }
>   
> -static int smsc95xx_disconnect_phy(struct usbnet *dev)
> +static int smsc95xx_stop(struct usbnet *dev)
>   {
> -	phy_stop(dev->net->phydev);
> -	phy_disconnect(dev->net->phydev);
> +	if (dev->net->phydev)
> +		phy_stop(dev->net->phydev);
> +
>   	return 0;
>   }
>   
> @@ -1965,7 +1962,7 @@ static const struct driver_info smsc95xx_info = {
>   	.unbind		= smsc95xx_unbind,
>   	.link_reset	= smsc95xx_link_reset,
>   	.reset		= smsc95xx_start_phy,
> -	.stop		= smsc95xx_disconnect_phy,
> +	.stop		= smsc95xx_stop,
>   	.rx_fixup	= smsc95xx_rx_fixup,
>   	.tx_fixup	= smsc95xx_tx_fixup,
>   	.status		= smsc95xx_status,
> 

