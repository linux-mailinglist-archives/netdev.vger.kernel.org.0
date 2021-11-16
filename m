Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD74453BAF
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhKPVgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhKPVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 16:36:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFF5C061570;
        Tue, 16 Nov 2021 13:33:15 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so3402791pja.1;
        Tue, 16 Nov 2021 13:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qTG9SIjYHX6f62hW4bNeP6RLfo5ctIgsWr+bGCNsOlY=;
        b=MhKu/CYBNf+saex87/tXWsDJdhpD6mZNR3kwzJ7CQu2VSnxk/1LrNy4zDJHilz2yG8
         xdRrpycybl4GR3d/CkPYlfWzC+hzmjD2PA2CfxwMo/91LdhSM3/0YhdBiOTiGDj48Lvm
         u6r+WLgqSU6iKBs+MtKTbZw78lB5zLc0L3Qnga8pyQjC5VpqhRKQ+bSBI5HPsgHNp3X8
         rh0bVmf8nEDoqMMIzWyz1XzibrVM8nYcnNmUAkuy36lsJ53kzEc0ad+ITNanE/dXHwNG
         ilj+Peys+yEx2jKP1u3MZiMq0kTmoyT6CHdLIligsNdH9QSBTB7aTWp2IJi1FYMOwZS6
         VkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qTG9SIjYHX6f62hW4bNeP6RLfo5ctIgsWr+bGCNsOlY=;
        b=HohwXKuXCGu9KOWkwwGTgrbUy6hO99u1zg9ZrAhESnhhV0LrHF9VZnc5bH2wN8979Z
         E5/Rf1w1plZNHphoAmvL+FRZOMmKVFUnmCzVLjcThoLdJECtX42zKn92HfzLLpEA2h/U
         UWk0pGkgRWNXgj+01hzbnnqDNApbcnKfXiH6FEmXXjxDYfUJ15bJcZSqAu9C+yxhMvxr
         Nz8hCbcYP7J1w3L1Jtv4wKYCNR50M7CHh9pkSqH4BjCV0BojArB84Z7n7y/B6bQodTUC
         LWm/v7mUglA9UyIvp+BxLRuqdnpiLJZudLFiWkcQthBg7ts5WYufKO1iop6gkd6+cMIW
         nfAw==
X-Gm-Message-State: AOAM5325JlBNxeNGOqMik8vUcI9vjOtHf0cgudq/rEVolW4iP/Rnysmu
        jqCszZeJsvG71wsHn/8fZBU=
X-Google-Smtp-Source: ABdhPJxXIY2FPncmcDyIy6JGacSPiQQVckJTPpcNt4j0LnKjskb4gAu+gGq2k1NfpAuYO/48sUJqcw==
X-Received: by 2002:a17:903:120c:b0:13f:d043:3477 with SMTP id l12-20020a170903120c00b0013fd0433477mr48986152plh.89.1637098394731;
        Tue, 16 Nov 2021 13:33:14 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id p35sm17667pgm.15.2021.11.16.13.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 13:33:14 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-11-16
Date:   Tue, 16 Nov 2021 13:33:13 -0800
Message-Id: <20211116213313.985961-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit d0f1c248b4ff71cada1b9e4ed61a1992cd94c3df:

  Merge tag 'for-net-next-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next (2021-10-05 07:41:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-11-16

for you to fetch changes up to 28491d7ef4af471841e454f8c1f77384f93c6fef:

  Bluetooth: btusb: enable Mediatek to support AOSP extension (2021-11-16 16:16:23 +0100)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for AOSP Bluetooth Quality Report
 - Enables AOSP extension for Mediatek Chip (MT7921 & MT7922)
 - Rework of HCI command execution serialization

----------------------------------------------------------------
Archie Pusaka (3):
      Bluetooth: Fix removing adv when processing cmd complete
      Bluetooth: Ignore HCI_ERROR_CANCELLED_BY_HOST on adv set terminated event
      Bluetooth: Attempt to clear HCI_LE_ADV on adv set terminated error event

Brian Gix (13):
      Bluetooth: hci_sync: Convert MGMT_OP_SET_FAST_CONNECTABLE
      Bluetooth: hci_sync: Enable synch'd set_bredr
      Bluetooth: hci_sync: Convert MGMT_OP_GET_CONN_INFO
      Bluetooth: hci_sync: Convert MGMT_OP_SET_SECURE_CONN
      Bluetooth: hci_sync: Convert MGMT_OP_GET_CLOCK_INFO
      Bluetooth: hci_sync: Convert MGMT_OP_SET_LE
      Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_DATA
      Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_EXT_DATA
      Bluetooth: hci_sync: Convert MGMT_OP_SET_LOCAL_NAME
      Bluetooth: hci_sync: Convert MGMT_OP_SET_PHY_CONFIGURATION
      Bluetooth: hci_sync: Convert MGMT_OP_SET_ADVERTISING
      Bluetooth: hci_sync: Convert adv_expire
      Bluetooth: hci_sync: Convert MGMT_OP_SSP

David Yang (1):
      Bluetooth: btusb: Fix application of sizeof to pointer

Jackie Liu (1):
      Bluetooth: fix uninitialized variables notify_evt

Jesse Melhuish (1):
      Bluetooth: Don't initialize msft/aosp when using user channel

Johan Hovold (1):
      Bluetooth: bfusb: fix division by zero in send path

Joseph Hwang (2):
      Bluetooth: Add struct of reading AOSP vendor capabilities
      Bluetooth: aosp: Support AOSP Bluetooth Quality Report

Kiran K (2):
      Bluetooth: Read codec capabilities only if supported
      Bluetooth: btintel: Fix bdaddress comparison with garbage value

Kyle Copperfield (1):
      Bluetooth: btsdio: Do not bind to non-removable BCM4345 and BCM43455

Luiz Augusto von Dentz (19):
      Bluetooth: hci_vhci: Fix calling hci_{suspend,resume}_dev
      Bluetooth: Fix handling of SUSPEND_DISCONNECTING
      Bluetooth: L2CAP: Fix not initializing sk_peer_pid
      Bluetooth: vhci: Add support for setting msft_opcode and aosp_capable
      Bluetooth: vhci: Fix checking of msft_opcode
      Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 1
      Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2
      Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3
      Bluetooth: hci_sync: Enable advertising when LL privacy is enabled
      Bluetooth: hci_sync: Rework background scan
      Bluetooth: hci_sync: Convert MGMT_SET_POWERED
      Bluetooth: hci_sync: Convert MGMT_OP_START_DISCOVERY
      Bluetooth: hci_sync: Rework init stages
      Bluetooth: hci_sync: Rework hci_suspend_notifier
      Bluetooth: hci_sync: Fix missing static warnings
      Bluetooth: hci_sync: Fix not setting adv set duration
      Bluetooth: hci_sync: Convert MGMT_OP_SET_DISCOVERABLE to use cmd_sync
      Bluetooth: hci_sync: Convert MGMT_OP_SET_CONNECTABLE to use cmd_sync
      Bluetooth: hci_request: Remove bg_scan_update work

Marcel Holtmann (1):
      Bluetooth: Add helper for serialized HCI command execution

Mark-YW.Chen (1):
      Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Mark-yw Chen (1):
      Bluetooth: btmtksdio: transmit packet according to status TX_EMPTY

Nguyen Dinh Phi (1):
      Bluetooth: hci_sock: purge socket queues in the destruct() callback

Paul Cercueil (1):
      Bluetooth: hci_bcm: Remove duplicated entry in OF table

Pavel Skripkin (1):
      Bluetooth: stop proccessing malicious adv data

Randy Dunlap (1):
      Bluetooth: btmrvl_main: repair a non-kernel-doc comment

Sean Wang (9):
      Bluetooth: mediatek: add BT_MTK module
      Bluetooth: btmtksido: rely on BT_MTK module
      Bluetooth: btmtksdio: add .set_bdaddr support
      Bluetooth: btmtksdio: explicitly set WHISR as write-1-clear
      Bluetooth: btmtksdio: move interrupt service to work
      Bluetooth: btmtksdio: update register CSDIOCSR operation
      Bluetooth: btmtksdio: use register CRPLR to read packet length
      mmc: add MT7921 SDIO identifiers for MediaTek Bluetooth devices
      Bluetooth: btmtksdio: add MT7921s Bluetooth support

Soenke Huster (1):
      Bluetooth: virtio_bt: fix memory leak in virtbt_rx_handle()

Tedd Ho-Jeong An (2):
      Bluetooth: hci_vhci: Fix to set the force_wakeup value
      Bluetooth: mgmt: Fix Experimental Feature Changed event

Tim Jiang (1):
      Bluetooth: btusb: Add support using different nvm for variant WCN6855 controller

Wang Hai (1):
      Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails

Wei Yongjun (2):
      Bluetooth: Fix debugfs entry leak in hci_register_dev()
      Bluetooth: Fix memory leak of hci device

Zijun Hu (1):
      Bluetooth: hci_h4: Fix padding calculation error within h4_recv_buf()

mark-yw.chen (1):
      Bluetooth: btusb: enable Mediatek to support AOSP extension

 drivers/bluetooth/Kconfig         |    6 +
 drivers/bluetooth/Makefile        |    1 +
 drivers/bluetooth/bfusb.c         |    3 +
 drivers/bluetooth/btintel.c       |   22 +-
 drivers/bluetooth/btmrvl_main.c   |    2 +-
 drivers/bluetooth/btmtk.c         |  289 +++
 drivers/bluetooth/btmtk.h         |  111 +
 drivers/bluetooth/btmtksdio.c     |  496 ++--
 drivers/bluetooth/btsdio.c        |    2 +
 drivers/bluetooth/btusb.c         |  390 +--
 drivers/bluetooth/hci_bcm.c       |    1 -
 drivers/bluetooth/hci_h4.c        |    4 +-
 drivers/bluetooth/hci_vhci.c      |  120 +-
 drivers/bluetooth/virtio_bt.c     |    3 +
 include/linux/mmc/sdio_ids.h      |    1 +
 include/net/bluetooth/bluetooth.h |    2 +
 include/net/bluetooth/hci.h       |    1 +
 include/net/bluetooth/hci_core.h  |   27 +-
 include/net/bluetooth/hci_sync.h  |  102 +
 net/bluetooth/Makefile            |    2 +-
 net/bluetooth/aosp.c              |  168 +-
 net/bluetooth/aosp.h              |   13 +
 net/bluetooth/cmtp/core.c         |    4 +-
 net/bluetooth/hci_codec.c         |   18 +-
 net/bluetooth/hci_conn.c          |   20 +-
 net/bluetooth/hci_core.c          | 1334 +---------
 net/bluetooth/hci_event.c         |  211 +-
 net/bluetooth/hci_request.c       |  500 +---
 net/bluetooth/hci_request.h       |   15 +-
 net/bluetooth/hci_sock.c          |   11 +-
 net/bluetooth/hci_sync.c          | 4922 +++++++++++++++++++++++++++++++++++++
 net/bluetooth/hci_sysfs.c         |    2 +
 net/bluetooth/l2cap_sock.c        |   19 +
 net/bluetooth/mgmt.c              | 2155 ++++++++--------
 net/bluetooth/mgmt_util.c         |   15 +-
 net/bluetooth/mgmt_util.h         |    4 +
 net/bluetooth/msft.c              |  511 ++--
 net/bluetooth/msft.h              |   15 +-
 38 files changed, 7675 insertions(+), 3847 deletions(-)
 create mode 100644 drivers/bluetooth/btmtk.c
 create mode 100644 drivers/bluetooth/btmtk.h
 create mode 100644 include/net/bluetooth/hci_sync.h
 create mode 100644 net/bluetooth/hci_sync.c
