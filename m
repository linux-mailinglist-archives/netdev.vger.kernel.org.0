Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B8F6CC51E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjC1PMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjC1PMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:12:21 -0400
X-Greylist: delayed 620 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Mar 2023 08:11:52 PDT
Received: from er-systems.de (er-systems.de [IPv6:2a01:4f8:261:3c41::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE10FF27
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 08:11:52 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id 4F161ECDAE2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:01:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id 38127ECDAC4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:01:27 +0200 (CEST)
Date:   Tue, 28 Mar 2023 17:01:24 +0200 (CEST)
From:   Thomas Voegtle <tv@lio96.de>
To:     netdev@vger.kernel.org
Subject: Warning: "Use slab_build_skb() instead" wrt bnx2x
Message-ID: <b8f295e4-ba57-8bfb-7d9c-9d62a498a727@lio96.de>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.103.8/26857/Tue Mar 28 09:23:39 2023
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello,

this warning comes up when this BCM57840 NetXtreme II 10 Gigabit Ethernet 
card is put in to a bond with another card during booting with Linux 
6.3.0-rc4.
This also can be seen with Linux 6.2.8.

    Thomas


[   83.750521] ------------[ cut here ]------------
[   83.750523] Use slab_build_skb() instead
[   83.750534] WARNING: CPU: 2 PID: 0 at net/core/skbuff.c:376 
__build_skb_around+0xcc/0x100
[   83.750540] Modules linked in: af_packet nf_conntrack_netlink msr 
bridge 8021q garp mrp bonding tls stp llc xfrm_user xfrm_algo dummy 
ip6t_ipv6header ip6table_raw ipt_REJECT nf_reject_ipv4
xt_state xt_conntrack xt_TCPMSS xt_connmark xt_CT xt_NFLOG nfnetlink_log 
xt_addrtype xt_set xt_policy iptable_raw ip6table_mangle iptable_mangle 
ip6table_nat iptable_nat ip6table_filter ip6_tables
iptable_filter ip_tables bpfilter nf_nat_tftp nf_conntrack_tftp nf_nat_sip 
nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_irc nf_conntrack_irc 
nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 ip_set_hash_netiface ip_set_list_set 
ip_set_hash_net ip_set_hash_ip ip_set vhost_net tun vhost vhost_iotlb tap 
ipmi_devintf ipmi_msghandler ppdev parport_pc parport st
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic 
ledtrig_audio led_class i915 drm_buddy coretemp intel_rapl_msr 
drm_display_helper intel_rapl_common intel_tcc_cooling
x86_pkg_temp_thermal kvm_intel ttm cec drm_kms_helper snd_hda_intel
[   83.750593]  kvm snd_intel_dspcfg snd_hda_codec uas drm snd_hwdep 
ee1004 mei_hdcp mei_pxp wmi_bmof mxm_wmi snd_hda_core bnx2x snd_pcm igb 
snd_timer irqbypass crc32_pclmul crc32c_intel
polyval_clmulni snd polyval_generic gf128mul ghash_clmulni_intel 
sha512_ssse3 aesni_intel crypto_simd i2c_i801 cryptd pcspkr i2c_smbus 
soundcore intel_gtt mei_me hwmon agpgart ptp mei dca r8169
syscopyarea pps_core sg sysfillrect video sysimgblt realtek 
tiny_power_button acpi_pad wmi button configfs
[   83.750625] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.3.0-rc4 #1 
ed9f7d9e385b31369315248b96faa9df43a0c154
[   83.750628] Hardware name: bluechip Computer AG bluechip ServerLine 
individual/P10S WS, BIOS 3801 11/19/2019
[   83.750629] RIP: 0010:__build_skb_around+0xcc/0x100
[   83.750631] Code: 20 01 00 00 00 5b 5d 41 5c c3 cc cc cc cc 80 3d 8c 94 
2b 01 00 75 15 48 c7 c7 70 e6 9b ae c6 05 7c 94 2b 01 01 e8 f4 d2 4e ff 
<0f> 0b 48 89 df e8 ea 90 71 ff ba 20 08 00 00 48
89 df 89 c6 41 89
[   83.750633] RSP: 0018:ffffa81e80170db0 EFLAGS: 00010286
[   83.750635] RAX: 000000000000001c RBX: ffff93c80fd38000 RCX: 
0000000000000000
[   83.750636] RDX: ffffa81e80170c68 RSI: ffffa81e80170cb8 RDI: 
0000000000000001
[   83.750637] RBP: ffff93c808038a00 R08: 0000000000000000 R09: 
c0000000ffffdfff
[   83.750638] R10: 0000000000000001 R11: ffffa81e80170c60 R12: 
0000000000000000
[   83.750639] R13: ffff93c849e182f8 R14: ffff93c8082c0980 R15: 
ffff93c80fdc00c0
[   83.750640] FS:  0000000000000000(0000) GS:ffff93cd56d00000(0000) 
knlGS:0000000000000000
[   83.750642] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   83.750643] CR2: 0000563a63c73bd8 CR3: 0000000601c34005 CR4: 
00000000003706e0
[   83.750645] Call Trace:
[   83.750647]  <IRQ>
[   83.750649]  __build_skb+0x49/0x60
[   83.750652]  build_skb+0x11/0xb0
[   83.750655]  bnx2x_rx_int+0x6be/0x16b0 [bnx2x 
bb4aca8a40e7af80af92c2691d138057d98c8214]
[   83.750706]  ? enqueue_entity+0x11f/0x3a0
[   83.750710]  ? __x64_sys_sched_rr_get_interval+0xb/0x50
[   83.750713]  ? __pfx_wake_q_add+0x3/0x10
[   83.750716]  bnx2x_poll+0x1b8/0x260 [bnx2x 
bb4aca8a40e7af80af92c2691d138057d98c8214]
[   83.750759]  __napi_poll+0x28/0x1b0
[   83.750763]  net_rx_action+0x28f/0x2e0
[   83.750767]  __do_softirq+0xbd/0x2b0
[   83.750771]  irq_exit_rcu+0x77/0xa0
[   83.750775]  common_interrupt+0x82/0xa0
[   83.750778]  </IRQ>
[   83.750779]  <TASK>
[   83.750780]  asm_common_interrupt+0x22/0x40
[   83.750783] RIP: 0010:cpuidle_enter_state+0xc6/0x450
[   83.750785] Code: 00 00 e8 9d 28 31 ff e8 18 f8 ff ff 49 89 c4 0f 1f 44 
00 00 31 ff e8 b9 45 30 ff 45 84 ff 0f 85 49 02 00 00 fb 0f 1f 44 00 00 
<45> 85 f6 0f 88 75 01 00 00 49 63 d6 4c 2b 24 24
48 8d 04 52 48 8d
[   83.750787] RSP: 0018:ffffa81e800f7e98 EFLAGS: 00000246
[   83.750789] RAX: ffff93cd56d32e80 RBX: 0000000000000004 RCX: 
000000000000001f
[   83.750790] RDX: 000000137feb6d01 RSI: 000000002aaaab99 RDI: 
0000000000000000
[   83.750791] RBP: ffffc81e7fd00108 R08: 0000000000000002 R09: 
0000000000032640
[   83.750792] R10: 000000709eeb8408 R11: ffff93cd56d31a04 R12: 
000000137feb6d01
[   83.750793] R13: ffffffffaedd81a0 R14: 0000000000000004 R15: 
0000000000000000
[   83.750796]  ? cpuidle_enter_state+0xb7/0x450
[   83.750799]  cpuidle_enter+0x29/0x40
[   83.750803]  do_idle+0x1fb/0x220
[   83.750806]  cpu_startup_entry+0x19/0x20
[   83.750808]  start_secondary+0xed/0xf0
[   83.750811]  secondary_startup_64_no_verify+0xe5/0xeb
[   83.750816]  </TASK>
[   83.750817] ---[ end trace 0000000000000000 ]---



