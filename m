Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728C957EA9C
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 02:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiGWAWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 20:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiGWAWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 20:22:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF415C9CA;
        Fri, 22 Jul 2022 17:22:34 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y24so5807415plh.7;
        Fri, 22 Jul 2022 17:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X56Obn07TJL2yLA+27UvWN9CiLQcrfo7UGGyhEDeuqk=;
        b=SikYR7kC303kGnJUo2l5s8qDTjLqejhYcTIAl1U4cHfkB3YQcwdkxbiZwDq4m+UsoM
         ocvRNgoWh3ylrirofI2Il+d6bZ69Kz/iaShWijI3h4rt79NEHDvtXlpoYdz2z9eTj+Z1
         4rooL4DweH+o13M3sZ1sBSEpSDm4M6eQ1ABfXpQKTs4RqYFM7z7y0MbGYSUviy8cjXkq
         /jfD8MUCxmaHhbUQktCChH1xty9HY7pO3SG/093ywNGVBBeeNlQCLKn6UU1p5Io1BfRJ
         esa5ao5rJDMZsxv6QDX6TFvc5xv678Jrf33OZu8tG7iS8notzlPXydsgwqRZNCBF9NKd
         K3vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X56Obn07TJL2yLA+27UvWN9CiLQcrfo7UGGyhEDeuqk=;
        b=QtRUEet9iY0jzm1RH5YJFk3AP9Sw2Utm+G9lOQbzutFxaklKo4ciWc0OBXB1C3OqgI
         5fPr7Wb/J/BCVlsYTIL9QcpDOhN/uD6H1eXvE7RGPAeF3b3H8Dr64RXBILK5EdlVkJfV
         WMkDuryS52xaS88Mq9jywF/OUPI2tMSg7as6qeoRhAhd7V+GYdZBeth0jHJC565t1+Wx
         ybjkLKkUYxRJwQpyUT027i0kwif1Lt7mWU975m002Zxalp2Wdyccd+hMK9pozWsUJ2Po
         rs8Dok+1f3t4WgAfN9I7hq1if5y+MEHaiXM3vFkva3rEEPsj+oABqw5kHCC9ynDi7/lZ
         In1g==
X-Gm-Message-State: AJIora+yH47HkGPx4TDYQ9BDa03Hp1CF675yuJAXaAIRcfwqyjdEChnM
        JrHWTbZzbGwACaQ6VecufCkdX2Vu6XTLkw==
X-Google-Smtp-Source: AGRyM1vjpHD4NzeNgYRTtkTc+bBvtEnbetSrMJDBPKGuftZsH/yd/l8kktTpNrPDzE9paGOZHpoV/g==
X-Received: by 2002:a17:902:cf09:b0:16d:3b47:d2dc with SMTP id i9-20020a170902cf0900b0016d3b47d2dcmr2192912plg.123.1658535753651;
        Fri, 22 Jul 2022 17:22:33 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id n13-20020a170902e54d00b0016c38eb1f3asm4530668plf.214.2022.07.22.17.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 17:22:33 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2022-07-22
Date:   Fri, 22 Jul 2022 17:22:32 -0700
Message-Id: <20220723002232.964796-1-luiz.dentz@gmail.com>
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

for you to fetch changes up to 14202eff214e1e941fefa0366d4c3bc4b1a0d500:

  Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet (2022-07-22 17:14:37 -0700)

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
