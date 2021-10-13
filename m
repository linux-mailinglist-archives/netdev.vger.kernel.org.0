Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D67D42B4AC
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 07:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhJMFUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 01:20:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56356 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237566AbhJMFUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 01:20:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634102292; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=JUSKj41czZwoaNcQw0MNGsipHssBg0X2glAePGRKNOo=; b=tvnUHJbT/qt5GpxaUmUK3oYP3wmy5zjVAwSRJkEVnVO3khtIurKxGNcVkxNCEVLA9k495hiD
 ByT8GXc9tzd8Hu56hCDnDj+3IovNA/WavzvSjJH8e/wiZrDNlFoASd7i6Q2WkThrF0zUwMzq
 bGiCQye2jBYV/vdo+HbckpspLKU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 61666c0b8ea00a941f353bde (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 13 Oct 2021 05:18:03
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03C90C4360C; Wed, 13 Oct 2021 05:18:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C457C4338F;
        Wed, 13 Oct 2021 05:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3C457C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W . Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:974 cfg80211_roamed+0x265/0x2a0 [cfg80211]
References: <20211012145227.566254-1-ammarfaizi2@gmail.com>
Date:   Wed, 13 Oct 2021 08:17:54 +0300
In-Reply-To: <20211012145227.566254-1-ammarfaizi2@gmail.com> (Ammar Faizi's
        message of "Tue, 12 Oct 2021 21:52:27 +0700")
Message-ID: <874k9l1p19.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ammar Faizi <ammar.faizi@students.amikom.ac.id> writes:

> I am using Jens Axboe's tree.
>
> Last commit from Linus' tree is
> 9e1ff307c779ce1f0f810c7ecce3d95bbae40896 ("Linux 5.15-rc4").
>
> OS details:
>   DISTRIB_ID=Ubuntu
>   DISTRIB_RELEASE=21.04
>   DISTRIB_CODENAME=hirsute
>   DISTRIB_DESCRIPTION="Ubuntu 21.04"
>   NAME="Ubuntu"
>   VERSION="21.04 (Hirsute Hippo)"
>   ID=ubuntu
>   ID_LIKE=debian
>   PRETTY_NAME="Ubuntu 21.04"
>   VERSION_ID="21.04"
>
> I found a kernel warning at net/wireless/sme.c:974. I don't have the
> reproducer for it. It's hard to reproduce, because it happens randomly.
>
> I might miss something.
>
> More info:
> I am using WiFi on my laptop for general internet use, after several
> hours using it, my laptop suddenly freezes for about 3 seconds, then I
> can't connect to the internet despite my WiFi is still connected. At
> this point, I check dmesg and find these kernel warnings.
>
> If I disconnect and reconnect the WiFi, it works again, but several
> moment later, the same will happen again with the same kernel warning.
>
> If anyone has any suggestion what should I do to diagnose this issue,
> please guide me, I will be happy to follow it eventhough it may not
> solve the problem (I am still happy to try). Maybe recommend me to
> compile the kernel with specific configuration, test a patch to fix it
> or something.
>
> Here is the log:
>
> <4>[266728.385936][  T633] ------------[ cut here ]------------
> <4>[266728.385946][  T633] WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:974 cfg80211_roamed+0x265/0x2a0 [cfg80211]
> <4>[266728.386040][ T633] Modules linked in: rfcomm xt_CHECKSUM
> xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp
> nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 nft_counter nf_tables nfnetlink bridge stp llc bfq cmac
> algif_hash algif_skcipher af_alg bnep dm_multipath scsi_dh_rdac
> scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_hda_codec_hdmi
> uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel
> videobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi
> btusb btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec
> btintel videodev snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm
> ecdh_generic snd_seq_midi ecc snd_seq_midi_event edac_mce_amd
> snd_rawmidi kvm_amd acer_wmi snd_seq sparse_keymap kvm cfg80211
> wmi_bmof input_leds serio_raw snd_seq_device snd_timer snd soundcore
> ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_tables x_tables
> autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov
> async_memcpy async_pq
> <4>[266728.386224][ T633] async_xor async_tx xor raid6_pq libcrc32c
> raid1 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon
> i2c_algo_bit drm_ttm_helper ttm hid_generic drm_kms_helper syscopyarea
> usbhid crct10dif_pclmul sysfillrect crc32_pclmul sysimgblt hid
> ghash_clmulni_intel fb_sys_fops cec aesni_intel rc_core rtsx_pci_sdmmc
> sdhci_pci crypto_simd cqhci r8169 cryptd psmouse ahci xhci_pci
> rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_pci_renesas wmi
> video
> <4>[266728.386330][ T633] CPU: 2 PID: 633 Comm: wl_event_handle
> Tainted: G W OE 5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4
> 8b24b2500a34cedea2e69c8d84eb4c855e713e61
> <4>[266728.386337][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIOS V1.05 07/02/2015
> <4>[266728.386341][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
> <4>[266728.386408][ T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6
> 85 42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0
> 0f 85 d6 fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3
> 0f 0b 48 8b 73
> <4>[266728.386412][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
> <4>[266728.386418][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX: 0000000000000000
> <4>[266728.386421][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffffff8109ead2
> <4>[266728.386425][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09: 0000000000000001
> <4>[266728.386428][  T633] R10: fffffffefb3c8d52 R11: ffff8881328b75b2 R12: 0000000000000cc0
> <4>[266728.386431][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15: dead000000000100
> <4>[266728.386435][  T633] FS:  0000000000000000(0000) GS:ffff888313d00000(0000) knlGS:0000000000000000
> <4>[266728.386439][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[266728.386443][  T633] CR2: 00007f3033edd000 CR3: 000000011a878000 CR4: 00000000000406e0
> <4>[266728.386447][  T633] Call Trace:
> <4>[266728.386456][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> <4>[266728.386555][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> <4>[266728.386648][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> <4>[266728.386730][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> <4>[266728.386808][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]

What wireless device and driver you have? Based on the call trace it
looks like you are using Broadcom's out-of-tree driver called wl.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
