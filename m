Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6920358A00
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhDHQqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbhDHQqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 12:46:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E45C061760;
        Thu,  8 Apr 2021 09:45:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o18so1451587pjs.4;
        Thu, 08 Apr 2021 09:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DxWZHrB7Dy/O+7LXwb2Qucf8ozxIQJ06o04ctbQQIwU=;
        b=mmaHmt+6PeTWQJbUrC9k9JBmrRu5tjJK3q7K51p2TtYnEiLf9+qjqlQ8E54bblZTxG
         F8WpdETSVEWpRYwNck5N2QedXhlbiFX1HljidVuIuvLLaesy34/YJAoBihfmbKZ32EuL
         WHEZI54q3F6HOeehEVEKzYoxcseNY5xRnIq9Vt3cCThFpXFgH1eCZ0mUmYceJgUwTw3I
         kf5KP/ZHzS890Jls2RtLWxcrRoWzV41CQ7BSIRUWGokPSyF72IHtyHI0/ZvpdYO3DC6B
         lVagfhM2ToZMwlSEHeIyuGATKaWGI01mRwI8bTbJXMoyARd0v8+HiJdVu8u3CSKZkNEy
         YysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DxWZHrB7Dy/O+7LXwb2Qucf8ozxIQJ06o04ctbQQIwU=;
        b=fFe0CjdBlI/2QeiksteIQLDSnp2gg3NJ6xYKUPm5cHwAY6ewhUFsLtePkwW3RJrxWU
         Qt0UNvxDRVOI+OQqZgGfCz1SKaND1OAHUC83UE4NtcdbbDqjnlC3FGQ/dxsdDrq2qh9I
         1HgnLBaimbqfjXDHL0lPzN4SSquLvFf65Qd54Agy19Tok8sKRZ+V+0Ar3YVe3d9RKAYc
         f+80QMqJMzfDXwVycTRkhaeU1Nv3xPK3nn2QxAN1K+nH+mtFNDLW1wwZDFz7Xxt/Njoy
         KRuuUwrT3OmuzQlXzJ9botVZ13jgvH6kle159ucPbW+M2IHStPoySxeYei8H1S+X3zb+
         aRvw==
X-Gm-Message-State: AOAM530Vq3Mixo3bjOIlR9u+vmKvgEnV846sNRaT6nEAUKsu7ngL9fJr
        ilqgWcLyqozAgp1Oocv0V/M=
X-Google-Smtp-Source: ABdhPJwKfoUP53bQR49OiE8mSmOLHv8DCON6R2qWPUSLfwOi0iz3nqCPRoxCtNy59Vhzrf5B2Q2nGg==
X-Received: by 2002:a17:902:d78a:b029:e6:e1f:f695 with SMTP id z10-20020a170902d78ab02900e60e1ff695mr8521378ply.82.1617900352256;
        Thu, 08 Apr 2021 09:45:52 -0700 (PDT)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id k10sm11895pfk.205.2021.04.08.09.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:45:51 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: pull request: bluetooth-next 2021-04-08
Date:   Thu,  8 Apr 2021 09:45:06 -0700
Message-Id: <20210408164506.1686871-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit d310ec03a34e92a77302edb804f7d68ee4f01ba0:

  Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-02-21 12:49:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-04-08

for you to fetch changes up to a61d67188f29ff678e94fb3ffba6c6d292e852c7:

  Bluetooth: Allow Microsoft extension to indicate curve validation (2021-04-08 12:26:34 +0200)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Proper support for BCM4330 and BMC4334
 - Various improvements for firmware download of Intel controllers
 - Update management interface revision to 20
 - Support for AOSP HCI vendor commands
 - Initial Virtio support

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: Notify suspend on le conn failed
      Bluetooth: Remove unneeded commands for suspend

Archie Pusaka (4):
      Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default
      Bluetooth: verify AMP hci_chan before amp_destroy
      Bluetooth: check for zapped sk before connecting
      Bluetooth: Check inquiry status before sending one

Arnd Bergmann (1):
      Bluetooth: fix set_ecdh_privkey() prototype

Ayush Garg (1):
      Bluetooth: Fix incorrect status handling in LE PHY UPDATE event

Bhaskar Chowdhury (2):
      Bluetooth: hci_qca: Mundane typo fix
      Bluetooth: L2CAP: Rudimentary typo fixes

Daniel Winkler (3):
      Bluetooth: Allow scannable adv with extended MGMT APIs
      Bluetooth: Use ext adv handle from requests in CCs
      Bluetooth: Do not set cur_adv_instance in adv param MGMT request

Jiri Kosina (1):
      Bluetooth: avoid deadlock between hci_dev->lock and socket lock

Kai Ye (1):
      Bluetooth: use the correct print format for L2CAP debug statements

Kiran K (2):
      Bluetooth: btusb: print firmware file name on error loading firmware
      Bluetooth: btintel: Fix offset calculation boot address parameter

Linus Walleij (4):
      Bluetooth: btbcm: Rewrite bindings in YAML and add reset
      Bluetooth: btbcm: Obtain and handle reset GPIO
      Bluetooth: btbcm: Add BCM4334 DT binding
      Bluetooth: btbcm: Add BCM4330 and BCM4334 compatibles

Lokendra Singh (3):
      Bluetooth: btintel: Reorganized bootloader mode tlv checks in intel_version_tlv parsing
      Bluetooth: btintel: Collect tlv based active firmware build info in FW mode
      Bluetooth: btintel: Skip reading firmware file version while in bootloader mode

Luiz Augusto von Dentz (10):
      Bluetooth: SMP: Fail if remote and local public keys are identical
      Bluetooth: L2CAP: Fix not checking for maximum number of DCID
      Bluetooth: SMP: Convert BT_ERR/BT_DBG to bt_dev_err/bt_dev_dbg
      Bluetooth: btintel: Check firmware version before download
      Bluetooth: btintel: Move operational checks after version check
      Bluetooth: btintel: Consolidate intel_version_tlv parsing
      Bluetooth: btintel: Consolidate intel_version parsing
      Bluetooth: btusb: Consolidate code for waiting firmware download
      Bluetooth: btusb: Consolidate code for waiting firmware to boot
      Bluetooth: SMP: Fix variable dereferenced before check 'conn'

Marcel Holtmann (10):
      Bluetooth: Fix mgmt status for LL Privacy experimental feature
      Bluetooth: Fix wrong opcode error for read advertising features
      Bluetooth: Add missing entries for PHY configuration commands
      Bluetooth: Move the advertisement monitor events to correct list
      Bluetooth: Increment management interface revision
      Bluetooth: Add support for reading AOSP vendor capabilities
      Bluetooth: Add support for virtio transport driver
      Bluetooth: Fix default values for advertising interval
      Bluetooth: Set defaults for le_scan_{int,window}_adv_monitor
      Bluetooth: Allow Microsoft extension to indicate curve validation

Meng Yu (4):
      Bluetooth: Remove trailing semicolon in macros
      Bluetooth: Remove trailing semicolon in macros
      Bluetooth: Remove 'return' in void function
      Bluetooth: Coding style fix

Rasmus Moorats (1):
      Bluetooth: btusb: support 0cb5:c547 Realtek 8822CE device

Sathish Narasimman (2):
      Bluetooth: Handle own address type change with HCI_ENABLE_LL_PRIVACY
      Bluetooth: LL privacy allow RPA

Sonny Sasaka (1):
      Bluetooth: Cancel le_scan_restart work when stopping discovery

Tetsuo Handa (1):
      Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Venkata Lakshmi Narayana Gubba (1):
      Bluetooth: hci_qca: Add device_may_wakeup support

mark-yw.chen (2):
      Bluetooth: btusb: Fix incorrect type in assignment and uninitialized symbol
      Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.

 .../devicetree/bindings/net/broadcom-bluetooth.txt |  56 ---
 .../bindings/net/broadcom-bluetooth.yaml           | 118 ++++++
 .../devicetree/bindings/serial/ingenic,uart.yaml   |   2 +-
 drivers/bluetooth/Kconfig                          |  10 +
 drivers/bluetooth/Makefile                         |   2 +
 drivers/bluetooth/btintel.c                        | 232 ++++++++++--
 drivers/bluetooth/btintel.h                        |  19 +-
 drivers/bluetooth/btusb.c                          | 408 ++++++++-------------
 drivers/bluetooth/hci_bcm.c                        |  19 +
 drivers/bluetooth/hci_intel.c                      |   7 +-
 drivers/bluetooth/hci_qca.c                        |  17 +-
 drivers/bluetooth/virtio_bt.c                      | 401 ++++++++++++++++++++
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |  17 +-
 include/net/bluetooth/l2cap.h                      |   1 +
 include/net/bluetooth/mgmt.h                       |   1 +
 include/uapi/linux/virtio_bt.h                     |  31 ++
 include/uapi/linux/virtio_ids.h                    |   1 +
 net/bluetooth/6lowpan.c                            |   5 +-
 net/bluetooth/Kconfig                              |   7 +
 net/bluetooth/Makefile                             |   1 +
 net/bluetooth/aosp.c                               |  35 ++
 net/bluetooth/aosp.h                               |  16 +
 net/bluetooth/ecdh_helper.h                        |   2 +-
 net/bluetooth/hci_conn.c                           |  14 +-
 net/bluetooth/hci_core.c                           |   5 +
 net/bluetooth/hci_debugfs.c                        |   8 +-
 net/bluetooth/hci_event.c                          |  50 ++-
 net/bluetooth/hci_request.c                        |  67 ++--
 net/bluetooth/l2cap_core.c                         |  43 ++-
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/bluetooth/mgmt.c                               |  19 +-
 net/bluetooth/msft.c                               |   8 +
 net/bluetooth/msft.h                               |   6 +
 net/bluetooth/sco.c                                |   4 +-
 net/bluetooth/smp.c                                | 113 +++---
 36 files changed, 1289 insertions(+), 465 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
 create mode 100644 drivers/bluetooth/virtio_bt.c
 create mode 100644 include/uapi/linux/virtio_bt.h
 create mode 100644 net/bluetooth/aosp.c
 create mode 100644 net/bluetooth/aosp.h
