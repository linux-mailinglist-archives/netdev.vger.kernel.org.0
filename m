Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25506280881
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 22:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbgJAUeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 16:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgJAUeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 16:34:22 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4513AC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 13:34:22 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 33so6680793edq.13
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 13:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WMgQAwwu3rju0MmZm2NvLb8D4yqxEqa7BM5mfh+/f5U=;
        b=dnlX2rlqqhM7Z55tWCyXtVaqq7RUtcijVD+OPICqQZbezGXDhIYsPh4xJVzNWr8RY8
         Zhk72Ga6yn5yyjdv3CWkGmsfdC1R8Mh6Ek0Wn4df7ZqO2JHufJN2WWM37+uI/57OfzbK
         pIwDmUjZP5YPTtNy+mnCsDZYjqPRNvfprBLScfNT9Yoh+3+9C6VqEaJMOfKKYqynARpp
         TxYffFLUpWqmSqlJEtD2vUj1gsCq6mcxKZuwhboV9YJRVuWuxwEXRN9xQpcW4DIwAQIK
         TETMi9N1mntsPl2G2XslL1MIAMM8VKIdHltn/P0olBT0YXrT3QGJiiCnVu43W1BX/CRA
         JLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WMgQAwwu3rju0MmZm2NvLb8D4yqxEqa7BM5mfh+/f5U=;
        b=KAHvoY+zI9DGWhfXHl1y7d3bVbibIkX7Us8eKZhL2C93aGqY2RNFt5hy6hdKgqq4Yl
         kka36p/Cfw8WXH2eSEWV3O+gbLHxAmjpR6YQl11E/lnz+dIP4GM3GnNuNWvJymx7HgLo
         xCHauuQ1TB9+M8SGiisLTE1lSmVZ0L6vT4Z9U9UfOO5MsMLweBimIytHPUOpM7hGLrge
         UNafiGwokYc7Lh7JVom56TdFZpYd7M1llJs6ZSrT2XdHY0iHXJVd/iwlYIaGc1VyzY4V
         OOmjfGj3pN4wORiCtSA8c7nVLglQUP4spEFNYTPGAoCY/UgWYcgFHZ5DrsVg6lXOB4yV
         h6cg==
X-Gm-Message-State: AOAM531fNcmXNb/YxeZ9UywOq0Wzmk4AeoU14nvSqniQtTPUBw8zEdR6
        PIYV2U1Q1w+bF6UzqQIv1SKx4BdS2bU=
X-Google-Smtp-Source: ABdhPJxfoDbIslDN21JyWSLSErAhgxr41t3wKQqg8Sm8V1MWUBprgqA15bVfbfqzssX62WDcMBX4rQ==
X-Received: by 2002:a05:6402:84f:: with SMTP id b15mr10224729edz.149.1601584460571;
        Thu, 01 Oct 2020 13:34:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:5ddd:648:7175:7d5c? (p200300ea8f006a005ddd064871757d5c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:5ddd:648:7175:7d5c])
        by smtp.googlemail.com with ESMTPSA id i7sm5352370ejo.22.2020.10.01.13.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 13:34:20 -0700 (PDT)
Subject: Fwd: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
To:     Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
X-Forwarded-Message-Id: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
Message-ID: <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
Date:   Thu, 1 Oct 2020 22:34:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a problem with the following code in ndo_start_xmit() of
the r8169 driver. A user reported the WARN being triggered due
to gso_size > 0 and gso_type = 0. The chip supports TSO(6).
The driver is widely used, therefore I'd expect much more such
reports if it should be a common problem. Not sure what's special.
My primary question: Is it a valid use case that gso_size is
greater than 0, and no SKB_GSO_ flag is set?
Any hint would be appreciated.



u32 mss = shinfo->gso_size;

	if (mss) {
		if (shinfo->gso_type & SKB_GSO_TCPV4) {
			opts[0] |= TD1_GTSENV4;
		} else if (shinfo->gso_type & SKB_GSO_TCPV6) {
			if (skb_cow_head(skb, 0))
				return false;

			tcp_v6_gso_csum_prep(skb);
			opts[0] |= TD1_GTSENV6;
		} else {
			WARN_ON_ONCE(1);
		}




-------- Forwarded Message --------
Subject: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
Date: Thu, 01 Oct 2020 19:19:24 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: hkallweit1@gmail.com

https://bugzilla.kernel.org/show_bug.cgi?id=209423

--- Comment #7 from Damian Wrobel (dwrobel@ertelnet.rybnik.pl) ---
Here it comes:

[86678.377120] ------------[ cut here ]------------
[86678.377155] gso_size = 1448, gso_type = 0x00000000
[86678.377381] WARNING: CPU: 0 PID: 0 at
drivers/net/ethernet/realtek/r8169_main.c:4095 rtl8169_start_xmit+0x489/0x800
[r8169]
[86678.377393] Modules linked in: tun nft_nat nft_masq nft_objref
nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject
nft_ct nft_chain_nat ip_set_hash_net ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
iptable_mangle iptable_raw iptable_security ip_set nf_tables nfnetlink
ip6table_filter ip6_tables iptable_filter sunrpc vfat fat snd_hda_codec_realtek
edac_mce_amd snd_hda_codec_generic snd_hda_codec_hdmi ledtrig_audio kvm_amd
snd_hda_intel snd_intel_dspcfg ccp snd_hda_codec kvm snd_hda_core snd_hwdep
snd_pcm hp_wmi snd_timer wmi_bmof sparse_keymap irqbypass snd sp5100_tco
i2c_piix4 soundcore k10temp fam15h_power rfkill_gpio rfkill acpi_cpufreq
ip_tables xfs amdgpu iommu_v2 gpu_sched i2c_algo_bit ttm drm_kms_helper cec drm
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ax88179_178a
usbnet serio_raw r8169 mii
[86678.377442]  wmi video
[86678.377486] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.8.12-201.fc32.x86_64
#1
[86678.377495] Hardware name: HP HP t630 Thin Client/8158, BIOS M40 v01.12
02/04/2020
[86678.377511] RIP: 0010:rtl8169_start_xmit+0x489/0x800 [r8169]
[86678.377521] Code: 10 0f 85 43 01 00 00 80 3d bb 20 01 00 00 0f 85 16 fe ff
ff 44 89 ee 48 c7 c7 b0 72 36 c0 c6 05 a4 20 01 00 01 e8 0d 33 d8 e1 <0f> 0b 44
8b 44 24 28 8b 74 24 2c 48 8b 8d c8 00 00 00 e9 e9 fd ff
[86678.377533] RSP: 0018:ffffa8f280003c80 EFLAGS: 00010282
[86678.377542] RAX: 0000000000000026 RBX: ffff8d331abc6000 RCX:
0000000000000000
[86678.377551] RDX: ffff8d331b427060 RSI: ffff8d331b418d00 RDI:
0000000000000300
[86678.377559] RBP: ffff8d32b5bb8200 R08: 00000000000003d0 R09:
000000000000000d
[86678.377576] R10: 0000000000000730 R11: ffffa8f280003b15 R12:
00000000000001c0
[86678.377596] R13: 00000000000005a8 R14: 0000000000000022 R15:
000000000000001c
[86678.377606] FS:  0000000000000000(0000) GS:ffff8d331b400000(0000)
knlGS:0000000000000000
[86678.377617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[86678.377624] CR2: 00007fa516f64520 CR3: 00000000b6de6000 CR4:
00000000001406f0
[86678.377632] Call Trace:
[86678.377641]  <IRQ>
[86678.377657]  dev_hard_start_xmit+0x8d/0x1d0
[86678.377676]  sch_direct_xmit+0xeb/0x2f0
[86678.377687]  __dev_queue_xmit+0x710/0x8a0
[86678.377713]  ? nf_confirm+0xcb/0xf0 [nf_conntrack]
[86678.377725]  ? nf_hook_slow+0x3f/0xb0
[86678.377735]  ip_finish_output2+0x2ad/0x560
[86678.377746]  __netif_receive_skb_core+0x4f0/0xf40
[86678.377758]  ? packet_rcv+0x44/0x490
[86678.377770]  __netif_receive_skb_one_core+0x2d/0x70
[86678.377779]  process_backlog+0x96/0x160
[86678.377789]  net_rx_action+0x13c/0x3e0
[86678.377804]  ? usbnet_bh+0x24/0x2b0 [usbnet]
[86678.377815]  __do_softirq+0xd9/0x2c4
[86678.377825]  asm_call_on_stack+0x12/0x20
[86678.377835]  </IRQ>
[86678.377845]  do_softirq_own_stack+0x39/0x50
[86678.377855]  irq_exit_rcu+0xc2/0x100
[86678.377865]  common_interrupt+0x75/0x140
[86678.377875]  asm_common_interrupt+0x1e/0x40
[86678.377885] RIP: 0010:cpuidle_enter_state+0xb6/0x3f0
[86678.377894] Code: e0 ab 6b 5d e8 ab c4 7b ff 49 89 c7 0f 1f 44 00 00 31 ff
e8 7c dd 7b ff 80 7c 24 0f 00 0f 85 d4 01 00 00 fb 66 0f 1f 44 00 00 <45> 85 e4
0f 88 e0 01 00 00 49 63 d4 4c 2b 7c 24 10 48 8d 04 52 48
[86678.377907] RSP: 0018:ffffffffa3a03e58 EFLAGS: 00000246
[86678.377915] RAX: ffff8d331b42a2c0 RBX: ffff8d3312f3e400 RCX:
000000000000001f
[86678.377923] RDX: 0000000000000000 RSI: 00000000401ec2e2 RDI:
0000000000000000
[86678.377931] RBP: ffffffffa3b78960 R08: 00004ed561df8e36 R09:
0000000000000006
[86678.377939] R10: 000000000000001d R11: 000000000000000e R12:
0000000000000002
[86678.377956] R13: ffff8d3312f3e400 R14: 0000000000000002 R15:
00004ed561df8e36
[86678.377970]  ? cpuidle_enter_state+0xa4/0x3f0
[86678.377980]  cpuidle_enter+0x29/0x40
[86678.377990]  do_idle+0x1d5/0x2a0
[86678.377999]  cpu_startup_entry+0x19/0x20
[86678.378009]  start_kernel+0x7f4/0x804
[86678.378022]  secondary_startup_64+0xb6/0xc0
[86678.378032] ---[ end trace 263bcddb7119c953 ]---

-- 
You are receiving this mail because:
You are on the CC list for the bug.
