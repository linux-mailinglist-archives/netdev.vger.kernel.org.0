Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759AAD0203
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 22:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbfJHUSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 16:18:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36265 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729935AbfJHUSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 16:18:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so4465994wmc.1
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 13:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nq3aDYm94AahJpGhrYsvlsN5ms0WwXmMEmtpjxqNwwE=;
        b=a1vGQOahAX5Rox6vpxGuc58xyibHOhq6A3IHNRcG8kRMKiMwGURVq5Jl+NzKvpEqGa
         Oj0SUeBlvS1EOd19wP6FKIEfViLX89GgtkyhMbhy52oKJHUINQXmReOhqcP55R5+CW9g
         bZpkSdy6lfZ1e7NMrZHi0NODVRPMrKhMNz+sKxxROWtMbqHC/2A8yGhtto2AHlN4MDJ9
         hCmQUgO5X3mAao1z3bUc6KJe2UBxQGDy9FVXnRcShSMMayPuay2FyqjoXdiTWhb0tYpd
         ukFsIRgIvpignXNQIz0lXEIH5AdLfyaVYqvAgiTWn5od0CCEDVnB1VEORIY51RPjl7ve
         hzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nq3aDYm94AahJpGhrYsvlsN5ms0WwXmMEmtpjxqNwwE=;
        b=PhY58dg1mFOMJS1ObLXuN+/AaDa1NKWE85QcRF1UUCMFUXwVTQBw+MVNf/gVJYi2rM
         TsmgWzWaEO+NTsjIZ8tt3duFLn5sCohaVbqJh+hP0s4N6ChWqDatpHHK6pL8SZMktOQF
         z/imEJUz+bgvY2mAUqDDz7E7TsKe02q5hb5VOiCNliHsqX7QyU+hG/j/TLaHCJc2V8es
         UQ9IcdM7GbyyVt2ao6cQkKttRJkOyBoR/QDU4MedBtNtWn+2rmWJ+I15sC8uBSGbkGj6
         +wyKof9pDu69hgIEAr7NoOt7Kd5Q8xfbAZf/5RnmzExYUcqT9bw7c4btMfc43zbYrQ7K
         sqHQ==
X-Gm-Message-State: APjAAAUOwp3Q3xIW7ikJqLRF6elQNq/EQbLR5SOKn7s7pOlpV8PezaRG
        9DUcuAOkYNZhNEI9wuR7S+DxRuyI
X-Google-Smtp-Source: APXvYqxkx2b/NEGuPG4lsA22XCL/tbtSIaewIFlH3LkFwpX9dTRophJNQ/pCBKSLLq/NhnYn7riOUg==
X-Received: by 2002:a05:600c:d4:: with SMTP id u20mr5471360wmm.66.1570565901239;
        Tue, 08 Oct 2019 13:18:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1dc6:b02d:53c2:ab45? (p200300EA8F2664001DC6B02D53C2AB45.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1dc6:b02d:53c2:ab45])
        by smtp.googlemail.com with ESMTPSA id m18sm40077633wrg.97.2019.10.08.13.18.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 13:18:20 -0700 (PDT)
Subject: Re: Potential Bug Report
To:     =?UTF-8?Q?Informationstechnik_W=c3=bcrfl?= <wuerfl@it-wuerfl.de>
References: <1570539338.8498.0@it-wuerfl.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c3f62cf5-d2ba-ac5b-47de-3e30a7f01abe@gmail.com>
Date:   Tue, 8 Oct 2019 22:18:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570539338.8498.0@it-wuerfl.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.10.2019 14:55, Informationstechnik Würfl wrote:
> Hi Heiner,
> 
> i just wanted to inform you about a potential bug since Kernel 5.3 (since the realtek driver has been renamed and refactored).
> 
> Booting with Kernels > 5.2 always result in a kernel oops (r8169,libphy), i guess that in the structure  handed over to phy_modify_paged tp->phy_dev is null, instead a correct value or something like that.
> My lspci for the network card lists:
> 
> 22:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
> 
> Maybe its of use and other people have the same issues.
> 
Thanks for the report. I think in your case simply the Realtek PHY driver module isn't available.
If you build it the problem should disappear. Nevertheless we may have to improve the Kconfig
dependencies for r8169 to prevent such cases.
Can you provide a full dmesg output and your kernel config?

> 
> 
> Regards 
> 
> Wolfgang
> 
Heiner
> 
> 
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> Okt 08 08:48:11 gentoo kernel: #PF: supervisor instruction fetch in kernel mode
> Okt 08 08:48:11 gentoo kernel: #PF: error_code(0x0010) - not-present page
> Okt 08 08:48:11 gentoo kernel: PGD 0 P4D 0 
> 
> 
> Okt 08 08:48:11 gentoo kernel: Oops: 0010 [#1] PREEMPT SMP
> Okt 08 08:48:11 gentoo kernel: CPU: 9 PID: 7119 Comm: NetworkManager Tainted: P           O      5.4.0-rc2-BeoCore #1
> Okt 08 08:48:11 gentoo kernel: Hardware name: Micro-Star International Co., Ltd MS-7B86/B450 GAMING PLUS MAX (MS-7B86), BIOS H.30 09/18/2019
> Okt 08 08:48:11 gentoo kernel: RIP: 0010:0x0
> Okt 08 08:48:11 gentoo kernel: Code: Bad RIP value.
> Okt 08 08:48:11 gentoo kernel: RSP: 0018:ffffc900006ab528 EFLAGS: 00010246
> Okt 08 08:48:11 gentoo kernel: RAX: ffffffffa00c72e0 RBX: 0000000000000004 RCX: 0000000000000004
> Okt 08 08:48:11 gentoo kernel: RDX: ff ff8887ce6ba3c0 RSI: 0000000000000a43 RDI: ffff8887f58a0000
> Okt 08 08:48:11 gentoo kernel: RBP: ffff8887f58a0000 R08: 0000000000000000 R09: 0000000000000000
> Okt 08 08:48:11 gentoo kernel: R10: 0000000000000002 R11: 000000000000000f R12: 0000000000000009
> Okt 08 08:48:11 gentoo kernel: R13: 0000000000000a43 R14: 0000000000000010 R15: ffff8887f2a38840
> Okt 08 08:48:11 gentoo kernel: FS:  00007fe83535a880(0000) GS:ffff8887fea40000(0000) knlGS:0000000000000000
> Okt 08 08:48:11 gentoo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Okt 08 08:48:11 gentoo kernel: CR2: ffffffffffffffd6 CR3: 00000007cd919000 CR4: 0000000000340ee0
> Okt 08 08:48:11 gentoo kernel: Call Trace:
> Okt 08 08:48:11 gentoo kernel:  phy_select_page+0x2b/0x60 [libphy]
> Okt 08 08:48:11 gentoo kernel:  phy_modify_paged_changed+0x18/0x50 [libphy]
> Okt 08 08:48:11 gentoo kernel:  phy_modify_paged+0 xc/0x20 [libphy]
> Okt 08 08:48:11 gentoo kernel:  rtl8168h_2_hw_phy_config+0x253/0x2e0 [r8169]
> Okt 08 08:48:11 gentoo kernel:  rtl8169_init_phy+0x20/0x80 [r8169]
> Okt 08 08:48:11 gentoo kernel:  rtl_open+0x3bc/0x580 [r8169]
> Okt 08 08:48:11 gentoo kernel:  __dev_open+0x91/0x110
> Okt 08 08:48:11 gentoo kernel:  __dev_change_flags+0x155/0x1b0
> Okt 08 08:48:11 gentoo kernel:  dev_change_flags+0x1c/0x50
> Okt 08 08:48:11 gentoo kernel:  do_setlink+0x678/0xd80
> Okt 08 08:48:11 gentoo kernel:  ? blk_mq_flush_plug_list+0x207/0x2b0
> Okt 08 08:48:11 gentoo kernel:  ? inet6_validate_link_af+0x47/0xc0
> Okt 08 08:48:11 gentoo kernel:  ? __nla_validate_parse+0x43/0x770
> Okt 08 08:48:11 gentoo kernel:  ? __snmp6_fill_stats64.isra.0+0x53/0xe0
> Okt 08 08:48:11 gentoo kernel:  __rtnl_newlink+0x545/0x8a0
> Okt 08 08:48:11 gento o kernel:  ? __nla_reserve+0x38/0x50
> Okt 08 08:48:11 gentoo kernel:  ? ___cache_free+0x1c/0x1d0
> Okt 08 08:48:11 gentoo kernel:  ? pskb_expand_head+0xfa/0x2c0
> Okt 08 08:48:11 gentoo kernel:  ? preempt_count_add+0x63/0x90
> Okt 08 08:48:11 gentoo kernel:  ? _raw_spin_lock_irqsave+0x14/0x40
> Okt 08 08:48:11 gentoo kernel:  ? __netlink_sendskb+0x2f/0x40
> Okt 08 08:48:11 gentoo kernel:  ? _raw_spin_lock+0xe/0x30
> Okt 08 08:48:11 gentoo kernel:  ? _raw_spin_lock_irq+0x20/0x30
> Okt 08 08:48:11 gentoo kernel:  ? dbuf_rele_and_unlock+0x5a4/0x6d0 [zfs]
> Okt 08 08:48:11 gentoo kernel:  ? kmem_cache_alloc_trace+0x141/0x1b0
> Okt 08 08:48:11 gentoo kernel:  rtnl_newlink+0x3f/0x60
> Okt 08 08:48:11 gentoo kernel:  rtnetlink_rcv_msg+0x10c/0x370
> Okt 08 08:48:11 gentoo kernel:  ? dmu_buf_hold_array_by_bonus+0x17e/0x1c0 [zfs]
> Okt 08 08:48:11 gentoo kernel:  ? rtnl_calcit.isra.0+0xe0/0xe0
> Okt 08 08:48:11 gentoo kernel:  netlink_rcv_skb+0x41/0x110
> Okt 08 08:48:11 gentoo kernel:  netlink_unicast+0x142/0x1d0
> Okt 08 08:48:11 gentoo kernel:  netlink_sendmsg+0x1b8/0x3c0
> Okt 08 08:48:11 gentoo kernel:  ? netlink_unicast+0x1d0/0x1d0
> Okt 08 08:48:11 gentoo kernel:  ___sys_sendmsg+0x29d/0x2f0
> Okt 08 08:48:11 gentoo kernel:  ? alloc_set_pte+0xf1/0x580
> Okt 08 08:48:11 gentoo kernel:  ? filemap_map_pages+0x22d/0x300
> Okt 08 08:48:11 gentoo kernel:  ? _raw_spin_unlock+0xd/0x20
> Okt 08 08:48:11 gentoo kernel:  ? __handle_mm_fault+0xde1/0x1060
> Okt 08 08:48:11 gentoo kernel:  ? __fget+0x6c/0xa0
> Okt 08 08:48:11 gentoo kernel:  __sys_sendmsg+0x44/0x80
> Okt 08 08:48:11 gentoo kernel:  do_syscall_64+0x4a/0x190
> Okt 08 08:48:11 gent oo kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> Okt 08 08:48:11 gentoo kernel: RIP: 0033:0x7fe835b92649
> Okt 08 08:48:11 gentoo kernel: Code: 00 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 3e e8 ff ff 41 89 c0 8b 54 24 1c 48 8b 74 24 10 b8 2e 00 00 00 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 37 44 89 c7 48 89 44 24 08 e8 72 e8 ff ff 48
> Okt 08 08:48:11 gentoo kernel: RSP: 002b:00007ffff5e76300 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> Okt 08 08:48:11 gentoo kernel: RAX: ffffffffffffffda RBX: 000055e197f3d300 RCX: 00007fe835b92649
> Okt 08 08:48:11 gentoo kernel: RDX: 0000000000000000 RSI: 00007ffff5e76360 RDI: 000000000000000a
> Okt 08 08:48:11 gentoo kernel: RBP: 00007ffff5e76360 R08: 0000000000000000 R09: 0000000000000000
> Okt 08 08:48:11 gentoo kernel: R10: 0000000000000001 R11: 0000000000000293 R12: 000055e197f3d300
> Okt 08 08:48:11 gentoo kernel: R13: 00007 ffff5e76518 R14: 00007ffff5e7650c R15: 0000000000000000
> Okt 08 08:48:11 gentoo kernel: Modules linked in: kvm_amd kvm irqbypass ppdev snd_hda_codec_ca0132 snd_hda_codec_hdmi snd_hda_intel snd_intel_nhlt aesni_intel snd_hda_codec glue_helper crypto_simd cryptd snd_hda_core snd_hwdep hid_holtek_mouse snd_pcm jo>
> Okt 08 08:48:11 gentoo kernel:  hid_logitech hid_gyration hid_ezkey hid_cypress hid_chicony hid_cherry hid_a4tech sl811_hcd xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd ehci_pci ehci_hcd aic94xx libsas lpfc crc_t10dif crct10dif_common qla2xxx megaraid_sas me>
> Okt 08 08:48:11 gentoo kernel:  pata_pdc2027x pata_mpiix usb_storage led_class usbhid xhci_pci r8169 xhci_hcd ahci libahci libphy usbcore libata usb_common parport
> Okt 08 08:48:11 gentoo kernel: CR2: 0000000000000000
> Okt 08 08:48:11 gentoo kernel: ---[ end trace 648d7ccfb58c01c8 ]---
> Okt 08 08:48:11 gentoo kernel: RIP: 0010:0x0
> Okt 08 08:48: 11 gentoo kernel: Code: Bad RIP value.
> Okt 08 08:48:11 gentoo kernel: RSP: 0018:ffffc900006ab528 EFLAGS: 00010246
> Okt 08 08:48:11 gentoo kernel: RAX: ffffffffa00c72e0 RBX: 0000000000000004 RCX: 0000000000000004
> Okt 08 08:48:11 gentoo kernel: RDX: ffff8887ce6ba3c0 RSI: 0000000000000a43 RDI: ffff8887f58a0000
> Okt 08 08:48:11 gentoo kernel: RBP: ffff8887f58a0000 R08: 0000000000000000 R09: 0000000000000000
> Okt 08 08:48:11 gentoo kernel: R10: 0000000000000002 R11: 000000000000000f R12: 0000000000000009
> Okt 08 08:48:11 gentoo kernel: R13: 0000000000000a43 R14: 0000000000000010 R15: ffff8887f2a38840
> Okt 08 08:48:11 gentoo kernel: FS:  00007fe83535a880(0000) GS:ffff8887fea40000(0000) knlGS:0000000000000000
> Okt 08 08:48:11 gentoo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Okt 08 08:48:11 gentoo kernel: CR2: ffffffffffffffd6 CR3: 00000007cd919000 CR4: 0000000000340ee0
> < /div>
> 

