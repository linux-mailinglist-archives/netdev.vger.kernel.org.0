Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0BD153692
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 18:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgBERcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 12:32:16 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:17810 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgBERcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 12:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580923931;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Date:Message-ID:Subject:From:Cc:To:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=+wzSZ6vN4sAVuCcf6W2xSlkM1Qf4K4sB/WazCDJnRo0=;
        b=XnMYiCjSYoEVZttWjc/UnK81osR8h0qDVfJJsrryc23UcZYxHjasMzDoJ6y85BzA5R
        5/GxBoIf2Oxw3DmRZQTK3gLcKQGHhqieyDgrT18k+8dRue1fQcRVRSjpIpdjyOv5pm1U
        Zk6fZj8TkOziGG4bAfjdVXuGdnylu7JKxp0e9g8VWKvyTHvCkDVAEZlJF8N5XE35wUuL
        vv5HRgUgV4lHwX/6ZX8aAzh/ab1WR/CIBBbLpysBbBaEyG5F1jINSaadPo6SABgss+wc
        1PUwLFkR5URnrBxv96gDXIhnfgYdGTuBpJNdcyScikNm5GzcmuGOpUOhIw2SVQZAJAU9
        2fRg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVMh7kiA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id g084e8w15HW8HH3
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 5 Feb 2020 18:32:08 +0100 (CET)
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Subject: WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:443
 dev_watchdog+0x254/0x260
Message-ID: <b3258eef-d9fa-3106-eb03-591f41662351@hartkopp.net>
Date:   Wed, 5 Feb 2020 18:32:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I attached a PocketBeagle board
https://docs.macchina.cc/p1-docs
to my USB port and -reproducible- got the WARNING message below.

The kernel is the latest merge window stuff from Linus' tree.

Any idea?

Regards,
Oliver


Feb  5 11:33:23 silver kernel: [    0.000000] Linux version 
5.5.0-09386-g33b40134e5cf (hartko@silver) (gcc version 8.3.0 (Debian 
8.3.0-6)) #88 SMP Tue Feb 4 16:44:00 CET 2020
(..)
Feb  5 12:23:03 silver kernel: [ 2989.043917] usb 1-2: new high-speed 
USB device number 9 using xhci_hcd
Feb  5 12:23:03 silver kernel: [ 2989.064507] usb 1-2: New USB device 
found, idVendor=1d6b, idProduct=0104, bcdDevice= 4.04
Feb  5 12:23:03 silver kernel: [ 2989.064513] usb 1-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Feb  5 12:23:03 silver kernel: [ 2989.064517] usb 1-2: Product: BeagleBone
Feb  5 12:23:03 silver kernel: [ 2989.064520] usb 1-2: Manufacturer: 
BeagleBoard.org
Feb  5 12:23:03 silver kernel: [ 2989.064522] usb 1-2: SerialNumber: 
1740GPB21127
Feb  5 12:23:03 silver kernel: [ 2989.098290] cdc_ether 1-2:1.3 eth0: 
register 'cdc_ether' at usb-0000:00:14.0-2, CDC Ethernet Device, 
60:64:05:6a:93:d0
Feb  5 12:23:03 silver kernel: [ 2989.099648] SCSI subsystem initialized
Feb  5 12:23:03 silver kernel: [ 2989.102426] usbcore: registered new 
interface driver cdc_ether
Feb  5 12:23:03 silver kernel: [ 2989.103603] usb-storage 1-2:1.2: USB 
Mass Storage device detected
Feb  5 12:23:03 silver kernel: [ 2989.103658] scsi host0: usb-storage 
1-2:1.2
Feb  5 12:23:03 silver kernel: [ 2989.103748] usbcore: registered new 
interface driver usb-storage
Feb  5 12:23:03 silver kernel: [ 2989.107234] rndis_host 1-2:1.0 eth1: 
register 'rndis_host' at usb-0000:00:14.0-2, RNDIS device, 60:64:05:6a:93:cd
Feb  5 12:23:03 silver kernel: [ 2989.107501] usbcore: registered new 
interface driver uas
Feb  5 12:23:03 silver kernel: [ 2989.110189] usbcore: registered new 
interface driver rndis_host
Feb  5 12:23:03 silver kernel: [ 2989.122109] cdc_ether 1-2:1.3 
enx6064056a93d0: renamed from eth0
Feb  5 12:23:03 silver kernel: [ 2989.143794] rndis_host 1-2:1.0 
enx6064056a93cd: renamed from eth1
Feb  5 12:23:04 silver kernel: [ 2990.116509] scsi 0:0:0:0: 
Direct-Access     Linux    File-Stor Gadget 0414 PQ: 0 ANSI: 2
Feb  5 12:23:04 silver kernel: [ 2990.127889] scsi 0:0:0:0: Attached 
scsi generic sg0 type 0
Feb  5 12:23:04 silver kernel: [ 2990.134184] sd 0:0:0:0: Power-on or 
device reset occurred
Feb  5 12:23:04 silver kernel: [ 2990.134719] sd 0:0:0:0: [sda] 36864 
512-byte logical blocks: (18.9 MB/18.0 MiB)
Feb  5 12:23:04 silver kernel: [ 2990.134915] sd 0:0:0:0: [sda] Write 
Protect is on
Feb  5 12:23:04 silver kernel: [ 2990.134919] sd 0:0:0:0: [sda] Mode 
Sense: 0f 00 80 00
Feb  5 12:23:04 silver kernel: [ 2990.135085] sd 0:0:0:0: [sda] Write 
cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb  5 12:23:04 silver kernel: [ 2990.155935]  sda: sda1
Feb  5 12:23:04 silver kernel: [ 2990.158114] sd 0:0:0:0: [sda] Attached 
SCSI removable disk
Feb  5 12:51:43 silver kernel: [ 4709.538511] usb 1-2: USB disconnect, 
device number 9
Feb  5 12:51:43 silver kernel: [ 4709.538714] rndis_host 1-2:1.0 
enx6064056a93cd: unregister 'rndis_host' usb-0000:00:14.0-2, RNDIS device
Feb  5 12:51:43 silver kernel: [ 4709.620838] cdc_ether 1-2:1.3 
enx6064056a93d0: unregister 'cdc_ether' usb-0000:00:14.0-2, CDC Ethernet 
Device
Feb  5 12:51:44 silver kernel: [ 4709.916748] usb 1-2: new full-speed 
USB device number 10 using xhci_hcd
Feb  5 12:51:44 silver kernel: [ 4710.064836] usb 1-2: not running at 
top speed; connect to a high speed hub
Feb  5 12:51:44 silver kernel: [ 4710.066123] usb 1-2: New USB device 
found, idVendor=0451, idProduct=6141, bcdDevice= 0.00
Feb  5 12:51:44 silver kernel: [ 4710.066129] usb 1-2: New USB device 
strings: Mfr=33, Product=37, SerialNumber=0
Feb  5 12:51:44 silver kernel: [ 4710.066133] usb 1-2: Product: AM335x USB
Feb  5 12:51:44 silver kernel: [ 4710.066135] usb 1-2: Manufacturer: 
Texas Instruments
Feb  5 12:51:44 silver kernel: [ 4710.110908] rndis_host 1-2:1.0 usb0: 
register 'rndis_host' at usb-0000:00:14.0-2, RNDIS device, 7e:ed:c6:26:73:7d
Feb  5 12:51:44 silver kernel: [ 4710.127696] rndis_host 1-2:1.0 
enp0s20f0u2: renamed from usb0
Feb  5 12:56:05 silver kernel: [ 4971.619914] usb 1-2: USB disconnect, 
device number 10
Feb  5 12:56:05 silver kernel: [ 4971.620150] rndis_host 1-2:1.0 
enp0s20f0u2: unregister 'rndis_host' usb-0000:00:14.0-2, RNDIS device
Feb  5 12:56:28 silver kernel: [ 4994.421333] usb 1-2: new high-speed 
USB device number 11 using xhci_hcd
Feb  5 12:56:28 silver kernel: [ 4994.442637] usb 1-2: New USB device 
found, idVendor=1d6b, idProduct=0104, bcdDevice= 4.04
Feb  5 12:56:28 silver kernel: [ 4994.442642] usb 1-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Feb  5 12:56:28 silver kernel: [ 4994.442646] usb 1-2: Product: BeagleBone
Feb  5 12:56:28 silver kernel: [ 4994.442649] usb 1-2: Manufacturer: 
BeagleBoard.org
Feb  5 12:56:28 silver kernel: [ 4994.442651] usb 1-2: SerialNumber: 
1740GPB21127
Feb  5 12:56:28 silver kernel: [ 4994.448068] rndis_host 1-2:1.0 eth0: 
register 'rndis_host' at usb-0000:00:14.0-2, RNDIS device, 60:64:05:6a:93:cd
Feb  5 12:56:28 silver kernel: [ 4994.452722] usb-storage 1-2:1.2: USB 
Mass Storage device detected
Feb  5 12:56:28 silver kernel: [ 4994.452876] scsi host0: usb-storage 
1-2:1.2
Feb  5 12:56:28 silver kernel: [ 4994.455094] cdc_ether 1-2:1.3 eth1: 
register 'cdc_ether' at usb-0000:00:14.0-2, CDC Ethernet Device, 
60:64:05:6a:93:d0
Feb  5 12:56:28 silver kernel: [ 4994.483916] rndis_host 1-2:1.0 
enx6064056a93cd: renamed from eth0
Feb  5 12:56:28 silver kernel: [ 4994.506437] cdc_ether 1-2:1.3 
enx6064056a93d0: renamed from eth1
Feb  5 12:56:29 silver kernel: [ 4995.462072] scsi 0:0:0:0: 
Direct-Access     Linux    File-Stor Gadget 0414 PQ: 0 ANSI: 2
Feb  5 12:56:29 silver kernel: [ 4995.462675] sd 0:0:0:0: Attached scsi 
generic sg0 type 0
Feb  5 12:56:29 silver kernel: [ 4995.463037] sd 0:0:0:0: Power-on or 
device reset occurred
Feb  5 12:56:29 silver kernel: [ 4995.463405] sd 0:0:0:0: [sda] 36864 
512-byte logical blocks: (18.9 MB/18.0 MiB)
Feb  5 12:56:29 silver kernel: [ 4995.463568] sd 0:0:0:0: [sda] Write 
Protect is on
Feb  5 12:56:29 silver kernel: [ 4995.463572] sd 0:0:0:0: [sda] Mode 
Sense: 0f 00 80 00
Feb  5 12:56:29 silver kernel: [ 4995.463736] sd 0:0:0:0: [sda] Write 
cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb  5 12:56:29 silver kernel: [ 4995.493379]  sda: sda1
Feb  5 12:56:29 silver kernel: [ 4995.494627] sd 0:0:0:0: [sda] Attached 
SCSI removable disk
Feb  5 12:58:24 silver kernel: [ 5110.597467] ------------[ cut here 
]------------
Feb  5 12:58:24 silver kernel: [ 5110.597473] NETDEV WATCHDOG: 
enx6064056a93cd (rndis_host): transmit queue 0 timed out
Feb  5 12:58:24 silver kernel: [ 5110.597517] WARNING: CPU: 3 PID: 0 at 
net/sched/sch_generic.c:443 dev_watchdog+0x254/0x260
Feb  5 12:58:24 silver kernel: [ 5110.597518] Modules linked in: 
sd_mod(E) sg(E) uas(E) rndis_host(E) usb_storage(E) cdc_ether(E) 
scsi_mod(E) usbnet(E) mii(E) usb_8dev(E) can_dev(E) rfcomm(E) uhid(E) 
algif_hash(E) algif_skcipher(E) af_alg(E) ctr(E) ccm(E) cmac(E) fuse(E) 
bnep(E) btusb(E) btrtl(E) btbcm(E) btintel(E) bluetooth(E) uvcvideo(E) 
videobuf2_vmalloc(E) videobuf2_memops(E) videobuf2_v4l2(E) 
videobuf2_common(E) drbg(E) videodev(E) mc(E) ansi_cprng(E) 
ecdh_generic(E) ecc(E) iwlmvm(E) x86_pkg_temp_thermal(E) 
intel_powerclamp(E) coretemp(E) kvm_intel(E) mac80211(E) kvm(E) 
irqbypass(E) libarc4(E) vcan(E) iwlwifi(E) crct10dif_pclmul(E) 
crc32_pclmul(E) ghash_clmulni_intel(E) snd_soc_skl(E) nls_ascii(E) 
mei_wdt(E) nls_cp437(E) snd_soc_core(E) vfat(E) fat(E) 
snd_soc_acpi_intel_match(E) intel_rapl_msr(E) snd_soc_acpi(E) hp_wmi(E) 
sparse_keymap(E) snd_hda_codec_hdmi(E) wmi_bmof(E) cfg80211(E) 
snd_soc_sst_ipc(E) snd_soc_sst_dsp(E) snd_hda_codec_conexant(E) 
snd_hda_ext_core(E) snd_hda_codec_generic(E) efi_pstore(E)
Feb  5 12:58:24 silver kernel: [ 5110.597582]  snd_hda_intel(E) 
snd_intel_dspcfg(E) snd_hda_codec(E) aesni_intel(E) glue_helper(E) 
snd_hwdep(E) crypto_simd(E) snd_hda_core(E) mei_me(E) cryptd(E) 
intel_cstate(E) intel_uncore(E) snd_pcm(E) joydev(E) snd_timer(E) snd(E) 
intel_rapl_perf(E) efivars(E) ucsi_acpi(E) mei(E) iTCO_wdt(E) 
hid_multitouch(E) processor_thermal_device(E) rfkill(E) 
intel_soc_dts_iosf(E) iTCO_vendor_support(E) soundcore(E) serio_raw(E) 
intel_rapl_common(E) intel_pch_thermal(E) typec_ucsi(E) battery(E) 
typec(E) wmi(E) tpm_crb(E) int3403_thermal(E) int340x_thermal_zone(E) 
evdev(E) tpm_tis(E) tpm_tis_core(E) tpm(E) int3400_thermal(E) 
acpi_thermal_rel(E) rng_core(E) ac(E) hp_wireless(E) acpi_pad(E) 
button(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) 
crc32c_generic(E) crc16(E) mbcache(E) jbd2(E) hid_generic(E) i915(E) 
i2c_algo_bit(E) drm_kms_helper(E) cec(E) crc32c_intel(E) psmouse(E) 
e1000e(E) xhci_pci(E) nvme(E) drm(E) i2c_i801(E) xhci_hcd(E) 
nvme_core(E) t10_pi(E) usbcore(E) intel_lpss_pci(E)
Feb  5 12:58:24 silver kernel: [ 5110.597642]  intel_lpss(E) idma64(E) 
i2c_hid(E) hid(E) thermal(E) video(E)
Feb  5 12:58:24 silver kernel: [ 5110.597653] CPU: 3 PID: 0 Comm: 
swapper/3 Tainted: G            E     5.5.0-09386-g33b40134e5cf #88
Feb  5 12:58:24 silver kernel: [ 5110.597655] Hardware name: HP HP 
EliteBook 840 G5/83B2, BIOS Q78 Ver. 01.07.00 04/17/2019
Feb  5 12:58:24 silver kernel: [ 5110.597662] RIP: 
0010:dev_watchdog+0x254/0x260
Feb  5 12:58:24 silver kernel: [ 5110.597666] Code: 48 85 c0 75 e5 eb 9c 
4c 89 f7 c6 05 db e3 a7 00 01 e8 e0 79 fc ff 89 d9 4c 89 f6 48 c7 c7 b0 
bd 14 b7 48 89 c2 e8 b7 3b 9f ff <0f> 0b e9 7b ff ff ff 0f 1f 44 00 00 
0f 1f 44 00 00 41 57 41 56 49
Feb  5 12:58:24 silver kernel: [ 5110.597669] RSP: 0018:ffffa9a3001c4e88 
EFLAGS: 00010282
Feb  5 12:58:24 silver kernel: [ 5110.597672] RAX: 0000000000000000 RBX: 
0000000000000000 RCX: 0000000000000007
Feb  5 12:58:24 silver kernel: [ 5110.597674] RDX: 0000000000000007 RSI: 
0000000000000086 RDI: ffff8c403f6d9800
Feb  5 12:58:24 silver kernel: [ 5110.597676] RBP: ffff8c4032e54440 R08: 
0000000000000424 R09: 0000000000000004
Feb  5 12:58:24 silver kernel: [ 5110.597678] R10: 0000000000000000 R11: 
0000000000000001 R12: ffff8c4032e5439c
Feb  5 12:58:24 silver kernel: [ 5110.597679] R13: 0000000000000003 R14: 
ffff8c4032e54000 R15: 0000000000000001
Feb  5 12:58:24 silver kernel: [ 5110.597683] FS: 
0000000000000000(0000) GS:ffff8c403f6c0000(0000) knlGS:0000000000000000
Feb  5 12:58:24 silver kernel: [ 5110.597685] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Feb  5 12:58:24 silver kernel: [ 5110.597687] CR2: 00007f73429af000 CR3: 
00000002edc0a004 CR4: 00000000003606e0
Feb  5 12:58:24 silver kernel: [ 5110.597690] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Feb  5 12:58:24 silver kernel: [ 5110.597691] DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
Feb  5 12:58:24 silver kernel: [ 5110.597693] Call Trace:
Feb  5 12:58:24 silver kernel: [ 5110.597697]  <IRQ>
Feb  5 12:58:24 silver kernel: [ 5110.597710]  ? 
pfifo_fast_enqueue+0x140/0x140
Feb  5 12:58:24 silver kernel: [ 5110.597717]  call_timer_fn+0x2d/0x130
Feb  5 12:58:24 silver kernel: [ 5110.597724]  run_timer_softirq+0x1a6/0x430
Feb  5 12:58:24 silver kernel: [ 5110.597730]  ? 
__hrtimer_run_queues+0x130/0x280
Feb  5 12:58:24 silver kernel: [ 5110.597735]  ? 
recalibrate_cpu_khz+0x10/0x10
Feb  5 12:58:24 silver kernel: [ 5110.597743]  __do_softirq+0xde/0x2df
Feb  5 12:58:24 silver kernel: [ 5110.597751]  irq_exit+0xa3/0xb0
Feb  5 12:58:24 silver kernel: [ 5110.597756] 
smp_apic_timer_interrupt+0x74/0x130
Feb  5 12:58:24 silver kernel: [ 5110.597762]  apic_timer_interrupt+0xf/0x20
Feb  5 12:58:24 silver kernel: [ 5110.597764]  </IRQ>
Feb  5 12:58:24 silver kernel: [ 5110.597771] RIP: 
0010:cpuidle_enter_state+0xb2/0x3b0
Feb  5 12:58:24 silver kernel: [ 5110.597775] Code: 31 ff e8 61 c3 aa ff 
45 84 ff 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 9d 02 00 00 31 ff e8 
65 d0 b0 ff fb 66 0f 1f 44 00 00 <85> ed 0f 88 1c 02 00 00 48 63 d5 48 
8b 0c 24 48 6b f2 68 48 2b 4c
Feb  5 12:58:24 silver kernel: [ 5110.597777] RSP: 0018:ffffa9a300117e70 
EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Feb  5 12:58:24 silver kernel: [ 5110.597780] RAX: ffff8c403f6ec740 RBX: 
ffff8c403f6f5000 RCX: 000000000000001f
Feb  5 12:58:24 silver kernel: [ 5110.597782] RDX: 000004a5e758457b RSI: 
000000003c9b28ab RDI: 0000000000000000
Feb  5 12:58:24 silver kernel: [ 5110.597784] RBP: 0000000000000006 R08: 
0000000000000002 R09: 000000000002bfc0
Feb  5 12:58:24 silver kernel: [ 5110.597786] R10: 000009e0038fe638 R11: 
ffff8c403f6eb844 R12: ffffffffb72bc9a0
Feb  5 12:58:24 silver kernel: [ 5110.597788] R13: ffffffffb72bcc28 R14: 
ffffffffb72bcc10 R15: 0000000000000000
Feb  5 12:58:24 silver kernel: [ 5110.597798]  cpuidle_enter+0x29/0x40
Feb  5 12:58:24 silver kernel: [ 5110.597805]  do_idle+0x23b/0x280
Feb  5 12:58:24 silver kernel: [ 5110.597811]  cpu_startup_entry+0x19/0x20
Feb  5 12:58:24 silver kernel: [ 5110.597816]  start_secondary+0x15f/0x1b0
Feb  5 12:58:24 silver kernel: [ 5110.597823] 
secondary_startup_64+0xa4/0xb0
Feb  5 12:58:24 silver kernel: [ 5110.597828] ---[ end trace 
ad75ef6e8e395eb0 ]---
Feb  5 12:59:39 silver kernel: [ 5185.620682] usb 1-2: USB disconnect, 
device number 11
Feb  5 12:59:39 silver kernel: [ 5185.620957] rndis_host 1-2:1.0 
enx6064056a93cd: unregister 'rndis_host' usb-0000:00:14.0-2, RNDIS device
Feb  5 12:59:39 silver kernel: [ 5185.657380] scsi 0:0:0:0: rejecting 
I/O to dead device
Feb  5 12:59:39 silver kernel: [ 5185.701866] cdc_ether 1-2:1.3 
enx6064056a93d0: unregister 'cdc_ether' usb-0000:00:14.0-2, CDC Ethernet 
Device

--------------------

Feb  5 17:54:41 silver kernel: [    0.000000] Linux version 
5.5.0-09386-g33b40134e5cf (hartko@silver) (gcc version 8.3.0 (Debian 
8.3.0-6)) #88 SMP Tue Feb 4 16:44:00 CET 2020
(..)
Feb  5 17:55:50 silver kernel: [   78.040434] usb 1-2: new high-speed 
USB device number 5 using xhci_hcd
Feb  5 17:55:50 silver kernel: [   78.061132] usb 1-2: New USB device 
found, idVendor=1d6b, idProduct=0104, bcdDevice= 4.04
Feb  5 17:55:50 silver kernel: [   78.061139] usb 1-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Feb  5 17:55:50 silver kernel: [   78.061143] usb 1-2: Product: BeagleBone
Feb  5 17:55:50 silver kernel: [   78.061146] usb 1-2: Manufacturer: 
BeagleBoard.org
Feb  5 17:55:50 silver kernel: [   78.061149] usb 1-2: SerialNumber: 
1740GPB21127
Feb  5 17:55:50 silver kernel: [   78.093736] SCSI subsystem initialized
Feb  5 17:55:50 silver kernel: [   78.095486] cdc_ether 1-2:1.3 eth0: 
register 'cdc_ether' at usb-0000:00:14.0-2, CDC Ethernet Device, 
60:64:05:6a:93:d0
Feb  5 17:55:50 silver kernel: [   78.096798] usbcore: registered new 
interface driver cdc_ether
Feb  5 17:55:50 silver kernel: [   78.098418] usb-storage 1-2:1.2: USB 
Mass Storage device detected
Feb  5 17:55:50 silver kernel: [   78.098495] scsi host0: usb-storage 
1-2:1.2
Feb  5 17:55:50 silver kernel: [   78.098585] usbcore: registered new 
interface driver usb-storage
Feb  5 17:55:50 silver kernel: [   78.100621] rndis_host 1-2:1.0 eth1: 
register 'rndis_host' at usb-0000:00:14.0-2, RNDIS device, 60:64:05:6a:93:cd
Feb  5 17:55:50 silver kernel: [   78.102537] usbcore: registered new 
interface driver rndis_host
Feb  5 17:55:50 silver kernel: [   78.103028] usbcore: registered new 
interface driver uas
Feb  5 17:55:50 silver kernel: [   78.109131] cdc_ether 1-2:1.3 
enx6064056a93d0: renamed from eth0
Feb  5 17:55:50 silver kernel: [   78.128889] rndis_host 1-2:1.0 
enx6064056a93cd: renamed from eth1
Feb  5 17:55:51 silver kernel: [   79.125431] scsi 0:0:0:0: 
Direct-Access     Linux    File-Stor Gadget 0414 PQ: 0 ANSI: 2
Feb  5 17:55:51 silver kernel: [   79.125936] IPv6: 
ADDRCONF(NETDEV_CHANGE): enx6064056a93d0: link becomes ready
Feb  5 17:55:51 silver kernel: [   79.134467] scsi 0:0:0:0: Attached 
scsi generic sg0 type 0
Feb  5 17:55:51 silver kernel: [   79.140433] sd 0:0:0:0: Power-on or 
device reset occurred
Feb  5 17:55:51 silver kernel: [   79.141081] sd 0:0:0:0: [sda] 36864 
512-byte logical blocks: (18.9 MB/18.0 MiB)
Feb  5 17:55:51 silver kernel: [   79.141420] sd 0:0:0:0: [sda] Write 
Protect is on
Feb  5 17:55:51 silver kernel: [   79.141425] sd 0:0:0:0: [sda] Mode 
Sense: 0f 00 80 00
Feb  5 17:55:51 silver kernel: [   79.141717] sd 0:0:0:0: [sda] Write 
cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb  5 17:55:52 silver kernel: [   79.160741]  sda: sda1
Feb  5 17:55:52 silver kernel: [   79.162687] sd 0:0:0:0: [sda] Attached 
SCSI removable disk
Feb  5 17:58:18 silver kernel: [  225.939845] ------------[ cut here 
]------------
Feb  5 17:58:18 silver kernel: [  225.939851] NETDEV WATCHDOG: 
enx6064056a93cd (rndis_host): transmit queue 0 timed out
Feb  5 17:58:18 silver kernel: [  225.939895] WARNING: CPU: 3 PID: 0 at 
net/sched/sch_generic.c:443 dev_watchdog+0x254/0x260
Feb  5 17:58:18 silver kernel: [  225.939896] Modules linked in: 
sd_mod(E) sg(E) uas(E) rndis_host(E) usb_storage(E) cdc_ether(E) 
scsi_mod(E) usbnet(E) mii(E) uhid(E) algif_hash(E) algif_skcipher(E) 
af_alg(E) rfcomm(E) ctr(E) ccm(E) cmac(E) fuse(E) 
x86_pkg_temp_thermal(E) intel_powerclamp(E) snd_soc_skl(E) coretemp(E) 
kvm_intel(E) kvm(E) bnep(E) irqbypass(E) snd_soc_core(E) 
snd_hda_codec_hdmi(E) btusb(E) btrtl(E) btbcm(E) 
snd_soc_acpi_intel_match(E) crct10dif_pclmul(E) btintel(E) 
snd_soc_acpi(E) snd_soc_sst_ipc(E) snd_soc_sst_dsp(E) vcan(E) mei_wdt(E) 
snd_hda_ext_core(E) snd_hda_codec_conexant(E) crc32_pclmul(E) 
uvcvideo(E) snd_hda_codec_generic(E) iwlmvm(E) mac80211(E) 
videobuf2_vmalloc(E) intel_rapl_msr(E) videobuf2_memops(E) 
ghash_clmulni_intel(E) videobuf2_v4l2(E) videobuf2_common(E) 
snd_hda_intel(E) bluetooth(E) nls_ascii(E) snd_intel_dspcfg(E) joydev(E) 
nls_cp437(E) libarc4(E) hp_wmi(E) sparse_keymap(E) vfat(E) wmi_bmof(E) 
snd_hda_codec(E) fat(E) efi_pstore(E) snd_hwdep(E) iwlwifi(E) 
videodev(E) snd_hda_core(E) mc(E)
Feb  5 17:58:18 silver kernel: [  225.939961]  aesni_intel(E) 
glue_helper(E) drbg(E) crypto_simd(E) cryptd(E) snd_pcm(E) 
intel_cstate(E) intel_uncore(E) snd_timer(E) ansi_cprng(E) 
processor_thermal_device(E) mei_me(E) intel_soc_dts_iosf(E) 
ecdh_generic(E) ecc(E) cfg80211(E) intel_rapl_perf(E) hid_multitouch(E) 
mei(E) efivars(E) snd(E) ucsi_acpi(E) intel_pch_thermal(E) iTCO_wdt(E) 
typec_ucsi(E) serio_raw(E) typec(E) iTCO_vendor_support(E) soundcore(E) 
intel_rapl_common(E) rfkill(E) wmi(E) battery(E) tpm_crb(E) 
int3400_thermal(E) int3403_thermal(E) acpi_thermal_rel(E) 
int340x_thermal_zone(E) button(E) tpm_tis(E) tpm_tis_core(E) tpm(E) 
rng_core(E) hp_wireless(E) acpi_pad(E) ac(E) evdev(E) efivarfs(E) 
ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) 
mbcache(E) jbd2(E) hid_generic(E) i915(E) i2c_algo_bit(E) xhci_pci(E) 
e1000e(E) xhci_hcd(E) crc32c_intel(E) i2c_i801(E) nvme(E) 
drm_kms_helper(E) psmouse(E) cec(E) nvme_core(E) intel_lpss_pci(E) 
t10_pi(E) intel_lpss(E) usbcore(E) idma64(E) drm(E) i2c_hid(E)
Feb  5 17:58:18 silver kernel: [  225.940024]  hid(E) thermal(E) video(E)
Feb  5 17:58:18 silver kernel: [  225.940033] CPU: 3 PID: 0 Comm: 
swapper/3 Tainted: G            E     5.5.0-09386-g33b40134e5cf #88
Feb  5 17:58:18 silver kernel: [  225.940035] Hardware name: HP HP 
EliteBook 840 G5/83B2, BIOS Q78 Ver. 01.07.00 04/17/2019
Feb  5 17:58:18 silver kernel: [  225.940042] RIP: 
0010:dev_watchdog+0x254/0x260
Feb  5 17:58:18 silver kernel: [  225.940046] Code: 48 85 c0 75 e5 eb 9c 
4c 89 f7 c6 05 db e3 a7 00 01 e8 e0 79 fc ff 89 d9 4c 89 f6 48 c7 c7 b0 
bd 54 8e 48 89 c2 e8 b7 3b 9f ff <0f> 0b e9 7b ff ff ff 0f 1f 44 00 00 
0f 1f 44 00 00 41 57 41 56 49
Feb  5 17:58:18 silver kernel: [  225.940049] RSP: 0018:ffffb902401c4e88 
EFLAGS: 00010282
Feb  5 17:58:18 silver kernel: [  225.940052] RAX: 0000000000000000 RBX: 
0000000000000000 RCX: 0000000000000007
Feb  5 17:58:18 silver kernel: [  225.940054] RDX: 0000000000000007 RSI: 
0000000000000086 RDI: ffff9e207f6d9800
Feb  5 17:58:18 silver kernel: [  225.940056] RBP: ffff9e2069f78440 R08: 
00000000000003eb R09: 0000000000000004
Feb  5 17:58:18 silver kernel: [  225.940058] R10: 0000000000000000 R11: 
0000000000000001 R12: ffff9e2069f7839c
Feb  5 17:58:18 silver kernel: [  225.940059] R13: 0000000000000003 R14: 
ffff9e2069f78000 R15: 0000000000000001
Feb  5 17:58:18 silver kernel: [  225.940063] FS: 
0000000000000000(0000) GS:ffff9e207f6c0000(0000) knlGS:0000000000000000
Feb  5 17:58:18 silver kernel: [  225.940065] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Feb  5 17:58:18 silver kernel: [  225.940067] CR2: 00007fb8a6060008 CR3: 
00000005dd60a006 CR4: 00000000003606e0
Feb  5 17:58:18 silver kernel: [  225.940069] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Feb  5 17:58:18 silver kernel: [  225.940071] DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
Feb  5 17:58:18 silver kernel: [  225.940073] Call Trace:
Feb  5 17:58:18 silver kernel: [  225.940077]  <IRQ>
Feb  5 17:58:18 silver kernel: [  225.940090]  ? 
pfifo_fast_enqueue+0x140/0x140
Feb  5 17:58:18 silver kernel: [  225.940097]  call_timer_fn+0x2d/0x130
Feb  5 17:58:18 silver kernel: [  225.940103]  run_timer_softirq+0x1a6/0x430
Feb  5 17:58:18 silver kernel: [  225.940109]  ? enqueue_hrtimer+0x38/0x90
Feb  5 17:58:18 silver kernel: [  225.940115]  ? 
__hrtimer_run_queues+0x130/0x280
Feb  5 17:58:18 silver kernel: [  225.940120]  ? 
recalibrate_cpu_khz+0x10/0x10
Feb  5 17:58:18 silver kernel: [  225.940128]  __do_softirq+0xde/0x2df
Feb  5 17:58:18 silver kernel: [  225.940136]  irq_exit+0xa3/0xb0
Feb  5 17:58:18 silver kernel: [  225.940141] 
smp_apic_timer_interrupt+0x74/0x130
Feb  5 17:58:18 silver kernel: [  225.940146]  apic_timer_interrupt+0xf/0x20
Feb  5 17:58:18 silver kernel: [  225.940149]  </IRQ>
Feb  5 17:58:18 silver kernel: [  225.940156] RIP: 
0010:cpuidle_enter_state+0xb2/0x3b0
Feb  5 17:58:18 silver kernel: [  225.940160] Code: 31 ff e8 61 c3 aa ff 
45 84 ff 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 9d 02 00 00 31 ff e8 
65 d0 b0 ff fb 66 0f 1f 44 00 00 <85> ed 0f 88 1c 02 00 00 48 63 d5 48 
8b 0c 24 48 6b f2 68 48 2b 4c
Feb  5 17:58:18 silver kernel: [  225.940162] RSP: 0018:ffffb90240117e70 
EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Feb  5 17:58:18 silver kernel: [  225.940165] RAX: ffff9e207f6ec740 RBX: 
ffff9e207f6f5000 RCX: 000000000000001f
Feb  5 17:58:18 silver kernel: [  225.940167] RDX: 000000349b0ff705 RSI: 
000000003c9b28ab RDI: 0000000000000000
Feb  5 17:58:18 silver kernel: [  225.940169] RBP: 0000000000000006 R08: 
0000000000000002 R09: 000000000002bfc0
Feb  5 17:58:18 silver kernel: [  225.940171] R10: 00000079f659d46e R11: 
ffff9e207f6eb844 R12: ffffffff8e6bc9a0
Feb  5 17:58:18 silver kernel: [  225.940172] R13: ffffffff8e6bcc28 R14: 
ffffffff8e6bcc10 R15: 0000000000000000
Feb  5 17:58:18 silver kernel: [  225.940183]  cpuidle_enter+0x29/0x40
Feb  5 17:58:18 silver kernel: [  225.940189]  do_idle+0x23b/0x280
Feb  5 17:58:18 silver kernel: [  225.940196]  cpu_startup_entry+0x19/0x20
Feb  5 17:58:18 silver kernel: [  225.940201]  start_secondary+0x15f/0x1b0
Feb  5 17:58:18 silver kernel: [  225.940207] 
secondary_startup_64+0xa4/0xb0
Feb  5 17:58:18 silver kernel: [  225.940212] ---[ end trace 
0465d31ecf732379 ]---
