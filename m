Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF141F811
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhJAXKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhJAXKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 19:10:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AD3C061775;
        Fri,  1 Oct 2021 16:08:54 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k26so9224458pfi.5;
        Fri, 01 Oct 2021 16:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cF0sk0lfmMnYmidKqZYIYKVpJrh4J/J6wCo7fVgd9ps=;
        b=jOWhaLV7RGzroGIfJpK2Bu8M/A9jqPAKIyJLMwKqFQ6+bAQPhHY80srW1CXjb8Sb7u
         ppfVIRGcIDJ/FEabYBGarepfry9b5d2chPzpnXmT5LqHGQ/f2Oua1Dfkc+DOWlcLIN/c
         vEtuJF1uzZ5uh3l3mZjXg1n5Wxap47HfSYudmw9IzYPwhoIOqggr/la/2laPa79RzEqx
         oEeUPABhL3JXgsji09oq255TaWKiG1gAsYpxl6gge/qvrq4J6EaKweQvDQAs8PfyLJM/
         Z78Pv7uA5yo/TTr3tC1qixpdcO6yOMdzW9vkK0MXHhgujfo8oimUGiLc5O/K5vSlh9ri
         2+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cF0sk0lfmMnYmidKqZYIYKVpJrh4J/J6wCo7fVgd9ps=;
        b=rtWDpc8oYZU37dtAWQRXXR59J0MEGPPo8a733sU5AWVc2Z1iAugqQ1oXh9ay6wgyPG
         alC0UHo0SX60lP9FwckwMJboDVx367Z19VRkn0LTApaBH0ROiCxKrs3MFzMMl3ySlgL1
         uTJ46ws6VxOJ6/ERjrXhONQiSo+VihZGgpE/qlcHMZNBgr3VX2yxxad9Tl2CPm0j72Zh
         RBBwnupyCnw1ow38OlYMYfGxfdZ/OD/mvjzBh1J891mlXYPrcLXfI9FYsp8Abm7lrMNk
         XEmzu8Lw5XOmvaJUMm+I8EmKO8i2HiKDSXmWSofxEMZ7MZ23GISNXzERT0M2lZuoNvge
         TGIg==
X-Gm-Message-State: AOAM530q50p/n4rFkiXRlsvInDPfmYKdX6S7JUfqpKPSnnEYY352GWbl
        siPzo0NeMK3s61zLZNlo4PgWy4yUu3I=
X-Google-Smtp-Source: ABdhPJxfFBRLMld0HUzuBNipnWV9bSoBHc9c+piqeuu1r/gn7jFu54E3RDC8CGgma2YAPIfs9KrFaQ==
X-Received: by 2002:a63:5942:: with SMTP id j2mr547943pgm.78.1633129734264;
        Fri, 01 Oct 2021 16:08:54 -0700 (PDT)
Received: from localhost.localdomain (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id u12sm8601532pjr.2.2021.10.01.16.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 16:08:53 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-10-01
Date:   Fri,  1 Oct 2021 16:08:50 -0700
Message-Id: <20211001230850.3635543-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 1b9fbe813016b08e08b22ddba4ddbf9cb1b04b00:

  net: ipv4: Fix the warning for dereference (2021-08-30 12:47:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-10-01

for you to fetch changes up to 4539ca67fe8edef34f522fd53da138e2ede13464:

  Bluetooth: Rename driver .prevent_wake to .wakeup (2021-10-01 15:46:15 -0700)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for MediaTek MT7922 and MT7921
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
 drivers/bluetooth/hci_vhci.c      | 122 ++++++++++
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
 35 files changed, 2789 insertions(+), 1084 deletions(-)
 create mode 100644 net/bluetooth/eir.c
 create mode 100644 net/bluetooth/eir.h
 create mode 100644 net/bluetooth/hci_codec.c
 create mode 100644 net/bluetooth/hci_codec.h
