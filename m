Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6E214A485
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgA0NGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:38 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33523 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgA0NGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:35 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so4873903pfn.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ySTFTyVLtOkBBlriTGaPo1Wo3ZpCHeLS/qiUSJLdxV8=;
        b=sYMI1UxtDz5wszZtEnabNE9BnRMUGGfaLfoqcaMmueKjJ/2q+93wFaRXtpJD4Si6Zr
         PLhqVLK3foGrT7J/zPwhgvqbMngp5k6fwpugchXAa8MDNgnZ2MbDwX7SrrZDdpOcYiAm
         YkueW7VPnMidYIRm3qrWyDxfJxEC6kxRYmjJbl/V85qsMSZAGqE1tzKdSNYKluqLxneX
         l0uK+CaBa/+SiKIeBfBZnTSq91PjdJts7dDf6RmPyPpDQqxuqqCwbu6esmxOg+zr51Or
         ZKzX86SLEcJz3kCZ/vYUnJzj2jUDfFJwsCkUNSLiPRn/Tq4nxY8xzU/6E3AnIpV5k0oi
         cieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ySTFTyVLtOkBBlriTGaPo1Wo3ZpCHeLS/qiUSJLdxV8=;
        b=SoezBb4pjQVUpvP0YwX7p3AMUeYN7TW4UEa9ygEUl7DpCJ0jQk+8XQ5ZvdDcGcfl+h
         OCDupQSCviFAocEP/7pPSypc6asoCSPYgFoyWjrKFslKwZSF+75RcbqBEKjTcI+KlSiP
         W83NK6xO/yuw+I6clGbSvRwa7XY2zq4BSE3UoQuw2XYD3x+3aT4TCsqpn4qenihNK3X3
         dQaVCfguFZUuXyb3NRHCWMPBNmkLscWToswVUmr4Dd5Wuio66s0Zjkx2lD/19zX05bGR
         XFoiqoJyWis4ozLHWEbk5nIXojlos+2fLNAtkKikY3rzwBtKJLpv/yf8m5g07SnDV+jN
         rpbQ==
X-Gm-Message-State: APjAAAW1ApvoK4ILwrCNGxgEcoPaty5Sj6B1esQnei/gkJ+1rh1xsMtx
        3veLWqnbA7zKFDl01bHZ05zpuUT8GRU=
X-Google-Smtp-Source: APXvYqz2hDJnYhOVNnkZqClrwNJ7+sZob9WGXe6NVNGQQHfSgnmoblH7J9ZVuKohQPn1SWHmonAVbw==
X-Received: by 2002:a63:3645:: with SMTP id d66mr19214936pga.337.1580130394459;
        Mon, 27 Jan 2020 05:06:34 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.06.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:06:33 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v6 16/17] Documentation: net: octeontx2: Add RVU HW and drivers overview
Date:   Mon, 27 Jan 2020 18:35:30 +0530
Message-Id: <1580130331-8964-17-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 0000000..88f5083
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
+=================
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
index 31084bd..681ba1d 100644
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

