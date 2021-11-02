Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681E84437DD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 22:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhKBVgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 17:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhKBVf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 17:35:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41641C061714;
        Tue,  2 Nov 2021 14:33:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id x5so520506pgk.11;
        Tue, 02 Nov 2021 14:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QnSteGxAFHSw1ZyOWwG9tukkuQKGwDiAkMIV0ek4uDo=;
        b=Kin2jlsMX4gpoVmUfOPt/XW13fjmopXT/rM65RZcYhlPJI61ISceEKfyVVfnQ6SxQX
         UAAH3+aMVtIsYWEM5Wvpdmvw5H5kDkLj8M0DPPcqwRzIpdHemB2CSGgq83p4YUogSIeO
         jPEs1EY5fL5gCVZvpQbMntikyNclY5rlBJKIJAaI7SHOyFHV6AgWFnnbOAzfjhMQVHD2
         WD/HYzwxjzNOd0CMnIPfzZx14Eg7F8rdtDGiXMrwpWWz8JXw38g3kkWPRQS1IuQ6gu3N
         L6leUAErreyjV0wtwmgsuMT/tHpSbudBRiGH+/YsErgY537mBNgQGhDYxtOwQAG14f7u
         viqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QnSteGxAFHSw1ZyOWwG9tukkuQKGwDiAkMIV0ek4uDo=;
        b=DGiHSyGuz5gUN2BAjsDfN4TNc4RzqbcQDkbf7ZbNI3jRnUu8mK0MsK0zxR/21+cU8n
         YVZZS6DMHTBSqi5VY6x+YNAvqIS207Sq0KP6iKD0TLjQy8FOnO1DHOwxIfSDp3i9bQQv
         qyHoUDt4/FT0IR4WTvaJ/P9K6B5NooEe+j1k6Nd7GhD+ETf8YDY9gr1Ex+ENviuLT80b
         LkRapldyXXv0pWb1KItmyGONo8LgO8I1+ZyqnGwSSLZ7ycCUoIyYGFAPEBlgU0MBFfEo
         +iVju+19hc8l8rVgdBZoLNIgK5Hhfn+DlzHjzVO7FnzeFvdR7DMIQshwVbB6UDgrsYr5
         +f6w==
X-Gm-Message-State: AOAM530ytxdW2ApM9JKlERnBTFAU05VNfMoQz22FV1dSoj+FBp3mfbEm
        wWPiHKLfvJJZ3DKWj2ViLQXJsnNJBOY=
X-Google-Smtp-Source: ABdhPJy92RTup1wxM5v8pp5TcmFinXved9BFyDbed4Kp7lbdwOLVTqTDK/l0eANYuUJdjoKVf8UcwQ==
X-Received: by 2002:a63:5c13:: with SMTP id q19mr14927067pgb.350.1635888803630;
        Tue, 02 Nov 2021 14:33:23 -0700 (PDT)
Received: from localhost.localdomain (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id c21sm107979pfv.119.2021.11.02.14.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 14:33:23 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-11-02
Date:   Tue,  2 Nov 2021 14:33:21 -0700
Message-Id: <20211102213321.18680-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit d0f1c248b4ff71cada1b9e4ed61a1992cd94c3df:

  Merge tag 'for-net-next-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next (2021-10-05 07:41:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-11-02

for you to fetch changes up to 258f56d11bbbf39df5bc5faf0119d28be528f27d:

  Bluetooth: aosp: Support AOSP Bluetooth Quality Report (2021-11-02 19:37:52 +0100)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for AOSP Bluetooth Quality Report
 - Rework of HCI command execution serialization

----------------------------------------------------------------
Archie Pusaka (1):
      Bluetooth: Fix removing adv when processing cmd complete

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

Luiz Augusto von Dentz (16):
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

 drivers/bluetooth/Kconfig         |    6 +
 drivers/bluetooth/Makefile        |    1 +
 drivers/bluetooth/bfusb.c         |    3 +
 drivers/bluetooth/btintel.c       |   22 +-
 drivers/bluetooth/btmtk.c         |  289 +++
 drivers/bluetooth/btmtk.h         |  111 +
 drivers/bluetooth/btmtksdio.c     |  496 ++--
 drivers/bluetooth/btsdio.c        |    2 +
 drivers/bluetooth/btusb.c         |  389 +--
 drivers/bluetooth/hci_bcm.c       |    1 -
 drivers/bluetooth/hci_vhci.c      |  120 +-
 drivers/bluetooth/virtio_bt.c     |    3 +
 include/linux/mmc/sdio_ids.h      |    1 +
 include/net/bluetooth/bluetooth.h |    2 +
 include/net/bluetooth/hci_core.h  |   22 +-
 include/net/bluetooth/hci_sync.h  |   97 +
 net/bluetooth/Makefile            |    2 +-
 net/bluetooth/aosp.c              |  168 +-
 net/bluetooth/aosp.h              |   13 +
 net/bluetooth/cmtp/core.c         |    4 +-
 net/bluetooth/hci_codec.c         |   18 +-
 net/bluetooth/hci_conn.c          |   20 +-
 net/bluetooth/hci_core.c          | 1334 +----------
 net/bluetooth/hci_event.c         |  159 +-
 net/bluetooth/hci_request.c       |  338 +--
 net/bluetooth/hci_request.h       |   10 +
 net/bluetooth/hci_sock.c          |   11 +-
 net/bluetooth/hci_sync.c          | 4799 +++++++++++++++++++++++++++++++++++++
 net/bluetooth/hci_sysfs.c         |    2 +
 net/bluetooth/l2cap_sock.c        |   19 +
 net/bluetooth/mgmt.c              | 2086 ++++++++--------
 net/bluetooth/mgmt_util.c         |   15 +-
 net/bluetooth/mgmt_util.h         |    4 +
 net/bluetooth/msft.c              |  511 ++--
 net/bluetooth/msft.h              |   15 +-
 35 files changed, 7472 insertions(+), 3621 deletions(-)
 create mode 100644 drivers/bluetooth/btmtk.c
 create mode 100644 drivers/bluetooth/btmtk.h
 create mode 100644 include/net/bluetooth/hci_sync.h
 create mode 100644 net/bluetooth/hci_sync.c
