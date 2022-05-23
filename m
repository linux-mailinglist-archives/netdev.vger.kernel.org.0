Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36C531C44
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbiEWUl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiEWUlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:41:55 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE40AA006C;
        Mon, 23 May 2022 13:41:53 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q76so14635970pgq.10;
        Mon, 23 May 2022 13:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mb/diutsKCyaTxghxZj5uB5jLkGYXFK+bGmVJLUN/+g=;
        b=HZBKsqeTDcQ7ErVYYohSGjxwy5bkobYkYr9TOMlfQAI8dmfc1+hqcBUepVkweyji49
         9U41dBh0CuwdHLmXqZ/frie4ifkkO8F92w8A2jS7awgFEbkaFbWT9pCRLDnX0OFwDPNE
         ZjZFjbzkVUxd7d9zHsO53KPNKOCuI36oQeU/dHXgJttHPWiDTtSITHiXnOeqID28vqxZ
         6qdqSS2yOoqVlfvXIzc7vhf83h/BhYUmN+UHet9KQkhzQcst4LZx7dGvgGrJChHKsTAV
         /sd1v1jCdqzHY4QV0utC5IrOI/OyZFF9rZZhd7rfkxpI02ITn7yJEKCIqbZQpozRAvaF
         2YwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mb/diutsKCyaTxghxZj5uB5jLkGYXFK+bGmVJLUN/+g=;
        b=TWwGLEVa1OVg9l5njKH7CqW4Q4Fc3DR3+Dnt94UjJEyGYLwRNyxeEGiJ+oJqBqF8Mz
         4ighflKqi7S79vT1xoS02+Wdy9FyiZWiUbGRuZ2peYGns/l5ey6ii12jwIelebdmOX25
         JiJwIW+KkkO3eDOAsl99lNV7bFE9/odB0lOIDU3hoHvkNmPr7koV6saZ+rv/I8LUZa6Z
         Yc6Sl/JWCbCtmYYckNbWsAuFpYuiJMjBSeogJ1ZR1ZK7nxKu4tf9h8uRftv6tAXZ3MME
         LwHQkTnsWt2PrGoTsXYfMySYs0QRddfjBfcIYnwvnO4Z8iU6YptcTZmSiSWcpoZGwyJW
         q5vg==
X-Gm-Message-State: AOAM531B5D2RHSvdZ6XtkL1uDdOm5g5ebYwkwdDBEVUm4NwgjTrR+s5A
        asc03E3zCmpPVf/gwA65PFk5+dTB7Je9tQ==
X-Google-Smtp-Source: ABdhPJzeSjWd37n4H5dP6zzteNEJnmggRi13DNtc7dIc0eH9zeUCSGvg9yX9ddRZP/ax4KvnGsUJ9Q==
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id b6-20020a056a00114600b004c9ede0725amr25013016pfm.35.1653338512619;
        Mon, 23 May 2022 13:41:52 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id y21-20020a056a001c9500b00518895f0dabsm4908489pfw.59.2022.05.23.13.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 13:41:51 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2022-05-23
Date:   Mon, 23 May 2022 13:41:51 -0700
Message-Id: <20220523204151.3327345-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

The following changes since commit 49bb39bddad214304bb523258f02f57cd25ed88b:

  selftests: fib_nexthops: Make the test more robust (2022-05-13 11:59:32 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-05-23

for you to fetch changes up to edcb185fa9c4f8fa1301f032fb503d2597a92b1e:

  Bluetooth: hci_sync: use hci_skb_event() helper (2022-05-23 17:21:59 +0200)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for Realtek 8761BUV
 - Add HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk
 - Add support for RTL8852C
 - Add a new PID/VID 0489/e0c8 for MT7921
 - Add support for Qualcomm WCN785x

----------------------------------------------------------------
Ahmad Fatoum (1):
      Bluetooth: hci_sync: use hci_skb_event() helper

Brian Gix (1):
      Bluetooth: Keep MGMT pending queue ordered FIFO

Ismael Luceno (1):
      Bluetooth: btusb: Add 0x0bda:0x8771 Realtek 8761BUV devices

Linus Walleij (1):
      Bluetooth: btbcm: Support per-board firmware variants

Luiz Augusto von Dentz (6):
      Bluetooth: HCI: Add HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk
      Bluetooth: Print broken quirks
      Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for QCA
      Bluetooth: MGMT: Add conditions for setting HCI_CONN_FLAG_REMOTE_WAKEUP
      Bluetooth: hci_sync: Fix attempting to suspend with unfiltered passive scan
      Bluetooth: eir: Add helpers for managing service data

Max Chou (1):
      Bluetooth: btrtl: Add support for RTL8852C

Niels Dossche (3):
      Bluetooth: use hdev lock in activate_scan for hci_is_adv_monitoring
      Bluetooth: use hdev lock for accept_list and reject_list in conn req
      Bluetooth: protect le accept and resolv lists with hdev->lock

Rikard Falkeborn (1):
      Bluetooth: btintel: Constify static struct regmap_bus

Sean Wang (5):
      Bluetooth: mt7921s: Fix the incorrect pointer check
      Bluetooth: btusb: Add a new PID/VID 0489/e0c8 for MT7921
      Bluetooth: btmtksdio: fix use-after-free at btmtksdio_recv_event
      Bluetooth: btmtksdio: fix possible FW initialization failure
      Bluetooth: btmtksdio: fix the reset takes too long

Steven Rostedt (1):
      Bluetooth: hci_qca: Use del_timer_sync() before freeing

Tim Harvey (1):
      Bluetooth: btbcm: Add entry for BCM4373A0 UART Bluetooth

Vasyl Vavrychuk (1):
      Bluetooth: core: Fix missing power_on work cancel on HCI close

Ying Hsu (1):
      Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Zijun Hu (2):
      Bluetooth: btusb: add support for Qualcomm WCN785x
      Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA

 drivers/bluetooth/btbcm.c        | 53 ++++++++++++++++++++++-
 drivers/bluetooth/btintel.c      |  2 +-
 drivers/bluetooth/btmtksdio.c    | 26 +++++++-----
 drivers/bluetooth/btrtl.c        | 13 ++++++
 drivers/bluetooth/btusb.c        | 23 +++++++++-
 drivers/bluetooth/hci_qca.c      |  4 +-
 include/net/bluetooth/hci.h      | 10 +++++
 include/net/bluetooth/hci_core.h |  8 +++-
 net/bluetooth/eir.c              | 31 ++++++++++++++
 net/bluetooth/eir.h              |  4 ++
 net/bluetooth/hci_conn.c         |  2 +-
 net/bluetooth/hci_core.c         |  2 -
 net/bluetooth/hci_event.c        | 27 +++++++++---
 net/bluetooth/hci_request.c      |  4 +-
 net/bluetooth/hci_sync.c         | 90 +++++++++++++++++++++++++++++++++-------
 net/bluetooth/mgmt.c             | 18 ++++++++
 net/bluetooth/mgmt_util.c        |  2 +-
 net/bluetooth/sco.c              | 23 ++++++----
 18 files changed, 289 insertions(+), 53 deletions(-)
