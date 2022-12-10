Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267AA648C65
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 02:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLJBfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 20:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLJBfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 20:35:04 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D6C11C17;
        Fri,  9 Dec 2022 17:34:59 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 65so4901624pfx.9;
        Fri, 09 Dec 2022 17:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FMhFhgb+0nk1X+uerGnU1w0C7oX56b7VZ/Oltg4UOTo=;
        b=ej4435v+YtLGWVm/FzWgt301MpIedNkXHAvXvw/60jFZ0RGE9ElOOkKKAFFq9+K49T
         DPna69iVo/L7eHZneLqAfv9YmokALP8VaJIr3mjF1Zd4q4Pv1Wlen6QiMdNYGZb+SCNu
         0o1D9i6E1+XTmMZ+X8Va0Dc/1ozK9hpmhrmlVWAsFHKwwXoPVSX3K7he4yD/R73mZbHe
         4glTUbwR9eDCIkzjCYjLjFEceYjeU0JaiZk/7svSD7xep56L/ipONgO0CmXnzDmYtUKp
         w3W8+OJhdmpQnwh31nPRgERCaG4E6KWggZ4putJmDIWnUSZtwg54NOrBOzy/L7HwpP/1
         uM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FMhFhgb+0nk1X+uerGnU1w0C7oX56b7VZ/Oltg4UOTo=;
        b=oYmofRb9eQom9rMN4DRO0jsBz28A5b8ErBVXl852mAhBszmLAO07GOx2PDUrPoM3j7
         Tp8dgo/oSj7Avws7qa8Y+ME55lwSuFInos7aE3pBDfUcXstpmhcBA9ZTlpm3LEHEDqtQ
         iCyc80N2LLwp82wCVU2AkhrXmamhkMWFfb8ZCZWhJL1rVlhQdiUHZBy5+B8GWQKwLXhx
         nUvd1S/rmdOBr3CDQttGqrmM2HxPrL9uUgB8bjFYTLQDbgyhdfbygGlZKMWW3Gij8Yj/
         lltav73vIxMJQEb70d6uRdA5OtCgbznkUXtJAfawLm7tUHMYux8Ttur8v9AwBix/3ii8
         b2SA==
X-Gm-Message-State: ANoB5pnad9MXTUwFCXtzN0IDxQEM2cYh2nRRDYgds4T92SJsjJ/AVRTF
        +IeK8YQXFG1cvm/a40/ZG9vrJlY15k7p/18A
X-Google-Smtp-Source: AA0mqf66XXJwHufZjNxwxn//gziDWqu9GBuVnZXhbrNXwN5E82hQI/2YdtW86OjWe9Gw0maJ6VQy5w==
X-Received: by 2002:aa7:9243:0:b0:56b:fa67:1f7f with SMTP id 3-20020aa79243000000b0056bfa671f7fmr7560792pfp.19.1670636098552;
        Fri, 09 Dec 2022 17:34:58 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id v12-20020aa799cc000000b0056b2e70c2f5sm1790162pfi.25.2022.12.09.17.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 17:34:57 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2022-12-09
Date:   Fri,  9 Dec 2022 17:34:56 -0800
Message-Id: <20221210013456.1085082-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 681bf011b9b5989c6e9db6beb64494918aab9a43:

  eth: pse: add missing static inlines (2022-10-03 21:52:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-12-09

for you to fetch changes up to 7a637ef7e0c3308754d7ccf0edb0eec69f77bb81:

  Bluetooth: Wait for HCI_OP_WRITE_AUTH_PAYLOAD_TO to complete (2022-12-07 13:11:50 -0800)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add a new VID/PID 0489/e0f2 for MT7922
 - Add Realtek RTL8852BE support ID 0x0cb8:0xc559
 - Add a new PID/VID 13d3/3549 for RTL8822CU
 - Add support for broadcom BCM43430A0 & BCM43430A1
 - Add CONFIG_BT_HCIBTUSB_POLL_SYNC
 - Add CONFIG_BT_LE_L2CAP_ECRED
 - Add support for CYW4373A0
 - Add support for RTL8723DS
 - Add more device IDs for WCN6855
 - Add Broadcom BCM4377 family PCIe Bluetooth

----------------------------------------------------------------
Andy Chi (1):
      Bluetooth: btusb: Add a new VID/PID 0489/e0f2 for MT7922

Archie Pusaka (2):
      Bluetooth: btusb: Introduce generic USB reset
      Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Artem Lukyanov (1):
      Bluetooth: btusb: Add Realtek RTL8852BE support ID 0x0cb8:0xc559

Chen Zhongjin (1):
      Bluetooth: Fix not cleanup led when bt_init fails

Chethan T N (2):
      Bluetooth: Remove codec id field in vendor codec definition
      Bluetooth: Fix support for Read Local Supported Codecs V2

Chethan Tumkur Narayan (1):
      btusb: Avoid reset of ISOC endpoint alt settings to zero

Christophe JAILLET (1):
      Bluetooth: Fix EALREADY and ELOOP cases in bt_status()

Gongwei Li (1):
      Bluetooth: btusb: Add a new PID/VID 13d3/3549 for RTL8822CU

Hawkins Jiawei (1):
      Bluetooth: L2CAP: Fix memory leak in vhci_write

Hilda Wu (2):
      Bluetooth: btrtl: Add btrealtek data struct
      Bluetooth: btusb: Ignore zero length of USB packets on ALT 6 for specific chip

Igor Skalkin (1):
      virtio_bt: Fix alignment in configuration struct

Inga Stotland (1):
      Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS

Ismael Ferreras Morezuelas (2):
      Bluetooth: btusb: Fix CSR clones again by re-adding ERR_DATA_REPORTING quirk
      Bluetooth: btusb: Add debug message for CSR controllers

Jiapeng Chong (1):
      Bluetooth: Use kzalloc instead of kmalloc/memset

Kang Minchul (1):
      Bluetooth: Use kzalloc instead of kmalloc/memset

Luca Weiss (1):
      dt-bindings: bluetooth: broadcom: add BCM43430A0 & BCM43430A1

Luiz Augusto von Dentz (16):
      Bluetooth: hci_sync: Fix not setting static address
      Bluetooth: hci_sync: Fix not able to set force_static_address
      Bluetooth: hci_conn: Fix not restoring ISO buffer count on disconnect
      Bluetooth: btusb: Add CONFIG_BT_HCIBTUSB_POLL_SYNC
      Bluetooth: btusb: Default CONFIG_BT_HCIBTUSB_POLL_SYNC=y
      Bluetooth: Add CONFIG_BT_LE_L2CAP_ECRED
      Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
      Bluetooth: L2CAP: Fix attempting to access uninitialized memory
      Bluetooth: Fix crash when replugging CSR fake controllers
      Bluetooth: btusb: Fix new sparce warnings
      Bluetooth: btusb: Fix existing sparce warning
      Bluetooth: btintel: Fix existing sparce warnings
      Bluetooth: hci_conn: Fix crash on hci_create_cis_sync
      Bluetooth: ISO: Avoid circular locking dependency
      Bluetooth: Wait for HCI_OP_WRITE_AUTH_PAYLOAD_TO to complete

Marek Vasut (2):
      dt-bindings: net: broadcom-bluetooth: Add CYW4373A0 DT binding
      Bluetooth: hci_bcm: Add CYW4373A0 support

Mateusz Jończyk (1):
      Bluetooth: silence a dmesg error message in hci_request.c

Maxim Mikityanskiy (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Michael S. Tsirkin (1):
      Bluetooth: virtio_bt: fix device removal

Nicolas Cavallari (1):
      Bluetooth: Work around SCO over USB HCI design defect

Pauli Virtanen (2):
      Bluetooth: hci_conn: Fix CIS connection dst_type handling
      Bluetooth: hci_conn: use HCI dst_type values also for BIS

Raman Varabets (1):
      Bluetooth: btusb: Add Realtek 8761BUV support ID 0x2B89:0x8761

Samuel Holland (1):
      dt-bindings: net: realtek-bluetooth: Add RTL8723DS

Shengyu Qu (1):
      Bluetooth: btusb: Add more device IDs for WCN6855

Soenke Huster (1):
      Bluetooth: virtio_bt: Use skb_put to set length

Sungwoo Kim (1):
      Bluetooth: L2CAP: Fix u8 overflow

Sven Peter (7):
      dt-bindings: net: Add generic Bluetooth controller
      dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
      arm64: dts: apple: t8103: Add Bluetooth controller
      Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
      Bluetooth: Add quirk to disable extended scanning
      Bluetooth: Add quirk to disable MWS Transport Configuration
      Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards

Wang ShaoBo (3):
      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
      Bluetooth: hci_conn: add missing hci_dev_put() in iso_listen_bis()
      Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()

Yang Yingliang (9):
      Bluetooth: hci_core: fix error handling in hci_register_dev()
      Bluetooth: hci_bcm4377: Fix missing pci_disable_device() on error in bcm4377_probe()
      Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao (1):
      Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

Zhengping Jiang (1):
      Bluetooth: hci_qca: only assign wakeup with serial port support

 .../devicetree/bindings/net/bluetooth.txt          |    5 -
 .../net/bluetooth/bluetooth-controller.yaml        |   29 +
 .../net/bluetooth/brcm,bcm4377-bluetooth.yaml      |   81 +
 .../net/{ => bluetooth}/qualcomm-bluetooth.yaml    |    6 +-
 .../bindings/net/broadcom-bluetooth.yaml           |    3 +
 .../devicetree/bindings/net/realtek-bluetooth.yaml |    1 +
 .../devicetree/bindings/soc/qcom/qcom,wcnss.yaml   |    8 +-
 MAINTAINERS                                        |    2 +
 arch/arm64/boot/dts/apple/t8103-j274.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j293.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j313.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j456.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j457.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |    8 +
 drivers/bluetooth/Kconfig                          |   23 +
 drivers/bluetooth/Makefile                         |    1 +
 drivers/bluetooth/btintel.c                        |   21 +-
 drivers/bluetooth/btrtl.c                          |    7 +
 drivers/bluetooth/btrtl.h                          |   21 +
 drivers/bluetooth/btusb.c                          |  234 +-
 drivers/bluetooth/hci_bcm.c                        |   13 +-
 drivers/bluetooth/hci_bcm4377.c                    | 2514 ++++++++++++++++++++
 drivers/bluetooth/hci_bcsp.c                       |    2 +-
 drivers/bluetooth/hci_h5.c                         |    2 +-
 drivers/bluetooth/hci_ll.c                         |    2 +-
 drivers/bluetooth/hci_qca.c                        |    5 +-
 drivers/bluetooth/virtio_bt.c                      |   37 +-
 include/net/bluetooth/hci.h                        |   33 +-
 include/net/bluetooth/hci_core.h                   |    8 +-
 include/uapi/linux/virtio_bt.h                     |    8 +
 net/bluetooth/6lowpan.c                            |    1 +
 net/bluetooth/Kconfig                              |   11 +
 net/bluetooth/af_bluetooth.c                       |    4 +-
 net/bluetooth/hci_codec.c                          |   19 +-
 net/bluetooth/hci_conn.c                           |   35 +-
 net/bluetooth/hci_core.c                           |   12 +-
 net/bluetooth/hci_debugfs.c                        |    2 +-
 net/bluetooth/hci_event.c                          |   24 +-
 net/bluetooth/hci_request.c                        |    2 +-
 net/bluetooth/hci_sync.c                           |   40 +-
 net/bluetooth/iso.c                                |   82 +-
 net/bluetooth/l2cap_core.c                         |   91 +-
 net/bluetooth/lib.c                                |    4 +-
 net/bluetooth/mgmt.c                               |    2 +-
 net/bluetooth/rfcomm/core.c                        |    2 +-
 45 files changed, 3265 insertions(+), 160 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)
 create mode 100644 drivers/bluetooth/hci_bcm4377.c
