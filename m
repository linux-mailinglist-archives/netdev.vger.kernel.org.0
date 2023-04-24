Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0CF6EC4D4
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 07:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjDXF1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 01:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDXF1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 01:27:48 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375D72D7E;
        Sun, 23 Apr 2023 22:27:47 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-3294eacb2f6so10247075ab.3;
        Sun, 23 Apr 2023 22:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682314066; x=1684906066;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eAn1WTahMvkGhL7kuFVW58e8GMs0v3dAOnhdX4Eq0O8=;
        b=F3IPUniBhulqkGvOPciajQzIPdUujbzsECDSAX6y/OUWQo4fiSHjnAWPlO3RxrYi4o
         25pjNKPq3cuJO9ELbGsrzzei30Q/6nwbAzF9JcSTzwqt96p7zlOBVbrgrYsSjyGXtvys
         8diL36N7tctHEd7fzaW40iCONaVjKykz5yxbZpGj1Lqnq4SLqzY96skoHDSRKSltPtMt
         LPLmYT3yH6kOCZpdmH9XHA++hHN0E15GmuuQp5depm31KVnhDSlZ0ArtYu6PTGcMjW/n
         x0fSmp9+ELn9VB1n/wNHYzEQb+vvyfY1ucVXccvuAzTtmG7GIqHF/KMzJuNwWa+d6Ytn
         Weog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682314066; x=1684906066;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eAn1WTahMvkGhL7kuFVW58e8GMs0v3dAOnhdX4Eq0O8=;
        b=UQ1L5QdilcS6TJcYJB8fx3tx/zArsL20R4guXt79ejP+0vIStdcwaeVfPyPnRX1J7k
         EG1qU7taZ2VifoiZ4UIIjwJgueboDGHoRO6cj2BzgI2WoUP4bSuCNbW9LWyFKsHjCzsD
         uzppRWTl2ti8Icd7SjsjXkFYA0aAHWYRpbSrM1WfYyQlS0fZO2Ci0XRWNbJaeWWKHczr
         FFsL1xBl6vW2FfRdOwD6MWVkspqnN/t/Z5TfvvAMPSehjaXBr2hIc6vO5lxUw9Zb4z65
         Ps+fy+JLItwaQ5lzU8828qfVrEZCSvwsTyz4vgetSM3+b1AvjH5H/1xEveXjJhFAJq8o
         +wUg==
X-Gm-Message-State: AAQBX9d2MKb8T7o1bOAqCO2S1/GEY9nQ6i+UYUFge9zVjJt2dlsmqacD
        X6B2Exyq3muyCsDwOqAz0aY=
X-Google-Smtp-Source: AKy350ben7HHqEeLipZF1NhYm312UmQof9BsXVAyaol+KkWGVnNR+o/NUTn595Ictbgj3oDNo9eMzg==
X-Received: by 2002:a92:d64f:0:b0:32b:7087:5bbf with SMTP id x15-20020a92d64f000000b0032b70875bbfmr5063076ilp.9.1682314065774;
        Sun, 23 Apr 2023 22:27:45 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id v5-20020a927a05000000b003261b6acc8asm2786385ilc.79.2023.04.23.22.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 22:27:44 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2023-04-23
Date:   Sun, 23 Apr 2023 22:27:42 -0700
Message-Id: <20230424052742.3423468-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit fd84c569f7b8bbf8154c9940b427942ff5bfbc48:

  Merge branch 'act_pedit-minor-improvements' (2023-04-23 18:35:27 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2023-04-23

for you to fetch changes up to d883a4669a1def6d121ccf5e64ad28260d1c9531:

  Bluetooth: hci_sync: Only allow hci_cmd_sync_queue if running (2023-04-23 22:07:43 -0700)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Introduce devcoredump support
 - Add support for Realtek RTL8821CS, RTL8851B, RTL8852BS
 - Add support for Mediatek MT7663, MT7922
 - Add support for NXP w8997
 - Add support for Actions Semi ATS2851
 - Add support for QTI WCN6855
 - Add support for Marvell 88W8997

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: Add support for hci devcoredump
      Bluetooth: btintel: Add Intel devcoredump support

Archie Pusaka (2):
      Bluetooth: hci_sync: Don't wait peer's reply when powering off
      Bluetooth: Cancel sync command before suspend and power off

Arnd Bergmann (1):
      Bluetooth: NXP: select CONFIG_CRC8

Brian Gix (1):
      Bluetooth: Convert MSFT filter HCI cmd to hci_sync

Chethan T N (1):
      Bluetooth: btintel: Add LE States quirk support

Chris Morgan (3):
      dt-bindings: net: realtek-bluetooth: Add RTL8821CS
      Bluetooth: hci_h5: btrtl: Add support for RTL8821CS
      arm64: dts: rockchip: Update compatible for bluetooth

Dan Carpenter (1):
      Bluetooth: vhci: Fix info leak in force_devcd_write()

Hans de Goede (4):
      Bluetooth: hci_bcm: Fall back to getting bdaddr from EFI if not set
      Bluetooth: hci_bcm: Limit bcm43430a0 / bcm43430a1 baudrate to 2000000
      Bluetooth: hci_bcm: Add Lenovo Yoga Tablet 2 830 / 1050 to the bcm_broken_irq_dmi_table
      Bluetooth: hci_bcm: Add Acer Iconia One 7 B1-750 to the bcm_broken_irq_dmi_table

Ilpo Järvinen (1):
      Bluetooth: hci_ldisc: Fix tty_set_termios() return value assumptions

Inga Stotland (1):
      Bluetooth: hci_sync: Remove duplicate statement

Iulia Tanasescu (2):
      Bluetooth: Split bt_iso_qos into dedicated structures
      Bluetooth: hci_conn: remove extra line in hci_le_big_create_sync

Krzysztof Kozlowski (4):
      Bluetooth: hci_ll: drop of_match_ptr for ID table
      Bluetooth: btmrvl_sdio: mark OF related data as maybe unused
      Bluetooth: hci_qca: mark OF related data as maybe unused
      Bluetooth: btmtkuart: mark OF related data as maybe unused

Lanzhe Li (1):
      Bluetooth: fix inconsistent indenting

Larry Finger (2):
      bluetooth: Add device 0bda:887b to device tables
      bluetooth: Add device 13d3:3571 to device tables

Liu Jian (1):
      Revert "Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work"

Luiz Augusto von Dentz (10):
      Bluetooth: MGMT: Use BIT macro when defining bitfields
      Bluetooth: hci_core: Make hci_conn_hash_add append to the list
      Bluetooth: hci_sync: Fix smatch warning
      Bluetooth: L2CAP: Delay identity address updates
      Bluetooth: Enable all supported LE PHY by default
      Bluetooth: hci_conn: Add support for linking multiple hcon
      Bluetooth: hci_conn: Fix not matching by CIS ID
      Bluetooth: hci_conn: Fix not waiting for HCI_EVT_LE_CIS_ESTABLISHED
      Bluetooth: btnxpuart: Fix sparse warnings
      Bluetooth: hci_sync: Only allow hci_cmd_sync_queue if running

Manish Mandlik (2):
      Bluetooth: Add vhci devcoredump support
      Bluetooth: btusb: Add btusb devcoredump support

Max Chou (3):
      Bluetooth: btrtl: check for NULL in btrtl_set_quirks()
      Bluetooth: btrtl: Firmware format v2 support
      Bluetooth: btrtl: Add the support for RTL8851B

Meng Tang (2):
      Bluetooth: btusb: Add new PID/VID 04ca:3801 for MT7663
      Bluetooth: Add VID/PID 0489/e0e4 for MediaTek MT7922

Min Li (1):
      Bluetooth: L2CAP: fix "bad unlock balance" in l2cap_disconnect_rsp

Neeraj Sanjay Kale (9):
      serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
      serdev: Add method to assert break signal over tty UART port
      dt-bindings: net: bluetooth: Add NXP bluetooth support
      Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
      Bluetooth: btnxpuart: Add support to download helper FW file for w8997
      Bluetooth: btnxpuart: Deasset UART break before closing serdev device
      Bluetooth: btnxpuart: Disable Power Save feature on startup
      Bluetooth: btnxpuart: No need to check the received bootloader signature
      Bluetooth: btnxpuart: Enable flow control before checking boot signature

Qiqi Zhang (1):
      Bluetooth: hci_h5: Complements reliable packet processing logic

Raul Cheleguini (2):
      Bluetooth: Improve support for Actions Semi ATS2851 based devices
      Bluetooth: Add new quirk for broken set random RPA timeout for ATS2851

Ruihan Li (2):
      bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
      bluetooth: Perform careful capability checks in hci_sock_ioctl()

Steev Klimaszewski (3):
      dt-bindings: net: Add WCN6855 Bluetooth
      Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
      Bluetooth: hci_qca: mark OF related data as maybe unused

Stefan Eichenberger (4):
      dt-bindings: bluetooth: marvell: add 88W8997
      dt-bindings: bluetooth: marvell: add max-speed property
      Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
      Bluetooth: hci_mrvl: Add serdev support for 88W8997

Tim Jiang (1):
      Bluetooth: btusb: Add WCN6855 devcoredump support

Tomasz Moń (1):
      Bluetooth: btusb: Do not require hardcoded interface numbers

Vasily Khoruzhick (2):
      Bluetooth: Add new quirk for broken local ext features page 2
      Bluetooth: btrtl: add support for the RTL8723CS

Victor Hassan (1):
      Bluetooth: btrtl: Add support for RTL8852BS

Zijun Hu (1):
      Bluetooth: Devcoredump: Fix storing u32 without specifying byte order issue

 .../bindings/net/bluetooth/nxp,88w8987-bt.yaml     |   45 +
 .../bindings/net/bluetooth/qualcomm-bluetooth.yaml |   17 +
 .../devicetree/bindings/net/marvell-bluetooth.yaml |   20 +-
 .../devicetree/bindings/net/realtek-bluetooth.yaml |   24 +-
 MAINTAINERS                                        |    7 +
 .../boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi   |    2 +-
 drivers/bluetooth/Kconfig                          |   14 +
 drivers/bluetooth/Makefile                         |    1 +
 drivers/bluetooth/btbcm.c                          |   47 +-
 drivers/bluetooth/btintel.c                        |   77 +-
 drivers/bluetooth/btintel.h                        |   12 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
 drivers/bluetooth/btmtkuart.c                      |    6 +-
 drivers/bluetooth/btnxpuart.c                      | 1352 ++++++++++++++++++++
 drivers/bluetooth/btqca.c                          |   14 +-
 drivers/bluetooth/btqca.h                          |   10 +
 drivers/bluetooth/btrtl.c                          |  502 +++++++-
 drivers/bluetooth/btrtl.h                          |   58 +-
 drivers/bluetooth/btsdio.c                         |    1 -
 drivers/bluetooth/btusb.c                          |  318 ++++-
 drivers/bluetooth/hci_bcm.c                        |   60 +-
 drivers/bluetooth/hci_h5.c                         |    6 +
 drivers/bluetooth/hci_ldisc.c                      |    8 +-
 drivers/bluetooth/hci_ll.c                         |    2 +-
 drivers/bluetooth/hci_mrvl.c                       |   90 +-
 drivers/bluetooth/hci_qca.c                        |   67 +-
 drivers/bluetooth/hci_vhci.c                       |  101 ++
 drivers/tty/serdev/core.c                          |   17 +-
 drivers/tty/serdev/serdev-ttyport.c                |   16 +-
 include/linux/serdev.h                             |   10 +-
 include/net/bluetooth/bluetooth.h                  |   43 +-
 include/net/bluetooth/coredump.h                   |  116 ++
 include/net/bluetooth/hci.h                        |   15 +
 include/net/bluetooth/hci_core.h                   |   55 +-
 include/net/bluetooth/hci_sync.h                   |    4 +
 include/net/bluetooth/l2cap.h                      |    2 +-
 include/net/bluetooth/mgmt.h                       |   80 +-
 net/bluetooth/Makefile                             |    2 +
 net/bluetooth/coredump.c                           |  536 ++++++++
 net/bluetooth/hci_conn.c                           |  365 +++---
 net/bluetooth/hci_core.c                           |    4 +
 net/bluetooth/hci_debugfs.c                        |    2 +-
 net/bluetooth/hci_event.c                          |  132 +-
 net/bluetooth/hci_sock.c                           |   37 +-
 net/bluetooth/hci_sync.c                           |  137 +-
 net/bluetooth/iso.c                                |  133 +-
 net/bluetooth/l2cap_core.c                         |    8 +-
 net/bluetooth/mgmt.c                               |   16 +-
 net/bluetooth/msft.c                               |   36 +-
 net/bluetooth/smp.c                                |    9 +-
 50 files changed, 4122 insertions(+), 516 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c
 create mode 100644 include/net/bluetooth/coredump.h
 create mode 100644 net/bluetooth/coredump.c
