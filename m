Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A9A4816F4
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 22:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhL2VNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 16:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhL2VNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 16:13:00 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3804CC061574;
        Wed, 29 Dec 2021 13:13:00 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v11so19647936pfu.2;
        Wed, 29 Dec 2021 13:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Sy7X83l+oFmQ+kJgQ2PAuquqo+Z6siPcNoTF5dDBiE=;
        b=nQ9mkrkwrzGQFQsdw1/zzw3B9xjQKmmjkCLdgJqFqf7ZHSDk+fajzOySUpqByFP7+f
         Prs49OtmGXVpHySwFNZyToJOBZthzz3ryXOrpTjKob//U4ObcEkbhDibaTP3zUgAcULg
         swObj9W3K/C0WaWnziN/M1mF3p3mzUICaBt2odsPcpKf8klw/bzGAAmu8Kcnkutnw7ay
         3C9ssyh+OqoIW4op1oj31M/ODobmDHzmRIbBcRe2yeJE+REwp8PCGivb3HiCc1j1cUCk
         cPDxOtaZIbDpsa2ztpnBloPrz0BMKIRyPq4yWjk4dVBSsp9D1Q8eTDzz+uJJGdMAXV2s
         r1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Sy7X83l+oFmQ+kJgQ2PAuquqo+Z6siPcNoTF5dDBiE=;
        b=oSpHRQUwIZfTi3cx2bShxFEaIqYMus6GJTEqhir8qswq/2Srer5D9UuXM+Va6KHCv5
         OzNuivKr6eCZ0XgDaMQ8TgVnYX2U/H7EYeYriq/QZbBSqRU45jZCQF1O/o8T4ML1m5IG
         jpwvChqvPBJ81zHcFr3yFtzL8eLCVh0A9/NJB28bord1CWBEATWPTd3cCCAtUAxpfEHy
         j+M86yABICg/OXidUMOmK+7r6I0gLdbnKCuxOaD25J/E6e82rdOz64p9N4RRztR7cyDy
         o/7akYMGceRar3YIu3jchQXg3l6EmbRltGIwTHdWm2Dg1NToV+YQpt9Nhrd0gVh6S/Ew
         gyAg==
X-Gm-Message-State: AOAM5339wm61dn+UfyT4xpS8xTbTgSWA0YNAbxO8kgIKqDI7irJQyZIu
        eipr85TiLaVA3F3NyuSRJoI=
X-Google-Smtp-Source: ABdhPJzd3kTpuJEVSFiHpwSxy8SJETUZMGlvvkwT05xbj2ylAXGle9h1fT5rGITps8A8DtR/eob+bA==
X-Received: by 2002:a63:85c3:: with SMTP id u186mr25006818pgd.225.1640812379556;
        Wed, 29 Dec 2021 13:12:59 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id e21sm17837042pjr.5.2021.12.29.13.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 13:12:59 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-12-29
Date:   Wed, 29 Dec 2021 13:12:58 -0800
Message-Id: <20211229211258.2290966-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit d156250018ab5adbcfcc9ea90455d5fba5df6769:

  Merge branch 'hns3-next' (2021-11-24 14:12:26 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-12-29

for you to fetch changes up to 5d1dd2e5a681b126a04192e37abb2011c2fb719c:

  Bluetooth: MGMT: Fix spelling mistake "simultanous" -> "simultaneous" (2021-12-23 11:39:59 -0800)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for Foxconn MT7922A
 - Add support for Realtek RTL8852AE
 - Rework HCI event handling to use skb_pull_data

----------------------------------------------------------------
Aaron Ma (1):
      Bluetooth: btusb: Add support for Foxconn MT7922A

Aditya Garg (2):
      Bluetooth: add quirk disabling LE Read Transmit Power
      Bluetooth: btbcm: disable read tx power for some Macs with the T2 Security chip

Archie Pusaka (2):
      Bluetooth: Send device found event on name resolve failure
      Bluetooth: Limit duration of Remote Name Resolve

Benjamin Berg (5):
      Bluetooth: Reset more state when cancelling a sync command
      Bluetooth: Add hci_cmd_sync_cancel to public API
      Bluetooth: hci_core: Cancel sync command if sending a frame failed
      Bluetooth: btusb: Cancel sync commands for certain URB errors
      Bluetooth: hci_sync: Push sync command cancellation to workqueue

Brian Gix (1):
      Bluetooth: refactor malicious adv data check

Colin Ian King (1):
      Bluetooth: MGMT: Fix spelling mistake "simultanous" -> "simultaneous"

Larry Finger (1):
      Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Luiz Augusto von Dentz (35):
      Bluetooth: HCI: Fix definition of hci_rp_read_stored_link_key
      Bluetooth: HCI: Fix definition of hci_rp_delete_stored_link_key
      skbuff: introduce skb_pull_data
      Bluetooth: HCI: Use skb_pull_data to parse BR/EDR events
      Bluetooth: HCI: Use skb_pull_data to parse Command Complete event
      Bluetooth: HCI: Use skb_pull_data to parse Number of Complete Packets event
      Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result event
      Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result with RSSI event
      Bluetooth: HCI: Use skb_pull_data to parse Extended Inquiry Result event
      Bluetooth: HCI: Use skb_pull_data to parse LE Metaevents
      Bluetooth: HCI: Use skb_pull_data to parse LE Advertising Report event
      Bluetooth: HCI: Use skb_pull_data to parse LE Ext Advertising Report event
      Bluetooth: HCI: Use skb_pull_data to parse LE Direct Advertising Report event
      Bluetooth: hci_event: Use of a function table to handle HCI events
      Bluetooth: hci_event: Use of a function table to handle LE subevents
      Bluetooth: hci_event: Use of a function table to handle Command Complete
      Bluetooth: hci_event: Use of a function table to handle Command Status
      Bluetooth: MGMT: Use hci_dev_test_and_{set,clear}_flag
      Bluetooth: hci_core: Rework hci_conn_params flags
      Bluetooth: btusb: Add support for queuing during polling interval
      Bluetooth: Introduce HCI_CONN_FLAG_DEVICE_PRIVACY device flag
      Bluetooth: hci_sync: Set Privacy Mode when updating the resolving list
      Bluetooth: msft: Fix compilation when CONFIG_BT_MSFTEXT is not set
      Bluetooth: mgmt: Introduce mgmt_alloc_skb and mgmt_send_event_skb
      Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_FOUND
      Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED
      Bluetooth: hci_sync: Fix not always pausing advertising when necessary
      Bluetooth: L2CAP: Fix using wrong mode
      Bluetooth: hci_event: Use skb_pull_data when processing inquiry results
      Bluetooth: hci_sync: Add hci_le_create_conn_sync
      Bluetooth: hci_sync: Add support for waiting specific LE subevents
      Bluetooth: hci_sync: Wait for proper events when connecting LE
      Bluetooth: hci_sync: Add check simultaneous roles support
      Bluetooth: MGMT: Fix LE simultaneous roles UUID if not supported
      Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES

Mark Chen (2):
      Bluetooth: btusb: Handle download_firmware failure cases
      Bluetooth: btusb: Return error code when getting patch status failed

Panicker Harish (1):
      Bluetooth: hci_qca: Stop IBS timer during BT OFF

Sean Wang (5):
      Bluetooth: btmtksdio: add support of processing firmware coredump and log
      Bluetooth: btmtksdio: drop the unnecessary variable created
      Bluetooth: btmtksdio: handle runtime pm only when sdio_func is available
      Bluetooth: btmtksdio: fix resume failure
      Bluetooth: btmtksdio: enable AOSP extension for MT7921

Tedd Ho-Jeong An (1):
      Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader

Zijun Hu (2):
      Bluetooth: btusb: Add one more Bluetooth part for WCN6855
      Bluetooth: btusb: Add two more Bluetooth parts for WCN6855

tjiang@codeaurora.org (2):
      Bluetooth: btusb: re-definition for board_id in struct qca_version
      Bluetooth: btusb: Add the new support IDs for WCN6855

Łukasz Bartosik (1):
      Bluetooth: btmtksdio: enable msft opcode

 drivers/bluetooth/btbcm.c         |   39 +
 drivers/bluetooth/btintel.c       |   26 +-
 drivers/bluetooth/btmtk.c         |    1 +
 drivers/bluetooth/btmtksdio.c     |   49 +-
 drivers/bluetooth/btusb.c         |  184 ++-
 drivers/bluetooth/hci_qca.c       |    3 +
 drivers/bluetooth/hci_vhci.c      |    2 +
 include/linux/skbuff.h            |    2 +
 include/net/bluetooth/bluetooth.h |    7 +
 include/net/bluetooth/hci.h       |   85 +-
 include/net/bluetooth/hci_core.h  |   46 +-
 include/net/bluetooth/hci_sync.h  |    6 +
 include/net/bluetooth/mgmt.h      |    9 +-
 net/bluetooth/hci_conn.c          |  305 +---
 net/bluetooth/hci_core.c          |   22 +-
 net/bluetooth/hci_event.c         | 3167 ++++++++++++++++++++-----------------
 net/bluetooth/hci_request.c       |   67 +-
 net/bluetooth/hci_request.h       |    3 -
 net/bluetooth/hci_sync.c          |  391 ++++-
 net/bluetooth/l2cap_core.c        |    2 +-
 net/bluetooth/l2cap_sock.c        |   12 +-
 net/bluetooth/mgmt.c              |  263 +--
 net/bluetooth/mgmt_util.c         |   66 +-
 net/bluetooth/mgmt_util.h         |    4 +
 net/bluetooth/msft.c              |    2 +-
 net/bluetooth/msft.h              |    5 +-
 net/core/skbuff.c                 |   24 +
 27 files changed, 2790 insertions(+), 2002 deletions(-)
