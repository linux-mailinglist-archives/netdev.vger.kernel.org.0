Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3464AA25
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 23:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiLLWX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 17:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiLLWX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 17:23:26 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4547FB7C1;
        Mon, 12 Dec 2022 14:23:25 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id js9so1349982pjb.2;
        Mon, 12 Dec 2022 14:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8XdeAWxI9ZFQ2kkTJY7b4Lpxs5vKZ4OtFA8H35eWfcg=;
        b=dpF3bjjvVdLu2YyxcYts6VoYYKlG4193SSnqOrVKDJS/jExlEpyNQoXXI94d7pF4fX
         3xNayRm2fqnpdWsi7nLI6DT9VgNVrcMza2Bw7kg0f7SzEW4aICbqoL0P8Bv20BVncINo
         3cB5TWSIa0PVJOR4pZPpqsr5/S8azRbt7kkkR+yI8Un/+lpy9aOrkr0q4H6SGdH5GSVo
         lLm0wAloj7AKK7GKsRY++gVqP0YOpo5keOPthk4troiUgjHB5UsgVF/uldxjhWXElcOM
         8nsWw+lz/9ZZWxQy/u8o4Iof/2ylfeCFY8jZTigSigW3JknSJsgXDrYEEO72WyB2/7eX
         YvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8XdeAWxI9ZFQ2kkTJY7b4Lpxs5vKZ4OtFA8H35eWfcg=;
        b=OgewGoS5LVoy3K7RlaAiNDe7nsOeO/KIMCebRkg3UwFGGZksm3GFC4c4hngSG2dx5a
         8oDZ2peG9VZZukAJtrOOoPBrfs0T9uUC6IiAhUvBxAs/4yYJkvzKHVIi7r5bJ5EqK2Z/
         +FskIsh2grUDJzBK6RmuOVo5FzDptV3p/xMHl/TX+YpwZLfjlX0+lLTxU0jKSBSx31YC
         Cao0OfXi+IUivB4AXE2JrgFewIRnOScdu2h4m/K8Bnt6CUaI+9qD3jfx1sse2dDvUjx/
         7riDvMBTQ2HzLF24mOV80EpMK8VF5bOXFblOwgXejEyvXrlrOdLdMFUoyAv9YM0bdVao
         c9eQ==
X-Gm-Message-State: ANoB5pnGmjOVlJuAp6CJK4gkakmDtQqjGV8mJ6d+RG4pj9NqqrMkJNec
        pMK6hXNPu+4cwBQRl3t7ThNwbzJPt88HIQ==
X-Google-Smtp-Source: AA0mqf4Adp9WP5xDAhdlA9qxHig5VwqTQGTuC23qGriOVFsOnNPpV0r2FOlunW6Fs++qIWp389Al4A==
X-Received: by 2002:a17:903:3317:b0:189:e14a:318e with SMTP id jk23-20020a170903331700b00189e14a318emr18346034plb.27.1670883804705;
        Mon, 12 Dec 2022 14:23:24 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id d1-20020a170903230100b00186f0f59c85sm6876350plh.235.2022.12.12.14.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 14:23:23 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2022-12-12
Date:   Mon, 12 Dec 2022 14:23:22 -0800
Message-Id: <20221212222322.1690780-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

The following changes since commit 15eb1621762134bd3a0f81020359b0c7745d1080:

  dt-bindings: net: Convert Socionext NetSec Ethernet to DT schema (2022-12-12 13:03:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-12-12

for you to fetch changes up to 7aca0ac4792e6cb0f35ef97bfcb39b1663a92fb7:

  Bluetooth: Wait for HCI_OP_WRITE_AUTH_PAYLOAD_TO to complete (2022-12-12 14:19:26 -0800)

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

Chethan Tumkur Narayan (1):
      btusb: Avoid reset of ISOC endpoint alt settings to zero

Christophe JAILLET (1):
      Bluetooth: Fix EALREADY and ELOOP cases in bt_status()

Gongwei Li (1):
      Bluetooth: btusb: Add a new PID/VID 13d3/3549 for RTL8822CU

Hilda Wu (2):
      Bluetooth: btrtl: Add btrealtek data struct
      Bluetooth: btusb: Ignore zero length of USB packets on ALT 6 for specific chip

Igor Skalkin (1):
      virtio_bt: Fix alignment in configuration struct

Inga Stotland (1):
      Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS

Jiapeng Chong (1):
      Bluetooth: Use kzalloc instead of kmalloc/memset

Kang Minchul (1):
      Bluetooth: Use kzalloc instead of kmalloc/memset

Luca Weiss (1):
      dt-bindings: bluetooth: broadcom: add BCM43430A0 & BCM43430A1

Luiz Augusto von Dentz (11):
      Bluetooth: hci_sync: Fix not setting static address
      Bluetooth: hci_sync: Fix not able to set force_static_address
      Bluetooth: btusb: Add CONFIG_BT_HCIBTUSB_POLL_SYNC
      Bluetooth: btusb: Default CONFIG_BT_HCIBTUSB_POLL_SYNC=y
      Bluetooth: Add CONFIG_BT_LE_L2CAP_ECRED
      Bluetooth: btusb: Fix new sparce warnings
      Bluetooth: btusb: Fix existing sparce warning
      Bluetooth: btintel: Fix existing sparce warnings
      Bluetooth: hci_conn: Fix crash on hci_create_cis_sync
      Bluetooth: ISO: Avoid circular locking dependency
      Bluetooth: Wait for HCI_OP_WRITE_AUTH_PAYLOAD_TO to complete

Marek Vasut (2):
      dt-bindings: net: broadcom-bluetooth: Add CYW4373A0 DT binding
      Bluetooth: hci_bcm: Add CYW4373A0 support

Michael S. Tsirkin (1):
      Bluetooth: virtio_bt: fix device removal

Nicolas Cavallari (1):
      Bluetooth: Work around SCO over USB HCI design defect

Pauli Virtanen (1):
      Bluetooth: hci_conn: use HCI dst_type values also for BIS

Raman Varabets (1):
      Bluetooth: btusb: Add Realtek 8761BUV support ID 0x2B89:0x8761

Samuel Holland (1):
      dt-bindings: net: realtek-bluetooth: Add RTL8723DS

Shengyu Qu (1):
      Bluetooth: btusb: Add more device IDs for WCN6855

Sven Peter (7):
      dt-bindings: net: Add generic Bluetooth controller
      dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
      arm64: dts: apple: t8103: Add Bluetooth controller
      Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
      Bluetooth: Add quirk to disable extended scanning
      Bluetooth: Add quirk to disable MWS Transport Configuration
      Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards

Wang ShaoBo (1):
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
 drivers/bluetooth/btusb.c                          |  236 +-
 drivers/bluetooth/hci_bcm.c                        |   13 +-
 drivers/bluetooth/hci_bcm4377.c                    | 2514 ++++++++++++++++++++
 drivers/bluetooth/hci_bcsp.c                       |    2 +-
 drivers/bluetooth/hci_h5.c                         |    2 +-
 drivers/bluetooth/hci_ll.c                         |    2 +-
 drivers/bluetooth/hci_qca.c                        |    5 +-
 drivers/bluetooth/virtio_bt.c                      |   35 +-
 include/net/bluetooth/hci.h                        |   21 +
 include/net/bluetooth/hci_core.h                   |    8 +-
 include/uapi/linux/virtio_bt.h                     |    8 +
 net/bluetooth/Kconfig                              |   11 +
 net/bluetooth/hci_conn.c                           |   17 +-
 net/bluetooth/hci_core.c                           |    4 +-
 net/bluetooth/hci_debugfs.c                        |    2 +-
 net/bluetooth/hci_event.c                          |   24 +-
 net/bluetooth/hci_sync.c                           |   21 +-
 net/bluetooth/iso.c                                |   67 +-
 net/bluetooth/l2cap_core.c                         |    2 +-
 net/bluetooth/lib.c                                |    4 +-
 net/bluetooth/mgmt.c                               |    2 +-
 net/bluetooth/rfcomm/core.c                        |    2 +-
 41 files changed, 3117 insertions(+), 121 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)
 create mode 100644 drivers/bluetooth/hci_bcm4377.c
