Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879371600F3
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 23:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgBOWfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 17:35:43 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47050 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOWfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 17:35:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so15193346wrl.13
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 14:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgLJqfXEYsjugV+WzFOQ+94iGhSgjhhXqMtqHASRlzg=;
        b=uCHDxu5Yh4MpJyiD2GkdSVahoyWqmFF7zNW0NTPKsbrxMlxs5LfYmiiKwsC/M1rMZ7
         l06vxqx/U+XjJULDesJo7qiDpyZOIWXdJvUQRjM07S4KxBJjP1FQ4B+i+90x7PHcrnqH
         wosOyu+BXdCyfajZ8o0Mp7OQmnZuld/3tBE7QI6kCbd60SpVC8TxM72Jfc0bgGffIyJV
         BlKSVPlXQMxHyknOOcwtKfufqsT/OLPATfwe/U3nTWPNdZrWeZjVORH3ePE95rCtFJDj
         fbP7zjsRjyWmogS8l9UBrio1dvW9/6meRW0yALBslX9xP5JC/ghRS0bC0HIdEBuKBo8g
         8g8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgLJqfXEYsjugV+WzFOQ+94iGhSgjhhXqMtqHASRlzg=;
        b=ZAsrLh9evUcj1EVxCmT9w1qB0EX95geBRuBTxwznQpo5kaO/RKaOPcwViQZ0NQ1IJR
         ube89zowRBrz0p036PrKJgc89fwLqJzISc47mRqqsFk9d0HdTqRmyLDEMWVisAfwsR6v
         DQR5AeLTUcYVJaaACl34vJTu94SSw+ommoYbhDdAyFT3W4J8zx8L22hH/zPbIbogd2GD
         5SNwYYa02FFAIOLsgEiwGJiIc7UW8RUg33Te5hOm9LrLvv4vbDk4YC7oB53VWgZuC5ON
         v/6rGdM4Fk/N5XctdugShxRSkjcS6jVYCq5CXsK9EIET3VxzTSsN0IQfIKgeYWKhncd7
         Fysg==
X-Gm-Message-State: APjAAAWwZDoYLw0efdn9fudsL7iRcfHka42X+fMITszzJojqIzlk4/b6
        D/Op/R3v1pdRZfN2v6qvolF1mMuY
X-Google-Smtp-Source: APXvYqwgLP7dog3020VEV1tFBD5lO50nnDATQ+YMwslWh28zZPvdNex66MJObGhk5Eei99LquUYf6Q==
X-Received: by 2002:a05:6000:1208:: with SMTP id e8mr12332367wrx.351.1581806140168;
        Sat, 15 Feb 2020 14:35:40 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:4420:246b:454a:50cd? (p200300EA8F2960004420246B454A50CD.dip0.t-ipconnect.de. [2003:ea:8f29:6000:4420:246b:454a:50cd])
        by smtp.googlemail.com with ESMTPSA id k7sm13253825wmi.19.2020.02.15.14.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 14:35:39 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Vincas Dargis <vindrg@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
Date:   Sat, 15 Feb 2020 23:35:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.02.2020 23:07, Vincas Dargis wrote:
> 2020-02-15 18:12, Salvatore Bonaccorso rašė:
>> You can generate the a7a92cf81589 revert patch, and then for simple
>> testing of a patch and build have a look at the Simple patching and
>> building[1] section of the kernel handbook.
>>
>> Hope this helps,
>>
>> Regards,
>> Salvatore
>>
>>   [1] https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.html#s4.2.2
>>
> 
> Sadly, after running for an hour, I still got this:
> 
> Feb 15 23:49:21 vinco kernel: [ 3670.779254] ------------[ cut here ]------------
> Feb 15 23:49:21 vinco kernel: [ 3670.779275] NETDEV WATCHDOG: enp5s0f1 (r8169): transmit queue 0 timed out
> Feb 15 23:49:21 vinco kernel: [ 3670.779299] WARNING: CPU: 6 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x248/0x250
> Feb 15 23:49:21 vinco kernel: [ 3670.779300] Modules linked in: rfcomm(E) xt_recent(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_multiport(E) xt_conntrack(E) xt_hashlimit(E) xt_addrtype(E) xt_iface(OE) xt_mark(E) nft_chain_nat(E) xt_comment(E) xt_CT(E) xt_owner(E) xt_tcpudp(E) nft_compat(E) nft_counter(E) xt_NFLOG(E) nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) nf_nat_tftp(E) nf_nat_snmp_basic(E) nf_conntrack_snmp(E) nf_nat_sip(E) nf_nat_pptp(E) nf_nat_irc(E) nf_nat_h323(E) nf_nat_ftp(E) nf_nat_amanda(E) ts_kmp(E) nf_conntrack_amanda(E) nf_nat(E) nf_conntrack_sane(E) nf_conntrack_tftp(E) nf_conntrack_sip(E) nf_conntrack_pptp(E) nf_conntrack_netlink(E) nf_conntrack_netbios_ns(E) nf_conntrack_broadcast(E) nf_conntrack_irc(E) nf_conntrack_h323(E) nf_conntrack_ftp(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) nf_tables(E) vboxnetadp(OE) vboxnetflt(OE) xfrm_user(E) xfrm_algo(E) vboxdrv(OE) l2tp_ppp(E) l2tp_netlink(E) l2tp_core(E) ip6_udp_tunnel(E) udp_tunnel(E) pppox(E)
> ppp_generic(E) slhc(E) nfnetlink_log(E) bnep(E)
> Feb 15 23:49:21 vinco kernel: [ 3670.779353]  nfnetlink(E) bbswitch(OE) intel_rapl_msr(E) intel_rapl_common(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) ghash_clmulni_intel(E) binfmt_misc(E) btusb(E) btrtl(E) btbcm(E) btintel(E) nls_ascii(E) nls_cp437(E) bluetooth(E) snd_hda_codec_realtek(E) aesni_intel(E) uvcvideo(E) vfat(E) crypto_simd(E) videobuf2_vmalloc(E) fat(E) snd_hda_codec_generic(E) cryptd(E) videobuf2_memops(E) glue_helper(E) ledtrig_audio(E) videobuf2_v4l2(E) iwlmvm(E) intel_cstate(E) drbg(E) snd_hda_codec_hdmi(E) intel_uncore(E) videobuf2_common(E) mac80211(E) ansi_cprng(E) libarc4(E) videodev(E) efi_pstore(E) joydev(E) snd_hda_intel(E) mc(E) snd_intel_dspcfg(E) intel_rapl_perf(E) ecdh_generic(E) pcspkr(E) ecc(E) serio_raw(E) snd_hda_codec(E) asus_nb_wmi(E) iwlwifi(E) asus_wmi(E) snd_hda_core(E) efivars(E) sparse_keymap(E) snd_hwdep(E) sg(E) snd_pcm(E) cfg80211(E) snd_timer(E) iTCO_wdt(E)
> iTCO_vendor_support(E) snd(E) watchdog(E) rfkill(E)
> Feb 15 23:49:21 vinco kernel: [ 3670.779386]  soundcore(E) ie31200_edac(E) evdev(E) asus_wireless(E) ac(E) parport_pc(E) ppdev(E) lp(E) parport(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc16(E) mbcache(E) jbd2(E) btrfs(E) blake2b_generic(E) xor(E) zstd_decompress(E) zstd_compress(E) raid6_pq(E) libcrc32c(E) crc32c_generic(E) sr_mod(E) sd_mod(E) cdrom(E) hid_logitech_hidpp(E) hid_logitech_dj(E) hid_generic(E) usbhid(E) hid(E) i915(E) rtsx_pci_sdmmc(E) i2c_algo_bit(E) mmc_core(E) xhci_pci(E) drm_kms_helper(E) ehci_pci(E) ahci(E) lpc_ich(E) rtsx_pci(E) ehci_hcd(E) mfd_core(E) drm(E) libahci(E) xhci_hcd(E) crc32_pclmul(E) mxm_wmi(E) libata(E) crc32c_intel(E) r8169(E) realtek(E) psmouse(E) usbcore(E) i2c_i801(E) scsi_mod(E) libphy(E) usb_common(E) wmi(E) battery(E) video(E) button(E)
> Feb 15 23:49:21 vinco kernel: [ 3670.779418] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G           OE     5.5.0-rc5-amd64 #1 Debian 5.5~rc5-1~exp1
> Feb 15 23:49:21 vinco kernel: [ 3670.779419] Hardware name: ASUSTeK COMPUTER INC. N551JM/N551JM, BIOS N551JM.205 02/13/2015
> Feb 15 23:49:21 vinco kernel: [ 3670.779422] RIP: 0010:dev_watchdog+0x248/0x250
> Feb 15 23:49:21 vinco kernel: [ 3670.779425] Code: 85 c0 75 e5 eb 9f 4c 89 ef c6 05 a8 8b a6 00 01 e8 1d cc fa ff 44 89 e1 4c 89 ee 48 c7 c7 68 ca 55 a9 48 89 c2 e8 1a 67 9e ff <0f> 0b eb 80 0f 1f 40 00 0f 1f 44 00 00 41 57 41 56 49 89 d6 41 55
> Feb 15 23:49:21 vinco kernel: [ 3670.779426] RSP: 0018:ffffbf5dc01e0e68 EFLAGS: 00010286
> Feb 15 23:49:21 vinco kernel: [ 3670.779428] RAX: 0000000000000000 RBX: ffffa0e11c031400 RCX: 000000000000083f
> Feb 15 23:49:21 vinco kernel: [ 3670.779429] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
> Feb 15 23:49:21 vinco kernel: [ 3670.779430] RBP: ffffa0e11caee45c R08: 0000000000000471 R09: 0000000000000004
> Feb 15 23:49:21 vinco kernel: [ 3670.779431] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> Feb 15 23:49:21 vinco kernel: [ 3670.779432] R13: ffffa0e11caee000 R14: ffffa0e11caee480 R15: 0000000000000001
> Feb 15 23:49:21 vinco kernel: [ 3670.779433] FS:  0000000000000000(0000) GS:ffffa0e11ef80000(0000) knlGS:0000000000000000
> Feb 15 23:49:21 vinco kernel: [ 3670.779434] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 15 23:49:21 vinco kernel: [ 3670.779435] CR2: 000004c3f29aba30 CR3: 000000020e80a005 CR4: 00000000001626e0
> Feb 15 23:49:21 vinco kernel: [ 3670.779436] Call Trace:
> Feb 15 23:49:21 vinco kernel: [ 3670.779439]  <IRQ>
> Feb 15 23:49:21 vinco kernel: [ 3670.779443]  ? pfifo_fast_enqueue+0x150/0x150
> Feb 15 23:49:21 vinco kernel: [ 3670.779446]  call_timer_fn+0x2d/0x130
> Feb 15 23:49:21 vinco kernel: [ 3670.779448]  __run_timers.part.0+0x16f/0x260
> Feb 15 23:49:21 vinco kernel: [ 3670.779452]  ? tick_sched_handle+0x22/0x60
> Feb 15 23:49:21 vinco kernel: [ 3670.779455]  ? tick_sched_timer+0x38/0x80
> Feb 15 23:49:21 vinco kernel: [ 3670.779457]  ? tick_sched_do_timer+0x60/0x60
> Feb 15 23:49:21 vinco kernel: [ 3670.779460]  run_timer_softirq+0x26/0x50
> Feb 15 23:49:21 vinco kernel: [ 3670.779464]  __do_softirq+0xe6/0x2e9
> Feb 15 23:49:21 vinco kernel: [ 3670.779469]  irq_exit+0xa6/0xb0
> Feb 15 23:49:21 vinco kernel: [ 3670.779471]  smp_apic_timer_interrupt+0x76/0x130
> Feb 15 23:49:21 vinco kernel: [ 3670.779474]  apic_timer_interrupt+0xf/0x20
> Feb 15 23:49:21 vinco kernel: [ 3670.779475]  </IRQ>
> Feb 15 23:49:21 vinco kernel: [ 3670.779479] RIP: 0010:cpuidle_enter_state+0xc9/0x3e0
> Feb 15 23:49:21 vinco kernel: [ 3670.779481] Code: e8 5c ad ab ff 80 7c 24 0f 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 ea 02 00 00 31 ff e8 9e dc b1 ff fb 66 0f 1f 44 00 00 <45> 85 ed 0f 88 40 02 00 00 49 63 d5 4c 2b 64 24 10 48 8d 04 52 48
> Feb 15 23:49:21 vinco kernel: [ 3670.779482] RSP: 0018:ffffbf5dc00c7e68 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> Feb 15 23:49:21 vinco kernel: [ 3670.779483] RAX: ffffa0e11efacac0 RBX: ffffdf5dbfd9e0f0 RCX: 000000000000001f
> Feb 15 23:49:21 vinco kernel: [ 3670.779484] RDX: 0000000000000000 RSI: 0000000033518eeb RDI: 0000000000000000
> Feb 15 23:49:21 vinco kernel: [ 3670.779485] RBP: ffffffffa96bdaa0 R08: 00000356ab7df88b R09: 000000000002c3e0
> Feb 15 23:49:21 vinco kernel: [ 3670.779486] R10: 0000000000001592 R11: ffffa0e11efab9a4 R12: 00000356ab7df88b
> Feb 15 23:49:21 vinco kernel: [ 3670.779487] R13: 0000000000000005 R14: 0000000000000005 R15: ffffa0e11ca98000
> Feb 15 23:49:21 vinco kernel: [ 3670.779490]  ? cpuidle_enter_state+0xa4/0x3e0
> Feb 15 23:49:21 vinco kernel: [ 3670.779493]  cpuidle_enter+0x29/0x40
> Feb 15 23:49:21 vinco kernel: [ 3670.779496]  do_idle+0x1e4/0x280
> Feb 15 23:49:21 vinco kernel: [ 3670.779499]  cpu_startup_entry+0x19/0x20
> Feb 15 23:49:21 vinco kernel: [ 3670.779502]  start_secondary+0x15f/0x1b0
> Feb 15 23:49:21 vinco kernel: [ 3670.779506]  secondary_startup_64+0xa4/0xb0
> Feb 15 23:49:21 vinco kernel: [ 3670.779508] ---[ end trace a87faacfee854ba7 ]---
> 
> Though what is strange that network does seems to be usable! I don't have to reboot to make browser and other application to continue working. Maybe other changes up to 5.5-rc5 helped?

In case of a tx timeout NIC and driver parts are reset, see rtl8169_tx_timeout().
Depending on the root cause this may often be sufficient to make it work again.

It's likely that the root cause for the timeout is in the driver, however we don't
know for sure yet. Reason could also be a net core regression. So still the best
would be a bisect.
5.4 has been out for more than two months now, and this report is the first one
I see. Therefore I'd assume that the issue affects special cases (e.g. specific
chip versions) only.

Helpful would be a full dmesg log of the boot.

And just to be on the safe side: You could try to disable EEE (ethtool --set-eee <if> eee off)
and see whether this helps.


