Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE1251F307
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 05:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiEIDtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 23:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiEIDks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 23:40:48 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A969AABF73
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 20:36:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p8so11147038pfh.8
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 20:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=saahcU8Gxy1zQvPPjnx+YvTy3qLLAMOIXdNRhIoez2w=;
        b=1TfGpJsvkqAEdbSzf0irDvWIkG+xep/+uI5WJ2x0W5xTJ/bL7HDHCIko2fgPY4x54K
         DzoOXGawM5L+WanTuc1CaLRPMpLEXnrP/XfB9yhfN79rTox066bB0y5fmbM6StSsCwwO
         4yPJiGSj6knXbXe3gL09s3U/zjDeoyErw3dWZifv1JyCso/gaz+DIvUSubRd2DacALo9
         iVcF7PVbc5Rer0Z29JEZThsY5XiMCTa9BfEoXFo1BEf0TsCgrjqdOo62bo3qSe8fMnCL
         95SoMTaFDyduBINnLtMxtfsswgkvRSITnEaazfbKDUMXicVOw/J+I3fwQSa2U9yTo3L0
         oyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=saahcU8Gxy1zQvPPjnx+YvTy3qLLAMOIXdNRhIoez2w=;
        b=mfVZ7NuJck24PwQxlcqeRo3YsQesZFifY8qT/I9inFelv5ezSscx+SVyGo4fndBrGk
         3v7a/z3U0o/LbRoQlJtpcK+aKN9MtnGBioHK91234Uqn/ZqsWTyQG7U/efaMSAxOeyaS
         hN8WBNAKp7yWvWcNlUwy5fnmwg7zJHZUotqrXPkZ374z/PWa7xEoBwiHvZWSIWFdISvk
         MH78eECzdJR/5RXpgk5UQOr4wFtglM6fCmhp9StSJZYSKn9Nu1bw2IBbPEPyDlw0qGIC
         EZZu8SRkB/WuI3muxV6VvJjbD0YpiNTVGf73c/9xq634+YwbOhZ40v2k0x8lGmIfjWkI
         fexw==
X-Gm-Message-State: AOAM532SrfnEPLGM4GqLjzK9BS5b24oIh7DbIiIgDUONWQpJ8Zb9Z+ss
        XewGxmOj0ck59fEW0JLR9/RjlnDq6wFO0w==
X-Google-Smtp-Source: ABdhPJwV7v9L1fRh2X4hD8dgVpePaVFqP3cMDspl8AxvzdWGrkNZ2BuIejU1P167Iz6EThbuXGLmBw==
X-Received: by 2002:a63:8442:0:b0:3c6:4271:cad with SMTP id k63-20020a638442000000b003c642710cadmr11736813pgd.275.1652067415103;
        Sun, 08 May 2022 20:36:55 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79ace000000b005107a4d5096sm5889535pfp.30.2022.05.08.20.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 20:36:54 -0700 (PDT)
Date:   Sun, 8 May 2022 20:36:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     tony0620emma@gmail.com, kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Fw: [Bug 215959] New: net: realtek: rtw88: firmware is not good
Message-ID: <20220508203651.606658c6@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 09 May 2022 01:22:51 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215959] New: net: realtek: rtw88: firmware is not good


https://bugzilla.kernel.org/show_bug.cgi?id=215959

            Bug ID: 215959
           Summary: net: realtek: rtw88: firmware is not good
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10.0-14
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: o@zgur.org
        Regression: No

Hello,

i have been getting this error for a while and firmware seems to have not good
worked maybe didnt support when bandwidth was changed.


[ 6688.175436] ------------[ cut here ]------------
[ 6688.175438] purge skb(s) not reported by firmware
[ 6688.175466] WARNING: CPU: 0 PID: 0 at
drivers/net/wireless/realtek/rtw88/tx.c:161 rtw_tx_report_purge_timer+0x20/0x50
[rtw88_core]
[ 6688.175467] Modules linked in: ctr ccm uinput rfcomm cmac algif_hash
algif_skcipher af_alg bnep btusb btrtl btbcm btintel bluetooth uvcvideo
videobuf2_vmalloc videobuf2_memops usbhid videobuf2_v4l2 videobuf2_common
jitterentropy_rng videodev drbg mc edac_mce_amd ansi_cprng ecdh_generic ecc
rtw88_8821ce rtw88_8821c rtw88_pci rtw88_core mac80211 kvm_amd ccp joydev
cfg80211 kvm snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio
snd_hda_codec_hdmi irqbypass snd_hda_intel nls_ascii snd_intel_dspcfg
soundwire_intel nls_cp437 soundwire_generic_allocation asus_nb_wmi
nvidia_drm(POE) asus_wmi vfat ghash_clmulni_intel snd_soc_core fat snd_compress
soundwire_cadence snd_hda_codec aesni_intel snd_hda_core libaes snd_hwdep
crypto_simd nvidia_modeset(POE) soundwire_bus cryptd glue_helper snd_pcm
snd_timer serio_raw pcspkr sparse_keymap efi_pstore rapl rfkill wmi_bmof snd
hid_multitouch libarc4 soundcore sp5100_tco watchdog k10temp tpm_crb tpm_tis
tpm_tis_core tpm ac rng_core asus_wireless evdev
[ 6688.175513]  acpi_cpufreq nvidia(POE) msr parport_pc ppdev lp parport fuse
configfs efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2
crc32c_generic amdgpu dm_mod xhci_pci xhci_hcd gpu_sched i2c_algo_bit ttm
usbcore nvme drm_kms_helper nvme_core r8169 t10_pi realtek cec crc_t10dif
hid_generic mdio_devres crct10dif_generic crct10dif_pclmul drm crc32_pclmul
crc32c_intel libphy i2c_piix4 usb_common crct10dif_common wmi i2c_hid video
battery hid button
[ 6688.175541] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P        W  OE    
5.10.0-14-amd64 #1 Debian 5.10.113-1
[ 6688.175542] Hardware name: ASUSTeK COMPUTER INC. TUF Gaming
FX505DT_FX505DT/FX505DT, BIOS FX505DT.316 01/28/2021
[ 6688.175548] RIP: 0010:rtw_tx_report_purge_timer+0x20/0x50 [rtw88_core]
[ 6688.175550] Code: 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00 8b 47 f0 85
c0 75 01 c3 41 54 55 53 48 89 fb 48 c7 c7 f8 f4 24 c3 e8 be 53 c4 d9 <0f> 0b 4c
8d 63 d8 4c 89 e7 e8 b2 a7 c8 d9 48 8d 7b e0 48 89 c5 e8
[ 6688.175551] RSP: 0018:ffffb0f640003ed0 EFLAGS: 00010286
[ 6688.175553] RAX: 0000000000000000 RBX: ffff9169039962e8 RCX:
ffff916a1721ca08
[ 6688.175554] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI:
ffff916a1721ca00
[ 6688.175555] RBP: ffff9169039962e8 R08: 0000000000000000 R09:
ffffb0f640003cf0
[ 6688.175555] R10: ffffb0f640003ce8 R11: ffffffff9dccb408 R12:
ffffffffc323cc00
[ 6688.175556] R13: dead000000000122 R14: 0000000000000000 R15:
ffff916a17220c40
[ 6688.175557] FS:  0000000000000000(0000) GS:ffff916a17200000(0000)
knlGS:0000000000000000
[ 6688.175558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6688.175559] CR2: 000014ba0e585000 CR3: 00000001b0124000 CR4:
00000000003506f0
[ 6688.175560] Call Trace:
[ 6688.175563]  <IRQ>
[ 6688.175569]  ? rtw_tx_write_data_h2c_get+0x90/0x90 [rtw88_core]
[ 6688.175572]  call_timer_fn+0x29/0xf0
[ 6688.175574]  __run_timers.part.0+0x1d5/0x250
[ 6688.175577]  ? recalibrate_cpu_khz+0x10/0x10
[ 6688.175579]  ? ktime_get+0x38/0xa0
[ 6688.175581]  ? native_x2apic_icr_read+0x10/0x10
[ 6688.175582]  ? lapic_next_event+0x1d/0x20
[ 6688.175585]  ? clockevents_program_event+0x8d/0xf0
[ 6688.175586]  run_timer_softirq+0x26/0x50
[ 6688.175589]  __do_softirq+0xc5/0x275
[ 6688.175591]  asm_call_irq_on_stack+0x12/0x20
[ 6688.175592]  </IRQ>
[ 6688.175594]  do_softirq_own_stack+0x37/0x40
[ 6688.175597]  irq_exit_rcu+0x8e/0xc0
[ 6688.175600]  sysvec_apic_timer_interrupt+0x36/0x80
[ 6688.175602]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[ 6688.175605] RIP: 0010:cpuidle_enter_state+0xc7/0x350
[ 6688.175606] Code: 8b 3d ed 17 37 63 e8 f8 cc a1 ff 49 89 c5 0f 1f 44 00 00
31 ff e8 09 d8 a1 ff 45 84 ff 0f 85 fa 00 00 00 fb 66 0f 1f 44 00 00 <45> 85 f6
0f 88 06 01 00 00 49 63 c6 4c 2b 2c 24 48 8d 14 40 48 8d
[ 6688.175607] RSP: 0018:ffffffff9dc03e70 EFLAGS: 00000246
[ 6688.175608] RAX: ffff916a1722fcc0 RBX: 0000000000000001 RCX:
000000000000001f
[ 6688.175609] RDX: 0000000000000000 RSI: 000000003d112200 RDI:
0000000000000000
[ 6688.175610] RBP: ffff916911da1800 R08: 000006153651edd3 R09:
0000000000000018
[ 6688.175611] R10: 000000000000018f R11: 0000000000000013 R12:
ffffffff9ddb9140
[ 6688.175611] R13: 000006153651edd3 R14: 0000000000000001 R15:
0000000000000000
[ 6688.175614]  cpuidle_enter+0x29/0x40
[ 6688.175617]  do_idle+0x1ef/0x2b0
[ 6688.175619]  cpu_startup_entry+0x19/0x20
[ 6688.175622]  start_kernel+0x587/0x5a8
[ 6688.175626]  secondary_startup_64_no_verify+0xb0/0xbb
[ 6688.175628] ---[ end trace dada0beabe9d5364 ]---

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
