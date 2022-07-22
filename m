Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E389457E89E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 22:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiGVUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 16:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGVUyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 16:54:03 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723F861738;
        Fri, 22 Jul 2022 13:54:02 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k16so5500269pls.8;
        Fri, 22 Jul 2022 13:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XunZYN18xVq5E9Gg2sKwwr3NassRtXFbRrHXf6W4tBY=;
        b=Qt9A/HBwz0Bzb5o7eDK9WCvcKS7ZXQ5Da21ut5GM/a9L95/DeM0L5XAK1NgDN2XTGz
         YNWTTb3Ko5nf8ja2JhfWKp+JYODdUm7QTUELZmCzgofSXm5nGBWD57TQz5aZ1Ce409La
         zUrfAr7X+VCXJnu63e3nMsmuz+E44xGQD+Wf2CcuWloCSooDdzOLsTkfS+XQ7sjav2WL
         7HNt4XQ9S8oH/3m7s/0H4KGYrgTeGqOEzde6OBLlCwiNcIxasnbgAZuAhgMi1IfuGMEt
         T0HHFYz9j7a3q5/dllAbAYIyJNOIL4l/RpS+fZ+1e7rGtWcMi868Xmc++I0hKxgq9czI
         fKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XunZYN18xVq5E9Gg2sKwwr3NassRtXFbRrHXf6W4tBY=;
        b=FMy7Qehg2AaLMLioDzm9WwbyrFAqyTLO964mv+SLbvGxv8I5UktcMIJziwxWdJE0xh
         Hp819QGok/PBdIHFR0hcrY9O944Qo8JA463HjbpmWY5VBC2kN2IdGbwUCwKd/qT4vpJf
         saNpVzwkwPxu4HUtiCkFe/qPAXmOEcjUPUXdKsY83zM+wnRBUkmqfShbQeezVGvHuzdF
         6voUUllddGp6cPiPZB1US6KlsBY4bKUBK9FpdRq4aFLP6LEjSIoDi5FEGOtE2uXTWCpf
         hgGR5OUi3oI0GWNVu42N/tj7cK43L5hrrBxINxT7k9ICsIrFs0/u/QO3ZvwDeQzq17xn
         k3XA==
X-Gm-Message-State: AJIora8wGZWkO+cnwPFWnoldK52GPpLcyfpxM3jY6KDwGrPaMq3OdnCD
        0CFiR2UCx7xq7OdALoLnBlmL1Uq+6PORIA==
X-Google-Smtp-Source: AGRyM1vU++s/jL3uPmYNRrFDvJyx4eTV7oUAzhvhl2Tcpeh0LoK3OPUg7zRkqOoriyyopr5WIqc2ZA==
X-Received: by 2002:a17:902:f641:b0:16d:351d:c1ea with SMTP id m1-20020a170902f64100b0016d351dc1eamr1268759plg.174.1658523241763;
        Fri, 22 Jul 2022 13:54:01 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id i23-20020a17090a059700b001f1acb6c3ebsm3806777pji.34.2022.07.22.13.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 13:54:01 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2022-07-22
Date:   Fri, 22 Jul 2022 13:54:00 -0700
Message-Id: <20220722205400.847019-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.36.1
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

The following changes since commit 6e0e846ee2ab01bc44254e6a0a6a6a0db1cba16d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-21 13:03:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-07-22

for you to fetch changes up to 768677808478ee7ffabf9c9128f345b7ec62b5f3:

  Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet (2022-07-22 13:24:55 -0700)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for IM Networks PID 0x3568
 - Add support for BCM4349B1
 - Add support for CYW55572
 - Add support for MT7922 VID/PID 0489/e0e2
 - Add support for Realtek RTL8852C
 - Initial support for Isochronous Channels/ISO sockets
 - Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING quirk

----------------------------------------------------------------
Aaron Ma (1):
      Bluetooth: btusb: Add support of IMC Networks PID 0x3568

Abhishek Pandit-Subedi (2):
      Bluetooth: Fix index added after unregister
      Bluetooth: Unregister suspend with userchannel

Ahmad Fatoum (2):
      dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT binding
      Bluetooth: hci_bcm: Add BCM4349B1 variant

Alain Michaud (1):
      Bluetooth: clear the temporary linkkey in hci_conn_cleanup

Brian Gix (3):
      Bluetooth: Remove dead code from hci_request.c
      Bluetooth: Remove update_scan hci_request dependancy
      Bluetooth: Convert delayed discov_off to hci_sync

Dan Carpenter (2):
      Bluetooth: fix an error code in hci_register_dev()
      Bluetooth: clean up error pointer checking

Hakan Jansson (7):
      dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
      Bluetooth: hci_bcm: Add support for FW loading in autobaud mode
      dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT binding
      dt-bindings: net: broadcom-bluetooth: Add conditional constraints
      Bluetooth: hci_bcm: Add DT compatible for CYW55572
      Bluetooth: hci_bcm: Prevent early baudrate setting in autobaud mode
      Bluetooth: hci_bcm: Increase host baudrate for CYW55572 in autobaud mode

He Wang (1):
      Bluetooth: btusb: Add a new VID/PID 0489/e0e2 for MT7922

Hilda Wu (5):
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04CA:0x4007
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04C5:0x1675
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0CB8:0xC558
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3587
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3586

Jiasheng Jiang (1):
      Bluetooth: hci_intel: Add check for platform_driver_register

Luiz Augusto von Dentz (16):
      Bluetooth: eir: Fix using strlen with hdev->{dev_name,short_name}
      Bluetooth: HCI: Fix not always setting Scan Response/Advertising Data
      Bluetooth: hci_sync: Fix not updating privacy_mode
      Bluetooth: hci_sync: Don't remove connected devices from accept list
      Bluetooth: hci_sync: Split hci_dev_open_sync
      Bluetooth: Add bt_status
      Bluetooth: Use bt_status to convert from errno
      Bluetooth: mgmt: Fix using hci_conn_abort
      Bluetooth: MGMT: Fix holding hci_conn reference while command is queued
      Bluetooth: hci_core: Introduce hci_recv_event_data
      Bluetooth: Add initial implementation of CIS connections
      Bluetooth: Add BTPROTO_ISO socket type
      Bluetooth: Add initial implementation of BIS connections
      Bluetooth: ISO: Add broadcast support
      Bluetooth: btusb: Add support for ISO packets
      Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet

Manish Mandlik (2):
      Bluetooth: hci_sync: Refactor add Adv Monitor
      Bluetooth: hci_sync: Refactor remove Adv Monitor

Sai Teja Aluvala (1):
      Bluetooth: hci_qca: Return wakeup for qca_wakeup

Schspa Shi (1):
      Bluetooth: When HCI work queue is drained, only queue chained work

Sean Wang (1):
      Bluetooth: btmtksdio: Add in-band wakeup support

Tamas Koczka (1):
      Bluetooth: Collect kcov coverage from hci_rx_work

Xiaohui Zhang (1):
      Bluetooth: use memset avoid memory leaks

Ying Hsu (1):
      Bluetooth: Add default wakeup callback for HCI UART driver

Yuri D'Elia (1):
      Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for MTK

Zhengping Jiang (2):
      Bluetooth: mgmt: Fix refresh cached connection info
      Bluetooth: hci_sync: Fix resuming scan after suspend resume

Zijun Hu (5):
      Bluetooth: hci_sync: Correct hci_set_event_mask_page_2_sync() event mask
      Bluetooth: hci_sync: Check LMP feature bit instead of quirk
      Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
      Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR
      Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING

shaomin Deng (1):
      Bluetooth: btrtl: Fix typo in comment

 .../bindings/net/broadcom-bluetooth.yaml           |   25 +
 drivers/bluetooth/btbcm.c                          |   33 +-
 drivers/bluetooth/btbcm.h                          |    8 +-
 drivers/bluetooth/btmtksdio.c                      |   15 +
 drivers/bluetooth/btrtl.c                          |    2 +-
 drivers/bluetooth/btusb.c                          |   45 +-
 drivers/bluetooth/hci_bcm.c                        |   35 +-
 drivers/bluetooth/hci_intel.c                      |    6 +-
 drivers/bluetooth/hci_qca.c                        |    2 +-
 drivers/bluetooth/hci_serdev.c                     |   11 +
 include/net/bluetooth/bluetooth.h                  |   71 +-
 include/net/bluetooth/hci.h                        |  203 ++-
 include/net/bluetooth/hci_core.h                   |  234 ++-
 include/net/bluetooth/hci_sock.h                   |    2 +
 include/net/bluetooth/hci_sync.h                   |   16 +
 include/net/bluetooth/iso.h                        |   32 +
 net/bluetooth/Kconfig                              |    1 +
 net/bluetooth/Makefile                             |    1 +
 net/bluetooth/af_bluetooth.c                       |    4 +-
 net/bluetooth/eir.c                                |   62 +-
 net/bluetooth/eir.h                                |    1 +
 net/bluetooth/hci_conn.c                           |  900 +++++++++-
 net/bluetooth/hci_core.c                           |  569 ++++--
 net/bluetooth/hci_event.c                          |  529 +++++-
 net/bluetooth/hci_request.c                        |  429 +----
 net/bluetooth/hci_request.h                        |   16 +-
 net/bluetooth/hci_sock.c                           |   11 +-
 net/bluetooth/hci_sync.c                           |  628 +++++--
 net/bluetooth/iso.c                                | 1824 ++++++++++++++++++++
 net/bluetooth/l2cap_core.c                         |    1 +
 net/bluetooth/lib.c                                |   71 +
 net/bluetooth/mgmt.c                               |  338 ++--
 net/bluetooth/msft.c                               |  269 +--
 net/bluetooth/msft.h                               |    6 +-
 34 files changed, 5224 insertions(+), 1176 deletions(-)
 create mode 100644 include/net/bluetooth/iso.h
 create mode 100644 net/bluetooth/iso.c
