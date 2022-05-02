Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B901751782F
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350516AbiEBUgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiEBUgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:36:39 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8BDB1E2;
        Mon,  2 May 2022 13:33:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b24so17863689edu.10;
        Mon, 02 May 2022 13:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Wh7RFLAlxXTGynBVcJhXTtdINHjpn6RYvr2KI/GMVUY=;
        b=eRKnFR2ca4mxzi0hy8vMLUf89tGPy5CMuxWeIVUcP0gncA/QrdtwsBaZM3XAm+DIYc
         VC5niphMLXAFwe6GJHS49Iyf61CPIuFayA3a/Jx9euE6VNj4G2UkX9Oujik3XHMrJgy3
         kG1a1PKS7KxF6YY+xtXvbkn6TxBXaDI2aRf9/4QxltgrbcPWly6TmyqDNT9g9yTu+py8
         QMtBHz3twpRZeX8pQS4QMcVfA7FEYWOFTY2q/GiQKaS2vQQPMgrNDU+PAAI9b18QTQeo
         fKlL+R+1Osjrtyf9gurnVR0FJhWT7//dHX/4TR2XnQEoXGDviV+kyD9XDTuemAYpsXKH
         0rhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Wh7RFLAlxXTGynBVcJhXTtdINHjpn6RYvr2KI/GMVUY=;
        b=Y0zJyFWg/azqBgIgaRcct+q5rT/LnmRP26XdvhtmP28vkgfsuZY7ixGIwM1aer1qNy
         FFk+8ashWYgsHyaoHAHY3b62/Pd8shBDDWPtnxeaftN4hqcw3N5CAHTAyjrFzbwipak9
         BFGsh8/Yk+3h2HLanPbfMzRq220eba+VeRLozPNOWsb44OZ0jtlR5g2yD30X1VG9LoYz
         Oc99m6R0Y57u6CgkPJF1r8gmbtzmhgYDxi5/P9lUxfiH2+o+wmCyYl4Kn8sH5DSoEFrG
         xSuQ62GNkOR8Y3eL5Fp2yDK/ydPEL3WvyA7B9SZmhDttYz7z0L8GBDICRd4lOX9IB5WN
         s6wA==
X-Gm-Message-State: AOAM533SAmR2BqV+1l4f5xEijfBCnyeHKsvoyGakR5Svr/2veMgjrCjE
        NCr/dQBNNr1l9fPzIq1/P+4=
X-Google-Smtp-Source: ABdhPJzE+24samQpCpujcRhbsw/DBwZzZ+rYxPc+cVaLlcBmfq4YMXEJ/BR7id/kWBXMZqsBqqqnLw==
X-Received: by 2002:a05:6402:d4c:b0:410:a415:fd95 with SMTP id ec12-20020a0564020d4c00b00410a415fd95mr14774431edb.288.1651523587757;
        Mon, 02 May 2022 13:33:07 -0700 (PDT)
Received: from ?IPV6:2a02:a466:68ed:1:fdc8:e41f:9a1d:6f82? (2a02-a466-68ed-1-fdc8-e41f-9a1d-6f82.fixed6.kpn.net. [2a02:a466:68ed:1:fdc8:e41f:9a1d:6f82])
        by smtp.gmail.com with ESMTPSA id cy19-20020a0564021c9300b0042617ba6386sm6936551edb.16.2022.05.02.13.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 13:33:07 -0700 (PDT)
Message-ID: <a9fcc952-a55f-1eae-c584-d58644bae00d@gmail.com>
Date:   Mon, 2 May 2022 22:33:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 0/7] Polling be gone on LAN95xx
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
References: <cover.1651037513.git.lukas@wunner.de>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <cover.1651037513.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,
Op 27-04-2022 om 07:48 schreef Lukas Wunner:
> Do away with link status polling on LAN95XX USB Ethernet
> and rely on interrupts instead, thereby reducing bus traffic,
> CPU overhead and improving interface bringup latency.
> 
> The meat of the series is in patch [5/7].  The preceding and
> following patches are various cleanups to prepare for and
> adjust to interrupt-driven link state detection.
> 
> Please review and test.  Thanks!
> 
> Lukas Wunner (7):
>    usbnet: Run unregister_netdev() before unbind() again
>    usbnet: smsc95xx: Don't clear read-only PHY interrupt
>    usbnet: smsc95xx: Don't reset PHY behind PHY driver's back
>    usbnet: smsc95xx: Avoid link settings race on interrupt reception
>    usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid
>      polling
>    net: phy: smsc: Cache interrupt mask
>    net: phy: smsc: Cope with hot-removal in interrupt handler
> 
>   drivers/net/phy/smsc.c         |  28 +++---
>   drivers/net/usb/asix_devices.c |   6 +-
>   drivers/net/usb/smsc95xx.c     | 155 ++++++++++++++++-----------------
>   drivers/net/usb/usbnet.c       |   6 +-
>   4 files changed, 91 insertions(+), 104 deletions(-)
> 

Tested-by: Ferry Toth <fntoth@gmail.com> (Intel Edison-Arduino)

(linux v5.17 + the series + usbnet: smsc95xx: Fix deadlock on runtime 
resume)

While testing I noted another problem. I have "DMA-API: debugging 
enabled by kernel config" and this (I guess) shows me before and after 
the patches:

------------[ cut here ]------------
DMA-API: xhci-hcd xhci-hcd.1.auto: cacheline tracking EEXIST, 
overlapping mappings aren't supported
WARNING: CPU: 0 PID: 24 at kernel/dma/debug.c:570 add_dma_entry+0x1d9/0x270
Modules linked in: mmc_block extcon_intel_mrfld sdhci_pci cqhci sdhci 
led_class mmc_core intel_soc_pmic_mrfld btrfs libcrc32c xor zlib_deflate 
raid6_pq zstd_c>
CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 5.17.0-edison-acpi-standard #1
Hardware name: Intel Corporation Merrifield/BODEGA BAY, BIOS 542 
2015.01.21:18.19.48
Workqueue: usb_hub_wq hub_event
RIP: 0010:add_dma_entry+0x1d9/0x270
Code: ff 0f 84 97 00 00 00 4c 8b 67 50 4d 85 e4 75 03 4c 8b 27 e8 29 a4 
52 00 48 89 c6 4c 89 e2 48 c7 c7 78 9d 7e 98 e8 b3 f7 b6 00 <0f> 0b 48 
85 ed 0f 85 d3 >
RSP: 0018:ffffb2ce000d7ad0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000000000000
RDX: 0000000000000001 RSI: 00000000ffffffea RDI: 00000000ffffffff
RBP: ffff9dea81239a00 R08: ffffffff98b356c8 R09: 00000000ffffdfff
R10: ffffffff98a556e0 R11: ffffffff98a556e0 R12: ffff9dea87397180
R13: 0000000000000001 R14: 0000000000000206 R15: 0000000000046c59
FS:  0000000000000000(0000) GS:ffff9deabe200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005595807522e0 CR3: 0000000006be2000 CR4: 00000000001006f0
Call Trace:
  <TASK>
  dma_map_page_attrs+0xfc/0x240
  ? usb_hcd_link_urb_to_ep+0x6e/0xa0
  ? preempt_count_add+0x63/0x90
  usb_hcd_map_urb_for_dma+0x3f3/0x580
  usb_hcd_submit_urb+0x93/0xb90
  ? _raw_spin_lock+0xe/0x30
  ? _raw_spin_unlock+0xd/0x20
  ? usb_hcd_link_urb_to_ep+0x6e/0xa0
  ? prepare_transfer+0xff/0x140
  usb_start_wait_urb+0x60/0x160
  usb_control_msg+0xdc/0x140
  hub_ext_port_status+0x82/0x100
  hub_event+0x1b2/0x1880
  ? hub_activate+0x59c/0x880
  process_one_work+0x1d3/0x3a0
  worker_thread+0x48/0x3c0
  ? rescuer_thread+0x380/0x380
  kthread+0xe2/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>
---[ end trace 0000000000000000 ]---
DMA-API: Mapped at:
  debug_dma_map_page+0x60/0xf0
  dma_map_page_attrs+0xfc/0x240
  usb_hcd_map_urb_for_dma+0x3f3/0x580
  usb_hcd_submit_urb+0x93/0xb90
  usb_start_wait_urb+0x60/0x160
usb 1-1.1: new high-speed USB device number 3 using xhci-hcd
usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00, 
bcdDevice= 2.00
usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1.1: Product: LAN9514
usb 1-1.1: Manufacturer: SMSC
usb 1-1.1: SerialNumber: 00951d0d

Any ideas on this?
