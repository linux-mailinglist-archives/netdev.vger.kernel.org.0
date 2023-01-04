Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DB065CD83
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjADHNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjADHNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:13:08 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17C8178AD
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:13:06 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id k2so15866853qkk.7
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 23:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kZ6EzxDshlFDoHvUFOuS+3llyLqT0yXUs763lCQWzEU=;
        b=kgIXiq071MRBCRknGb4u7FgPw1SYXlKscEb/nK6du3UxLbvj7vO40YcbZU+I54hsKy
         W55VcjrWrbff6JPcdhoG2aQsO4wYeH/0LRf0zTJuCYyqo6VrGidYJKPPczv8UW6ooYRE
         P/L+H98yFp/7OJMzN8I7seWntltdKbZPuGoppTVfyL5Aujn9cbUoG5EdXJEgL+WZaHt0
         T21xLAF3qIMx7Itpx2HUeMXCzj4s0U5w+9PugqSUxjGeUFB+Momax8bffFgQ+TP6ZqO5
         PiYYiDAZA2nJgTS/2Qs8JYmQVJX0nK7/gL0uexS42JMl2h1WnWmVXe/+YegDoJdwF/aI
         BQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kZ6EzxDshlFDoHvUFOuS+3llyLqT0yXUs763lCQWzEU=;
        b=MRygEA26zuG9zB1OphArCxzPyxkmVfjTwSEUjq0xo2OLB1blfpfFT68Q/38NbjBfa1
         O1e5GdzDWlGsbTdkYrPWlvVvxlWvn+BHz2trPqpjS/m3PWCJ4BfbJhTMb2rxb7CJvbM8
         xkjXGlf8mwRMBteNx9ySFaj74tafDNcmtFmBcnV+kks/62QTzW0F8iz4YlS0ueyIuATj
         eHh/yiLyxfVVvwXFvMv1FwCIcdk1sny9IeU3M7QrF0b1ul2BBB+TjpJ5MfPtzhaiXsFf
         z3LwpvvqrN95uOeGuIAMAcFRiVIg5FdnZTfs0Ngkc3F2D14yRN39IO8m2aj/2fVr+lqs
         xmvA==
X-Gm-Message-State: AFqh2krl/fbd34eHLhBVfk1e6H2A69v8Z5+EK0tmh0Im+RYhFj5my3Lk
        oL6g3TlZGt1IG5oiXH5Wt+c+jKsu3ltF7vrkhF/sMuOI
X-Google-Smtp-Source: AMrXdXt4CSKAO5sKQ9ozBJiLV7GYnCE/HK6b91X6N6ekA8CJ4F8grSahpq40JklXYu4jmXo5NZSL084nQMgtMfS9RTQ=
X-Received: by 2002:a05:620a:1188:b0:6ee:9453:9d92 with SMTP id
 b8-20020a05620a118800b006ee94539d92mr2384627qkk.520.1672816385788; Tue, 03
 Jan 2023 23:13:05 -0800 (PST)
MIME-Version: 1.0
References: <CAEjTV=_nRAyaUQMWPZN9Vhz3ByS8SRVoimJMWuR80qaGDNx5Kg@mail.gmail.com>
In-Reply-To: <CAEjTV=_nRAyaUQMWPZN9Vhz3ByS8SRVoimJMWuR80qaGDNx5Kg@mail.gmail.com>
From:   Jesse <pianohacker@gmail.com>
Date:   Wed, 4 Jan 2023 00:12:55 -0700
Message-ID: <CAEjTV=--CvwHPhwiD0ctTDnupiO9-5ssi6up_uCXUeYnqr264Q@mail.gmail.com>
Subject: Fwd: Bad page after suspend with Innodisk EGPL-T101 [1d6a:14c0]
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Resending to list due to HTML in previous message)

After resume, I sometimes see the following error and the device hangs:

[36257.935269] BUG: Bad page state in process kworker/u64:33  pfn:10e400
[36257.935269] page:00000000597be4f0 refcount:0 mapcount:0
mapping:00000000eeb38d16 index:0x0 pfn:0x10e400
[36257.935270] aops:anon_aops.1 ino:63a9
[36257.935271] flags: 0x17ffffc0000800(arch_1|node=0|zone=2|lastcpupid=0x1fffff)
[36257.935271] raw: 0017ffffc0000800 0000000000000000 dead000000000122
ffff970d81f08178
[36257.935272] raw: 0000000000000000 0000000000000003 00000000ffffffff
0000000000000000
[36257.935272] page dumped because: non-NULL mapping
[36257.935272] Modules linked in: i2c_dev xt_conntrack nft_chain_nat
xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype nft_compat nf_tables
br_netfilter bridge stp llc wireguard libchacha20poly1305
chacha_x86_64 poly1305_x86_64 curve25519_x86_64 libcurve25519_generic
libchacha ip6_udp_tunnel udp_tunnel ctr ccm snd_seq_dummy snd_hrtimer
snd_seq nfnetlink tun rfcomm cmac algif_hash algif_skcipher af_alg
qrtr overlay bnep binfmt_misc nls_ascii nls_cp437 vfat fat ext4
squashfs mbcache jbd2 loop btusb intel_rapl_msr intel_rapl_common
iwlmvm btrtl btbcm btintel btmtk snd_hda_codec_realtek edac_mce_amd
bluetooth mac80211 snd_hda_codec_generic uvcvideo snd_hda_codec_hdmi
videobuf2_vmalloc snd_hda_intel kvm_amd videobuf2_memops snd_usb_audio
snd_intel_dspcfg videobuf2_v4l2 eeepc_wmi snd_intel_sdw_acpi
jitterentropy_rng libarc4 asus_wmi videobuf2_common asus_ec_sensors
snd_hda_codec drbg snd_usbmidi_lib platform_profile kvm iwlwifi
[36257.935286]  videodev ansi_cprng battery snd_rawmidi snd_hda_core
irqbypass sparse_keymap snd_seq_device ecdh_generic rapl ledtrig_audio
wmi_bmof pcspkr mc snd_hwdep zenpower(OE) ecc cfg80211 crc16 joydev
snd_pcm razermouse(OE) snd_timer cdc_acm snd ccp sp5100_tco soundcore
rfkill rng_core watchdog acpi_cpufreq evdev nfsd auth_rpcgss nfs_acl
lockd lm92 grace nct6775 nct6775_core hwmon_vid sunrpc msr drivetemp
parport_pc ppdev lp parport fuse efi_pstore configfs efivarfs
ip_tables x_tables autofs4 btrfs blake2b_generic xor raid6_pq
zstd_compress libcrc32c crc32c_generic dm_crypt dm_mod
hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid amdgpu
gpu_sched drm_buddy video drm_display_helper cec crc32_pclmul
crc32c_intel rc_core ghash_clmulni_intel ahci drm_ttm_helper
sha512_ssse3 ttm libahci sha512_generic xhci_pci drm_kms_helper nvme
libata xhci_hcd nvme_core atlantic aesni_intel drm t10_pi crypto_simd
igb scsi_mod usbcore crc64_rocksoft_generic cryptd macsec dca
crc64_rocksoft
[36257.935303]  i2c_piix4 crc_t10dif ptp crct10dif_generic
i2c_algo_bit crct10dif_pclmul scsi_common usb_common crc64
crct10dif_common pps_core wmi button
[36257.935305] CPU: 8 PID: 610626 Comm: kworker/u64:33 Tainted: G    B
     OE      6.1.0-0-amd64 #1  Debian 6.1.1-1~exp2
[36257.935306] Hardware name: System manufacturer System Product
Name/ROG STRIX X570-I GAMING, BIOS 4408 10/28/2022
[36257.935306] Workqueue: events_unbound async_run_entry_fn
[36257.935307] Call Trace:
[36257.935307]  <TASK>
[36257.935307]  dump_stack_lvl+0x44/0x5c
[36257.935308]  bad_page.cold+0x63/0x8f
[36257.935309]  __free_pages_ok+0x139/0x4f0
[36257.935310]  ? force_dma_unencrypted+0x27/0xa0
[36257.935311]  aq_ring_alloc+0xa4/0xb0 [atlantic]
[36257.935315]  aq_vec_ring_alloc+0xea/0x1a0 [atlantic]
[36257.935320]  aq_nic_init+0x114/0x1d0 [atlantic]
[36257.935324]  atl_resume_common+0x40/0xd0 [atlantic]
[36257.935328]  ? pci_legacy_resume+0x80/0x80
[36257.935329]  dpm_run_callback+0x4a/0x150
[36257.935330]  device_resume+0x88/0x190
[36257.935331]  async_resume+0x19/0x30
[36257.935331]  async_run_entry_fn+0x30/0x130
[36257.935332]  process_one_work+0x1c7/0x380
[36257.935333]  worker_thread+0x4d/0x380
[36257.935335]  ? rescuer_thread+0x3a0/0x3a0
[36257.935336]  kthread+0xe9/0x110
[36257.935336]  ? kthread_complete_and_exit+0x20/0x20
[36257.935337]  ret_from_fork+0x22/0x30
[36257.935339]  </TASK>
[36257.935445] atlantic 0000:01:00.0: PM: dpm_run_callback():
pci_pm_resume+0x0/0xe0 returns -12
[36257.935447] atlantic 0000:01:00.0: PM: failed to resume async: error -12

This error occurs inconsistently; sometimes after a single sleep/wake
cycle, sometimes after multiple. I have tried all of the random kernel
flags I can find from the most reputable stackexchange posts,
including pci=nommconf.

Note that this is with iommu=pt. Without this flag there are iommu
errors before a crash with a similar traceback.

On kernel 6.1.1 (not latest, but don't see relevant changes in Git
since). Apologies if this is the wrong path for reporting bugs.

-- 
Jesse Weaver
