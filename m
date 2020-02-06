Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB92154E6D
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgBFV4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:56:33 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52977 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFV4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 16:56:33 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so515631wmc.2
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 13:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tDMsrMtxiqqWthW6Wz0Q6T9LnjNH/qRWNCzdPLK/GME=;
        b=heZSxitHFGrR8G/q7avMSuVyrR/CNIq8fcrWhAN0hKu0wddOUH56zBNxpTi5thEXf9
         Osh6fpZYuSjQOAO90I+GqXH/MLNPsByyevPqOH4cmATSfF6ZCgVQTIIlp8BCQFWsmTQo
         HEXhT0UNEViyI1mmAmHs3R51h/Tma8WjfQkUCG26yyf3EGUPsFNrKD/EM1oJGUunVa8t
         iYaKvQpVaR6V8B2hiqcRO/yx5viVeWySvdLZmfZMZiQwApWWXQaFSLrprwLFUIw2UeoL
         IKhCdQQ+wh5ACdcEIbLpNlIxvCRaIMgDkMPrqBtuZC7un2t2xTH18VnoEr76LVcWxeND
         E+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tDMsrMtxiqqWthW6Wz0Q6T9LnjNH/qRWNCzdPLK/GME=;
        b=OoNCyl697vIOADxX05NCgdkD1fKUTnkM05ELErhv0sBY4CIR1WDO6UVKPtujSFe48w
         3Y/xCRIdfumyZ6AVtxlIIxsq7uU+YjjKhmDP+3eZUf68yPEFF32Ek70zwEmZ4uUrd+Iw
         J0oMX8fa8I1Qkwz+pR38ckM+dBB3ilKqBWQ2P4qQPNxZ3OWlEfkXQcoiAfVJnKM86U6J
         7ZcaXDuQpOLfF7AyWdSxfX4maR7T9NYQx33o2JaSeDlMM80Jyqb37KaqVY2BKiHLOIWf
         3Re5w+wJh6s+Wi7GhfhU3SdvFMnw9n2dhx3RTAl5JlO9G5VGZqLRZk8lUFa4ZgSYZxG1
         4IYA==
X-Gm-Message-State: APjAAAVcvMyaqAgi/1FToSKPrtjezb5tUFeDx5FX7SmbDB3PG05bj/Ec
        3DidUGEc68bqRp+dsaOAiIDjqg0Y
X-Google-Smtp-Source: APXvYqxXQ7VaOo/+JrWKIaF5TCajSgzoBkR0ket+xy1Enx+MnM0eSSGaH7qw/HN1fjWayvXItDodEQ==
X-Received: by 2002:a7b:c30b:: with SMTP id k11mr6563162wmj.36.1581026189430;
        Thu, 06 Feb 2020 13:56:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:ccdf:10a:e87a:1f49? (p200300EA8F296000CCDF010AE87A1F49.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ccdf:10a:e87a:1f49])
        by smtp.googlemail.com with ESMTPSA id o187sm997395wme.36.2020.02.06.13.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 13:56:28 -0800 (PST)
Subject: Re: [PATCH] NET: Realtek depency chain r8169 -> realtec -> libphy
 fixed.
To:     Lauri Jakku <lja@iki.fi>, nic_swsd@realtek.com
Cc:     netdev@vger.kernel.org
References: <20200206185152.2427-1-lja@iki.fi>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a00e09f3-4f79-5ce8-9f45-c0f8717446e2@gmail.com>
Date:   Thu, 6 Feb 2020 22:56:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200206185152.2427-1-lja@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.02.2020 19:51, Lauri Jakku wrote:
>   * Added soft depency from realtec phy to libphy.
> 
> [   39.953438] Generic PHY r8169-200:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
> [   39.957413] ------------[ cut here ]------------
> [   39.957414] read_page callback not available, PHY driver not loaded?
> [   39.957458] WARNING: CPU: 3 PID: 3896 at drivers/net/phy/phy-core.c:700 __phy_read_page+0x3f/0x50 [libphy]
> [   39.957459] Modules linked in: cmac algif_hash algif_skcipher af_alg bnep nls_iso8859_1 nls_cp437 vfat fat squashfs loop videobuf2_vmalloc videobuf2_memops snd_usb_audio videobuf2_v4l2 amdgpu videobuf2_common snd_usbmidi_lib videodev snd_rawmidi snd_seq_device mc btusb btrtl btbcm btintel mousedev input_leds joydev
> bluetooth gpu_sched snd_hda_codec_realtek i2c_algo_bit ttm ecdh_generic snd_hda_codec_generic snd_hda_codec_hdmi rfkill ecc drm_kms_helper ledtrig_audio snd_hda_intel drm snd_intel_dspcfg snd_hda_codec agpgart snd_hda_core syscopyarea sysfillrect sysimgblt snd_hwdep fb_sys_fops snd_pcm snd_timer r8169 snd soundcore eda
> c_mce_amd sp5100_tco kvm_amd i2c_piix4 realtek libphy ccp wmi_bmof ppdev rng_core k10temp kvm irqbypass parport_pc evdev parport mac_hid wmi pcspkr acpi_cpufreq uinput crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom sd_mod ohci_pci pata_atiixp ata_generic pata_acpi firewire_ohci ahci pata_jmicron
> [   39.957483]  firewire_core libahci crc_itu_t libata scsi_mod ehci_pci ehci_hcd ohci_hcd floppy
> [   39.957488] CPU: 3 PID: 3896 Comm: NetworkManager Not tainted 5.5.0-2-MANJARO-usb-mod-v4 #1
> [   39.957489] Hardware name: Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, BIOS F8l 07/15/2010
> [   39.957494] RIP: 0010:__phy_read_page+0x3f/0x50 [libphy]
> [   39.957496] Code: c0 74 05 e9 33 77 3d e9 80 3d cd e3 00 00 00 74 06 b8 a1 ff ff ff c3 48 c7 c7 50 0c 63 c0 c6 05 b7 e3 00 00 01 e8 33 70 86 e8 <0f> 0b eb e3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00
> [   39.957497] RSP: 0018:ffffa459ca3fb3b0 EFLAGS: 00010282
> [   39.957498] RAX: 0000000000000000 RBX: 0000000000006662 RCX: 0000000000000000
> [   39.957499] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 00000000ffffffff
> [   39.957499] RBP: ffff9c91b46c3800 R08: 000000000000047a R09: 0000000000000001
> [   39.957500] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9c91b5a8a8c0
> [   39.957500] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
> [   39.957501] FS:  00007ff199d38d80(0000) GS:ffff9c91b7cc0000(0000) knlGS:0000000000000000
> [   39.957502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   39.957503] CR2: 00007f907f428ff8 CR3: 00000001ed122000 CR4: 00000000000006e0
> [   39.957503] Call Trace:
> [   39.957511]  phy_select_page+0x28/0x50 [libphy]
> [   39.957518]  phy_write_paged+0x18/0x50 [libphy]
> [   39.957523]  rtl8168d_1_hw_phy_config+0x1c8/0x1f0 [r8169]
> [   39.957526]  rtl8169_init_phy+0x2c/0xb0 [r8169]
> [   39.957529]  rtl_open+0x3b2/0x570 [r8169]
> [   39.957533]  __dev_open+0xe0/0x170
> [   39.957535]  __dev_change_flags+0x188/0x1e0
> [   39.957537]  dev_change_flags+0x21/0x60
> [   39.957539]  do_setlink+0x78a/0xf90
> [   39.957544]  ? kernel_init_free_pages+0x6d/0x90
> [   39.957546]  ? prep_new_page+0x46/0xd0
> [   39.957548]  ? cpumask_next+0x16/0x20
> [   39.957550]  ? __snmp6_fill_stats64.isra.0+0x66/0x110
> [   39.957553]  __rtnl_newlink+0x5d1/0x9a0
> [   39.957563]  rtnl_newlink+0x44/0x70
> [   39.957564]  rtnetlink_rcv_msg+0x137/0x3c0
> [   39.957566]  ? rtnl_calcit.isra.0+0x120/0x120
> [   39.957568]  netlink_rcv_skb+0x75/0x140
> [   39.957570]  netlink_unicast+0x199/0x240
> [   39.957572]  netlink_sendmsg+0x243/0x480
> [   39.957575]  sock_sendmsg+0x5e/0x60
> [   39.957576]  ____sys_sendmsg+0x21b/0x290
> [   39.957577]  ? copy_msghdr_from_user+0xe1/0x160
> [   39.957580]  ___sys_sendmsg+0x9e/0xe0
> [   39.957583]  ? addrconf_sysctl_forward+0x12b/0x270
> [   39.957585]  __sys_sendmsg+0x81/0xd0
> [   39.957588]  do_syscall_64+0x4e/0x150
> [   39.957591]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   39.957593] RIP: 0033:0x7ff19af247ed
> [   39.957594] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 4a 53 f8 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 7e 53 f8 ff 48
> [   39.957595] RSP: 002b:00007ffd570ac710 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> [   39.957596] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff19af247ed
> [   39.957596] RDX: 0000000000000000 RSI: 00007ffd570ac750 RDI: 000000000000000c
> [   39.957597] RBP: 0000562f3d390090 R08: 0000000000000000 R09: 0000000000000000
> [   39.957597] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
> [   39.957598] R13: 00007ffd570ac8b0 R14: 00007ffd570ac8ac R15: 0000000000000000
> [   39.957601] ---[ end trace f2cccff3f7fdfb28 ]---
> 
> Signed-off-by: Lauri Jakku <lja@iki.fi>

This patch is not correct for several reasons, most important one being that realtek.ko
has a hard dependency on libphy already. In your case supposedly r8169.ko is in
initramfs but realtek.ko is not. This needs to be changed, then the error should be gone.

> ---
>  drivers/net/phy/realtek.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index f5fa2fff3ddc..4a1d4342c71e 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -54,6 +54,7 @@
>  MODULE_DESCRIPTION("Realtek PHY driver");
>  MODULE_AUTHOR("Johnson Leung");
>  MODULE_LICENSE("GPL");
> +MODULE_SOFTDEP("pre: libphy");
>  
>  static int rtl821x_read_page(struct phy_device *phydev)
>  {
> 

