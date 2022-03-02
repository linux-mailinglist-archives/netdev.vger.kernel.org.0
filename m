Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46154CB305
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 00:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiCBXp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 18:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiCBXp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 18:45:56 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F048947555
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 15:43:48 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t11so5184945wrm.5
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 15:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bpcrX9eJk9qwh1DxqEkWhWGA3D/Itd198n/MZdvWXz0=;
        b=RueQ6di2y5vZWsXKKhQ/EVflGZhhb71QXwEPHwgnlFOJ6cWlAOHqs12D0YHPAYa6Gr
         qVnbcNzmNtT6Vq4DIkC1H/Ckv+ouOa+DkgxQew671aW+ZQRuTdoSrhnRi5JycMcqxbmU
         gjM0Gal5gp3uXk1c5SxhiRDQ5WeQ2X5WAMLpHaTnliQHVqWupuvdEY98RdGO4U30wXTJ
         iVjZa0PFyfAYmEQjxFlk2aPPXYQJ4P/tmIfqEFwAGqQkHsuuZ1GYyQGDTj3GNJmYzemK
         2pAY3NbeGDSWTBWXv+kF6MqVJGCqmv31Qluu+TNnMsVaSsv0Rb4ipfQNHDHK8vMtRXz3
         m69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bpcrX9eJk9qwh1DxqEkWhWGA3D/Itd198n/MZdvWXz0=;
        b=VxKMm4oWEsU2FPTh7ImvTzp0YTVSdhWBWa+f1KMpFslHfzTDSUecrLqyRoz82b8DjM
         spDW6YTbSPesLP9yfP+JVuzDt+GYe8pvpe3IdG2U0eQXdLndblmttOnQcrwhOLIGvJ9y
         jHAR24G6o85pRTaJ2A3eNLg5otmoud/e46QhnKp66t1XdutTctlItFpX/CzACRFgu/4e
         oJ6kjzOD3688b5hfnD+PU4WSYsJdheJjiQxjjIo7UmJgyGqqwn2CYXi2UIRGKgKMN2sT
         F3QXZy1tKoL4Jh6aTINvqnKMKvrJsCt+KzuYssxRvcgs5nrIqFWnrKvCTKqUoEImRa3b
         McNA==
X-Gm-Message-State: AOAM5326FuD2IOydj3ljZK/jXNvlpgsbwZnKAiOR0D4iNtgyZPH+KV1i
        K18pw7qCVtV+I0y+WLYqoHo2CMyd+IF9vBVQmuohiESYeLQ=
X-Google-Smtp-Source: ABdhPJzyv0rVpT6eUav1O30UZ1jwYTRnCDPrWx4exPbTGqCeufl7UH1ZabU1Rce4bd06rxkDuIZivM/ECvL/Vn3gMrg=
X-Received: by 2002:a17:906:2646:b0:6d5:d889:c92b with SMTP id
 i6-20020a170906264600b006d5d889c92bmr25601965ejc.696.1646262903542; Wed, 02
 Mar 2022 15:15:03 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
 <Yh/r5hkui6MrV4W6@lunn.ch>
In-Reply-To: <Yh/r5hkui6MrV4W6@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 2 Mar 2022 20:14:52 -0300
Message-ID: <CAOMZO5D1X2Vy1aCoLsa=ga94y74Az2RrbwcZgUfmx=Eyi4LcWw@mail.gmail.com>
Subject: Re: smsc95xx warning after a 'reboot' command
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for your reply.

On Wed, Mar 2, 2022 at 7:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Mar 02, 2022 at 06:57:06PM -0300, Fabio Estevam wrote:
> > Hi,
> >
> > On a imx8mm iotgateway board from Compulab running 5.10 or 5.17-rc the
> > following warning is observed after a 'reboot' command:
>
> Just to make sure i'm interpreting this correctly, you are doing a
> reboot with the first 20 seconds of the machine starting?

Yes, just for the sake of capturing the log I issued a 'reboot'
command right after reaching
the Linux prompt.

The same problem happens if 'reboot' is issued at a much later point as well.

> So it looks like the PHY state machine has not been told to stop using
> the PHY. That suggests smsc95xx_disconnect_phy() has not been
> called. Could you confirm this by putting a printk() in there.

I added a printk (*********** smsc95xx_disconnect_phy())
and confirmed that smsc95xx_disconnect_phy() is being called.

Please see the log below, thanks.

[   22.140598] ci_hdrc ci_hdrc.1: remove, state 1
[   22.145077] usb usb2: USB disconnect, device number 1
[   22.146674] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   22.150146] usb 2-1: USB disconnect, device number 2
[   22.157275] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   22.162237] usb 2-1.1: USB disconnect, device number 3
[   22.167986] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   22.174690] smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx'
usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
[   22.179732] ------------[ cut here ]------------
[   22.193687] WARNING: CPU: 1 PID: 114 at drivers/net/phy/phy.c:958
phy_error+0x14/0x60
[   22.201514] Modules linked in:
[   22.204577] CPU: 1 PID: 114 Comm: kworker/u8:2 Not tainted
5.10.102-00042-ga4a140612082-dirty #29
[   22.213447] Hardware name: CompuLab i.MX8MM IoT Gateway (DT)
[   22.219112] Workqueue: events_power_efficient phy_state_machine
[   22.225036] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[   22.231043] pc : phy_error+0x14/0x60
[   22.234620] lr : phy_state_machine+0x88/0x218
[   22.238975] sp : ffff800011733d20
[   22.242289] x29: ffff800011733d20 x28: ffff800011217000
[   22.247608] x27: ffff000000008070 x26: ffff000000008020
[   22.252924] x25: 0000000000000000 x24: 00000000ffffffed
[   22.258240] x23: ffff00000edb8ce8 x22: ffff000002165580
[   22.263558] x21: ffff00000edb8800 x20: 0000000000000005
[   22.268875] x19: ffff00000edb8800 x18: 0000000000000010
[   22.274193] x17: 0000000000000000 x16: 0000000000000000
[   22.279509] x15: ffff0000021659f8 x14: 00000000000000dd
[   22.284825] x13: 0000000000000001 x12: 0000000000000000
[   22.290140] x11: 0000000000000000 x10: 00000000000009d0
[   22.295456] x9 : ffff8000117338a0 x8 : ffff000002165fb0
[   22.300772] x7 : ffff00007fb8d680 x6 : 000000000000000e
[   22.306088] x5 : 00000000410fd030 x4 : 0000000000000000
[   22.311406] x3 : ffff00000edb8ce8 x2 : 0000000000000000
[   22.316723] x1 : ffff000002165580 x0 : ffff00000edb8800
[   22.322039] Call trace:
[   22.324490]  phy_error+0x14/0x60
[   22.327722]  phy_state_machine+0x88/0x218
[   22.331736]  process_one_work+0x1bc/0x338
[   22.335747]  worker_thread+0x50/0x420
[   22.339411]  kthread+0x140/0x160
[   22.342642]  ret_from_fork+0x10/0x34
[   22.346219] ---[ end trace 25b1972853f1f1f8 ]---
[   22.350892] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   22.350975] *********** smsc95xx_disconnect_phy()
[   22.358039] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   22.358043] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   22.375057] ------------[ cut here ]------------
[   22.379681] called from state HALTED
[   22.383298] WARNING: CPU: 2 PID: 1 at drivers/net/phy/phy.c:1080
phy_stop+0xc4/0x198
[   22.391040] Modules linked in:
[   22.394100] CPU: 2 PID: 1 Comm: systemd-shutdow Tainted: G        W
        5.10.102-00042-ga4a140612082-dirty #29
[   22.404446] Hardware name: CompuLab i.MX8MM IoT Gateway (DT)
[   22.410108] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[   22.416116] pc : phy_stop+0xc4/0x198
[   22.419691] lr : phy_stop+0xc4/0x198
[   22.423263] sp : ffff8000113db4d0
[   22.426578] x29: ffff8000113db4d0 x28: ffff000000088000
[   22.431894] x27: ffff8000112fb8c0 x26: ffff00000f8c6000
[   22.437210] x25: ffff00000edb80a0 x24: ffff00000002db48
[   22.442528] x23: 0000000000000000 x22: ffff800010c965a0
[   22.447846] x21: ffff00000002d000 x20: ffff00000002d900
[   22.453164] x19: ffff00000edb8800 x18: 0000000000000010
[   22.458480] x17: 0000000000000000 x16: 0000000000000000
[   22.463796] x15: ffff000000088478 x14: 0000000000000191
[   22.469112] x13: ffff000000088478 x12: 00000000ffffffea
[   22.474428] x11: ffff8000112a2230 x10: ffff80001128a1f0
[   22.479744] x9 : ffff80001128a248 x8 : 0000000000017fe8
[   22.485062] x7 : c0000000ffffefff x6 : 0000000000000001
[   22.490379] x5 : 0000000000000000 x4 : 0000000000000000
[   22.495697] x3 : 00000000ffffffff x2 : ffff8000112321c0
[   22.501013] x1 : 0000000000000000 x0 : 0000000000000000
[   22.506329] Call trace:
[   22.508775]  phy_stop+0xc4/0x198
[   22.512008]  smsc95xx_disconnect_phy+0x2c/0x4c
[   22.516454]  usbnet_stop+0x90/0x1f0
[   22.519946]  __dev_close_many+0xac/0x138
[   22.523873]  dev_close_many+0x84/0x128
[   22.527624]  rollback_registered_many+0x118/0x618
[   22.532329]  unregister_netdevice_queue+0x94/0x118
[   22.537122]  unregister_netdev+0x24/0x38
[   22.541046]  usbnet_disconnect+0x38/0xd8
[   22.544971]  usb_unbind_interface+0x74/0x240
[   22.549243]  device_release_driver_internal+0x114/0x1f0
[   22.554470]  device_release_driver+0x18/0x28
[   22.558739]  bus_remove_device+0x128/0x138
[   22.562837]  device_del+0x16c/0x3d8
[   22.566327]  usb_disable_device+0x8c/0x158
[   22.570426]  usb_disconnect+0xb8/0x2b8
[   22.574177]  usb_disconnect+0xa0/0x2b8
[   22.577930]  usb_disconnect+0xa0/0x2b8
[   22.581679]  usb_remove_hcd+0xd8/0x2d0
[   22.585430]  host_stop+0x38/0xa0
[   22.588660]  ci_hdrc_host_destroy+0x20/0x30
[   22.592844]  ci_hdrc_remove+0x48/0x108
[   22.596596]  platform_drv_remove+0x2c/0x50
[   22.600694]  device_release_driver_internal+0x114/0x1f0
[   22.605919]  device_release_driver+0x18/0x28
[   22.610190]  bus_remove_device+0x128/0x138
[   22.614287]  device_del+0x16c/0x3d8
[   22.617777]  platform_device_del.part.0+0x1c/0x88
[   22.622485]  platform_device_unregister+0x24/0x40
[   22.627190]  ci_hdrc_remove_device+0x18/0x38
[   22.631463]  ci_hdrc_imx_remove+0x2c/0x118
[   22.635561]  ci_hdrc_imx_shutdown+0x10/0x20
[   22.639745]  platform_drv_shutdown+0x20/0x30
[   22.644016]  device_shutdown+0x158/0x360
[   22.647941]  kernel_restart_prepare+0x38/0x48
[   22.652298]  kernel_restart+0x18/0x68
[   22.655963]  __do_sys_reboot+0x228/0x250
[   22.659887]  __arm64_sys_reboot+0x24/0x30
[   22.663900]  el0_svc_common.constprop.0+0x78/0x1c8
[   22.668693]  do_el0_svc+0x24/0x90
[   22.672009]  el0_svc+0x14/0x20
[   22.675065]  el0_sync_handler+0xb0/0xb8
[   22.678903]  el0_sync+0x180/0x1c0
[   22.682217] ---[ end trace 25b1972853f1f1f9 ]---
[   22.686875] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   22.694021] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   22.699778] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   22.706327] smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
[   22.723702] usb 2-1.4: USB disconnect, device number 4
[   22.732781] ci_hdrc ci_hdrc.1: USB bus 2 deregistered
[   22.740648] ci_hdrc ci_hdrc.0: remove, state 4
[   22.745113] usb usb1: USB disconnect, device number 1
[   22.750721] ci_hdrc ci_hdrc.0: USB bus 1 deregistered
[   22.776831] imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
[   22.783514] reboot: Restarting system
