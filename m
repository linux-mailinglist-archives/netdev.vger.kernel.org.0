Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A875F177B
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 02:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbiJAAqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 20:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiJAAqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 20:46:06 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44ECD574E;
        Fri, 30 Sep 2022 17:46:05 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d2so93729ilr.12;
        Fri, 30 Sep 2022 17:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=3B/Ah/6+V4ogpm9VnsBsaPlWJ+P7J8Di3ELwUnG5ZO8=;
        b=jp9nZNVaHCjGWCVw5GvSclnKA7BretNTCUXtOZgukqzxoTl+0W7FbHyNzjOLiKAgQg
         TG2QYoHH1jKLG2SpTBgX08MfYbQGUrT6B4ueoVSoZcpOngf/b5Nza2V8izNYFuuP5F5W
         Wbh1KTqm5iyb4Y+fekZ1ni6MfySC8tlj++4zZEKS/QdDDgu8fmiT1a85ffSHvVBhMKgs
         EzT1wNtpotMHY/Mb07JfqGtsxgAtH7ve9RVXaymmqJog+nfrZRulo1Rty6LiQRWw4WOe
         oHbeE1STdYUHcIWKuZfwJBpFdrZ+Phw63BP16toVL3Rm8bcGhLkwYFAqRLnx2DVDHBKb
         LMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=3B/Ah/6+V4ogpm9VnsBsaPlWJ+P7J8Di3ELwUnG5ZO8=;
        b=gCk//2Sg5wWZKB1QtD337TJFQnaoOqW/XnOTmy4HpMKW7srM4AThOgi2+zTf5NEO5Z
         ocoPxMOP5xpvxLpu9r05Ja5oiFQ/pO4MYcURTJ9lzT7kGYN3XvQF1/H1xXhJLEhynzn/
         R6dXekWOZM7aiikt0N/NJQt26Txlo+aSdtuwZdnbedIPF57CZxcYYoX+aC9yFild1shs
         v0SKW0jrYMYbZfbTIiNabk7dgHv+8q9BUoAYnDufGH1qWHcipw7ImyeEYKOKDB5Yg/mr
         PKPUEeT1kGfDCvrtpQy8Sx1oklzP9QEM9iYchg4BGyZPVmO0DplQwxcWzwGq9ibw0tAa
         29Iw==
X-Gm-Message-State: ACrzQf2Hf4l1oE6r1/M6pu+g57JDWorwGesAieHVAk7t2Aqp4DFRldH7
        BQnq6UsGbngjOcGvZBXIoQW+cH7IR9g=
X-Google-Smtp-Source: AMsMyM61xixvRjYH2QUVBHN6n8d3oNwhomVAOeis0RsyoY7ZVxD4b0Nb2bNRmP7ua456+NR4azTRqg==
X-Received: by 2002:a05:6e02:19ca:b0:2f6:b3c5:4aaf with SMTP id r10-20020a056e0219ca00b002f6b3c54aafmr5195702ill.251.1664585165120;
        Fri, 30 Sep 2022 17:46:05 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id m127-20020a6b3f85000000b006a4e07e6c90sm1644010ioa.34.2022.09.30.17.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 17:46:04 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: bluetooth-next 2022-09-30
Date:   Fri, 30 Sep 2022 17:46:02 -0700
Message-Id: <20221001004602.297366-1-luiz.dentz@gmail.com>
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

The following changes since commit b9030780971b56c0c455c3b66244efd96608846d:

  netdev: Use try_cmpxchg in napi_if_scheduled_mark_missed (2022-08-25 14:20:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-09-30

for you to fetch changes up to 6abf0dae8c3c927f54e62c46faf8aba580ba0d04:

  Bluetooth: hci_sync: Fix not indicating power state (2022-09-30 17:32:12 -0700)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add RTL8761BUV device (Edimax BT-8500)
 - Add a new PID/VID 13d3/3583 for MT7921
 - Add Realtek RTL8852C support ID 0x13D3:0x3592
 - Add VID/PID 0489/e0e0 for MediaTek MT7921
 - Add a new VID/PID 0e8d/0608 for MT7921
 - Add a new PID/VID 13d3/3578 for MT7921
 - Add BT device 0cb8:c549 from RTW8852AE
 - Add support for Intel Magnetor

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: Prevent double register of suspend
      Bluetooth: Call shutdown for HCI_USER_CHANNEL

Archie Pusaka (1):
      Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt

Brian Gix (12):
      Bluetooth: Convert le_scan_disable timeout to hci_sync
      Bluetooth: Rework le_scan_restart for hci_sync
      Bluetooth: Delete unused hci_req_stop_discovery()
      Bluetooth: Convert SCO configure_datapath to hci_sync
      Bluetooth: Move Adv Instance timer to hci_sync
      Bluetooth: Delete unreferenced hci_request code
      Bluetooth: move hci_get_random_address() to hci_sync
      Bluetooth: convert hci_update_adv_data to hci_sync
      Bluetooth: Normalize HCI_OP_READ_ENC_KEY_SIZE cmdcmplt
      Bluetooth: Move hci_abort_conn to hci_conn.c
      Bluetooth: Implement support for Mesh
      Bluetooth: Add experimental wrapper for MGMT based mesh

Chris Lu (1):
      Bluetooth: btusb: Add a new PID/VID 13d3/3578 for MT7921

Daniel Golle (1):
      Bluetooth: btusb: Add a new VID/PID 0e8d/0608 for MT7921

Fae (1):
      Bluetooth: Add VID/PID 0489/e0e0 for MediaTek MT7921

Hans de Goede (1):
      Bluetooth: hci_event: Fix vendor (unknown) opcode status handling

Kiran K (2):
      Bluetooth: btintel: Add support for Magnetor
      Bluetooth: btintel: Mark Intel controller to support LE_STATES quirk

Larry Finger (1):
      Bluetooth: btusb: Add BT device 0cb8:c549 from RTW8852AE to tables

Luiz Augusto von Dentz (13):
      Bluetooth: hci_sync: Fix suspend performance regression
      Bluetooth: L2CAP: Fix build errors in some archs
      Bluetooth: MGMT: Fix Get Device Flags
      Bluetooth: ISO: Fix not handling shutdown condition
      Bluetooth: hci_sync: Fix hci_read_buffer_size_sync
      Bluetooth: Fix HCIGETDEVINFO regression
      Bluetooth: RFCOMM: Fix possible deadlock on socket shutdown/release
      Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
      Bluetooth: hci_debugfs: Fix not checking conn->debugfs
      Bluetooth: hci_event: Make sure ISO events don't affect non-ISO connections
      Bluetooth: hci_core: Fix not handling link timeouts propertly
      Bluetooth: L2CAP: Fix user-after-free
      Bluetooth: hci_sync: Fix not indicating power state

Max Chou (1):
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3592

Sean Wang (2):
      Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend
      Bluetooth: btusb: Add a new PID/VID 13d3/3583 for MT7921

Szabolcs Sipos (2):
      Bluetooth: btusb: RTL8761BUV consistent naming
      Bluetooth: btusb: Add RTL8761BUV device (Edimax BT-8500)

Tetsuo Handa (5):
      Bluetooth: hci_sync: fix double mgmt_pending_free() in remove_adv_monitor()
      Bluetooth: avoid hci_dev_test_and_set_flag() in mgmt_init_hdev()
      Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
      Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works
      Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure

Wolfram Sang (1):
      Bluetooth: move from strlcpy with unused retval to strscpy

Yihao Han (1):
      Bluetooth: MGMT: fix zalloc-simple.cocci warnings

Zhengping Jiang (2):
      Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn
      Bluetooth: hci_sync: allow advertise when scan without RPA

 drivers/bluetooth/btintel.c       |   20 +-
 drivers/bluetooth/btusb.c         |   38 +-
 drivers/bluetooth/hci_ldisc.c     |    7 +-
 drivers/bluetooth/hci_serdev.c    |   10 +-
 include/net/bluetooth/bluetooth.h |    1 +
 include/net/bluetooth/hci.h       |    4 +
 include/net/bluetooth/hci_core.h  |   17 +-
 include/net/bluetooth/hci_sock.h  |    2 -
 include/net/bluetooth/hci_sync.h  |    9 +-
 include/net/bluetooth/mgmt.h      |   52 ++
 net/bluetooth/hci_conn.c          |  162 +++-
 net/bluetooth/hci_core.c          |   68 +-
 net/bluetooth/hci_debugfs.c       |    2 +-
 net/bluetooth/hci_event.c         |  188 +++--
 net/bluetooth/hci_request.c       | 1650 ++++---------------------------------
 net/bluetooth/hci_request.h       |   53 --
 net/bluetooth/hci_sock.c          |    4 +-
 net/bluetooth/hci_sync.c          |  533 +++++++++++-
 net/bluetooth/hci_sysfs.c         |    3 +
 net/bluetooth/hidp/core.c         |    6 +-
 net/bluetooth/iso.c               |   35 +-
 net/bluetooth/l2cap_core.c        |   27 +-
 net/bluetooth/mgmt.c              |  682 +++++++++++++--
 net/bluetooth/mgmt_util.c         |   74 ++
 net/bluetooth/mgmt_util.h         |   18 +
 net/bluetooth/rfcomm/sock.c       |    3 +
 26 files changed, 1870 insertions(+), 1798 deletions(-)
