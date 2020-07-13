Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1618C21D33B
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgGMJy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:54:57 -0400
Received: from smtp45.i.mail.ru ([94.100.177.105]:38316 "EHLO smtp45.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgGMJy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 05:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To; bh=Tz2Qp/k2yRLW1PddCeZm683FHMKBRrIZ0QGM7LM4HSU=;
        b=ABpJa4pawqjd4XoNQSZ2xJZiL67SzLyJkLLaImWn6XqFuEyoShr+k6Gp1etz0/LqJtO1ZNzo5v53KI7QApXx1W51CuV4LqEtrzxZ0SaNwx0j23bUtepnlVQgHokhGrs2HdrRNdI6iAaFGaV9j8xsq+gx+OR5hBx03778bDXAvMA=;
Received: by smtp45.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1juvAg-0000AF-Qm; Mon, 13 Jul 2020 12:54:51 +0300
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
From:   Maxim Kochetkov <fido_max@inbox.ru>
Subject: 88E6176 dsa switch on ls1021a (GIANFAR)
Message-ID: <5a1a2fac-7d16-afed-173b-54483a3faa6d@inbox.ru>
Date:   Mon, 13 Jul 2020 12:54:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp45.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9BB76C036EA8E79ACD8892A7C49526C615EDCB82F0F92FEA4182A05F53808504010F3AE380B44568FB43C45C2B72F52C434831B0BE96377A3370D9A5FF93AB5CC
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE708661B9CC72D936EEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637D59CDB32E2D1ED2AEA1F7E6F0F101C674E70A05D1297E1BBC6CDE5D1141D2B1CDC3A8225D7281D0CDD1D31D0289DC6EB857490055563565F9FA2833FD35BB23D9E625A9149C048EE33AC447995A7AD18CB629EEF1311BF91D2E47CDBA5A96583BD4B6F7A4D31EC0BB23A54CFFDBC96A8389733CBF5DBD5E9D5E8D9A59859A8B6957A4DEDD2346B42CC7F00164DA146DA6F5DAA56C3B73B23E7DDDDC251EA7DABD81D268191BDAD3DC09775C1D3CA48CFCB56C4F5857C67B9BA3038C0950A5D36C8A9BA7A39EFB76633AA9177FDEE801FBA3038C0950A5D36D5E8D9A59859A8B6091938966D39094376E601842F6C81A1F004C90652538430FAAB00FBE355B82D93EC92FD9297F6718AA50765F79006377AA2284B41911753A7F4EDE966BC389F395957E7521B51C24C7702A67D5C33162DBA43225CD8A89F83C798A30B85E16B57739F23D657EF2BB5C8C57E37DE458B4C7702A67D5C3316FA3894348FB808DBA1CE242F1348D5363B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 86AC083BACC31EE7DF04ADE4C76764E09D69B0687DD6549BDC40724EB7B885FA8861F0797B99BC7D9F595CEF8576C34B
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj7M7hD4t88wl+Obham0QTAg==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB24D910E2FDD919D1FD6FD5F3F218613788348EC3D22628D65AEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I connected 88E6176 switch to ls1021a based board.
DSA works fine.
But I found a problem.
1) Set IP on lan0 (switch port 0).
2) Create bridge br0.
3) Add lan3 (switch port3) to br0.
4) Set lan3 up.
5) Set IP on br0.
------------------------------------------------------------------------
[ 1530.972078] mv88e6085 mdio@2d24000:0c lan3: configuring for phy/ link 
mode
[ 1531.022737] mv88e6085 mdio@2d24000:0c lan3: Link is Up - 100Mbps/Full 
- flow control off
[ 3648.512947] mv88e6085 mdio@2d24000:0c lan3: Link is Down
[ 3686.413791] br0: port 1(lan3) entered blocking state
[ 3686.413809] br0: port 1(lan3) entered disabled state
[ 3686.414836] device lan3 entered promiscuous mode
[ 3716.124830] device eth0 entered promiscuous mode
[ 3716.124987] mv88e6085 mdio@2d24000:0c lan3: configuring for phy/ link 
mode
[ 3718.888113] mv88e6085 mdio@2d24000:0c lan3: Link is Up - 100Mbps/Full 
- flow control off
[ 3718.888168] br0: port 1(lan3) entered blocking state
[ 3718.888178] br0: port 1(lan3) entered forwarding state
[ 3725.587161] BUG: scheduling while atomic: mdio@2d24000:0c/257/0x00000100
[ 3725.587170] Modules linked in: sctp libcrc32c tag_edsa marvell 
mv88e6xxx dsa_core phylink bridge stp ntc_thermistor llc dwc3 roles 
ucc_tdm(C) ina2xx_adc ina2xx mux_gpio iio_mux mux_core iio_rescale 
spidev spi_fsl_dspi lm75 lm90 gpio_pca953x iio_hwmon ti_ads1015 
industrialio_triggered_buffer kfifo_buf industrialio at24 i2c_dev
[ 3725.587244] CPU: 0 PID: 257 Comm: mdio@2d24000:0c Tainted: G 
C        5.7.0.3 #1
[ 3725.587247] Hardware name: Freescale LS1021A
[ 3725.587252] Backtrace:
[ 3725.587275] [] (dump_backtrace) from [] (show_stack+0x18/0x1c)
[ 3725.587285]  r7:c0a40cc0 r6:60080113 r5:00000000 r4:c0c11c90
[ 3725.587297] [] (show_stack) from [] (dump_stack+0xbc/0xd8)
[ 3725.587310] [] (dump_stack) from [] (__schedule_bug+0x60/0x80)
[ 3725.587319]  r7:c0a40cc0 r6:00000000 r5:ef5cdcc0 r4:00000000
[ 3725.587334] [] (__schedule_bug) from [] (__schedule+0x5c/0x34c)
[ 3725.587340]  r5:ef5cdcc0 r4:eaf7af40
[ 3725.587350] [] (__schedule) from [] (schedule+0x9c/0xe0)
[ 3725.587361]  r10:e9495a24 r9:bf109b6c r8:00000002 r7:eae4e04c 
r6:00000000 r5:e9494000
[ 3725.587365]  r4:eaf7af40
[ 3725.587377] [] (schedule) from [] (schedule_preempt_disabled+0x10/0x14)
[ 3725.587383]  r5:e9494000 r4:eae4e04c
[ 3725.587395] [] (schedule_preempt_disabled) from [] 
(__mutex_lock.constprop.0+0xb0/0x2c8)
[ 3725.587407] [] (__mutex_lock.constprop.0) from [] 
(__mutex_lock_slowpath+0x14/0x18)
[ 3725.587418]  r10:e9495a24 r9:bf109b6c r8:eae4e040 r7:eae4e04c 
r6:00000000 r5:e968b860
[ 3725.587423]  r4:eae4e04c
[ 3725.587434] [] (__mutex_lock_slowpath) from [] (mutex_lock+0x54/0x78)
[ 3725.587515] [] (mutex_lock) from [] (mv88e6xxx_port_fdb_add+0x2c/0x60 
[mv88e6xxx])
[ 3725.587520]  r4:00000003
[ 3725.587588] [] (mv88e6xxx_port_fdb_add [mv88e6xxx]) from [] 
(dsa_switch_event+0x298/0x630 [dsa_core])
[ 3725.587598]  r8:00000000 r7:00000000 r6:e94e4040 r5:bf114ef8 r4:e94959d4
[ 3725.587623] [] (dsa_switch_event [dsa_core]) from [] 
(notifier_call_chain+0x48/0x6c)
[ 3725.587632]  r8:00000000 r7:00000000 r6:e94959d4 r5:00000003 r4:ffffffff
[ 3725.587642] [] (notifier_call_chain) from [] 
(raw_notifier_call_chain+0x20/0x28)
[ 3725.587652]  r9:00000000 r8:e968b860 r7:eafc7a00 r6:ea976500 
r5:eae47500 r4:bf107720
[ 3725.587676] [] (raw_notifier_call_chain) from [] 
(dsa_port_notify+0x1c/0x30 [dsa_core])
[ 3725.587713] [] (dsa_port_notify [dsa_core]) from [] 
(dsa_port_fdb_add+0x48/0x6c [dsa_core])
[ 3725.587750] [] (dsa_port_fdb_add [dsa_core]) from [] 
(dsa_legacy_fdb_add+0x20/0x24 [dsa_core])
[ 3725.587871] [] (dsa_legacy_fdb_add [dsa_core]) from [] 
(br_fdb_update+0x190/0x200 [bridge])
[ 3725.587984] [] (br_fdb_update [bridge]) from [] 
(br_handle_frame_finish+0xb4/0x314 [bridge])
[ 3725.587996]  r10:c0c05a5c r9:00000001 r8:0000005a r7:eafc7a00 
r6:00000000 r5:eae47500
[ 3725.588000]  r4:e9177300
[ 3725.588111] [] (br_handle_frame_finish [bridge]) from [] 
(br_handle_frame+0x148/0x1c4 [bridge])
[ 3725.588122]  r9:e968b800 r8:0000005a r7:e968b85a r6:e9495aec 
r5:eafc7a00 r4:e9177300
[ 3725.588184] [] (br_handle_frame [bridge]) from [] 
(__netif_receive_skb_core+0x2c0/0x4fc)
[ 3725.588195]  r9:c0a41598 r8:00000000 r7:bf0e4f20 r6:00000000 
r5:eae45000 r4:00000001
[ 3725.588206] [] (__netif_receive_skb_core) from [] 
(__netif_receive_skb_one_core+0x3c/0x80)
[ 3725.588217]  r10:eaa3c608 r9:eaa3c000 r8:eadb5c00 r7:bf10c098 
r6:e9495c04 r5:eae45000
[ 3725.588221]  r4:e9177300
[ 3725.588230] [] (__netif_receive_skb_one_core) from [] 
(__netif_receive_skb+0x60/0x68)
[ 3725.588236]  r5:eae45000 r4:e9177300
[ 3725.588246] [] (__netif_receive_skb) from [] 
(netif_receive_skb+0x64/0xc0)
[ 3725.588251]  r5:eae45000 r4:e9177300
[ 3725.588277] [] (netif_receive_skb) from [] 
(dsa_switch_rcv+0x150/0x154 [dsa_core])
[ 3725.588282]  r4:e9177300
[ 3725.588308] [] (dsa_switch_rcv [dsa_core]) from [] 
(__netif_receive_skb_list_ptype+0x64/0x70)
[ 3725.588319]  r9:eaa3c000 r8:bf10436c r7:eaa3c000 r6:e9495c04 
r5:bf10c098 r4:e9495c04
[ 3725.588331] [] (__netif_receive_skb_list_ptype) from [] 
(__netif_receive_skb_list_core+0x64/0x104)
[ 3725.588341]  r9:eaa3c000 r8:00000000 r7:eaa3c608 r6:bf10c098 
r5:eaa3c000 r4:e9495c04
[ 3725.588352] [] (__netif_receive_skb_list_core) from [] 
(netif_receive_skb_list_internal+0x108/0x234)
[ 3725.588363]  r10:ef5ce580 r9:eaa3c588 r8:e9177300 r7:ffffe000 
r6:00000000 r5:00000000
[ 3725.588367]  r4:eaa3c608
[ 3725.588377] [] (netif_receive_skb_list_internal) from [] 
(gro_normal_list+0x28/0x3c)
[ 3725.588386]  r8:e9495d04 r7:00000040 r6:f086e000 r5:eaa3c608 r4:eaa3c588
[ 3725.588396] [] (gro_normal_list) from [] (napi_complete_done+0x78/0xe4)
[ 3725.588401]  r5:00000000 r4:eaa3c588
[ 3725.588415] [] (napi_complete_done) from [] (gfar_poll_rx_sq+0x4c/0x94)
[ 3725.588422]  r6:f086e000 r5:00000001 r4:eaa3c588
[ 3725.588432] [] (gfar_poll_rx_sq) from [] (net_rx_action+0x10c/0x2c0)
[ 3725.588441]  r7:e9495cfc r6:c0538ca0 r5:2eb8d000 r4:c0a41580
[ 3725.588451] [] (net_rx_action) from [] (__do_softirq+0x198/0x1fc)
[ 3725.588462]  r10:c0c03080 r9:00000100 r8:c0c03080 r7:e9495d40 
r6:00000008 r5:c0c0308c
[ 3725.588466]  r4:e9494000
[ 3725.588478] [] (__do_softirq) from [] (irq_exit+0x6c/0xcc)
[ 3725.588489]  r10:eafe7edc r9:e9494000 r8:bf11b814 r7:00000001 
r6:ea810000 r5:00000000
[ 3725.588493]  r4:00000000
[ 3725.588506] [] (irq_exit) from [] (__handle_domain_irq+0x7c/0xa8)
[ 3725.588511]  r5:00000000 r4:00000000
[ 3725.588524] [] (__handle_domain_irq) from [] (gic_handle_irq+0x54/0x80)
[ 3725.588532]  r7:f0803000 r6:c0c0503c r5:f0802000 r4:e9495df8
[ 3725.588542] [] (gic_handle_irq) from [] (__irq_svc+0x58/0x74)
[ 3725.588548] Exception stack(0xe9495df8 to 0xe9495e40)
[ 3725.588554] 5de0: 
   ea84c000 0000000c
[ 3725.588564] 5e00: 01000000 0000039a 010c0000 f08a4520 0000000c 
00000001 bf11b814 c0233fec
[ 3725.588574] 5e20: eafe7edc e9495e64 e9495e48 e9495e48 c0535570 
c0535580 20080013 ffffffff
[ 3725.588583]  r7:e9495e2c r6:ffffffff r5:20080013 r4:c0535580
[ 3725.588595] [] (fsl_pq_mdio_read) from [] (__mdiobus_read+0x38/0x5c)
[ 3725.588603]  r7:00000001 r6:00000001 r5:ea84c000 r4:0000000c
[ 3725.588613] [] (__mdiobus_read) from [] (mdiobus_read+0x5c/0x74)
[ 3725.588621]  r7:00000001 r6:0000000c r5:ea84c558 r4:ea84c000
[ 3725.588666] [] (mdiobus_read) from [] 
(mv88e6xxx_smi_direct_read+0x18/0x28 [mv88e6xxx])
[ 3725.588675]  r7:0000001b r6:e9495f18 r5:00000000 r4:e9495f18
[ 3725.588745] [] (mv88e6xxx_smi_direct_read [mv88e6xxx]) from [] 
(mv88e6xxx_smi_indirect_read+0x78/0x7c [mv88e6xxx])
[ 3725.588751]  r5:00000000 r4:eae4e040
[ 3725.588819] [] (mv88e6xxx_smi_indirect_read [mv88e6xxx]) from [] 
(mv88e6xxx_read+0x4c/0x58 [mv88e6xxx])
[ 3725.588827]  r7:e9495f18 r6:00000000 r5:0000001b r4:eae4e040
[ 3725.588896] [] (mv88e6xxx_read [mv88e6xxx]) from [] 
(mv88e6xxx_g1_read+0x20/0x24 [mv88e6xxx])
[ 3725.588907]  r9:c0233fec r8:eafecd00 r7:eae4e04c r6:eae4e040 
r5:00000000 r4:00000000
[ 3725.588976] [] (mv88e6xxx_g1_read [mv88e6xxx]) from [] 
(mv88e6xxx_g1_irq_thread_work+0x98/0x128 [mv88e6xxx])
[ 3725.589045] [] (mv88e6xxx_g1_irq_thread_work [mv88e6xxx]) from [] 
(mv88e6xxx_irq_poll+0x18/0x2c [mv88e6xxx])
[ 3725.589054]  r7:ffffe000 r6:e9494000 r5:eafecd00 r4:eae4e374
[ 3725.589097] [] (mv88e6xxx_irq_poll [mv88e6xxx]) from [] 
(kthread_worker_fn+0x12c/0x198)
[ 3725.589103]  r5:eafecd00 r4:c0c478e0
[ 3725.589114] [] (kthread_worker_fn) from [] (kthread+0xec/0xf8)
[ 3725.589122]  r7:e9595b4c r6:ffffe000 r5:eafecd40 r4:eafe7ec0
[ 3725.589132] [] (kthread) from [] (ret_from_fork+0x14/0x3c)
[ 3725.589137] Exception stack(0xe9495fb0 to 0xe9495ff8)
[ 3725.589144] 5fa0:                                     00000000 
00000000 00000000 00000000
[ 3725.589153] 5fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 3725.589161] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[ 3725.589171]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 
r6:00000000 r5:c02339b0
[ 3725.589176]  r4:eafecd40 r3:00000001
--------------------------------------------------------------------------------
mv88e6xxx_port_fdb_add is trying to lock busy mutex, but it is called 
from napi_complete_done, which is called from gfar_poll_rx_sq which is 
software irq context and cannot sleep on mutex_lock.
