Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B190C3B674F
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhF1RL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhF1RL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:11:28 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD98EC061760;
        Mon, 28 Jun 2021 10:09:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso464431pjb.4;
        Mon, 28 Jun 2021 10:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ayzyjA7sqM8Kd0CJnae9oXKGxQfRtU8wzvTHP0aSqm0=;
        b=CBPnTpTe13ZK90tvlBVOzrN5AoRb8fD4Ygtx7eu7+r0C6kDSEcAISHcVBe2M868qXm
         RvqKiep7EKSvJ5PiJsKSWQRyR6/LO6/tgxcjmSsMXHm1mf+bBPSAwha6fQ7VmuUXLyby
         h9wcflY+9Su9h+7fm07oaf47P2wUnqx1KH7Ofk9N4wliUqwWb9yNoUMaK927ibwksUBD
         hV909Th3J0g/j4bB8OCzs+5CfaJTwsBAeM43IePE5HF4no2A3a0ZcLb8LopKqq69G2PC
         SWxgOYmW/6+WUzKKggmonnkHWiGn83GctpfLipwjTd86nqho5Ow9JG58MEpyc+malKIn
         mI8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ayzyjA7sqM8Kd0CJnae9oXKGxQfRtU8wzvTHP0aSqm0=;
        b=f+nCIud64A567LcTMDjSGnSvJ3Xb7NRbpyWXrIKK4opR5jNuzAHpDAM57/hH6lOzwz
         h/Y6XRn+Ut0UjLxDDjHBitkvjukYd+62LIzI7cEx/J1IqPkWm62QjeZgHIccQeNrRkHJ
         gVU7LJOH1wJhkrJcEOfopZvKypw0UCW23W3GYmJGivoYIzWJ0/bIXbV7R3TX2oGPg2XO
         pNbLVcIsWBLJSW2wZe+V/gcicj7nqJ4NGh0i5rDXTOz6ZrNjatILoiyYSsBBmZhUdosV
         qLetMly/Uu9vTeQ+n1DbnlVIXrp5MngLUxUIjH2pfLpF6q0H7kcMULhJxH5MFHfRr433
         oM2Q==
X-Gm-Message-State: AOAM533uSFCvbohC4hqlMD9zjXndFq7YqI1mR776/eKsNRffzkbLkNBr
        yei8ncdPcduSJOYrZOG5y08=
X-Google-Smtp-Source: ABdhPJz9vrMR1rvIO0tSeBI0MW0WKXlBdN7mJIe5WrjBfaKrK3dOp0Yb4lEUzX46EC9ZrLnUENAnUA==
X-Received: by 2002:a17:902:f243:b029:11e:3249:4a17 with SMTP id j3-20020a170902f243b029011e32494a17mr23537915plc.0.1624900141179;
        Mon, 28 Jun 2021 10:09:01 -0700 (PDT)
Received: from localhost.localdomain (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id y1sm15344343pgr.70.2021.06.28.10.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 10:09:00 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2021-06-28
Date:   Mon, 28 Jun 2021 10:08:58 -0700
Message-Id: <20210628170858.312168-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit ff8744b5eb116fdf9b80a6ff774393afac7325bd:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-06-25 11:59:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-06-28

for you to fetch changes up to 1f0536139cb8e8175ca034e12706b86f77f9061e:

  Bluetooth: hci_uart: Remove redundant assignment to fw_ptr (2021-06-26 07:52:41 +0200)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Proper support for BCM4330 and BMC4334
 - Various improvements for firmware download of Intel controllers
 - Update management interface revision to 20
 - Support for AOSP HCI vendor commands
 - Initial Virtio support

----------------------------------------------------------------
Archie Pusaka (9):
      Bluetooth: hci_h5: Add RTL8822CS capabilities
      Bluetooth: use inclusive language in hci_core.h
      Bluetooth: use inclusive language to describe CPB
      Bluetooth: use inclusive language in HCI LE features
      Bluetooth: use inclusive language in SMP
      Bluetooth: use inclusive language in comments
      Bluetooth: use inclusive language in HCI role comments
      Bluetooth: use inclusive language when tracking connections
      Bluetooth: use inclusive language when filtering devices

Colin Ian King (2):
      Bluetooth: virtio_bt: add missing null pointer check on alloc_skb call return
      Bluetooth: btmrvl: remove redundant continue statement

Connor Abbott (1):
      Bluetooth: btqca: Don't modify firmware contents in-place

Daniel Lenski (1):
      Bluetooth: btusb: Add a new QCA_ROME device (0cf3:e500)

Hilda Wu (1):
      Bluetooth: btusb: Add support USB ALT 3 for WBS

Jiapeng Chong (1):
      Bluetooth: 6lowpan: remove unused function

Joakim Tjernlund (2):
      Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU (ASUS BT500) device.
      Bluetooth: btrtl: rename USB fw for RTL8761

Kai Ye (11):
      Bluetooth: 6lowpan: delete unneeded variable initialization
      Bluetooth: bnep: Use the correct print format
      Bluetooth: cmtp: Use the correct print format
      Bluetooth: hidp: Use the correct print format
      Bluetooth: 6lowpan: Use the correct print format
      Bluetooth: a2mp: Use the correct print format
      Bluetooth: amp: Use the correct print format
      Bluetooth: mgmt: Use the correct print format
      Bluetooth: msft: Use the correct print format
      Bluetooth: sco: Use the correct print format
      Bluetooth: smp: Use the correct print format

Kai-Heng Feng (1):
      Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Kiran K (1):
      Bluetooth: Fix alt settings for incoming SCO with transparent coding format

Luiz Augusto von Dentz (5):
      Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
      Bluetooth: L2CAP: Fix invalid access on ECRED Connection response
      Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
      Bluetooth: Fix Set Extended (Scan Response) Data
      Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event

Manish Mandlik (1):
      Bluetooth: Add ncmd=0 recovery handling

Marcel Holtmann (1):
      Bluetooth: Increment management interface revision

Mikhail Rudenko (1):
      Bluetooth: btbcm: Add entry for BCM43430B0 UART Bluetooth

Muhammad Usama Anjum (1):
      Bluetooth: btusb: fix memory leak

Nigel Christian (1):
      Bluetooth: hci_uart: Remove redundant assignment to fw_ptr

Pavel Skripkin (1):
      Bluetooth: hci_qca: fix potential GPF

Qiheng Lin (1):
      Bluetooth: use flexible-array member instead of zero-length array

Sathish Narasimman (1):
      Bluetooth: Translate additional address type during le_conn_comp

Szymon Janc (1):
      Bluetooth: Remove spurious error message

Tedd Ho-Jeong An (1):
      Bluetooth: mgmt: Fix the command returns garbage parameter value

Thadeu Lima de Souza Cascardo (1):
      Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Tim Jiang (2):
      Bluetooth: btusb: use default nvm if boardID is 0 for wcn6855.
      Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Venkata Lakshmi Narayana Gubba (5):
      Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6750
      Bluetooth: btqca: Add support for firmware image with mbn type for WCN6750
      Bluetooth: btqca: Moved extracting rom version info to common place
      dt-bindings: net: bluetooth: Convert Qualcomm BT binding to DT schema
      dt-bindings: net: bluetooth: Add device tree bindings for QTI chip wcn6750

Yu Liu (2):
      Bluetooth: Return whether a connection is outbound
      Bluetooth: Fix the HCI to MGMT status conversion table

YueHaibing (1):
      Bluetooth: RFCOMM: Use DEVICE_ATTR_RO macro

Yun-Hao Chung (1):
      Bluetooth: disable filter dup when scan for adv monitor

Zhang Qilong (1):
      Bluetooth: btmtkuart: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

mark-yw.chen (2):
      Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.
      Bluetooth: btusb: Add support for Lite-On Mediatek Chip

 .../devicetree/bindings/net/qualcomm-bluetooth.txt |  69 -------
 .../bindings/net/qualcomm-bluetooth.yaml           | 183 +++++++++++++++++++
 drivers/bluetooth/btbcm.c                          |   1 +
 drivers/bluetooth/btmrvl_sdio.c                    |   4 +-
 drivers/bluetooth/btmtkuart.c                      |   6 +-
 drivers/bluetooth/btqca.c                          | 113 +++++++++---
 drivers/bluetooth/btqca.h                          |  14 +-
 drivers/bluetooth/btrtl.c                          |  35 ++--
 drivers/bluetooth/btrtl.h                          |   7 +
 drivers/bluetooth/btusb.c                          |  45 ++++-
 drivers/bluetooth/hci_ag6xx.c                      |   1 -
 drivers/bluetooth/hci_h5.c                         |   5 +-
 drivers/bluetooth/hci_qca.c                        | 118 +++++++++---
 drivers/bluetooth/virtio_bt.c                      |   3 +
 include/net/bluetooth/hci.h                        |  99 +++++-----
 include/net/bluetooth/hci_core.h                   |  29 +--
 include/net/bluetooth/mgmt.h                       |   3 +-
 net/bluetooth/6lowpan.c                            |  54 +-----
 net/bluetooth/a2mp.c                               |  24 +--
 net/bluetooth/amp.c                                |   6 +-
 net/bluetooth/bnep/core.c                          |   8 +-
 net/bluetooth/cmtp/capi.c                          |  22 +--
 net/bluetooth/cmtp/core.c                          |   5 +
 net/bluetooth/hci_conn.c                           |  10 +-
 net/bluetooth/hci_core.c                           |  78 +++++---
 net/bluetooth/hci_debugfs.c                        |   8 +-
 net/bluetooth/hci_event.c                          | 187 +++++++++++--------
 net/bluetooth/hci_request.c                        | 203 +++++++++++++--------
 net/bluetooth/hci_sock.c                           |  12 +-
 net/bluetooth/hidp/core.c                          |   8 +-
 net/bluetooth/l2cap_core.c                         |  16 +-
 net/bluetooth/mgmt.c                               |  58 +++---
 net/bluetooth/mgmt_config.c                        |   4 +-
 net/bluetooth/msft.c                               |   8 +-
 net/bluetooth/rfcomm/tty.c                         |  10 +-
 net/bluetooth/sco.c                                |   8 +-
 net/bluetooth/smp.c                                |  78 ++++----
 net/bluetooth/smp.h                                |   6 +-
 38 files changed, 967 insertions(+), 581 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
