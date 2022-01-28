Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4164A0274
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351467AbiA1U7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351182AbiA1U7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 15:59:18 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254E2C061748;
        Fri, 28 Jan 2022 12:59:18 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id s18so9273230ioa.12;
        Fri, 28 Jan 2022 12:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiYhvzujcBaaFivtmfz1XJPI+uesSMM4OAxFSBu7qf0=;
        b=CzMKM9msHbn+zCcZRGASucPl2B94QbYFkJHsdKPAu0VaqBGG6MXFYwygwv8nHY08sg
         r2ao5LArwp60/FIlcey5RdKyistmQbZAbApy7iCq8TwlY2PRPczQAWpoM6ypvCnrmree
         Lgo8/2RymR8GVwVdcJX7Y7H2f3ut1fYlsRaykL1F0ZDvhNl54MivO/UVMR4w3BoEwKOh
         6eOpLBsZ/vBH+Gl5pH6f8hj35/CY1F7OQbWEYE4irvnC08JyuVcualqozWq66YxGfwuF
         M1TUQlpAOZXVJid9b84Ai0g7t2E1F5KF+4DXRPUZTsrIM947iD8mPt6I0XrC6GkNajFD
         AuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiYhvzujcBaaFivtmfz1XJPI+uesSMM4OAxFSBu7qf0=;
        b=Q1wgbS5nE5SJcUrc/bBVlzfb8XivZ/UN53LJQzT4mlCYANevXkPW8qkARQJ7MNRpmE
         hU+x63WuAToxOBEJSxJTNmy5NCmUqQ5KB05tkgprwERR5pHFdCUuSddRX5puh0xGoSF9
         L2gi0THVZEULNfQgZWDGw/4YcI5qIWoQ7vQ53cRGzEdT6NYIQ6q3sJnekd/INy51QOBY
         JvXBj6AnlfypHP77DSasTKqSzecEemT/7LL6EdlRqnkwvyaHJ4YkILIhHrj5FltdBUMZ
         ztfFhFwq8uDEwASVlFYXRt2/VR+W8Q0hjBmbtfzYV9fPmf2EW5lebPs1r1GsHLwATFLR
         xGow==
X-Gm-Message-State: AOAM530x2j6k/I8psOnKdX7BqieeHEV0bL5w4Mc5ik1Jo45shwyZULWG
        XfBZ045y/92p/4RsU8V6ZzJ4YMFSRL5/0w==
X-Google-Smtp-Source: ABdhPJwpuKSbLTfML0GIASkagW2fo/rcR98ZBz/8tB0c4JaR++RD2PQ+6GLkYjnJWhuzggKWs23frg==
X-Received: by 2002:a02:84ef:: with SMTP id f102mr5666240jai.25.1643403557340;
        Fri, 28 Jan 2022 12:59:17 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id m1sm15198187ilu.87.2022.01.28.12.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:59:16 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-01-28
Date:   Fri, 28 Jan 2022 12:59:15 -0800
Message-Id: <20220128205915.3995760-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 8aaaf2f3af2ae212428f4db1af34214225f5cec3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-09 17:00:17 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-01-28

for you to fetch changes up to 91cb4c19118a19470a9d7d6dbdf64763bbbadcde:

  Bluetooth: Increment management interface revision (2022-01-27 12:35:13 -0800)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for RTL8822C hci_ver 0x08
 - Add support for RTL8852AE part 0bda:2852
 - Fix WBS setting for Intel legacy ROM products
 - Enable SCO over I2S ib mt7921s
 - Increment management interface revision

----------------------------------------------------------------
Dan Carpenter (1):
      Bluetooth: hci_sync: unlock on error in hci_inquiry_result_with_rssi_evt()

Ismael Ferreras Morezuelas (1):
      Bluetooth: btusb: Whitespace fixes for btusb_setup_csr()

Larry Finger (1):
      Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Luiz Augusto von Dentz (4):
      Bluetooth: hci_sync: Fix compilation warning
      Bluetooth: hci_core: Rate limit the logging of invalid SCO handle
      Bluetooth: hci_event: Fix HCI_EV_VENDOR max_len
      Bluetooth: hci_sync: Fix queuing commands when HCI_UNREGISTER is set

Manish Mandlik (2):
      Bluetooth: msft: Handle MSFT Monitor Device Event
      Bluetooth: mgmt: Add MGMT Adv Monitor Device Found/Lost events

Marcel Holtmann (1):
      Bluetooth: Increment management interface revision

Mark Chen (6):
      Bluetooth: mt7921s: Support wake on bluetooth
      Bluetooth: mt7921s: Enable SCO over I2S
      Bluetooth: mt7921s: fix firmware coredump retrieve
      Bluetooth: btmtksdio: refactor btmtksdio_runtime_[suspend|resume]()
      Bluetooth: mt7921s: fix bus hang with wrong privilege
      Bluetooth: mt7921s: fix btmtksdio_[drv|fw]_pmctrl()

Pavel Skripkin (1):
      Bluetooth: hci_serdev: call init_rwsem() before p->open()

Sean Wang (6):
      Bluetooth: btmtksdio: rename btsdio_mtk_reg_read
      Bluetooth: btmtksdio: move struct reg_read_cmd to common file
      Bluetooth: btmtksdio: clean up inconsistent error message in btmtksdio_mtk_reg_read
      Bluetooth: btmtksdio: lower log level in btmtksdio_runtime_[resume|suspend]()
      Bluetooth: btmtksdio: run sleep mode by default
      Bluetooth: btmtksdio: mask out interrupt status

Soenke Huster (3):
      Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
      Bluetooth: msft: fix null pointer deref on msft_monitor_device_evt
      Bluetooth: hci_event: Ignore multiple conn complete events

Tedd Ho-Jeong An (2):
      Bluetooth: btintel: Fix WBS setting for Intel legacy ROM products
      Bluetooth: Remove kernel-doc style comment block

Vyacheslav Bocharov (2):
      Bluetooth: btrtl: Add support for RTL8822C hci_ver 0x08
      Bluetooth: hci_h5: Add power reset via gpio in h5_btrtl_open

 drivers/bluetooth/btintel.c        |  11 +-
 drivers/bluetooth/btintel.h        |   1 +
 drivers/bluetooth/btmrvl_debugfs.c |   2 +-
 drivers/bluetooth/btmrvl_sdio.c    |   2 +-
 drivers/bluetooth/btmtk.h          |  35 +++++
 drivers/bluetooth/btmtksdio.c      | 276 +++++++++++++++++++++++++++++--------
 drivers/bluetooth/btrtl.c          |   8 ++
 drivers/bluetooth/btusb.c          |  14 +-
 drivers/bluetooth/hci_h5.c         |   5 +
 drivers/bluetooth/hci_ll.c         |   2 +-
 drivers/bluetooth/hci_serdev.c     |   3 +-
 include/net/bluetooth/hci_core.h   |  17 +++
 include/net/bluetooth/mgmt.h       |  16 +++
 net/bluetooth/hci_conn.c           |   1 +
 net/bluetooth/hci_core.c           |   5 +-
 net/bluetooth/hci_event.c          |  89 +++++++++---
 net/bluetooth/hci_sync.c           |   7 +-
 net/bluetooth/mgmt.c               | 117 +++++++++++++++-
 net/bluetooth/msft.c               | 170 +++++++++++++++++++++--
 19 files changed, 676 insertions(+), 105 deletions(-)
