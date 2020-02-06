Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04F0154F81
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 00:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgBFXry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 18:47:54 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33302 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgBFXry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 18:47:54 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so309470lfl.0
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 15:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YRKHZcS28nTCvZ3OmGeZmuFHTmjCqwmW93t74uwW0Kw=;
        b=tyltA8wpK3JGxUB5PsqW1iTiVkbkdMYOW9xXloiAUeGhvSKfrVVD8JJhFgNNJiI8cQ
         LsIz84gbP6jNbNi8bEaycvgzFq5gqnPSora1Ut1doAm00+YcOmglXCaIOKJcZF2fl7uC
         6sDS4zTIeydfhnqnRtEw5w3wuctTkTkqG7W1uo42Xu7i/9KoA/WcEFjY35PAdAMf/S+l
         RWufUsmJEEJ92t7IWLiyj7qEDai8igrLexi8wAE0SZsq3rD8OIAUYEL45VK6S8u147c2
         B7cR0BOSceGqLyhyMDiaFoE242+2yEU1jC2CWiiDn5WvYvasHrR6C699+Vw54jfS42VW
         hbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YRKHZcS28nTCvZ3OmGeZmuFHTmjCqwmW93t74uwW0Kw=;
        b=SSWhCsJ/CHFCHi3/zgxBXkG4MUMyTp5rDG9cvVRx84LWKku8hp9MvNY85ls3Ji2r+c
         hU6bKRwD7+xm2/3tSbKq6K1Wzye7RLA0WxmZu1sBHpfVBIpowl/UU/vn7gNi6he6pNkH
         8LPhXPRCet5TuR3uDcWlK3nKy1nH3O8WhVFYI7b/SE+pqLiC1s6kxFj79ih9XFrAqjxh
         QnO9u06YcTjQTgXMZDUlLUltOI/HZerb0JGmts5NTg5T7rVcS9/SJx2RJJspsv3Um3ec
         Uz5DwoS+2YpvWmqqqhbBbUpZStNTQtnYdVwsjMeG9L58asDCBzP35/E+kdCIylrUumzr
         f3jw==
X-Gm-Message-State: APjAAAXqzWIciNDNxMdymtAbcAiEoDUQ8j7KflREo4+m6wlsWpjK7qBt
        cIeh1jpw5aOV/J4QzAmw9Utw57CAn5w=
X-Google-Smtp-Source: APXvYqxdFuuFtuBhRFF523L0M1qtU/yQBQ+LVezIRszBnrUqdBN5r/EB6Z+XkezB2A9/jL5tI7fS2A==
X-Received: by 2002:a19:228c:: with SMTP id i134mr3080844lfi.2.1581032870792;
        Thu, 06 Feb 2020 15:47:50 -0800 (PST)
Received: from ?IPv6:2001:2003:f41e:c300:224:1dff:fe12:e61a? ([2001:2003:f41e:c300:224:1dff:fe12:e61a])
        by smtp.gmail.com with ESMTPSA id l12sm333440lji.52.2020.02.06.15.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 15:47:49 -0800 (PST)
Subject: Re: [PATCH] NET: Realtek depency chain r8169 -> realtec -> libphy
 fixed.
From:   Lauri Jakku <ljakku77@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>, Lauri Jakku <lja@iki.fi>,
        nic_swsd@realtek.com
Cc:     netdev@vger.kernel.org
References: <20200206185152.2427-1-lja@iki.fi>
 <a00e09f3-4f79-5ce8-9f45-c0f8717446e2@gmail.com>
 <357bc619-457d-8470-abcc-282641fbe22d@gmail.com>
 <f607cc60-48d7-8b35-41d6-361af163fc8e@gmail.com>
 <3c530d00-4588-cd2c-6a69-0a7089d13d6d@gmail.com>
 <4b7cdd3e-f244-8458-f5a2-1f1da79fa4a3@gmail.com>
Message-ID: <0f5b04f9-6468-0c4f-f6b9-ab4e633feba8@gmail.com>
Date:   Fri, 7 Feb 2020 01:47:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <4b7cdd3e-f244-8458-f5a2-1f1da79fa4a3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-02-07 00:56, Lauri Jakku wrote:
> Hi,
>
> Toughts while compiling:
>
> On 2020-02-07 00:39, Lauri Jakku wrote:
>> Hi,
>>
>> On 2020-02-07 00:36, Heiner Kallweit wrote:
>>> On 06.02.2020 23:20, Lauri Jakku wrote:
>>>> On 2020-02-06 23:56, Heiner Kallweit wrote:
>>>>> On 06.02.2020 19:51, Lauri Jakku wrote:
>>>>>>   * Added soft depency from realtec phy to libphy.
>>>>>>
>>>>>> [   39.953438] Generic PHY r8169-200:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
>>>>>> [   39.957413] ------------[ cut here ]------------
>>>>>> [   39.957414] read_page callback not available, PHY driver not loaded?
>>>>>> [   39.957458] WARNING: CPU: 3 PID: 3896 at drivers/net/phy/phy-core.c:700 __phy_read_page+0x3f/0x50 [libphy]
>>>>>> [   39.957459] Modules linked in: cmac algif_hash algif_skcipher af_alg bnep nls_iso8859_1 nls_cp437 vfat fat squashfs loop videobuf2_vmalloc videobuf2_memops snd_usb_audio videobuf2_v4l2 amdgpu videobuf2_common snd_usbmidi_lib videodev snd_rawmidi snd_seq_device mc btusb btrtl btbcm btintel mousedev input_leds joydev
>>>>>> bluetooth gpu_sched snd_hda_codec_realtek i2c_algo_bit ttm ecdh_generic snd_hda_codec_generic snd_hda_codec_hdmi rfkill ecc drm_kms_helper ledtrig_audio snd_hda_intel drm snd_intel_dspcfg snd_hda_codec agpgart snd_hda_core syscopyarea sysfillrect sysimgblt snd_hwdep fb_sys_fops snd_pcm snd_timer r8169 snd soundcore eda
>>>>>> c_mce_amd sp5100_tco kvm_amd i2c_piix4 realtek libphy ccp wmi_bmof ppdev rng_core k10temp kvm irqbypass parport_pc evdev parport mac_hid wmi pcspkr acpi_cpufreq uinput crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom sd_mod ohci_pci pata_atiixp ata_generic pata_acpi firewire_ohci ahci pata_jmicron
>>>>>> [   39.957483]  firewire_core libahci crc_itu_t libata scsi_mod ehci_pci ehci_hcd ohci_hcd floppy
>>>>>> [   39.957488] CPU: 3 PID: 3896 Comm: NetworkManager Not tainted 5.5.0-2-MANJARO-usb-mod-v4 #1
>>>>>> [   39.957489] Hardware name: Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, BIOS F8l 07/15/2010
>>>>>> [   39.957494] RIP: 0010:__phy_read_page+0x3f/0x50 [libphy]
>>>>>> [   39.957496] Code: c0 74 05 e9 33 77 3d e9 80 3d cd e3 00 00 00 74 06 b8 a1 ff ff ff c3 48 c7 c7 50 0c 63 c0 c6 05 b7 e3 00 00 01 e8 33 70 86 e8 <0f> 0b eb e3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00
>>>>>> [   39.957497] RSP: 0018:ffffa459ca3fb3b0 EFLAGS: 00010282
>>>>>> [   39.957498] RAX: 0000000000000000 RBX: 0000000000006662 RCX: 0000000000000000
>>>>>> [   39.957499] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 00000000ffffffff
>>>>>> [   39.957499] RBP: ffff9c91b46c3800 R08: 000000000000047a R09: 0000000000000001
>>>>>> [   39.957500] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9c91b5a8a8c0
>>>>>> [   39.957500] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
>>>>>> [   39.957501] FS:  00007ff199d38d80(0000) GS:ffff9c91b7cc0000(0000) knlGS:0000000000000000
>>>>>> [   39.957502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>> [   39.957503] CR2: 00007f907f428ff8 CR3: 00000001ed122000 CR4: 00000000000006e0
>>>>>> [   39.957503] Call Trace:
>>>>>> [   39.957511]  phy_select_page+0x28/0x50 [libphy]
>>>>>> [   39.957518]  phy_write_paged+0x18/0x50 [libphy]
>>>>>> [   39.957523]  rtl8168d_1_hw_phy_config+0x1c8/0x1f0 [r8169]
>>>>>> [   39.957526]  rtl8169_init_phy+0x2c/0xb0 [r8169]
>>>>>> [   39.957529]  rtl_open+0x3b2/0x570 [r8169]
>>>>>> [   39.957533]  __dev_open+0xe0/0x170
>>>>>> [   39.957535]  __dev_change_flags+0x188/0x1e0
>>>>>> [   39.957537]  dev_change_flags+0x21/0x60
>>>>>> [   39.957539]  do_setlink+0x78a/0xf90
>>>>>> [   39.957544]  ? kernel_init_free_pages+0x6d/0x90
>>>>>> [   39.957546]  ? prep_new_page+0x46/0xd0
>>>>>> [   39.957548]  ? cpumask_next+0x16/0x20
>>>>>> [   39.957550]  ? __snmp6_fill_stats64.isra.0+0x66/0x110
>>>>>> [   39.957553]  __rtnl_newlink+0x5d1/0x9a0
>>>>>> [   39.957563]  rtnl_newlink+0x44/0x70
>>>>>> [   39.957564]  rtnetlink_rcv_msg+0x137/0x3c0
>>>>>> [   39.957566]  ? rtnl_calcit.isra.0+0x120/0x120
>>>>>> [   39.957568]  netlink_rcv_skb+0x75/0x140
>>>>>> [   39.957570]  netlink_unicast+0x199/0x240
>>>>>> [   39.957572]  netlink_sendmsg+0x243/0x480
>>>>>> [   39.957575]  sock_sendmsg+0x5e/0x60
>>>>>> [   39.957576]  ____sys_sendmsg+0x21b/0x290
>>>>>> [   39.957577]  ? copy_msghdr_from_user+0xe1/0x160
>>>>>> [   39.957580]  ___sys_sendmsg+0x9e/0xe0
>>>>>> [   39.957583]  ? addrconf_sysctl_forward+0x12b/0x270
>>>>>> [   39.957585]  __sys_sendmsg+0x81/0xd0
>>>>>> [   39.957588]  do_syscall_64+0x4e/0x150
>>>>>> [   39.957591]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>>> [   39.957593] RIP: 0033:0x7ff19af247ed
>>>>>> [   39.957594] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 4a 53 f8 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 7e 53 f8 ff 48
>>>>>> [   39.957595] RSP: 002b:00007ffd570ac710 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
>>>>>> [   39.957596] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff19af247ed
>>>>>> [   39.957596] RDX: 0000000000000000 RSI: 00007ffd570ac750 RDI: 000000000000000c
>>>>>> [   39.957597] RBP: 0000562f3d390090 R08: 0000000000000000 R09: 0000000000000000
>>>>>> [   39.957597] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
>>>>>> [   39.957598] R13: 00007ffd570ac8b0 R14: 00007ffd570ac8ac R15: 0000000000000000
>>>>>> [   39.957601] ---[ end trace f2cccff3f7fdfb28 ]---
>>>>>>
>>>>>> Signed-off-by: Lauri Jakku <lja@iki.fi>
>>>>> This patch is not correct for several reasons, most important one being that realtek.ko
>>>>> has a hard dependency on libphy already. In your case supposedly r8169.ko is in
>>>>> initramfs but realtek.ko is not. This needs to be changed, then the error should be gone.
>>>> Yeah, I tried to make a depency chain that would load realtek.ko before probing
>>>>
>>>> at r8169 driver.
>>>>
>>> This soft dependency is included in r8169 already. Just if r8169.ko is in initramfs then it
>>> can't load realtek.ko if it's not in initramfs.
>>>> Should i make realtek.ko as build-in to kernel, or how one enforces module to initramfs ?
>>>>
>>> Check mkinitcpio.conf. Some distributions may have own tools for configuring initramfs.
>>> Ubuntu has lsinitramfs for checking what's included in a particular initramfs file.
>> Ok, will do.
> I saw that there is no MODULE_SOFTDEP done, witch I think triggers the mechanism
>
> to load realtek.ko (i put in in initramfs now, hopefully). I'm not sure what does the
>
> code at r8169_main.c:
>
>
>        /* Some tools for creating an initramfs don't consider softdeps, then
>
>          * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
>          * PHY driver is used that doesn't work with most chip versions.
>          */
>         if (!driver_find("RTL8201CP Ethernet", &mdio_bus_type)) {
>                 dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>                 return -ENOENT;
>         }
>
> Trigger module loading without this patch ?
>
I just noticed, that the realtek.ko is loaded, and libphy when this happens. The

   rtl8168d_1_hw_phy_config+0x1c8/0x1f0 [r8169] is the reason


@MinistryOfSillyWalk realtek]$ lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 Host Bridge
00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (external gfx0 port A)
00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (PCI express gpp port D)
00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port E)
00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port F)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB OHCI1 Controller
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB OHCI1 Controller
00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller (rev 3a)
00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 IDE Controller
00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 LPC host controller
00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI Bridge
00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] (rev e7)
01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590]

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03)

04:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02)
04:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02)
05:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link)

Rev 3 (RTL_GIGA_MAC_VER_03) function pointer should be used instead of RTL_GIGA_MAC_VER_25.. before i change anything heavily 
i wonder why the indexing error ?

>>>>>> ---
>>>>>>  drivers/net/phy/realtek.c | 1 +
>>>>>>  1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>>>>>> index f5fa2fff3ddc..4a1d4342c71e 100644
>>>>>> --- a/drivers/net/phy/realtek.c
>>>>>> +++ b/drivers/net/phy/realtek.c
>>>>>> @@ -54,6 +54,7 @@
>>>>>>  MODULE_DESCRIPTION("Realtek PHY driver");
>>>>>>  MODULE_AUTHOR("Johnson Leung");
>>>>>>  MODULE_LICENSE("GPL");
>>>>>> +MODULE_SOFTDEP("pre: libphy");
>>>>>>  
>>>>>>  static int rtl821x_read_page(struct phy_device *phydev)
>>>>>>  {
>>>>>>

