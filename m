Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D44451755F
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243599AbiEBRJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 13:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243526AbiEBRJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:09:50 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC712195;
        Mon,  2 May 2022 10:06:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g23so17297981edy.13;
        Mon, 02 May 2022 10:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mU7fapiops2WWyU9yZMpO4lszXyDUOiq/JT8oV30im8=;
        b=pIi350sSVm8g4pJHGyg5Juv8HDt3n0XwppTtUoq1Aagl1OwmzaiFKgcc63O9DB0fWm
         OWuHb/a/zf2CPJvEPS52tqPMkpw1m5LFJXrbZEbYLnuTq2Wm/TEIM3EGohRTBrJL/EKd
         JkrPTMCETNd7Z/7D+Cm42x7KWm54l9teeHjHtqQYqtj+eA0S8oZmOdQu2oOcpuZtErx1
         xvgWlfe/Hi8ePHcjK1+88chdVYstEHB33bFZ/oVOUcE4d8bVyO07U727ISfeX963a2XC
         aH0ZgYkovd3IPaWC1ZFUuTYkwHJjC8A2pUOS8JnEVsLRn2iDSWISrPpW7ROFF0ta4UKU
         bNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mU7fapiops2WWyU9yZMpO4lszXyDUOiq/JT8oV30im8=;
        b=LKcIbLSkawxhxlfZwyLjGpMblv4uugSqzxSM8bwhBPIZvTNdt3Q6RMIO9NvbnRIVL6
         n/wM6lAmhcYw+um92AO3HcwOlzfEVIkrzwicO1VtFBlocaZET9VWJCQhlUcBKhYT3i7G
         33J/ERrtFO87pxAfs+zpAbvuqvGIBUe+cFFh8tQttfSopkoztOfD1ju5uqfprKptzcEY
         oL9f9Nf2KS2iLLmjDEFFfl0Duo5pa9Jlkmfgba+m77lY9CEpoHPugayRreUeNgGkSZnR
         piFe8F5wzFdjh65C/DUkWnD8QlF2nLPXdU5orYCy+jaHgH3KaozuhScJM0SfO/gss9gu
         fmXA==
X-Gm-Message-State: AOAM532RTrTH14//q2w2NPWV9L2cBIKwuerx0IllZKat6G4TWa9NDRBZ
        zawuK8lxDkvkvUWx42MfumrPm5f7JL86IddqFrw+PghJfdQ=
X-Google-Smtp-Source: ABdhPJxZphI/AtyVmN3sXaZFd1yCFFSdDJTAznd81vzNonPun1KLBi2QnRnfq0PmbHVVbCoBGSNczkYeKqo/HSCTZk0=
X-Received: by 2002:a05:6402:518b:b0:427:ae8b:a400 with SMTP id
 q11-20020a056402518b00b00427ae8ba400mr11770436edd.52.1651511179135; Mon, 02
 May 2022 10:06:19 -0700 (PDT)
MIME-Version: 1.0
From:   Test Bot <zgrieee@gmail.com>
Date:   Mon, 2 May 2022 21:06:08 +0400
Message-ID: <CAOFRbGkEKemtiU=fSSv5UxcjNfST7E51_XYXEePfM2xkgG=MVw@mail.gmail.com>
Subject: [ERROR] skb: realtek rtw88
To:     netdev@vger.kernel.org
Cc:     linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The v5.18.0-rc4+ kernel was automatically tested.

Hardware:
ASUSTeK TUF Gaming FX505DT

+ wireless driver fail.

Fail Log:

[   17.271683] ------------[ cut here ]------------
[   17.271685] purge skb(s) not reported by firmware
[   17.271713] WARNING: CPU: 1 PID: 0 at
drivers/net/wireless/realtek/rtw88/tx.c:161
rtw_tx_report_purge_timer+0x20/0x50 [rtw88_core]
[   17.271714] Modules linked in: ctr ccm rfcomm cmac algif_hash
algif_skcipher af_alg bnep btusb btrtl btbcm btintel bluetooth
jitterentropy_rng usbhid edac_mce_amd rtw88_8821ce kvm_amd rtw88_8821c
uvcvideo rtw88_pci rtw88_core videobuf2_vmalloc videobuf2_memops
videobuf2_v4l2 kvm videobuf2_common drbg videodev
snd_hda_codec_realtek ansi_cprng snd_hda_codec_generic ecdh_generic
mac80211 irqbypass mc ledtrig_audio snd_hda_codec_hdmi ecc
snd_hda_intel snd_intel_dspcfg nvidia_drm(POE) ccp soundwire_intel
soundwire_generic_allocation joydev ghash_clmulni_intel snd_soc_core
cfg80211 nls_ascii nls_cp437 snd_compress nvidia_modeset(POE)
soundwire_cadence aesni_intel snd_hda_codec asus_nb_wmi asus_wmi
libaes vfat crypto_simd fat snd_hda_core cryptd glue_helper snd_hwdep
soundwire_bus rapl snd_pcm snd_timer serio_raw sp5100_tco tpm_crb
pcspkr snd sparse_keymap efi_pstore wmi_bmof hid_multitouch rfkill
tpm_tis k10temp soundcore libarc4 watchdog tpm_tis_core tpm rng_core
ac evdev asus_wireless
[   17.271766]  acpi_cpufreq nvidia(POE) msr parport_pc ppdev lp
parport fuse configfs efivarfs ip_tables x_tables autofs4 ext4 crc16
mbcache jbd2 crc32c_generic amdgpu dm_mod gpu_sched i2c_algo_bit ttm
drm_kms_helper xhci_pci nvme xhci_hcd nvme_core r8169 cec t10_pi
realtek hid_generic crc_t10dif mdio_devres crct10dif_generic drm
usbcore crct10dif_pclmul crc32_pclmul crc32c_intel i2c_hid libphy
i2c_piix4 usb_common crct10dif_common wmi hid video battery button
[   17.271798] CPU: 1 PID: 0 Comm: swapper/1 Tainted: P           OE
  5.10.0-13-amd64 #1 Debian 5.10.106-1
[   17.271800] Hardware name: ASUSTeK COMPUTER INC. TUF Gaming
FX505DT_FX505DT/FX505DT, BIOS FX505DT.316 01/28/2021
[   17.271805] RIP: 0010:rtw_tx_report_purge_timer+0x20/0x50 [rtw88_core]
[   17.271808] Code: 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00 8b
47 f0 85 c0 75 01 c3 41 54 55 53 48 89 fb 48 c7 c7 f8 a4 43 c3 e8 bf
93 a5 d2 <0f> 0b 4c 8d 63 d8 4c 89 e7 e8 02 ea a9 d2 48 8d 7b e0 48 89
c5 e8
[   17.271809] RSP: 0018:ffffade60007ced0 EFLAGS: 00010286
[   17.271811] RAX: 0000000000000000 RBX: ffff9356482f62e8 RCX: ffff93575725ca08
[   17.271812] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff93575725ca00
[   17.271812] RBP: ffff9356482f62e8 R08: 0000000000000000 R09: ffffade60007ccf0
[   17.271813] R10: ffffade60007cce8 R11: ffffffff96ccb408 R12: ffffffffc3427c00
[   17.271814] R13: dead000000000122 R14: 0000000000000000 R15: ffff935757260c40
[   17.271816] FS:  0000000000000000(0000) GS:ffff935757240000(0000)
knlGS:0000000000000000
[   17.271817] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.271818] CR2: 00007fc3777fcf08 CR3: 0000000105f9c000 CR4: 00000000003506e0
[   17.271819] Call Trace:
[   17.271821]  <IRQ>
[   17.271828]  ? rtw_tx_write_data_h2c_get+0x90/0x90 [rtw88_core]
[   17.271831]  call_timer_fn+0x29/0xf0
[   17.271833]  __run_timers.part.0+0x1d3/0x240
[   17.271837]  ? recalibrate_cpu_khz+0x10/0x10
[   17.271839]  ? ktime_get+0x38/0xa0
[   17.271842]  ? native_x2apic_icr_read+0x10/0x10
[   17.271844]  ? lapic_next_event+0x1d/0x20
[   17.271846]  ? clockevents_program_event+0x8d/0xf0
[   17.271848]  run_timer_softirq+0x26/0x50
[   17.271851]  __do_softirq+0xc5/0x275
[   17.271853]  asm_call_irq_on_stack+0x12/0x20
[   17.271854]  </IRQ>
[   17.271857]  do_softirq_own_stack+0x37/0x40
[   17.271860]  irq_exit_rcu+0x8e/0xc0
[   17.271863]  sysvec_apic_timer_interrupt+0x36/0x80
[   17.271864]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   17.271868] RIP: 0010:cpuidle_enter_state+0xc7/0x350
[   17.271869] Code: 8b 3d 1d 23 37 6a e8 28 d8 a1 ff 49 89 c5 0f 1f
44 00 00 31 ff e8 39 e3 a1 ff 45 84 ff 0f 85 fa 00 00 00 fb 66 0f 1f
44 00 00 <45> 85 f6 0f 88 06 01 00 00 49 63 c6 4c 2b 2c 24 48 8d 14 40
48 8d
[   17.271870] RSP: 0018:ffffade60013fea8 EFLAGS: 00000246
[   17.271871] RAX: ffff93575726fcc0 RBX: 0000000000000001 RCX: 000000000000001f
[   17.271872] RDX: 0000000000000000 RSI: 000000003d112200 RDI: 0000000000000000
[   17.271873] RBP: ffff935660d58400 R08: 000000040578d501 R09: 0000000000000018
[   17.271874] R10: 0000000000000282 R11: 00000000000000b1 R12: ffffffff96db9180
[   17.271875] R13: 000000040578d501 R14: 0000000000000001 R15: 0000000000000000
[   17.271878]  ? cpuidle_enter_state+0xb7/0x350
[   17.271880]  cpuidle_enter+0x29/0x40
[   17.271882]  do_idle+0x1ef/0x2b0
[   17.271884]  cpu_startup_entry+0x19/0x20
[   17.271887]  secondary_startup_64_no_verify+0xb0/0xbb
[   17.271889] ---[ end trace 0336ae1c9c67abd1 ]---
