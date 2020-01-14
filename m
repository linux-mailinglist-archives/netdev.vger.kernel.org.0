Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF013A148
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgANHDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:03:33 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33818 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgANHDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:03:31 -0500
Received: by mail-pj1-f67.google.com with SMTP id s94so664008pjc.1
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JT4gQITz5X9Xt6Y+CPiYWOuaQyLN3EbApxlmt3oZ4ms=;
        b=Yn3FyfRt/GHJfiT5WA12QGY0ae+GzG0x/COwvypKJdpq8CmDnkwt7/jz/thyCZ4IHM
         TrayoivpCFGBdrNFgRGHJfYiQOCsBpycZ68oJt2S1IoiaL2NJWYAvXomZ61aRfLZOgFV
         283RUwgDgbxsKQSR/EB8Tu97b14mPFYnEg1mNQgqx8l0NHLASg7A8+lKaG5dwWwi3yAG
         S5jjND/asVE6zHKhaVT4YsDp4LA7bgU2gJDGGxRceB4AsLh3wplyLlvxx4VAzc2dWZNL
         nL9/v+IKr5/N2hinWehIY+VrE+AyP/WFsMx0J/Y+SZDr//CXAJu5eqICjELRmLUmmNsN
         I2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JT4gQITz5X9Xt6Y+CPiYWOuaQyLN3EbApxlmt3oZ4ms=;
        b=g+nvr2zxBSxMToaBwCjcjJMC96BJgMMWlKCMT+jremSKsSk04cu5YQR/BmzuSdPRD2
         sfZd59iwZYIu5Difet85PXNn5LEjbYcc28l22Jq8VFOrr9ZVPwDO4WZXGR68Gn6jfYkA
         QWkUuNxaLlZgz2l2mpDRd7vz8kFDNbYdCnTOY9TKALB8QGv2/tl13JeaiaAvYk6OEUU3
         XqI6PtF/QvQmgNRG13rUq2K22ffRfbDe+DcGT9hEcP5PFlHt+0WLTVQW5aOdJ5YMPODw
         X795+UaOE8GqrvDYLiG5OQ+9XP5dZVStHDVJo9/As3+Ea2HMRuyxzeHqSHZXivGi34Jn
         BoOg==
X-Gm-Message-State: APjAAAVGDGOQJ34/KlQEwa42nysEWoVA1YiQUSX8PLVX/8YjY610EUWD
        ZPOryLSVAnBMm7/1YY1d3kbL23LMiQs=
X-Google-Smtp-Source: APXvYqygW8yRULkjlVivzTdi9rjQFjUX2ZwaFg/arS73un0EJGmB0b93uF7pRy0ZrK2BcabehEWjXA==
X-Received: by 2002:a17:902:528:: with SMTP id 37mr25147061plf.322.1578985410245;
        Mon, 13 Jan 2020 23:03:30 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm2241014pjr.2.2020.01.13.23.03.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 Jan 2020 23:03:29 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 16/17] Documentation: net: octeontx2: Add RVU HW and drivers overview
Date:   Tue, 14 Jan 2020 12:32:19 +0530
Message-Id: <1578985340-28775-17-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added high level overview of OcteonTx2 RVU HW and functionality of
various drivers which will be upstreamed.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 Documentation/networking/device_drivers/index.rst  |   1 +
 .../device_drivers/marvell/octeontx2.rst           | 159 +++++++++++++++++++++
 MAINTAINERS                                        |   1 +
 3 files changed, 161 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/marvell/octeontx2.rst

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 4bc6ff2..a191faa 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -22,6 +22,7 @@ Contents:
    intel/iavf
    intel/ice
    google/gve
+   marvell/octeontx2
    mellanox/mlx5
    netronome/nfp
    pensando/ionic
diff --git a/Documentation/networking/device_drivers/marvell/octeontx2.rst b/Documentation/networking/device_drivers/marvell/octeontx2.rst
new file mode 100644
index 0000000..51d9ccb
--- /dev/null
+++ b/Documentation/networking/device_drivers/marvell/octeontx2.rst
@@ -0,0 +1,159 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+====================================
+Marvell OcteonTx2 RVU Kernel Drivers
+====================================
+
+Copyright (c) 2020 Marvell International Ltd.
+
+Contents
+========
+
+- `Overview`_
+- `Drivers`_
+- `Basic packet flow`_
+
+Overview
+========
+
+Resource virtualization unit (RVU) on Marvell's OcteonTX2 SOC maps HW
+resources from the network, crypto and other functional blocks into
+PCI-compatible physical and virtual functions. Each functional block
+again has multiple local functions (LFs) for provisioning to PCI devices.
+RVU supports multiple PCIe SRIOV physical functions (PFs) and virtual
+functions (VFs). PF0 is called the administrative / admin function (AF)
+and has privileges to provision RVU functional block's LFs to each of the
+PF/VF.
+
+RVU managed networking functional blocks
+ - Network pool or buffer allocator (NPA)
+ - Network interface controller (NIX)
+ - Network parser CAM (NPC)
+ - Schedule/Synchronize/Order unit (SSO)
+ - Loopback interface (LBK)
+
+RVU managed non-networking functional blocks
+ - Crypto accelerator (CPT)
+ - Scheduled timers unit (TIM)
+ - Schedule/Synchronize/Order unit (SSO)
+   Used for both networking and non networking usecases
+
+Resource provisioning examples
+ - A PF/VF with NIX-LF & NPA-LF resources works as a pure network device
+ - A PF/VF with CPT-LF resource works as a pure crypto offload device.
+
+RVU functional blocks are highly configurable as per software requirements.
+
+Firmware setups following stuff before kernel boots
+ - Enables required number of RVU PFs based on number of physical links.
+ - Number of VFs per PF are either static or configurable at compile time.
+   Based on config, firmware assigns VFs to each of the PFs.
+ - Also assigns MSIX vectors to each of PF and VFs.
+ - These are not changed after kernel boot.
+
+Drivers
+=======
+
+Linux kernel will have multiple drivers registering to different PF and VFs
+of RVU. Wrt networking there will be 3 flavours of drivers.
+
+Admin Function driver
+---------------------
+
+As mentioned above RVU PF0 is called the admin function (AF), this driver
+supports resource provisioning and configuration of functional blocks.
+Doesn't handle any I/O. It sets up few basic stuff but most of the
+funcionality is achieved via configuration requests from PFs and VFs.
+
+PF/VFs communicates with AF via a shared memory region (mailbox). Upon
+receiving requests AF does resource provisioning and other HW configuration.
+AF is always attached to host kernel, but PFs and their VFs may be used by host
+kernel itself, or attached to VMs or to userspace applications like
+DPDK etc. So AF has to handle provisioning/configuration requests sent
+by any device from any domain.
+
+AF driver also interacts with underlying firmware to
+ - Manage physical ethernet links ie CGX LMACs.
+ - Retrieve information like speed, duplex, autoneg etc
+ - Retrieve PHY EEPROM and stats.
+ - Configure FEC, PAM modes
+ - etc
+
+From pure networking side AF driver supports following functionality.
+ - Map a physical link to a RVU PF to which a netdev is registered.
+ - Attach NIX and NPA block LFs to RVU PF/VF which provide buffer pools, RQs, SQs
+   for regular networking functionality.
+ - Flow control (pause frames) enable/disable/config.
+ - HW PTP timestamping related config.
+ - NPC parser profile config, basically how to parse pkt and what info to extract.
+ - NPC extract profile config, what to extract from the pkt to match data in MCAM entries.
+ - Manage NPC MCAM entries, upon request can frame and install requested packet forwarding rules.
+ - Defines receive side scaling (RSS) algorithms.
+ - Defines segmentation offload algorithms (eg TSO)
+ - VLAN stripping, capture and insertion config.
+ - SSO and TIM blocks config which provide packet scheduling support.
+ - Debugfs support, to check current resource provising, current status of
+   NPA pools, NIX RQ, SQ and CQs, various stats etc which helps in debugging issues.
+ - And many more.
+
+Physical Function driver
+------------------------
+
+This RVU PF handles IO, is mapped to a physical ethernet link and this
+driver registers a netdev. This supports SR-IOV. As said above this driver
+communicates with AF with a mailbox. To retrieve information from physical
+links this driver talks to AF and AF gets that info from firmware and responds
+back ie cannot talk to firmware directly.
+
+Supports ethtool for configuring links, RSS, queue count, queue size,
+flow control, ntuple filters, dump PHY EEPROM, config FEC etc.
+
+Virtual Function driver
+-----------------------
+
+There are two types VFs, VFs that share the physical link with their parent
+SR-IOV PF and the VFs which work in pairs using internal HW loopback channels (LBK).
+
+Type1:
+ - These VFs and their parent PF share a physical link and used for outside communication.
+ - VFs cannot communicate with AF directly, they send mbox message to PF and PF
+   forwards that to AF. AF after processing, responds back to PF and PF forwards
+   the reply to VF.
+ - From functionality point of view there is no difference between PF and VF as same type
+   HW resources are attached to both. But user would be able to configure few stuff only
+   from PF as PF is treated as owner/admin of the link.
+
+Type2:
+ - RVU PF0 ie admin function creates these VFs and maps them to loopback block's channels.
+ - A set of two VFs (VF0 & VF1, VF2 & VF3 .. so on) works as a pair ie pkts sent out of
+   VF0 will be received by VF1 and viceversa.
+ - These VFs can be used by applications or virtual machines to communicate between them
+   without sending traffic outside. There is no switch present in HW, hence the support
+   for loopback VFs.
+ - These communicate directly with AF (PF0) via mbox.
+
+Except for the IO channels or links used for packet reception and transmission there is
+no other difference between these VF types. AF driver takes care of IO channel mapping,
+hence same VF driver works for both types of devices.
+
+Basic packet flow
+===========
+
+Ingress
+-------
+
+1. CGX LMAC receives packet.
+2. Forwards the packet to the NIX block.
+3. Then submitted to NPC block for parsing and then MCAM lookup to get the destination RVU device.
+4. NIX LF attached to the destination RVU device allocates a buffer from RQ mapped buffer pool of NPA block LF.
+5. RQ may be selected by RSS or by configuring MCAM rule with a RQ number.
+6. Packet is DMA'ed and driver is notified.
+
+Egress
+------
+
+1. Driver prepares a send descriptor and submits to SQ for transmission.
+2. The SQ is already configured (by AF) to transmit on a specific link/channel.
+3. The SQ descriptor ring is maintained in buffers allocated from SQ mapped pool of NPA block LF.
+4. NIX block transmits the pkt on the designated channel.
+5. NPC MCAM entries can be installed to divert pkt onto a different channel.
diff --git a/MAINTAINERS b/MAINTAINERS
index 2549f10..6659dd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10000,6 +10000,7 @@ M:	Jerin Jacob <jerinj@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/marvell/octeontx2/af/
+F:	Documentation/networking/device_drivers/marvell/octeontx2.rst
 
 MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
-- 
2.7.4

