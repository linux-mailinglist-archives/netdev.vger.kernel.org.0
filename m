Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EE8421914
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 23:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhJDVQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 17:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbhJDVQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 17:16:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F3C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 14:14:21 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t4so841395plo.0
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 14:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=7sIl4pwj3+8Sn7j1hatPTF//dctkIuMp2/OfBYRPG70=;
        b=DNdHT1vKIboHTfzeu6XZ4gI7fubSzTon8QC8+vV674g3wSE06bZiKIxmr60vSf5HJ3
         7sq2hQE8WRnuN3I04etc3Xu+PsUJqn715jDERsfoJa6amMhW6qpW3BmJhwgM8Nmm5og5
         cdk8qJjBXsA9IGNHPbYr/hQN7VZtWH7XvZV9UcIPz9UK3K/0oI/3kzpmfPirr0TDzHgm
         pVYb+n7zxzvEAyHYNR2nZcQNVnwhOu6tgy8WX/CSY1ellmC8RgUZZqTogdXIjd3kacID
         yEV5sAz1ioQI0BLVNC/hNAd/eG44vez4ih5dvVgTXqnErPpX7rpQvWrcufdJVNB//thc
         vJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=7sIl4pwj3+8Sn7j1hatPTF//dctkIuMp2/OfBYRPG70=;
        b=KjwgbMNJSa7Ye1NquPo4/TGjQayDZzSnSTw0Z25HePBfvG2AxPn7WG9cWKHl+ZDjiC
         aTDe9wNkwTkzNgafPjzoBTtnK7M7jwuPfT2JmjWktkAaaNcO9TFzDsebN/ylivWLVCAj
         H/0PlDPCcu88g9evpvXbgh8m7L26cSQrjHOWfbmCDIbI2/S/nJAiAAv9eQgQjHQ7ZpUn
         yrV7Eaqu2iUgUozhEUw8bH70gAKBJil9VPpDAfHkiOq2xLFJqlfm82FWnYI4a5m+I9/D
         APcbt9f1/eAbvq/TN/6xZAgxWVjYgazhJPUBigJtHQKtmaQTwc66TgYzuaCKvMsQmSj3
         BKYg==
X-Gm-Message-State: AOAM532pwUuxCnhOKfbScU6YQJi4dV3r2e6nKwi6l2Sil7p+cqv6AQzi
        wQ1NsKtjEItyNqpf829twRYxHwc2x/cJ1A==
X-Google-Smtp-Source: ABdhPJypruW2QfCKW+RaU6dDG3SurgZ7uEnqKovVDav6Zq4VLatQkM0etlkzODl6GB7K6qEPxg1fGQ==
X-Received: by 2002:a17:90a:312:: with SMTP id 18mr39356087pje.178.1633382060946;
        Mon, 04 Oct 2021 14:14:20 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id k201sm3247814pfd.133.2021.10.04.14.14.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 14:14:20 -0700 (PDT)
Date:   Mon, 4 Oct 2021 14:14:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 214619] New: Aquantia / Atlantic driver not loading post
 5.14.RC7
Message-ID: <20211004141418.1b4bd7bb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 04 Oct 2021 21:02:11 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214619] New: Aquantia / Atlantic driver not loading post 5.14.RC7


https://bugzilla.kernel.org/show_bug.cgi?id=214619

            Bug ID: 214619
           Summary: Aquantia / Atlantic driver not loading post 5.14.RC7
           Product: Networking
           Version: 2.5
    Kernel Version: 514.rc7
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: Miles.Rumppe@gmail.com
        Regression: No

Created attachment 299091
  --> https://bugzilla.kernel.org/attachment.cgi?id=299091&action=edit  
Photo of error

When upgrading from RC7 to any post release my system hangs with an error
regarding the card.  

server:~$ sudo inxi -F
System:    Host: server Kernel: 5.14.0-051400rc7-lowlatency x86_64 bits: 64
Console: tty pts/5 
           Distro: Ubuntu 21.10 (Impish Indri) 
Machine:   Type: Desktop Mobo: ASRock model: Z390M Pro4 serial: M80-C9015301070
UEFI-[Legacy]: American Megatrends v: P4.30 
           date: 12/03/2019 
CPU:       Info: 6-Core model: Intel Core i7-8700K bits: 64 type: MT MCP cache:
L2: 12 MiB 
           Speed: 800 MHz min/max: 800/4700 MHz Core speeds (MHz): 1: 800 2:
799 3: 800 4: 800 5: 800 6: 800 7: 800 8: 800 
           9: 800 10: 800 11: 800 12: 800 
Graphics:  Device-1: Intel CometLake-S GT2 [UHD Graphics 630] driver: i915 v:
kernel 
           Device-2: Conexant Systems CX23887/8 PCIe Broadcast Audio and Video
Decoder with 3D Comb driver: cx23885 v: 0.0.4 
           Device-3: Conexant Systems CX23887/8 PCIe Broadcast Audio and Video
Decoder with 3D Comb driver: cx23885 v: 0.0.4 
           Display: server: X.org 1.20.13 driver: loaded: modesetting tty:
182x55 
           Message: Advanced graphics data unavailable in console for root. 
Audio:     Device-1: Intel Cannon Lake PCH cAVS driver: snd_hda_intel 
           Device-2: Conexant Systems CX23887/8 PCIe Broadcast Audio and Video
Decoder with 3D Comb driver: cx23885 
           Device-3: Conexant Systems CX23887/8 PCIe Broadcast Audio and Video
Decoder with 3D Comb driver: cx23885 
           Sound Server-1: ALSA v: k5.14.0-051400rc7-lowlatency running: yes 
           Sound Server-2: PulseAudio v: 15.0 running: yes 
           Sound Server-3: PipeWire v: 0.3.32 running: yes 
Network:   Device-1: Intel Ethernet I219-V driver: e1000e 
           IF: eno1 state: up speed: 1000 Mbps duplex: full mac:
a2:9d:8a:e8:39:2a 
           Device-2: Aquantia AQC111 NBase-T/IEEE 802.3bz Ethernet [AQtion]
driver: atlantic 
           IF: enp5s0 state: up speed: 2500 Mbps duplex: full mac:
24:5e:be:4d:c4:53 
           Device-3: Aquantia AQC111 NBase-T/IEEE 802.3bz Ethernet [AQtion]
driver: atlantic 
           IF: enp6s0 state: down mac: 24:5e:be:4d:c4:54 
           Device-4: Aquantia AQC111 NBase-T/IEEE 802.3bz Ethernet [AQtion]
driver: atlantic 
           IF: enp8s0 state: up speed: 1000 Mbps duplex: full mac:
a2:9d:8a:e8:39:2a 
           Device-5: Aquantia AQC111 NBase-T/IEEE 802.3bz Ethernet [AQtion]
driver: atlantic 
           IF: enp9s0 state: up speed: 1000 Mbps duplex: full mac:
a2:9d:8a:e8:39:2a 
           IF-ID-1: bo0 state: up speed: 2000 Mbps duplex: full mac:
a2:9d:8a:e8:39:2a 
           IF-ID-2: bonding_masters state: N/A speed: N/A duplex: N/A mac: N/A 
           IF-ID-3: br0 state: up speed: 2500 Mbps duplex: unknown mac:
da:88:2f:77:a2:3d 
           IF-ID-4: nordlynx state: unknown speed: N/A duplex: N/A mac: N/A 
RAID:      Device-1: md0 type: mdraid level: raid-10 status: active size: 18.19
TiB report: 5/5 UUUUU 
           Components: Online: 1: sdd1 2: sde1 3: sdb1 4: sdc1 5: sda1 
Drives:    Local Storage: total: raw: 36.62 TiB usable: 18.43 TiB used: 7.18
TiB (39.0%) 
           ID-1: /dev/nvme0n1 vendor: Samsung model: MZVPW256HEGL-000H1 size:
238.47 GiB 
           ID-2: /dev/sda vendor: Western Digital model: WD80EZAZ-11TDBA0 size:
7.28 TiB 
           ID-3: /dev/sdb vendor: Western Digital model: WD80EZAZ-11TDBA0 size:
7.28 TiB 
           ID-4: /dev/sdc vendor: Western Digital model: WD80EZAZ-11TDBA0 size:
7.28 TiB 
           ID-5: /dev/sdd vendor: Western Digital model: WD80EZAZ-11TDBA0 size:
7.28 TiB 
           ID-6: /dev/sde vendor: Western Digital model: WD80EZAZ-11TDBA0 size:
7.28 TiB 
Partition: ID-1: / size: 233.73 GiB used: 89.04 GiB (38.1%) fs: ext4 dev:
/dev/nvme0n1p1 
Swap:      Alert: No swap data was found. 
Sensors:   System Temperatures: cpu: 30.0 C mobo: 32.0 C 
           Fan Speeds (RPM): fan-1: 860 fan-2: 634 fan-4: 888 fan-5: 882 
Info:      Processes: 366 Uptime: 2h 58m Memory: 15.29 GiB used: 2.47 GiB
(16.1%) Init: systemd runlevel: 5 Shell: Bash 
           inxi: 3.3.06 

I've tried weekly to update the kernel with the same result as the attachment.
Requires a boot into livecd and remove the updated kernel and revert to rc7
release to resume working.  It's a bit difficult to capture more info since the
hanging boot eventually does bring up the desktop but, functions requiring sudo
don't respond in terminal to capture additional info.  I've attempted weekly
upgrades to non-RC kernel versions as well as skipping to 5.15.x to see if it
has been resolved to no avail.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
