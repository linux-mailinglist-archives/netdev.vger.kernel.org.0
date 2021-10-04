Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969654219E3
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhJDWXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhJDWXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 18:23:37 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECE0C061745;
        Mon,  4 Oct 2021 15:21:48 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 187so11294745pfc.10;
        Mon, 04 Oct 2021 15:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r5nXv9D7HIrxZo6HyfXHL96yJIOG1wOMeZuiwKD02xU=;
        b=Sm0zHfY3qe3kqn9MMy79G/ekatvZvMK4mlgtjy9NgMqY4KSWiGorQRB+hJktnsAAxx
         0fBasihhxysIdWV7uzEEYpVCFxA0wb8HRN7hSo1nXl5/8gjytg1/IM9cxaYt86ZtWyKS
         BO8igT29TTuQUskHATycYjJ5ee8ohVh/BD0s2Xy8dgDjYfKr8EYWgnxqYNJHoz1iqr3c
         BGHQ5HEi6NvNWinKRWTXEJi6YpLyXBFsZ8S4q4BnPg+5w+oyvAMmidMfIV4djQiz+CLj
         MQTN8wZ0T68V2Ii0hEI6Bd+30lwUtHyi3RRISHE2VVj3W6WPBLRH97JcMeXOKDF16ZPX
         nf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r5nXv9D7HIrxZo6HyfXHL96yJIOG1wOMeZuiwKD02xU=;
        b=sWCCa5tZzdiGkkCKm/lXQ5kQ9pf9EgIDRF3qD9ZQsrr2rq42MK5wAcybZrnY+mNSm8
         heaDUqOlC+YUvds/6D1XCryA41v4TjUMwKMnpFKTzG5xNDAZ487/aYS9wvYDu34Qkjlh
         xv776oSubx20lyizQ9485AyNYzF8DVH4fRs7eOOcP4Oi7C5Kd8w375LLxczMvqXKObyx
         HaUbu+4AMMAC5me6X60sam7y0WwRiYDouNwQ1/rIXENFYRvWZvQUx1/oFKR89pT7W9Fn
         iIx601KhXhdqedqKwKT7r3KR2y6kF5+4g2NT4TOWA9yyRoiBfns+Pzc2dfaH0Gas/oqc
         06/w==
X-Gm-Message-State: AOAM531z5sxpCUgAgIJCa3tuNVPWr/SKZd9pWL5aWEdiVC0SgGvzWuH5
        ue22vcWuuCh0NXwnmoJNx3U=
X-Google-Smtp-Source: ABdhPJw4rJ1STGk4p6Kb1RJhvmq4NTnxyUG7bIUZiHgJcNZ5WouueddbxHrkJkC4UuXCpa9Fs3KYvQ==
X-Received: by 2002:a63:1a1b:: with SMTP id a27mr12783363pga.220.1633386107604;
        Mon, 04 Oct 2021 15:21:47 -0700 (PDT)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id h9sm17294830pjg.9.2021.10.04.15.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 15:21:47 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-10-04
Date:   Mon,  4 Oct 2021 15:21:46 -0700
Message-Id: <20211004222146.251892-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 1660034361904dfcb82714aa48615a9b66462ee6:

  Merge branch 'phy-10g-mode-helper' (2021-10-04 13:50:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-10-04

for you to fetch changes up to 43f51bd946dab69bb38b05863898dd711b7e4506:

  Bluetooth: Rename driver .prevent_wake to .wakeup (2021-10-04 15:15:36 -0700)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for MediaTek MT7922 and MT7921
 - Add support for TP-Link UB500
 - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
   8822C/8852A.
 - Add initial support for link quality and audio/codec offload.
 - Rework of sockets sendmsg to avoid locking issues.
 - Add vhci suspend/resume emulation.

----------------------------------------------------------------
Brian Gix (1):
      Bluetooth: mgmt: Disallow legacy MGMT_OP_READ_LOCAL_OOB_EXT_DATA

Chethan T N (2):
      Bluetooth: btintel: support link statistics telemetry events
      Bluetooth: Allow usb to auto-suspend when SCO use non-HCI transport

Colin Ian King (1):
      Bluetooth: btintel: Fix incorrect out of memory check

Desmond Cheong Zhi Xi (2):
      Bluetooth: call sock_hold earlier in sco_conn_del
      Bluetooth: fix init and cleanup of sco_conn.timeout_work

Dinghao Liu (1):
      Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync

Hans de Goede (2):
      Bluetooth: hci_h5: Fix (runtime)suspend issues on RTL8723BS HCIs
      Bluetooth: hci_h5: directly return hci_uart_register_device() ret-val

Hilda Wu (1):
      Bluetooth: btrtl: Ask ic_info to drop firmware

Joseph Hwang (6):
      Bluetooth: btusb: disable Intel link statistics telemetry events
      Bluetooth: refactor set_exp_feature with a feature table
      Bluetooth: Support the quality report events
      Bluetooth: set quality report callback for Intel
      Bluetooth: hci_qca: enable Qualcomm WCN399x for AOSP extension
      Bluetooth: btrtl: enable Realtek 8822C/8852A to support AOSP extension

Kiran K (14):
      Bluetooth: btintel: Fix boot address
      Bluetooth: btintel: Read boot address irrespective of controller mode
      Bluetooth: Enumerate local supported codec and cache details
      Bluetooth: Add support for Read Local Supported Codecs V2
      Bluetooth: btintel: Read supported offload use cases
      Bluetooth: Allow querying of supported offload codecs over SCO socket
      Bluetooth: btintel: Define callback to fetch data_path_id
      Bluetooth: Allow setting of codec for HFP offload use case
      Bluetooth: Add support for HCI_Enhanced_Setup_Synchronous_Connection command
      Bluetooth: Configure codec for HFP offload use case
      Bluetooth: btintel: Define a callback to fetch codec config data
      Bluetooth: Add support for msbc coding format
      Bluetooth: Add offload feature under experimental flag
      Bluetooth: hci_vhci: Add support for offload codecs over SCO

Larry Finger (1):
      Bbluetooth: btusb: Add another Bluetooth part for Realtek 8852AE

Luiz Augusto von Dentz (17):
      Bluetooth: Fix enabling advertising for central role
      Bluetooth: Fix using address type from events
      Bluetooth: Fix using RPA when address has been resolved
      Bluetooth: Add bt_skb_sendmsg helper
      Bluetooth: Add bt_skb_sendmmsg helper
      Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg
      Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg
      Bluetooth: eir: Move EIR/Adv Data functions to its own file
      Bluetooth: hci_sock: Add support for BT_{SND,RCV}BUF
      Bluetooth: Fix passing NULL to PTR_ERR
      Bluetooth: SCO: Fix sco_send_frame returning skb->len
      Bluetooth: hci_core: Move all debugfs handling to hci_debugfs.c
      Bluetooth: Make use of hci_{suspend,resume}_dev on suspend notifier
      Bluetooth: hci_vhci: Add force_suspend entry
      Bluetooth: hci_vhci: Add force_prevent_wake entry
      Bluetooth: hci_sock: Replace use of memcpy_from_msg with bt_skb_sendmsg
      Bluetooth: Rename driver .prevent_wake to .wakeup

Manish Mandlik (1):
      Bluetooth: Fix Advertisement Monitor Suspend/Resume

Marcel Holtmann (4):
      Bluetooth: Fix handling of experimental feature for quality reports
      Bluetooth: Fix handling of experimental feature for codec offload
      Bluetooth: btrtl: Set VsMsftOpCode based on device table
      Bluetooth: btrtl: Add support for MSFT extension to rtl8821c devices

Max Chou (1):
      Bluetooth: btusb: Add the new support ID for Realtek RTL8852A

Mianhan Liu (1):
      Bluetooth: btrsi: remove superfluous header files from btrsi.c

Miao-chen Chou (1):
      Bluetooth: Keep MSFT ext info throughout a hci_dev's life cycle

Nicholas Flintham (1):
      Bluetooth: btusb: Add support for TP-Link UB500 Adapter

Pavel Skripkin (1):
      Bluetooth: hci_uart: fix GPF in h5_recv

Takashi Iwai (1):
      Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()

Tetsuo Handa (1):
      Bluetooth: reorganize functions from hci_sock_sendmsg()

Thadeu Lima de Souza Cascardo (1):
      Bluetooth: hci_ldisc: require CAP_NET_ADMIN to attach N_HCI ldisc

Wang ShaoBo (1):
      Bluetooth: fix use-after-free error in lock_sock_nested()

Yun-Hao Chung (1):
      Bluetooth: Fix wrong opcode when LL privacy enabled

mark-yw.chen (3):
      Bluetooth: btusb: Support public address configuration for MediaTek Chip.
      Bluetooth: btusb: Add protocol for MediaTek bluetooth devices(MT7922)
      Bluetooth: btusb: Add support for IMC Networks Mediatek Chip(MT7921)

tjiang@codeaurora.org (1):
      Bluetooth: btusb: Add gpio reset way for qca btsoc in cmd_timeout

 drivers/bluetooth/btintel.c       | 239 ++++++++++++++++---
 drivers/bluetooth/btintel.h       |  11 +
 drivers/bluetooth/btmrvl_main.c   |   6 +-
 drivers/bluetooth/btmtkuart.c     |  13 +-
 drivers/bluetooth/btrsi.c         |   1 -
 drivers/bluetooth/btrtl.c         |  26 ++-
 drivers/bluetooth/btusb.c         |  64 ++++-
 drivers/bluetooth/hci_h5.c        |  35 ++-
 drivers/bluetooth/hci_ldisc.c     |   3 +
 drivers/bluetooth/hci_qca.c       |   5 +-
 drivers/bluetooth/hci_vhci.c      | 124 ++++++++++
 include/net/bluetooth/bluetooth.h |  90 +++++++
 include/net/bluetooth/hci.h       | 117 ++++++++++
 include/net/bluetooth/hci_core.h  |  75 +++---
 net/bluetooth/Makefile            |   3 +-
 net/bluetooth/eir.c               | 335 ++++++++++++++++++++++++++
 net/bluetooth/eir.h               |  72 ++++++
 net/bluetooth/hci_codec.c         | 238 +++++++++++++++++++
 net/bluetooth/hci_codec.h         |   7 +
 net/bluetooth/hci_conn.c          | 168 ++++++++++++--
 net/bluetooth/hci_core.c          | 320 +++++++++++--------------
 net/bluetooth/hci_debugfs.c       | 123 ++++++++++
 net/bluetooth/hci_debugfs.h       |   5 +
 net/bluetooth/hci_event.c         | 135 +++++++----
 net/bluetooth/hci_request.c       | 478 ++++++--------------------------------
 net/bluetooth/hci_request.h       |  25 +-
 net/bluetooth/hci_sock.c          | 214 ++++++++++-------
 net/bluetooth/l2cap_core.c        |   2 +-
 net/bluetooth/l2cap_sock.c        |  10 +-
 net/bluetooth/mgmt.c              | 445 ++++++++++++++++++++++++++---------
 net/bluetooth/msft.c              | 172 ++++++++++++--
 net/bluetooth/msft.h              |   9 +
 net/bluetooth/rfcomm/core.c       |  50 +++-
 net/bluetooth/rfcomm/sock.c       |  46 +---
 net/bluetooth/sco.c               | 209 +++++++++++++++--
 35 files changed, 2791 insertions(+), 1084 deletions(-)
 create mode 100644 net/bluetooth/eir.c
 create mode 100644 net/bluetooth/eir.h
 create mode 100644 net/bluetooth/hci_codec.c
 create mode 100644 net/bluetooth/hci_codec.h
