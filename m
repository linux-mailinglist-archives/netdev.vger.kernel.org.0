Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05482B2979
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKNADk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKNADj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 19:03:39 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B0CC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 16:03:39 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id h16so4318153pgb.7
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 16:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=qg373rKKJ1I7GHxFuYnp30TtXBfWgduhxy8G4qZv0KQ=;
        b=u5M9K85YA80/eAdineHM/uHjgfiv7o9vLnexJFQuwcxuPBQINFla6+iAM2f0LTX3hN
         FF1o88T9R8LV2JYFNNRkCTxMGyZsHkeSOt5IYoa3le1qRV1fRf/FDohu76GwK2Q++CO+
         8/TlxAteBCqvLbJ5J8ZE2iU3i1h/eqd1ZFD1w2a8TQryQQJcAf+nPXxfSRYLYajGIUnJ
         wqi/EoKGS0xyQ9Ss2gr3kloWPcGiBZBe8Z6dHDM8fiDxnqe2g/fKdPaOjbrjT3bKqYsC
         mKuxuRPddT6UfiCMr849RraBn4KNX46ClqSBP+G6Co/4rIXA8vhkE6l91Obsp7JtBxeM
         9JAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=qg373rKKJ1I7GHxFuYnp30TtXBfWgduhxy8G4qZv0KQ=;
        b=uCQ4ryspJyF9qEu0zuzL4uRueN+3q9WvbLEorIFIOEHynrvZxYkSR85ex6C6C93V2C
         5jnZtaEEUEqSNLTRIVrallnO0RIUlhnMQqBBhQQExHoeVccJ1/bb/TzmTZyR37gkwpiu
         5HWFFCwgshL25xSNwqMyi3FZMYkWkd+9Eo9BB6nWZTJ6kW3cFHTukZzrP//ELDsjpdCU
         0Ik1I5OxoRyb8V8sOrHFERqV/0raNlV5WK6hwHMvIN1aARFG0OfagS/zel01WMy/wFHO
         i8Q9L1SY6HEVJLIygcjh/AHRCbe3wm7JH5Fqvl9Xm0FWMtu0eBUG/vaVWG8N51n380j6
         rqmQ==
X-Gm-Message-State: AOAM530WHKtRQbw3sj4lrqKwO9dssTM2nqUg9580NJfgB8RiviRjJnJb
        sX6ABXY7yg1YIJJseqa6fwY5RO06SL6OfY8A
X-Google-Smtp-Source: ABdhPJw5UM1BR8wUcCB00bny3dtxtvGDjubgf9SxdCqIglmpmlEqx2IeiNCkf+9ZnYR7s6OrXIjhOw==
X-Received: by 2002:a17:90a:a417:: with SMTP id y23mr5462085pjp.97.1605312218329;
        Fri, 13 Nov 2020 16:03:38 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y5sm3534236pja.52.2020.11.13.16.03.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 16:03:37 -0800 (PST)
Date:   Fri, 13 Nov 2020 16:03:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 210195] New: Security scanner crashes kernel post 4.19.13
 ade446403bfb
Message-ID: <20201113160318.28d1780b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 13 Nov 2020 23:01:48 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 210195] New: Security scanner crashes kernel post 4.19.13 ade446403bfb


https://bugzilla.kernel.org/show_bug.cgi?id=210195

            Bug ID: 210195
           Summary: Security scanner crashes kernel post 4.19.13
                    ade446403bfb
           Product: Networking
           Version: 2.5
    Kernel Version: 4.19.13 post  ade446403bfb
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: stefan.king@hitachivantara.com
        Regression: No

Created attachment 293667
  --> https://bugzilla.kernel.org/attachment.cgi?id=293667&action=edit  
pcap file needed to reproduce

Ip security scanner crashes kernels 4.19 series since commit
ade446403bfb79d3528d56071a84b15351a139ad.  4.19.15 built with just this commit
removed survives just fine.  4.19.154 (long term supported) also crashes.  This
bug was observed on numerous machines.



Bug report per kernel bug guidelines follows.
See Investigation section following boilerplate.

Summary: Security scanner crashes kernel post 4.19.13

Details:
    Ip security scanner crashes kernels 4.19 series since commit
    ade446403bfb79d3528d56071a84b15351a139ad.  4.19.15 built with just
    this commit removed survives just fine.  This bug was observed on
    numerous machines.

Keywords: ip_defrag, kmem_cache, kernel

Kernel information:  4.19 series, 5.3.11

Kernel version:
    Linux version 4.19.15-300.fc29.x86_64
(mockbuild@bkernel03.phx2.fedoraproject.org) (gcc version 8.2.1 20181215 (Red
Hat 8.2.1-6) (GCC)) #1 SMP Mon Jan 14 16:32:35 UTC 2019

How to reproduce:

    Rewrite the attached pcap file to the ip address of your test machine and
    play it back.

    Rewrite destination headers:
    tcprewrite --pnat=192.168.0.25:<your ip address> -i
qualys.192.168.0.25.pcap -o your-new-file-name.pcap

    Replay at high speed:
    tcpreplay -T nano --preload-pcap --loop 1 --topspeed
your-new-file-name.pcap

    Notes: For most kernels, high speed playback was not required to crash.
    -x 1000 was often sufficient.  Reducing network latency was required to
    produce the crash.  This crash could not be reproduced until the send
    and receive machine were connected with a single switch.  But note that
    this has been seen in the wild on corporate networks with no special
    topology.

Environment:
    ipv4 1Gb ethernet.

Processor(s):
    Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz (24 cores)
    Intel(R) Xeon(R) Silver 4210 CPU @ 2.20GHz (40 cores)

Modules:
    [root@none ~]# cat /proc/modules
    bonding 180224 0 - Live 0xffffffffc056f000
    dm_round_robin 16384 8 - Live 0xffffffffc044f000
    sunrpc 425984 1 - Live 0xffffffffc04c6000
    i2c_algo_bit 16384 0 - Live 0xffffffffc043d000
    ttm 131072 0 - Live 0xffffffffc0712000
    drm_kms_helper 196608 0 - Live 0xffffffffc0866000
    cdc_ether 16384 0 - Live 0xffffffffc06db000
    usbnet 49152 1 cdc_ether, Live 0xffffffffc0442000
    coretemp 16384 0 - Live 0xffffffffc0430000
    drm 487424 2 ttm,drm_kms_helper, Live 0xffffffffc09e1000
    mii 16384 1 usbnet, Live 0xffffffffc0933000
    wmi 28672 0 - Live 0xffffffffc0435000
    acpi_power_meter 20480 0 - Live 0xffffffffc03ea000
    dm_multipath 32768 9 dm_round_robin, Live 0xffffffffc0398000
    scsi_dh_rdac 16384 0 - Live 0xffffffffc0366000
    scsi_dh_emc 16384 0 - Live 0xffffffffc035e000
    fuse 122880 1 - Live 0xffffffffc0411000
    scsi_dh_alua 20480 0 - Live 0xffffffffc034f000
    ses 20480 0 - Live 0xffffffffc0325000
    enclosure 16384 1 ses, Live 0xffffffffc031c000
    scsi_transport_sas 45056 1 ses, Live 0xffffffffc030a000
    intel_rapl 24576 0 - Live 0xffffffffc05ea000
    skx_edac 16384 0 - Live 0xffffffffc03fc000
    nfit 61440 1 skx_edac, Live 0xffffffffc059c000
    x86_pkg_temp_thermal 16384 0 - Live 0xffffffffc04c1000
    intel_powerclamp 16384 0 - Live 0xffffffffc0373000
    kvm_intel 241664 0 - Live 0xffffffffc29ee000
    kvm 737280 1 kvm_intel, Live 0xffffffffc07b1000
    ipmi_ssif 32768 0 - Live 0xffffffffc0301000
    irqbypass 16384 1 kvm, Live 0xffffffffc06e7000
    crct10dif_pclmul 16384 0 - Live 0xffffffffc06d6000
    crc32_pclmul 16384 0 - Live 0xffffffffc0746000
    crc32c_intel 24576 5 - Live 0xffffffffc02fa000
    ghash_clmulni_intel 16384 0 - Live 0xffffffffc070d000
    intel_cstate 16384 0 - Live 0xffffffffc02f5000
    iTCO_wdt 16384 0 - Live 0xffffffffc02e7000
    lpfc 921600 32 - Live 0xffffffffc1195000
    iTCO_vendor_support 16384 1 iTCO_wdt, Live 0xffffffffc02f0000
    nvmet_fc 32768 1 lpfc, Live 0xffffffffc0346000
    intel_uncore 135168 0 - Live 0xffffffffc0ba9000
    ixgbe 380928 0 - Live 0xffffffffc0983000
    nvmet 73728 1 nvmet_fc, Live 0xffffffffc08d8000
    i40e 393216 0 - Live 0xffffffffc0750000
    nvme_fc 45056 1 lpfc, Live 0xffffffffc073a000
    nvme_fabrics 24576 1 nvme_fc, Live 0xffffffffc06f7000
    intel_rapl_perf 16384 0 - Live 0xffffffffc066c000
    nvme_core 81920 2 nvme_fc,nvme_fabrics, Live 0xffffffffc064f000
    ipmi_si 65536 0 - Live 0xffffffffc05f2000
    megaraid_sas 159744 4 - Live 0xffffffffc0610000
    scsi_transport_fc 69632 1 lpfc, Live 0xffffffffc053b000
    uas 28672 0 - Live 0xffffffffc0469000
    ioatdma 61440 0 - Live 0xffffffffc0401000
    mei_me 45056 0 - Live 0xffffffffc03f0000
    ipmi_devintf 20480 0 - Live 0xffffffffc03e2000
    mdio 16384 1 ixgbe, Live 0xffffffffc03a2000
    mei 118784 1 mei_me, Live 0xffffffffc03b2000
    joydev 24576 0 - Live 0xffffffffc03a7000
    usb_storage 69632 1 uas, Live 0xffffffffc0386000
    i2c_i801 28672 0 - Live 0xffffffffc0379000
    lpc_ich 28672 0 - Live 0xffffffffc036b000
    dca 16384 2 ixgbe,ioatdma, Live 0xffffffffc0607000
    ipmi_msghandler 69632 3 ipmi_ssif,ipmi_si,ipmi_devintf, Live
0xffffffffc05b1000
    acpi_pad 36864 0 - Live 0xffffffffc0565000

Loaded drivers:
    # cat /proc/ioports
    0000-03af : PCI Bus 0000:00
      0000-001f : dma1
      0020-0021 : pic1
      0040-0043 : timer0
      0050-0053 : timer1
      0060-0060 : keyboard
      0061-0061 : PNP0800:00
      0064-0064 : keyboard
      0070-0071 : rtc0
      0080-008f : dma page reg
      00a0-00a1 : pic2
      00c0-00df : dma2
      00f0-00ff : fpu
        00f0-00f0 : PNP0C04:00
      02f8-02ff : serial
    03b0-03bb : PCI Bus 0000:00
    03c0-03df : PCI Bus 0000:00
    03e0-0cf7 : PCI Bus 0000:00
      03f8-03ff : serial
      0400-047f : pnp 00:01
        0400-041f : iTCO_wdt
      0500-05fe : pnp 00:01
        0500-0503 : ACPI PM1a_EVT_BLK
        0504-0505 : ACPI PM1a_CNT_BLK
        0508-050b : ACPI PM_TMR
        0530-0533 : iTCO_wdt
        0550-0550 : ACPI PM2_CNT_BLK
        0580-059f : ACPI GPE0_BLK
      0600-061f : pnp 00:01
      0780-079f : 0000:00:1f.4
        0780-079f : i801_smbus
      0800-081f : pnp 00:01
      0880-0883 : pnp 00:01
      0a00-0a0f : pnp 00:02
      0a10-0a1f : pnp 00:02
      0a20-0a2f : pnp 00:02
      0a30-0a3f : pnp 00:02
      0ca2-0ca2 : IPI0001:00
        0ca2-0ca2 : IPMI Address 1
          0ca2-0ca2 : ipmi_si
      0ca3-0ca3 : IPI0001:00
        0ca3-0ca3 : IPMI Address 2
          0ca3-0ca3 : ipmi_si
    0cf8-0cff : PCI conf1
    0f00-0ffe : pnp 00:06
    1000-3fff : PCI Bus 0000:00
      2000-2fff : PCI Bus 0000:01
        2000-2fff : PCI Bus 0000:02
          2000-207f : 0000:02:00.0
      3000-301f : 0000:00:17.0
        3000-301f : ahci
      3020-303f : 0000:00:11.5
        3020-303f : ahci
      3040-3043 : 0000:00:17.0
        3040-3043 : ahci
      3050-3057 : 0000:00:17.0
        3050-3057 : ahci
      3060-3063 : 0000:00:11.5
        3060-3063 : ahci
      3070-3077 : 0000:00:11.5
        3070-3077 : ahci
    4000-5fff : PCI Bus 0000:17
    6000-7fff : PCI Bus 0000:3a
    8000-9fff : PCI Bus 0000:5d
      9000-9fff : PCI Bus 0000:5e
        9000-90ff : 0000:5e:00.0
    a000-bfff : PCI Bus 0000:80
    c000-dfff : PCI Bus 0000:85
      d000-dfff : PCI Bus 0000:86
        d000-d01f : 0000:86:00.1
        d020-d03f : 0000:86:00.0
    e000-efff : PCI Bus 0000:ae
    f000-ffff : PCI Bus 0000:d7
      f000-ffff : PCI Bus 0000:d8
        f000-f01f : 0000:d8:00.1
        f020-f03f : 0000:d8:00.0

    # cat /proc/iomem
    00000000-00000fff : Reserved
    00001000-0009ffff : System RAM
    000a0000-000fffff : Reserved
      000a0000-000bffff : PCI Bus 0000:00
      000c0000-000c7fff : Video ROM
        000c4000-000c7fff : PCI Bus 0000:00
      000f0000-000fffff : System ROM
    00100000-553ab017 : System RAM
      28000000-37ffffff : Crash kernel
    553ab018-55409e57 : System RAM
    55409e58-5540a017 : System RAM
    5540a018-55468e57 : System RAM
    55468e58-55469017 : System RAM
    55469018-554a1257 : System RAM
    554a1258-554a2017 : System RAM
    554a2018-554bc457 : System RAM
    554bc458-554bd017 : System RAM
    554bd018-5551a257 : System RAM
    5551a258-5551b017 : System RAM
    5551b018-55578257 : System RAM
    55578258-55579017 : System RAM
    55579018-555d6257 : System RAM
    555d6258-555d7017 : System RAM
    555d7018-55634257 : System RAM
    55634258-55635017 : System RAM
    55635018-55646457 : System RAM
    55646458-5b7b9fff : System RAM
    5b7ba000-5bb93fff : ACPI Non-volatile Storage
    5bb94000-694abfff : System RAM
    694ac000-6c1a2fff : Reserved
    6c1a3000-6c5b9fff : System RAM
    6c5ba000-6d5fffff : ACPI Non-volatile Storage
    6d600000-6fae4fff : Reserved
    6fae5000-6fffffff : System RAM
    70000000-8fffffff : Reserved
      80000000-8fffffff : PCI MMCONFIG 0000 [bus 00-ff]
    90000000-9d7fffff : PCI Bus 0000:00
      90000000-900000ff : 0000:00:1f.4
      9c000000-9d0fffff : PCI Bus 0000:01
        9c000000-9d0fffff : PCI Bus 0000:02
          9c000000-9cffffff : 0000:02:00.0
            9c000000-9c2fffff : efifb
          9d000000-9d01ffff : 0000:02:00.0
      9d100000-9d17ffff : 0000:00:17.0
        9d100000-9d17ffff : ahci
      9d180000-9d1fffff : 0000:00:11.5
        9d180000-9d1fffff : ahci
      9d200000-9d20ffff : 0000:00:14.0
        9d200000-9d20ffff : xhci-hcd
      9d210000-9d213fff : 0000:00:1f.2
      9d214000-9d217fff : 0000:00:04.7
        9d214000-9d217fff : ioatdma
      9d218000-9d21bfff : 0000:00:04.6
        9d218000-9d21bfff : ioatdma
      9d21c000-9d21ffff : 0000:00:04.5
        9d21c000-9d21ffff : ioatdma
      9d220000-9d223fff : 0000:00:04.4
        9d220000-9d223fff : ioatdma
      9d224000-9d227fff : 0000:00:04.3
        9d224000-9d227fff : ioatdma
      9d228000-9d22bfff : 0000:00:04.2
        9d228000-9d22bfff : ioatdma
      9d22c000-9d22ffff : 0000:00:04.1
        9d22c000-9d22ffff : ioatdma
      9d230000-9d233fff : 0000:00:04.0
        9d230000-9d233fff : ioatdma
      9d234000-9d235fff : 0000:00:17.0
        9d234000-9d235fff : ahci
      9d236000-9d237fff : 0000:00:11.5
        9d236000-9d237fff : ahci
      9d238000-9d2380ff : 0000:00:17.0
        9d238000-9d2380ff : ahci
      9d239000-9d239fff : 0000:00:16.4
      9d23a000-9d23afff : 0000:00:16.1
      9d23b000-9d23bfff : 0000:00:16.0
        9d23b000-9d23bfff : mei_me
      9d23c000-9d23cfff : 0000:00:14.2
      9d23d000-9d23d0ff : 0000:00:11.5
        9d23d000-9d23d0ff : ahci
      9d23e000-9d23efff : 0000:00:05.4
      9d7fc000-9d7fcfff : dmar7
    9d800000-aaffffff : PCI Bus 0000:17
      aaf00000-aaf00fff : 0000:17:05.4
      aaffc000-aaffcfff : dmar4
    ab000000-b87fffff : PCI Bus 0000:3a
      b3000000-b82fffff : PCI Bus 0000:3b
        b3000000-b82fffff : PCI Bus 0000:3c
          b3000000-b82fffff : PCI Bus 0000:3d
            b3000000-b3ffffff : 0000:3d:00.3
              b3000000-b3ffffff : i40e
            b4000000-b4ffffff : 0000:3d:00.2
              b4000000-b4ffffff : i40e
            b5000000-b5ffffff : 0000:3d:00.1
              b5000000-b5ffffff : i40e
            b6000000-b6ffffff : 0000:3d:00.0
              b6000000-b6ffffff : i40e
            b7000000-b73fffff : 0000:3d:00.3
            b7400000-b77fffff : 0000:3d:00.2
            b7800000-b7bfffff : 0000:3d:00.1
            b7c00000-b7ffffff : 0000:3d:00.0
            b8000000-b8007fff : 0000:3d:00.3
              b8000000-b8007fff : i40e
            b8008000-b800ffff : 0000:3d:00.2
              b8008000-b800ffff : i40e
            b8010000-b8017fff : 0000:3d:00.1
              b8010000-b8017fff : i40e
            b8018000-b801ffff : 0000:3d:00.0
              b8018000-b801ffff : i40e
            b8020000-b809ffff : 0000:3d:00.3
            b80a0000-b811ffff : 0000:3d:00.2
            b8120000-b819ffff : 0000:3d:00.1
            b81a0000-b821ffff : 0000:3d:00.0
      b8300000-b86fffff : PCI Bus 0000:3b
        b8300000-b83fffff : 0000:3b:00.0
        b8400000-b85fffff : PCI Bus 0000:3c
          b8400000-b85fffff : PCI Bus 0000:3d
            b8400000-b847ffff : 0000:3d:00.3
            b8480000-b84fffff : 0000:3d:00.2
            b8500000-b857ffff : 0000:3d:00.1
            b8580000-b85fffff : 0000:3d:00.0
        b8600000-b861ffff : 0000:3b:00.0
      b8700000-b8700fff : 0000:3a:05.4
      b87fc000-b87fcfff : dmar5
    b8800000-c5ffffff : PCI Bus 0000:5d
      c5b00000-c5dfffff : PCI Bus 0000:5e
        c5b00000-c5bfffff : 0000:5e:00.0
        c5c00000-c5cfffff : 0000:5e:00.0
        c5d00000-c5dfffff : 0000:5e:00.0
          c5d00000-c5dfffff : megasas: LSI
      c5e00000-c5efffff : PCI Bus 0000:5e
        c5e00000-c5efffff : 0000:5e:00.0
      c5f00000-c5f00fff : 0000:5d:05.4
      c5ffc000-c5ffcfff : dmar6
    c6000000-d37fffff : PCI Bus 0000:80
      d3700000-d3703fff : 0000:80:04.7
        d3700000-d3703fff : ioatdma
      d3704000-d3707fff : 0000:80:04.6
        d3704000-d3707fff : ioatdma
      d3708000-d370bfff : 0000:80:04.5
        d3708000-d370bfff : ioatdma
      d370c000-d370ffff : 0000:80:04.4
        d370c000-d370ffff : ioatdma
      d3710000-d3713fff : 0000:80:04.3
        d3710000-d3713fff : ioatdma
      d3714000-d3717fff : 0000:80:04.2
        d3714000-d3717fff : ioatdma
      d3718000-d371bfff : 0000:80:04.1
        d3718000-d371bfff : ioatdma
      d371c000-d371ffff : 0000:80:04.0
        d371c000-d371ffff : ioatdma
      d3720000-d3720fff : 0000:80:05.4
      d37fc000-d37fcfff : dmar0
    d3800000-e0ffffff : PCI Bus 0000:85
      e0900000-e0efffff : PCI Bus 0000:86
        e0900000-e097ffff : 0000:86:00.1
          e0900000-e097ffff : ixgbe
        e0980000-e09fffff : 0000:86:00.0
        e0a00000-e0a7ffff : 0000:86:00.0
          e0a00000-e0a7ffff : ixgbe
        e0a80000-e0b7ffff : 0000:86:00.1
        e0b80000-e0c7ffff : 0000:86:00.1
        e0c80000-e0d7ffff : 0000:86:00.0
        e0d80000-e0e7ffff : 0000:86:00.0
        e0e80000-e0e83fff : 0000:86:00.1
          e0e80000-e0e83fff : ixgbe

        e0e84000-e0e87fff : 0000:86:00.0
          e0e84000-e0e87fff : ixgbe
      e0f00000-e0f00fff : 0000:85:05.4
      e0ffc000-e0ffcfff : dmar1
    e1000000-ee7fffff : PCI Bus 0000:ae
      ee400000-ee5fffff : PCI Bus 0000:af
        ee400000-ee47ffff : 0000:af:00.1
        ee480000-ee4fffff : 0000:af:00.0
        ee500000-ee507fff : 0000:af:00.1
          ee500000-ee507fff : lpfc
        ee508000-ee50ffff : 0000:af:00.0
          ee508000-ee50ffff : lpfc
        ee510000-ee510fff : 0000:af:00.0
          ee510000-ee510fff : lpfc
      ee600000-ee6fffff : PCI Bus 0000:af
        ee600000-ee67ffff : 0000:af:00.1
        ee680000-ee6fffff : 0000:af:00.0
      ee700000-ee700fff : 0000:ae:05.4
      ee7fc000-ee7fcfff : dmar2
    ee800000-fbffffff : PCI Bus 0000:d7
      f7000000-f7ffffff : PCI Bus 0000:dc
      f8000000-f8ffffff : PCI Bus 0000:da
      f9000000-f9ffffff : PCI Bus 0000:dc
      fa000000-faffffff : PCI Bus 0000:da
      fb000000-fb5fffff : PCI Bus 0000:d8
        fb000000-fb07ffff : 0000:d8:00.1
          fb000000-fb07ffff : ixgbe
        fb080000-fb0fffff : 0000:d8:00.0
          fb080000-fb0fffff : ixgbe
        fb100000-fb1fffff : 0000:d8:00.1
        fb200000-fb2fffff : 0000:d8:00.1
        fb300000-fb3fffff : 0000:d8:00.0
        fb400000-fb4fffff : 0000:d8:00.0
        fb500000-fb503fff : 0000:d8:00.1
          fb500000-fb503fff : ixgbe
        fb504000-fb507fff : 0000:d8:00.0
          fb504000-fb507fff : ixgbe
      fb600000-fb600fff : 0000:d7:05.4
      fbffc000-fbffcfff : dmar3
    fd000000-fe7fffff : Reserved
      fd000000-fdabffff : pnp 00:05
      fdad0000-fdadffff : pnp 00:05
      fdb00000-fdffffff : pnp 00:05
        fdc6000c-fdc6000f : iTCO_wdt
      fe000000-fe00ffff : pnp 00:05
      fe010000-fe010fff : PCI Bus 0000:00
        fe010000-fe010fff : 0000:00:1f.5
      fe011000-fe01ffff : pnp 00:05
      fe036000-fe03bfff : pnp 00:05
      fe03d000-fe3fffff : pnp 00:05
      fe410000-fe7fffff : pnp 00:05
    fec00000-fecfffff : PNP0003:00
      fec00000-fec003ff : IOAPIC 0
      fec01000-fec013ff : IOAPIC 1
      fec08000-fec083ff : IOAPIC 2
      fec10000-fec103ff : IOAPIC 3
      fec18000-fec183ff : IOAPIC 4
      fec20000-fec203ff : IOAPIC 5
      fec28000-fec283ff : IOAPIC 6
      fec30000-fec303ff : IOAPIC 7
      fec38000-fec383ff : IOAPIC 8
    fed00000-fed003ff : HPET 0
      fed00000-fed003ff : PNP0103:00
    fed12000-fed1200f : pnp 00:01
    fed12010-fed1201f : pnp 00:01
    fed1b000-fed1bfff : pnp 00:01
    fed20000-fed44fff : Reserved
    fed45000-fed8bfff : pnp 00:01
    fee00000-feefffff : pnp 00:01
      fee00000-fee00fff : Local APIC
    ff000000-ffffffff : Reserved
      ff000000-ffffffff : pnp 00:01
    100000000-603fffffff : System RAM
      2879000000-2879c031d0 : Kernel code
      2879c031d1-287a39ac7f : Kernel data
      287a974000-287adfffff : Kernel bss



Investigation:

The following table summarizes results from 4.19.13 to 4.19.14.

Commithash      cmmt nr.   result

f630d3cc        v4.19.14   crashed
ca3a6fd2        76         crashed
9adea490        114        crashed
3a1cbcf4        133        crashed
42e8bf85        152        crashed
5ea9c08a        157        crashed
d5f9565c        158        crashed
acb70d28        159        no crash
ec820972        161        no crash
360gb1db        165        no crash
3e881d87        170        no crash
c04c050f        v4.19.13   no crash

In addition, stable 4.19.154 (f5d8eef067) also crashes.

4.19.15 minus commit ade446403bfb79d3528d56071a84b15351a139ad does not
crash.

5.3.11 also tested: crashes
5.6.13 also tested: no crash

Crash dump analysis yields two signatures, the less common one is below:

[exception RIP: kmem_cache_alloc+129]
 RIP: ffffffff8927a121 RSP: ffff935e4fa83db8 RFLAGS: 00010206
 RAX: 0000000000000000 RBX: 19aeb00f27a2aed2 RCX: 0000000000000000
 RDX: 0000000000005d78 RSI: 0000000000480020 RDI: 0000000000028480
 RBP: 0000000000480020 R8: ffff935e4faa8480 R9: ffff935e1f79d0fc
 R10: ffff935240280e80 R11: 000000307fa724a3 R12: ffffffff897acac5
 R13: 19aeb00f27a2aed2 R14: ffff93524f59f300 R15: ffff93524f59f300
 ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
 #5 [ffff935e4fa83de8] __build_skb at ffffffff897acac5
 #6 [ffff935e4fa83e00] build_skb at ffffffff897acb91
 #7 [ffff935e4fa83e18] ixgbe_poll at ffffffffc06a3a65 [ixgbe]
 #8 [ffff935e4fa83ee8] net_rx_action at ffffffff897c50e9
 #9 [ffff935e4fa83f68] __softirqentry_text_start at ffffffff89c000e3
#10 [ffff935e4fa83fc8] irq_exit at ffffffff890b8830
#11 [ffff935e4fa83fd8] smp_apic_timer_interrupt at ffffffff89a02514
#12 [ffff935e4fa83ff0] apic_timer_interrupt at ffffffff89a01a7f
--- <IRQ stack> ---

The more commonone is:

 [exception RIP: kmem_cache_alloc+129]
 RIP: ffffffff9d27a121 RSP: ffff8da27f743c28 RFLAGS: 00010206
 RAX: 0000000000000000 RBX: 7a1d636a4dcbe755 RCX: 0000000000000004
 RDX: 00000000010e6dec RSI: 0000000000480020 RDI: 0000000000028680
 RBP: 0000000000480020 R8: ffff8da27f768680 R9: ffff8d426e7ea000
 R10: ffff8da26d3a0550 R11: ffff8d426e7ea0a0 R12: ffffffff9d7ae99d
 R13: 7a1d636a4dcbe755 R14: ffff8d427325a580 R15: ffff8d427325a580
 ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
 #5 [ffff8da27f743c58] skb_clone at ffffffff9d7ae99d
 #6 [ffff8da27f743c70] ip_defrag at ffffffff9d81eb11
 #7 [ffff8da27f743cf0] ipv4_conntrack_defrag at ffffffffc0333134
[nf_defrag_ipv4]
 #8 [ffff8da27f743d08] nf_hook_slow at ffffffff9d8114d4
 #9 [ffff8da27f743d38] ip_rcv at ffffffff9d81dda5
#10 [ffff8da27f743d90] __netif_receive_skb_one_core at ffffffff9d7c4922
#11 [ffff8da27f743db8] netif_receive_skb_internal at ffffffff9d7c3b12
#12 [ffff8da27f743de0] napi_gro_receive at ffffffff9d7c5a1a
#13 [ffff8da27f743e00] ixgbe_poll at ffffffffc0636558 [ixgbe]
#14 [ffff8da27f743ed0] net_rx_action at ffffffff9d7c50e9
#15 [ffff8da27f743f50] __softirqentry_text_start at ffffffff9dc000e3
#16 [ffff8da27f743fb0] irq_exit at ffffffff9d0b8830
#17 [ffff8da27f743fc0] do_IRQ at ffffffff9da01cb5
--- <IRQ stack> ---
#18 [ffffa4ef801fbde8] ret_from_intr at ffffffff9da0098f
 [exception RIP: cpuidle_enter_state+185]
 RIP: ffffffff9d76dd69 RSP: ffffa4ef801fbe90 RFLAGS: 00000246
 RAX: ffff8da27f760f40 RBX: 00003a0cd7edcf49 RCX: 000000000000001f
 RDX: 00003a0cd7edcf49 RSI: 000000003a2e8d5e RDI: 0000000000000000
 RBP: ffff8da27f76bc78 R8: 0000000000000002 R9: 0000000000020800
 R10: 00012aac101412d6 R11: ffff8da27f75fde8 R12: 0000000000000003
 R13: ffffffff9e2d7a18 R14: 0000000000000003 R15: 0000000000000000
 ORIG_RAX: ffffffffffffffd9 CS: 0010 SS: 0018
#19 [ffffa4ef801fbed0] do_idle at ffffffff9d0e5a56
#20 [ffffa4ef801fbf10] cpu_startup_entry at ffffffff9d0e5c6f
#21 [ffffa4ef801fbf30] start_secondary at ffffffff9d054a47
#22 [ffffa4ef801fbf50] secondary_startup_64 at ffffffff9d0000d4

Examination of the kmem_cache pointers in slub.c shows that they
are corrupted elsewhere and only precipitate a crash here:

mm/slub.c

 248 static inline void *freelist_ptr(const struct kmem_cache *s, void *ptr,
 249                                  unsigned long ptr_addr)
 250 {
 251 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 252         return (void *)((unsigned long)ptr ^ s->random ^ ptr_addr);
 253 #else
 254         return ptr;
 255 #endif
 256 }

The hardening macro is irrelevant, the data are corrupt beforehand.


This crash has been observed at two commercial banks both of which employ
Qualys scanner appliances.  Attempts to reproduce this with a VM-based
Qualys scanner failed.  The crash was reproduced however by capturing the
packets from the VM system and replaying them faster.

Kernel 4.19.13 or 4.19.15 without the commit mentioned survive even if
the packets are replayed at wire speed. With the commit in place, crash
occurs at perhaps 2% of that speed.

As noted, 4.19.154 also crashes, as does 4.20.3 and 4.20.16.
Only two 5-series kernels were tried 5.3.11 (crashed) and 5.6.13 (survived).

This has been reproduced numerous times while scanning live, and also
with captured packets using tcpreplay.

Note that the Qualys scanner uses a shower-of-packets strategy with several
threads running so it is not straightforward to identify a sequence which
provokes a crash.

-- 
You are receiving this mail because:
You are the assignee for the bug.
