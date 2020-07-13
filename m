Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2CB21D4BA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgGMLUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMLUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:20:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB74C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 04:20:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id f12so16549257eja.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 04:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vLiuSDKXHAwqBoMJK0geUozKlrncjKGaXSwa67Xkd4s=;
        b=Fyu+cyqba4acg1h7+g9KoIm63A2VVorlpl76DmfdNxpSykyrpHc01PJyrmNKaUOzid
         XS5ZAzaLjp3rkGi5rxybgaHho9ijbd9nm/hzb/aHc3g7pHZcsW+Lriz54TMhtg7nJUpk
         X5flp16mHu9olz/P2yGO0sHCTYDAU6mW0YHea/T0UB6QFPhMKrx9dyWGoXTlKY1Mf9pO
         eySj/UeseDQoWH4tjzZo3P+c8FaVFglcOCgLw7gXfXCUap4/7YLkJd3uBSuqCxHJvORD
         pD7617kVvtxv8V7L7tDVHLwa576G7twX7D5NA+na9z6iRhhLQwpBxf/N4kMwAxy+2Jlw
         WKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vLiuSDKXHAwqBoMJK0geUozKlrncjKGaXSwa67Xkd4s=;
        b=daqd1lQQPQu+7Uift/vLIQam85aG9dn4VsoDXPAQxu0oKGmjbz0r8yuKhcm/0kmLTq
         rt1PpFXBg04idoY5M1lmxb7aglQPJK+LWEXAerFC2sgswsOKrx2Z12MJcrzmnE/q9uNw
         i2VfJZB19VWEpeto/CzA9B9M+/LA8QVZWLfjgEXWdeIrW5P+g/PZtGZNtypMBl2KLV5h
         ylEwbv8d22hskw8DMUuGvhRjRLyGAOJgHoXrd2WjvIRkv7Uxp6a5coS/7kDqRseW/71g
         aqXWD1Fy1h3t5A9bn1/cd2pNCaDVg+4ZX3/FJwjBt3b979f5P8lcWrasx2igIspUZVkB
         NB6Q==
X-Gm-Message-State: AOAM5314wyam048dr6OrCGmT2wk4QkKEHknHvZb1niWOruGyrXsKQ7sc
        Szk+Vth88zUYW+FSWDCG7pg=
X-Google-Smtp-Source: ABdhPJxz/RAI2XkAXJEzcKD6l08ineUlUq4PukEwZCHo9WVcfzWkRtUi6cTRUMjpS3ap3LBMBvd6pQ==
X-Received: by 2002:a17:906:375a:: with SMTP id e26mr75615235ejc.324.1594639242890;
        Mon, 13 Jul 2020 04:20:42 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id o18sm9451971ejr.45.2020.07.13.04.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 04:20:42 -0700 (PDT)
Date:   Mon, 13 Jul 2020 14:20:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: 88E6176 dsa switch on ls1021a (GIANFAR)
Message-ID: <20200713112040.zn4fmuuttwqier5j@skbuf>
References: <5a1a2fac-7d16-afed-173b-54483a3faa6d@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a1a2fac-7d16-afed-173b-54483a3faa6d@inbox.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim!

On Mon, Jul 13, 2020 at 12:54:58PM +0300, Maxim Kochetkov wrote:
> I connected 88E6176 switch to ls1021a based board.
> DSA works fine.
> But I found a problem.
> 1) Set IP on lan0 (switch port 0).
> 2) Create bridge br0.
> 3) Add lan3 (switch port3) to br0.
> 4) Set lan3 up.
> 5) Set IP on br0.
> ------------------------------------------------------------------------
> [ 1530.972078] mv88e6085 mdio@2d24000:0c lan3: configuring for phy/ link mode
> [ 1531.022737] mv88e6085 mdio@2d24000:0c lan3: Link is Up - 100Mbps/Full - flow control off
> [ 3648.512947] mv88e6085 mdio@2d24000:0c lan3: Link is Down
> [ 3686.413791] br0: port 1(lan3) entered blocking state
> [ 3686.413809] br0: port 1(lan3) entered disabled state
> [ 3686.414836] device lan3 entered promiscuous mode
> [ 3716.124830] device eth0 entered promiscuous mode
> [ 3716.124987] mv88e6085 mdio@2d24000:0c lan3: configuring for phy/ link  mode
> [ 3718.888113] mv88e6085 mdio@2d24000:0c lan3: Link is Up - 100Mbps/Full - flow control off
> [ 3718.888168] br0: port 1(lan3) entered blocking state
> [ 3718.888178] br0: port 1(lan3) entered forwarding state
> [ 3725.587161] BUG: scheduling while atomic: mdio@2d24000:0c/257/0x00000100
> [ 3725.587170] Modules linked in: sctp libcrc32c tag_edsa marvell mv88e6xxx
> dsa_core phylink bridge stp ntc_thermistor llc dwc3 roles ucc_tdm(C)
> ina2xx_adc ina2xx mux_gpio iio_mux mux_core iio_rescale spidev spi_fsl_dspi
> lm75 lm90 gpio_pca953x iio_hwmon ti_ads1015 industrialio_triggered_buffer
> kfifo_buf industrialio at24 i2c_dev
> [ 3725.587244] CPU: 0 PID: 257 Comm: mdio@2d24000:0c Tainted: G C 5.7.0.3 #1
> [ 3725.587247] Hardware name: Freescale LS1021A
> [ 3725.587252] Backtrace:
> [ 3725.587275] [] (dump_backtrace) from [] (show_stack+0x18/0x1c)
> [ 3725.587285]  r7:c0a40cc0 r6:60080113 r5:00000000 r4:c0c11c90
> [ 3725.587297] [] (show_stack) from [] (dump_stack+0xbc/0xd8)
> [ 3725.587310] [] (dump_stack) from [] (__schedule_bug+0x60/0x80)
> [ 3725.587319]  r7:c0a40cc0 r6:00000000 r5:ef5cdcc0 r4:00000000
> [ 3725.587334] [] (__schedule_bug) from [] (__schedule+0x5c/0x34c)
> [ 3725.587340]  r5:ef5cdcc0 r4:eaf7af40
> [ 3725.587350] [] (__schedule) from [] (schedule+0x9c/0xe0)
> [ 3725.587361]  r10:e9495a24 r9:bf109b6c r8:00000002 r7:eae4e04c r6:00000000 r5:e9494000
> [ 3725.587365]  r4:eaf7af40
> [ 3725.587377] [] (schedule) from [] (schedule_preempt_disabled+0x10/0x14)
> [ 3725.587383]  r5:e9494000 r4:eae4e04c
> [ 3725.587395] [] (schedule_preempt_disabled) from [] (__mutex_lock.constprop.0+0xb0/0x2c8)
> [ 3725.587407] [] (__mutex_lock.constprop.0) from [] (__mutex_lock_slowpath+0x14/0x18)
> [ 3725.587418]  r10:e9495a24 r9:bf109b6c r8:eae4e040 r7:eae4e04c r6:00000000 r5:e968b860
> [ 3725.587423]  r4:eae4e04c
> [ 3725.587434] [] (__mutex_lock_slowpath) from [] (mutex_lock+0x54/0x78)
> [ 3725.587515] [] (mutex_lock) from [] (mv88e6xxx_port_fdb_add+0x2c/0x60 [mv88e6xxx])
> [ 3725.587520]  r4:00000003
> [ 3725.587588] [] (mv88e6xxx_port_fdb_add [mv88e6xxx]) from [] (dsa_switch_event+0x298/0x630 [dsa_core])
> [ 3725.587598]  r8:00000000 r7:00000000 r6:e94e4040 r5:bf114ef8 r4:e94959d4
> [ 3725.587623] [] (dsa_switch_event [dsa_core]) from [] (notifier_call_chain+0x48/0x6c)
> [ 3725.587632]  r8:00000000 r7:00000000 r6:e94959d4 r5:00000003 r4:ffffffff
> [ 3725.587642] [] (notifier_call_chain) from [] (raw_notifier_call_chain+0x20/0x28)
> [ 3725.587652]  r9:00000000 r8:e968b860 r7:eafc7a00 r6:ea976500 r5:eae47500 r4:bf107720
> [ 3725.587676] [] (raw_notifier_call_chain) from [] (dsa_port_notify+0x1c/0x30 [dsa_core])
> [ 3725.587713] [] (dsa_port_notify [dsa_core]) from [] (dsa_port_fdb_add+0x48/0x6c [dsa_core])
> [ 3725.587750] [] (dsa_port_fdb_add [dsa_core]) from [] (dsa_legacy_fdb_add+0x20/0x24 [dsa_core])
> [ 3725.587871] [] (dsa_legacy_fdb_add [dsa_core]) from [] (br_fdb_update+0x190/0x200 [bridge])

This call path is interesting. How does br_fdb_update() end up calling
dsa_legacy_fdb_add(), which is only accessible through .ndo_fdb_add? The
only call path I see in the mainline kernel for .ndo_fdb_add() is from
rtnl_fdb_add(), which seems to not be called here.

If necessary, I do have a patch which makes dsa_legacy_fdb_add and
dsa_legacy_fdb_del atomic-friendly, however I would like to understand
why this happens first.

> [ 3725.587984] [] (br_fdb_update [bridge]) from [] (br_handle_frame_finish+0xb4/0x314 [bridge])
> [ 3725.587996]  r10:c0c05a5c r9:00000001 r8:0000005a r7:eafc7a00 r6:00000000 r5:eae47500
> [ 3725.588000]  r4:e9177300
> [ 3725.588111] [] (br_handle_frame_finish [bridge]) from [] (br_handle_frame+0x148/0x1c4 [bridge])
> [ 3725.588122]  r9:e968b800 r8:0000005a r7:e968b85a r6:e9495aec r5:eafc7a00 r4:e9177300
> [ 3725.588184] [] (br_handle_frame [bridge]) from [] (__netif_receive_skb_core+0x2c0/0x4fc)
> [ 3725.588195]  r9:c0a41598 r8:00000000 r7:bf0e4f20 r6:00000000 r5:eae45000 r4:00000001
> [ 3725.588206] [] (__netif_receive_skb_core) from [] (__netif_receive_skb_one_core+0x3c/0x80)
> [ 3725.588217]  r10:eaa3c608 r9:eaa3c000 r8:eadb5c00 r7:bf10c098 r6:e9495c04 r5:eae45000
> [ 3725.588221]  r4:e9177300
> [ 3725.588230] [] (__netif_receive_skb_one_core) from [] (__netif_receive_skb+0x60/0x68)
> [ 3725.588236]  r5:eae45000 r4:e9177300
> [ 3725.588246] [] (__netif_receive_skb) from [] (netif_receive_skb+0x64/0xc0)
> [ 3725.588251]  r5:eae45000 r4:e9177300
> [ 3725.588277] [] (netif_receive_skb) from [] (dsa_switch_rcv+0x150/0x154 [dsa_core])
> [ 3725.588282]  r4:e9177300
> [ 3725.588308] [] (dsa_switch_rcv [dsa_core]) from [] (__netif_receive_skb_list_ptype+0x64/0x70)
> [ 3725.588319]  r9:eaa3c000 r8:bf10436c r7:eaa3c000 r6:e9495c04 r5:bf10c098 r4:e9495c04
> [ 3725.588331] [] (__netif_receive_skb_list_ptype) from [] (__netif_receive_skb_list_core+0x64/0x104)
> [ 3725.588341]  r9:eaa3c000 r8:00000000 r7:eaa3c608 r6:bf10c098 r5:eaa3c000 r4:e9495c04
> [ 3725.588352] [] (__netif_receive_skb_list_core) from [] (netif_receive_skb_list_internal+0x108/0x234)
> [ 3725.588363]  r10:ef5ce580 r9:eaa3c588 r8:e9177300 r7:ffffe000 r6:00000000 r5:00000000
> [ 3725.588367]  r4:eaa3c608
> [ 3725.588377] [] (netif_receive_skb_list_internal) from [] (gro_normal_list+0x28/0x3c)
> [ 3725.588386]  r8:e9495d04 r7:00000040 r6:f086e000 r5:eaa3c608 r4:eaa3c588
> [ 3725.588396] [] (gro_normal_list) from [] (napi_complete_done+0x78/0xe4)
> [ 3725.588401]  r5:00000000 r4:eaa3c588
> [ 3725.588415] [] (napi_complete_done) from [] (gfar_poll_rx_sq+0x4c/0x94)
> [ 3725.588422]  r6:f086e000 r5:00000001 r4:eaa3c588
> [ 3725.588432] [] (gfar_poll_rx_sq) from [] (net_rx_action+0x10c/0x2c0)
> [ 3725.588441]  r7:e9495cfc r6:c0538ca0 r5:2eb8d000 r4:c0a41580
> [ 3725.588451] [] (net_rx_action) from [] (__do_softirq+0x198/0x1fc)
> [ 3725.588462]  r10:c0c03080 r9:00000100 r8:c0c03080 r7:e9495d40 r6:00000008 r5:c0c0308c
> [ 3725.588466]  r4:e9494000
> [ 3725.588478] [] (__do_softirq) from [] (irq_exit+0x6c/0xcc)
> [ 3725.588489]  r10:eafe7edc r9:e9494000 r8:bf11b814 r7:00000001 r6:ea810000 r5:00000000
> [ 3725.588493]  r4:00000000
> [ 3725.588506] [] (irq_exit) from [] (__handle_domain_irq+0x7c/0xa8)
> [ 3725.588511]  r5:00000000 r4:00000000
> [ 3725.588524] [] (__handle_domain_irq) from [] (gic_handle_irq+0x54/0x80)
> [ 3725.588532]  r7:f0803000 r6:c0c0503c r5:f0802000 r4:e9495df8
> [ 3725.588542] [] (gic_handle_irq) from [] (__irq_svc+0x58/0x74)
> [ 3725.588548] Exception stack(0xe9495df8 to 0xe9495e40)
> [ 3725.588554] 5de0:   ea84c000 0000000c
> [ 3725.588564] 5e00: 01000000 0000039a 010c0000 f08a4520 0000000c 00000001 bf11b814 c0233fec
> [ 3725.588574] 5e20: eafe7edc e9495e64 e9495e48 e9495e48 c0535570 c0535580 20080013 ffffffff
> [ 3725.588583]  r7:e9495e2c r6:ffffffff r5:20080013 r4:c0535580
> [ 3725.588595] [] (fsl_pq_mdio_read) from [] (__mdiobus_read+0x38/0x5c)
> [ 3725.588603]  r7:00000001 r6:00000001 r5:ea84c000 r4:0000000c
> [ 3725.588613] [] (__mdiobus_read) from [] (mdiobus_read+0x5c/0x74)
> [ 3725.588621]  r7:00000001 r6:0000000c r5:ea84c558 r4:ea84c000
> [ 3725.588666] [] (mdiobus_read) from [] (mv88e6xxx_smi_direct_read+0x18/0x28 [mv88e6xxx])
> [ 3725.588675]  r7:0000001b r6:e9495f18 r5:00000000 r4:e9495f18
> [ 3725.588745] [] (mv88e6xxx_smi_direct_read [mv88e6xxx]) from [] (mv88e6xxx_smi_indirect_read+0x78/0x7c [mv88e6xxx])
> [ 3725.588751]  r5:00000000 r4:eae4e040
> [ 3725.588819] [] (mv88e6xxx_smi_indirect_read [mv88e6xxx]) from [] (mv88e6xxx_read+0x4c/0x58 [mv88e6xxx])
> [ 3725.588827]  r7:e9495f18 r6:00000000 r5:0000001b r4:eae4e040
> [ 3725.588896] [] (mv88e6xxx_read [mv88e6xxx]) from [] (mv88e6xxx_g1_read+0x20/0x24 [mv88e6xxx])
> [ 3725.588907]  r9:c0233fec r8:eafecd00 r7:eae4e04c r6:eae4e040 r5:00000000 r4:00000000
> [ 3725.588976] [] (mv88e6xxx_g1_read [mv88e6xxx]) from [] (mv88e6xxx_g1_irq_thread_work+0x98/0x128 [mv88e6xxx])
> [ 3725.589045] [] (mv88e6xxx_g1_irq_thread_work [mv88e6xxx]) from [] (mv88e6xxx_irq_poll+0x18/0x2c [mv88e6xxx])
> [ 3725.589054]  r7:ffffe000 r6:e9494000 r5:eafecd00 r4:eae4e374
> [ 3725.589097] [] (mv88e6xxx_irq_poll [mv88e6xxx]) from [] (kthread_worker_fn+0x12c/0x198)
> [ 3725.589103]  r5:eafecd00 r4:c0c478e0
> [ 3725.589114] [] (kthread_worker_fn) from [] (kthread+0xec/0xf8)
> [ 3725.589122]  r7:e9595b4c r6:ffffe000 r5:eafecd40 r4:eafe7ec0
> [ 3725.589132] [] (kthread) from [] (ret_from_fork+0x14/0x3c)
> [ 3725.589137] Exception stack(0xe9495fb0 to 0xe9495ff8)
> [ 3725.589144] 5fa0:                                     00000000 00000000 00000000 00000000
> [ 3725.589153] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [ 3725.589161] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [ 3725.589171]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c02339b0
> [ 3725.589176]  r4:eafecd40 r3:00000001
> --------------------------------------------------------------------------------
> mv88e6xxx_port_fdb_add is trying to lock busy mutex, but it is called from
> napi_complete_done, which is called from gfar_poll_rx_sq which is software
> irq context and cannot sleep on mutex_lock.

Thanks,
-Vladimir
