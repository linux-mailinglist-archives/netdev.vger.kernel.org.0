Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E505316665B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgBTScq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:32:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37311 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgBTScq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:32:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so5773028wru.4
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 10:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9GN2bsKOXBFKbvN5ew/4J3QGSow/O2NrTXhmsG611JU=;
        b=U+Gg6gZgY/T08wbQLgGbnQm2LAC/Y0/n7VEU8cIcdjWS60fkHQMYO8GToSy/KMpzC8
         QvE04zGR9z4I7jEdfEf8fv0pL6lxEB2Hjs0pShvg5NFs+DZ6B1Rwv3DYmwiWduJj85mw
         JS35FIFFzAFyTuq3yUxgbk/g2JoihiwEE+KHWHtIhkGwrpgjqmKePo0BAJ5vEaUzADce
         lun3s3sUkKC4tlt2KXIw2noCo4SzQxOetb43uWrvaXJaebfRf9u3Nsslpb+Fwg9nE/C1
         jytJw3/gEcyzPTFvb67gZq02CYLkxMoiWL+SMytpSDsArjKtFoGErIKwJczNmEY64ohC
         CMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9GN2bsKOXBFKbvN5ew/4J3QGSow/O2NrTXhmsG611JU=;
        b=VT5JCQ5wV2JARtCs35hqVoRuJZjK5l2iBdpDOpkyl/ecqoQiM09l9rDTNzyG18sroc
         khWATVcsJs1UmEKHXjtU2jxPFZ8O9hM5RlxH3HU0v2topomO11OMuTiS2dz0DrieAtQz
         aFrFLaOlEcoUsR7RYAvlU+GQCpK713NCWMem2Qb6gAmDtmgyFsKuy1EKseWcWdMKWBGf
         w/pqfbjGgYZjrmWC8hz8NRbncUPj0lUikw8iH2Xbxlizz2hTuODc6PilJ28Mwr0b+RHw
         5ZjgMR3VCvU+HdfR5Uo6/EVUGCG7v6qxqeh4rg4RJXz0Ce2Gd8ZqUta8J55lS4GMej1S
         WufQ==
X-Gm-Message-State: APjAAAV+jA+QBKQtPbCBycL188o5kWN9f5yKYZdbLutkmP5NFbr71p94
        liQj2G+arbGYgRPs3meooHD40ayQ
X-Google-Smtp-Source: APXvYqyFjFnNF0kRZtzUKrkmoOdqHX4z24Z2M4aeg6qSE0MygYfvr1vr3rHCnXfIKNY583beYLvqgQ==
X-Received: by 2002:adf:f504:: with SMTP id q4mr41613304wro.28.1582223563321;
        Thu, 20 Feb 2020 10:32:43 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:98c6:3f79:bff9:4c51? (p200300EA8F29600098C63F79BFF94C51.dip0.t-ipconnect.de. [2003:ea:8f29:6000:98c6:3f79:bff9:4c51])
        by smtp.googlemail.com with ESMTPSA id m68sm153770wme.48.2020.02.20.10.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 10:32:42 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Vincas Dargis <vindrg@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
 <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
 <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
 <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
 <d2b5d904-61e1-6c14-f137-d4d5a803dcf6@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <356588e8-b46a-e0bb-e05b-89af81824dfa@gmail.com>
Date:   Thu, 20 Feb 2020 19:32:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d2b5d904-61e1-6c14-f137-d4d5a803dcf6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.02.2020 18:36, Vincas Dargis wrote:
> 2020-02-19 23:54, Heiner Kallweit rašė:
>> Realtek responded that they are not aware of a HW issue with RTL8411b. They will try to reproduce the error,
>> in addition they ask to test whether same issue occurs with their own driver, r8168.
>> Would be great if you could give r8168 a try. Most distributions provide it as an optional package.
>> Worst case it can be downloaded from Realtek's website, then it needs to be compiled.
>>
> 
> I have installed r8168-dkms:
> 
> ```
> apt policy r8168-dkms
> r8168-dkms:
>   Installed: 8.048.00-1
>   Candidate: 8.048.00-1
>   Version table:
>  *** 8.048.00-1 500
>         500 http://debian.mirror.vu.lt/debian unstable/non-free amd64 Packages
>         500 http://debian.mirror.vu.lt/debian unstable/non-free i386 Packages
>         100 /var/lib/dpkg/status
> ```
> 
> Rebooted, and still (rather fast) got same timeout after maybe couple of minutes of running on same 5.4 withoyt ethtool fixes:
> 
> Feb 20 19:24:54 vinco kernel: [  228.808802] ------------[ cut here ]------------
> Feb 20 19:24:54 vinco kernel: [  228.808832] NETDEV WATCHDOG: enp5s0f1 (r8168): transmit queue 0 timed out
> Feb 20 19:24:54 vinco kernel: [  228.808865] WARNING: CPU: 7 PID: 0 at net/sched/sch_generic.c:447 dev_watchdog+0x248/0x250
> Feb 20 19:24:54 vinco kernel: [  228.808871] Modules linked in: xt_recent ipt_REJECT nf_reject_ipv4 xt_multiport xt_conntrack xt_hashlimit xt_addrtype xt_iface(OE) xt_mark nft_chain_nat xt_comment xt_CT xt_owner xt_tcpudp nft_compat nft_counter xt_NFLOG nf_log_ipv4 nf_log_common xt_LOG nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_nat nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rfcomm vboxnetadp(OE) vboxnetflt(OE) xfrm_user xfrm_algo vboxdrv(OE) l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppox ppp_generic slhc bnep nfnetlink_log nfnetlink ipmi_devintf ipmi_msghandler intel_rapl_msr intel_rapl_common bbswitch(OE) x86_pkg_temp_thermal intel_powerclamp coretemp
> kvm_intel kvm irqbypass btusb btrtl iwlmvm btbcm
> Feb 20 19:24:54 vinco kernel: [  228.808935]  binfmt_misc btintel bluetooth crct10dif_pclmul nls_ascii ghash_clmulni_intel mac80211 nls_cp437 snd_hda_codec_realtek snd_hda_codec_generic vfat drbg ledtrig_audio libarc4 snd_hda_codec_hdmi fat uvcvideo aesni_intel iwlwifi videobuf2_vmalloc ansi_cprng crypto_simd videobuf2_memops videobuf2_v4l2 snd_hda_intel cryptd glue_helper snd_intel_nhlt videobuf2_common snd_hda_codec videodev snd_hda_core intel_cstate ecdh_generic ecc cfg80211 mc intel_uncore efi_pstore snd_hwdep snd_pcm snd_timer asus_nb_wmi joydev asus_wmi snd sparse_keymap iTCO_wdt rtsx_pci_ms iTCO_vendor_support pcspkr intel_rapl_perf serio_raw sg efivars soundcore memstick watchdog rfkill ie31200_edac evdev ac asus_wireless parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs xor zstd_decompress zstd_compress raid6_pq libcrc32c crc32c_generic sr_mod cdrom sd_mod hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid i915
> rtsx_pci_sdmmc mmc_core i2c_algo_bit ahci
> Feb 20 19:24:54 vinco kernel: [  228.809003]  drm_kms_helper libahci xhci_pci crc32_pclmul mxm_wmi libata xhci_hcd drm crc32c_intel ehci_pci ehci_hcd psmouse scsi_mod usbcore rtsx_pci lpc_ich i2c_i801 mfd_core r8168(OE) usb_common video wmi battery button
> Feb 20 19:24:54 vinco kernel: [  228.809025] CPU: 7 PID: 0 Comm: swapper/7 Tainted: P           OE     5.4.0-4-amd64 #1 Debian 5.4.19-1
> Feb 20 19:24:54 vinco kernel: [  228.809027] Hardware name: ASUSTeK COMPUTER INC. N551JM/N551JM, BIOS N551JM.205 02/13/2015
> Feb 20 19:24:54 vinco kernel: [  228.809034] RIP: 0010:dev_watchdog+0x248/0x250
> Feb 20 19:24:54 vinco kernel: [  228.809038] Code: 85 c0 75 e5 eb 9f 4c 89 ef c6 05 58 1d a8 00 01 e8 0d e4 fa ff 44 89 e1 4c 89 ee 48 c7 c7 f0 cc d2 9a 48 89 c2 e8 76 40 a0 ff <0f> 0b eb 80 0f 1f 40 00 0f 1f 44 00 00 41 57 41 56 49 89 d6 41 55
> Feb 20 19:24:54 vinco kernel: [  228.809040] RSP: 0018:ffffc0e74020ce68 EFLAGS: 00010286
> Feb 20 19:24:54 vinco kernel: [  228.809043] RAX: 0000000000000000 RBX: ffff9f660df8e200 RCX: 000000000000083f
> Feb 20 19:24:54 vinco kernel: [  228.809044] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
> Feb 20 19:24:54 vinco kernel: [  228.809046] RBP: ffff9f660d30045c R08: ffff9f661edd7688 R09: 0000000000000004
> Feb 20 19:24:54 vinco kernel: [  228.809048] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> Feb 20 19:24:54 vinco kernel: [  228.809049] R13: ffff9f660d300000 R14: ffff9f660d300480 R15: 0000000000000001
> Feb 20 19:24:54 vinco kernel: [  228.809052] FS:  0000000000000000(0000) GS:ffff9f661edc0000(0000) knlGS:0000000000000000
> Feb 20 19:24:54 vinco kernel: [  228.809054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 20 19:24:54 vinco kernel: [  228.809055] CR2: 00005f1110bf6da4 CR3: 0000000185e0a001 CR4: 00000000001626e0
> Feb 20 19:24:54 vinco kernel: [  228.809057] Call Trace:
> Feb 20 19:24:54 vinco kernel: [  228.809060]  <IRQ>
> Feb 20 19:24:54 vinco kernel: [  228.809068]  ? pfifo_fast_enqueue+0x150/0x150
> Feb 20 19:24:54 vinco kernel: [  228.809073]  call_timer_fn+0x2d/0x130
> Feb 20 19:24:54 vinco kernel: [  228.809077]  __run_timers.part.0+0x16f/0x260
> Feb 20 19:24:54 vinco kernel: [  228.809084]  ? tick_sched_handle+0x22/0x60
> Feb 20 19:24:54 vinco kernel: [  228.809089]  ? tick_sched_timer+0x38/0x80
> Feb 20 19:24:54 vinco kernel: [  228.809093]  ? tick_sched_do_timer+0x60/0x60
> Feb 20 19:24:54 vinco kernel: [  228.809096]  run_timer_softirq+0x26/0x50
> Feb 20 19:24:54 vinco kernel: [  228.809102]  __do_softirq+0xe6/0x2e9
> Feb 20 19:24:54 vinco kernel: [  228.809111]  irq_exit+0xa6/0xb0
> Feb 20 19:24:54 vinco kernel: [  228.809115]  smp_apic_timer_interrupt+0x76/0x130
> Feb 20 19:24:54 vinco kernel: [  228.809118]  apic_timer_interrupt+0xf/0x20
> Feb 20 19:24:54 vinco kernel: [  228.809120]  </IRQ>
> Feb 20 19:24:54 vinco kernel: [  228.809126] RIP: 0010:cpuidle_enter_state+0xc4/0x450
> Feb 20 19:24:54 vinco kernel: [  228.809129] Code: e8 b1 54 ad ff 80 7c 24 0f 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 61 03 00 00 31 ff e8 a3 74 b3 ff fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 8c 02 00 00 49 63 cc 4c 2b 6c 24 10 48 8d 04 49 48
> Feb 20 19:24:54 vinco kernel: [  228.809131] RSP: 0018:ffffc0e7400cfe68 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> Feb 20 19:24:54 vinco kernel: [  228.809133] RAX: ffff9f661edea6c0 RBX: ffffffff9aeb92e0 RCX: 000000000000001f
> Feb 20 19:24:54 vinco kernel: [  228.809135] RDX: 0000000000000000 RSI: 000000003351882d RDI: 0000000000000000
> Feb 20 19:24:54 vinco kernel: [  228.809137] RBP: ffff9f661edf4a00 R08: 000000354610e2fa R09: 0000000000029fa0
> Feb 20 19:24:54 vinco kernel: [  228.809138] R10: ffff9f661ede95a0 R11: ffff9f661ede9580 R12: 0000000000000005
> Feb 20 19:24:54 vinco kernel: [  228.809140] R13: 000000354610e2fa R14: 0000000000000005 R15: ffff9f661caa8f00
> Feb 20 19:24:54 vinco kernel: [  228.809145]  ? cpuidle_enter_state+0x9f/0x450
> Feb 20 19:24:54 vinco kernel: [  228.809149]  cpuidle_enter+0x29/0x40
> Feb 20 19:24:54 vinco kernel: [  228.809155]  do_idle+0x1dc/0x270
> Feb 20 19:24:54 vinco kernel: [  228.809162]  cpu_startup_entry+0x19/0x20
> Feb 20 19:24:54 vinco kernel: [  228.809168]  start_secondary+0x15f/0x1b0
> Feb 20 19:24:54 vinco kernel: [  228.809174]  secondary_startup_64+0xa4/0xb0
> Feb 20 19:24:54 vinco kernel: [  228.809179] ---[ end trace f2c0113df7c88e86 ]---
> Feb 20 19:24:57 vinco kernel: [  231.448423] r8168: enp5s0f1: link up
> 
> Full kernl.log is attached.
> 
> Interestingly, network did started working again after some time. Does that "link up" mean card was reset successfully or something?

Thanks a lot again for testing! I didn't check in detail, but most likely r8168 has the same NIC reset procedure
after a tx timeout. "link up" means that at least the link on PHY level was successfully re-established.

It would be great if you could test one more thing. Few chip versions have a hw issue with tx checksumming
for very small packets. Maybe your chip version suffers from the same issue.
Could you please test the following patch (with all features enabled, TSO and checksumming)?

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8442b8767..bee90af57 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4345,6 +4345,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 			case RTL_GIGA_MAC_VER_12:
 			case RTL_GIGA_MAC_VER_17:
 			case RTL_GIGA_MAC_VER_34:
+			case RTL_GIGA_MAC_VER_44:
 				features &= ~NETIF_F_CSUM_MASK;
 				break;
 			default:
-- 
2.25.1

