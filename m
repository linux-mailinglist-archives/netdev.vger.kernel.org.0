Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882F55618A3
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbiF3K7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiF3K7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:59:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4030442EF9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g/UA+KoWQRIHckvuzJu2dr4eSNNVzUcPE7eO6PmO98o=; b=bd+iPWpyX7pvGD+5xphUYim0hC
        4WbWy6DPTXyQ+Pm1ZuQeXhvpuCURErUEFKWMis8SXWb2Snf/pLYVUkSepyQZJHslesmrORqTdx98q
        vjTtPOhQ+q4J54p7mHO8U17cFoCBG8lEPoIwHTGEl1Tx3pY9tr8OWa4Lx5MDxIvekcOAEaw9EkeMA
        VcITeGXrL29L2+l7u1Uc/R1Ukd3PMVdKzkdSMJWa9Yp9Dmxp1EMNMEWQOyx+SrCCCWvgrLbtK+63Q
        iH0d7Bx8IY/2XATJa5pPDTU2mrdsQt82Nrlr0Ht9Rp1rPsjwc1WTaPCzKWB4y7Oku0IlO/8/YC9WI
        MtHZh7aw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33112)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6rtg-0004JX-FF; Thu, 30 Jun 2022 11:59:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6rte-0006jE-AI; Thu, 30 Jun 2022 11:59:42 +0100
Date:   Thu, 30 Jun 2022 11:59:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: 'Re: [PATCH net-next 2/2] net: phylink: disable PCS polling over
 major configuration'
Message-ID: <Yr2CHnKbALCn85pY@shell.armlinux.org.uk>
References: <E1o5nAZ-004RRE-So@rmk-PC.armlinux.org.uk>
 <20220630090435.27086-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630090435.27086-1-arun.ramadoss@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 02:34:35PM +0530, Arun Ramadoss wrote:
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000004
> [00000004] *pgd=00000000
> Internal error: Oops: 5 [#1] ARM
> Modules linked in:
> CPU: 0 PID: 5 Comm: kworker/u2:0 Not tainted 5.19.0-rc3 #21
> Hardware name: Atmel SAMA5
> Workqueue: events_unbound deferred_probe_work_func
> PC is at phylink_major_config+0x120/0x2c0
> LR is at phylink_major_config+0xf4/0x2c0
> pc : [<c0537498>]    lr : [<c053746c>]    psr: 60000013
> sp : d0825be0  ip : c10294c0  fp : c098f0ec
> r10: c185e180  r9 : 00000000  r8 : 00000001
> r7 : 00000000  r6 : 00000000  r5 : d0825c08  r4 : c1848400
> r3 : 00000000  r2 : 82f62a40  r1 : 00000000  r0 : c1848400
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c53c7d  Table: 20004059  DAC: 00000051
> Register r0 information: slab kmalloc-256 start c1848400 pointer offset 0 size 256
> Register r1 information: NULL pointer
> Register r2 information: non-paged memory
> Register r3 information: NULL pointer
> Register r4 information: slab kmalloc-256 start c1848400 pointer offset 0 size 256
> Register r5 information: 2-page vmalloc region starting at 0xd0824000 allocated at kernel_clone+0xb8/0x368
> Register r6 information: NULL pointer
> Register r7 information: NULL pointer
> Register r8 information: non-paged memory
> Register r9 information: NULL pointer
> Register r10 information: slab kmalloc-64 start c185e180 pointer offset 0 size 64
> Register r11 information: non-slab/vmalloc memory
> Register r12 information: slab task_struct start c10294c0 pointer offset 0
> Process kworker/u2:0 (pid: 5, stack limit = 0x(ptrval))
> Stack: (0xd0825be0 to 0xd0826000)
> 5be0: c185e078 c0536198 0000e188 c0d0324c c1848400 d0825c08 c185e188 c185e078
> 5c00: c098ea8c c053860c 00006248 00000000 00000000 00000008 00000000 00000000
> 5c20: 00000007 00000064 00000001 00000000 00000006 82f62a40 c1848400 00000000
> 5c40: c1862700 c05386a8 c0a5dab8 00000000 c115a400 00000000 c1862700 c07d4230
> 5c60: c115a400 c07d4264 c115a400 00000000 c1862700 c07d1184 00000000 c1862700
> 5c80: c115a400 c07d29bc 00000000 d0825ccc c0d0324c c0d5a708 c0a6bfe4 c0a6af44
> 5ca0: c185e180 00000000 00000004 00000000 00000000 00000000 00000000 82f62a40
> 5cc0: 00000000 00000004 c0d5a6f8 cfdf5a78 00000000 00000400 00000dc0 c0956f78
> 5ce0: c1001240 c01cdf84 00000000 00000dc0 a0000013 00000004 20000013 d0825d20
> 5d00: c0d0324c c05edfa4 cfde9bb8 c05f1f64 cfde9bb8 82f62a40 00000007 c1848540
> 5d20: 00000000 c0d0324c c0a21544 cfde94fc 00000000 c0d58d8c c1a491c0 c054cbb8
> 5d40: 00000000 60000013 c0d0324c 00000000 00000004 82f62a40 c1006000 c0956f78
> 5d60: 00000000 c1373800 c0d0324c c1848540 c1848558 c0956f78 c1006000 c0552c14
> 5d80: c0a2a990 0000001b 00000001 00000000 00000000 00000005 00000020 00000000
> 5da0: 00000000 00000000 00000000 00000000 00000000 00000000 c0552b10 c0552b0c
> 5dc0: c1848558 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 5de0: 00000000 00ffffff 00000000 00000000 00000000 00000000 00000000 00000000
> 5e00: 00000000 00000000 00000000 00000000 00000000 00000060 00000040 00000000
> 5e20: 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000
> 5e40: 00000000 82f62a40 c1373800 00000000 c0d2e2b0 c1373800 00000001 c0d28434
> 5e60: c100700d c052ce70 c1373800 00000000 c0d2e2c0 c04b5744 c1373800 c0d2e2c0
> 5e80: c1373800 c04b59a0 c0d57d0c c0d57d10 c1373800 c04b5a34 c0d2e2c0 d0825eec
> 5ea0: c1373800 c0d0324c 00000001 c04b5d68 00000000 d0825eec c04b5ce0 c04b3b00
> 5ec0: c1373800 c10b3c5c c1387eb4 82f62a40 c0d28434 c0d0324c c1373800 c1373844
> 5ee0: c0d28410 c04b55d8 c0d0b580 c1373800 00000001 82f62a40 c1373800 c1373800
> 5f00: c0d2b504 c0d28410 00000000 c04b47bc c1373800 c0d28404 c0d28404 c04b4c78
> 5f20: c0d28430 c100e500 00000040 c1007000 00000000 c012bbf0 c0d18ca0 c1006000
> 5f40: c100e500 c1006000 c1006018 c0d18ca0 c100e518 00000088 c0d3f567 c012c060
> 5f60: 00000000 c0a229e8 c10294c0 c101f940 c012be18 c100e500 c101f700 d0815e98
> 5f80: c10294c0 00000000 00000000 c0132774 c101f940 c01326ac 00000000 00000000
> 5fa0: 00000000 00000000 00000000 c0100148 00000000 00000000 00000000 00000000
> 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
> phylink_major_config from phylink_mac_initial_config.constprop.19+0xa0/0xf4
> phylink_mac_initial_config.constprop.19 from phylink_start+0x48/0x28c
> phylink_start from dsa_port_enable_rt+0x50/0x68
> dsa_port_enable_rt from dsa_port_enable+0x1c/0x2c
> dsa_port_enable from dsa_port_setup+0xec/0x118
> dsa_port_setup from dsa_register_switch+0xa88/0xfa8
> dsa_register_switch from ksz_switch_register+0x580/0x5e8
> ksz_switch_register from ksz_spi_probe+0x100/0x150
> ksz_spi_probe from spi_probe+0x88/0xac
> spi_probe from really_probe+0xc0/0x298
> really_probe from __driver_probe_device+0x84/0xe4
> __driver_probe_device from driver_probe_device+0x34/0xd4
> driver_probe_device from __device_attach_driver+0x88/0xb4
> __device_attach_driver from bus_for_each_drv+0x58/0xb8
> bus_for_each_drv from __device_attach+0xf4/0x198
> __device_attach from bus_probe_device+0x84/0x8c
> bus_probe_device from deferred_probe_work_func+0x7c/0xa8
> deferred_probe_work_func from process_one_work+0x1d4/0x3fc
> process_one_work from worker_thread+0x248/0x504
> worker_thread from kthread+0xc8/0xe4
> kthread from ret_from_fork+0x14/0x2c
> Exception stack(0xd0825fb0 to 0xd0825ff8)
> 5fa0:                                     00000000 00000000 00000000 00000000
> 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> Code: e12fff33 e2503000 ba00001f e594300c (e5d33004)
>  ---[ end trace 0000000000000000 ]---
> 
> After this patch series, crash happens during ksz9477 booting. After reverting
> it ksz9477 booting works fine.

Fix already submitted by Vladimir. Thanks for reporting.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
