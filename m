Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B73E2E23B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfE2QZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:25:50 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57614 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfE2QZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8dFFB24idLsFTLuoMaTkxxtsWoRYf+l8XvVnqekUfwI=; b=zZx6s8sTjCN8EqYkpQMsI0MlF
        byEWFhvt2thqZjobQLGhFV/F5H7cDlOFuCpJnkPEI9AQnDtkUEGZdGt0TZRHU7/gt+CmRJiauy0Kd
        xpAqRqv12zivCXVnMcvB43Owp8xG8c58unC+Dkb63q9jw6nmz3Jme8VXHEI+LaNDx7j1qH/xydQpu
        2F+oMuMK32irQWp1fJ7RkinHUsHb0Dob/V81AM8NFruYYAY96q6fN/LkIMkXVhCnXNHb9hjPtwCUt
        +XNdqf7SlSWr1sFAuQlF3Wthjf14aEGMZwSvSCaLQ69G3j+wkkrwdm7THaUiO+GcpII6LRG8Jf9QZ
        4EuuTxw2g==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56058)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hW1OR-0005kn-Gr; Wed, 29 May 2019 17:25:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hW1OK-0004f3-3q; Wed, 29 May 2019 17:25:28 +0100
Date:   Wed, 29 May 2019 17:25:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lkp@01.org" <lkp@01.org>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [net] 9dd6d07682: kernel_BUG_at_drivers/net/phy/mdio_bus.c
Message-ID: <20190529162527.kuunt5gxif6wvhoo@shell.armlinux.org.uk>
References: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
 <20190529023557.GA22325@shao2-debian>
 <VI1PR0402MB2800068E2D6880BE1930DE53E01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800068E2D6880BE1930DE53E01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 04:11:57PM +0000, Ioana Ciornei wrote:
> > Subject: [net] 9dd6d07682: kernel_BUG_at_drivers/net/phy/mdio_bus.c
> > 
> > FYI, we noticed the following commit (built with gcc-6):
> > 
> > commit: 9dd6d07682b10a55d1f49d495b85f7b945ff75ca ("[PATCH 10/11] net:
> > dsa: Use PHYLINK for the CPU/DSA ports")
> > url:
> > 
> > 
> > in testcase: boot
> > 
> > on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m
> > 2G
> > 
> > caused below changes (please refer to attached dmesg/kmsg for entire
> > log/backtrace):
> > 
> > 
> > +------------------------------------------+------------+------------+
> > |                                          | 3a2573f868 | 9dd6d07682 |
> > +------------------------------------------+------------+------------+
> > | boot_successes                           | 4          | 0          |
> > | boot_failures                            | 0          | 6          |
> > | kernel_BUG_at_drivers/net/phy/mdio_bus.c | 0          | 6          |
> > | invalid_opcode:#[##]                     | 0          | 6          |
> > | EIP:mdiobus_free                         | 0          | 6          |
> > | Kernel_panic-not_syncing:Fatal_exception | 0          | 6          |
> > +------------------------------------------+------------+------------+
> > 
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > 
> > 
> > [   39.031781] kernel BUG at drivers/net/phy/mdio_bus.c:503!
> > [   39.049792] invalid opcode: 0000 [#1] PREEMPT
> > [   39.058345] CPU: 0 PID: 152 Comm: kworker/0:2 Tainted: G                T 5.2.0-
> > rc1-00321-g9dd6d07 #1
> > [   39.076106] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > 1.10.2-1 04/01/2014
> > [   39.091893] Workqueue: events deferred_probe_work_func
> > [   39.101903] EIP: mdiobus_free+0x21/0x39
> > [   39.109323] Code: 18 5f ed ff 5b 5e 5f 5d c3 55 89 e5 52 89 45 fc 8b 45 fc 8b
> > 90 9c 00 00 00 83 fa 01 75 07 e8 9b fa 99 ff eb 1b 83 fa 03 74 02 <0f> 0b c7 80 9c
> > 00 00 00 04 00 00 00 05 a0 00 00 00 e8 94 58 ed ff
> > [   39.144715] EAX: eff3e008 EBX: eff3a020 ECX: c23a9de9 EDX: 00000002
> > [   39.156773] ESI: f0403560 EDI: efffbe24 EBP: efffbdf8 ESP: efffbdf4
> > [   39.168825] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010297
> > [   39.182048] CR0: 80050033 CR2: 00000000 CR3: 02781000 CR4: 000006b0
> > [   39.194136] Call Trace:
> > [   39.198932]  _devm_mdiobus_free+0xd/0x10
> > [   39.206573]  release_nodes+0x194/0x1ad
> > [   39.213804]  devres_release_all+0x37/0x3d
> > [   39.221709]  really_probe+0x2b4/0x3a3
> > [   39.228808]  driver_probe_device+0x110/0x14b
> > [   39.237206]  __device_attach_driver+0x9d/0xa5
> > [   39.245622]  bus_for_each_drv+0x65/0x77
> > [   39.253081]  __device_attach+0x8f/0x104
> > [   39.260507]  ? driver_allows_async_probing+0x26/0x26
> > [   39.270161]  device_initial_probe+0x14/0x16
> > [   39.278223]  bus_probe_device+0x22/0x64
> > [   39.285645]  deferred_probe_work_func+0x7b/0xa1
> > [   39.294428]  process_one_work+0x1bc/0x2eb
> > [   39.302332]  ? process_one_work+0x164/0x2eb
> > [   39.310539]  process_scheduled_works+0x1e/0x24
> > [   39.319218]  worker_thread+0x1cb/0x268
> > [   39.326604]  kthread+0xeb/0xf0
> > [   39.332607]  ? process_scheduled_works+0x24/0x24
> > [   39.341641]  ? __kthread_create_on_node+0x128/0x128
> > [   39.350985]  ret_from_fork+0x1e/0x28
> > [   39.369743] ---[ end trace 2d9c21baf7b99d11 ]---
> > 
> 
> Hi,
> 
> Just to give more context onto what's the path that reaches the BUG_ON, here is the last part of the dmesg before the crash:
> 
> [   38.772573] dsa-loop fixed-0:1f: DSA mockup driver: 0x1f
> [   38.790366] libphy: dsa slave smi: probed
> [   38.799285] dsa-loop fixed-0:1f lan1 (uninitialized): PHY [dsa-0.0:00] driver [Generic PHY]
> [   38.815725] dsa-loop fixed-0:1f lan1 (uninitialized): phy: setting supported 00,00000000,000062c8 advertising 00,00000000,000062c8
> [   38.856337] dsa-loop fixed-0:1f lan2 (uninitialized): PHY [dsa-0.0:01] driver [Generic PHY]
> [   38.872670] dsa-loop fixed-0:1f lan2 (uninitialized): phy: setting supported 00,00000000,000062c8 advertising 00,00000000,000062c8
> [   38.903821] dsa-loop fixed-0:1f lan3 (uninitialized): PHY [dsa-0.0:02] driver [Generic PHY]
> [   38.920337] dsa-loop fixed-0:1f lan3 (uninitialized): phy: setting supported 00,00000000,000062c8 advertising 00,00000000,000062c8
> [   38.952873] dsa-loop fixed-0:1f lan4 (uninitialized): PHY [dsa-0.0:03] driver [Generic PHY]
> [   38.969462] dsa-loop fixed-0:1f lan4 (uninitialized): phy: setting supported 00,00000000,000062c8 advertising 00,00000000,000062c8
> [   39.002349] could not attach to PHY: -19
> [   39.010359] dsa-loop fixed-0:1f: failed to setup link for port 0.5
> 
> The dsa-loop mockup driver is trying to register a switch using information based on the dsa_chip_data structure rather than on DTS.
> This, of course, leads to PHYLINK being unable to successfully call phylink_of_phy_connect() on a NULL device_node.

Right, phylink_of_phy_connect() is not supposed to be called with a NULL
device node, but if it is, it fails gracefully.

> Rewinding the stack, we see that dsa_tree_setup() fails and that calling dsa_tree_remove_switch() should take care of removing/unregistering any resources previously allocated.
> This does not happen.
> 
> Of special interest here is unregistering the MDIO bus which was registered in dsa_switch_setup().
> The mdiobus_unregister() is never called because it is conditioned by dts->setup being true, which is set only after _all_ setup steps were performed successfully.
> This leads the code to the part where it tries to free an MDIO bus which was not unregistered properly, which is exactly this BUG_ON.
> 
> The immediate fix for this is to use PHYLINK on the CPU port only when the device_node associated is not NULL.
> As a separate patch from this series, I will also try to fix the initial bug.

Yep, it sounds like a short-coming of the error handling, which should
be the first priority to fix; avoiding PHYLINK on the CPU port when
the device_node is NULL seems to me like papering over a bug.

However, should mention that I have been carrying a patch for some time
for ZII boards to disable the error path for "no PHY" in
dsa_slave_phy_setup() - iow, when phylink_of_phy_connect() returns
-ENODEV and dsa_slave_phy_connect() also errors out.  That was the only
way I could get the SFF modules to work there.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
