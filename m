Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77543F2311
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbhHSWXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbhHSWXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 18:23:46 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673EFC061575;
        Thu, 19 Aug 2021 15:23:09 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a5so4807207plh.5;
        Thu, 19 Aug 2021 15:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G2jhdOu2ca6vjL9Bc8zir8YaOp90KJxiD9Z7YkrPKcA=;
        b=I5efwC4rwgdvW16+GSERDjCWU9rB5fLWPRkK2brL+L7DS9vFfvmc31iEfeTntFCTsX
         TD/N+QsRFRZpkI5P+vijXGsK8nRev+jbv5M4qQIQJgJLFZ/mTK2Ent1Wkdp8ws3tZrqf
         Ou4QvzP7DWGKzg9HGf4INH8m7k0u20V5eSdbOqscKt0YLX1FyikWJKPGFHuc85gKrXBp
         NB+nI/bmpCGc0ZwzHL9/L5h3g9SMpWklzDUloAfI6v5HmoaiHYiqHBmYd3c1DeNpzy56
         FpxCBkHkXZ8W/pwy7eChWKEWCfSCMxgHY3S1ePpApir6/keAUaKKvtqJw/H/0cRoaYiX
         aWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G2jhdOu2ca6vjL9Bc8zir8YaOp90KJxiD9Z7YkrPKcA=;
        b=gAJBWENo1vEeklF6nECDdZJe4GNS4NNO109qBwwyFq3EnOXn/OQTXhWkedSNrcKMPn
         1pFxIWXgj4Xodl+e9ifCuekD/fXPxXfLY4zDygxnX02DaLZawybOTtd/NZb4KBa2gAnE
         h4FNoZq/Tc9MhM8l0Wkw2e5HMXwJhZ2/67nD94s8u1jrauN0+EnoIF1xJ7kmRhY2lyLR
         RckWb24wDruKFRxhxtj55Pq61pmu3E1VJETzPy8S2S2UFBzr4T7MgLRZLKM0hWJMEPs1
         DyVAaD8SPgnJ3PCo9QV5A6vE68MmqV9V2EPxldvNbZTakJfuBrTqHW/MT1nEOIWBrnAs
         hmog==
X-Gm-Message-State: AOAM530xPjG25qvPombMMsgSMYXadOJCn0ba9XlIk+OiBs174+SrIoiP
        43BKxupBr9/rwCOIIn+jQh8=
X-Google-Smtp-Source: ABdhPJyxQisasRwuzw9WpWpJlRdSmJuuQBJQqIVw5MG3eC1LXHV4Kpl+NjTeBGd1yPDdY0TMpZO/Ng==
X-Received: by 2002:a17:90a:fa89:: with SMTP id cu9mr1017335pjb.5.1629411788765;
        Thu, 19 Aug 2021 15:23:08 -0700 (PDT)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id n18sm4678633pfu.3.2021.08.19.15.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:23:08 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-08-19
Date:   Thu, 19 Aug 2021 15:23:07 -0700
Message-Id: <20210819222307.242695-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 4431531c482a2c05126caaa9fcc5053a4a5c495b:

  nfp: fix return statement in nfp_net_parse_meta() (2021-07-22 05:46:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-08-19

for you to fetch changes up to 61969ef867d48fc76551fe50cefe0501e624766e:

  Bluetooth: Fix return value in hci_dev_do_close() (2021-08-19 17:28:40 +0200)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for Foxconn Mediatek Chip
 - Add support for LG LGSBWAC92/TWCM-K505D
 - hci_h5 flow control fixes and suspend support
 - Switch to use lock_sock for SCO and RFCOMM
 - Various fixes for extended advertising
 - Reword Intel's setup on btusb unifying the supported generations

----------------------------------------------------------------
Aaron Ma (1):
      Bluetooth: btusb: Add support for Foxconn Mediatek Chip

Andy Shevchenko (1):
      Bluetooth: hci_bcm: Fix kernel doc comments

Angus Ainslie (1):
      Bluetooth: btbcm: add patch ram for bluetooth

Archie Pusaka (4):
      Bluetooth: btrtl: Set MSFT opcode for RTL8852
      Bluetooth: hci_h5: add WAKEUP_DISABLE flag
      Bluetooth: hci_h5: btrtl: Maintain flow control if wakeup is enabled
      Bluetooth: hci_h5: Add runtime suspend

Chethan T N (1):
      Bluetooth: btusb: Enable MSFT extension for Intel next generation controllers

Colin Ian King (2):
      6lowpan: iphc: Fix an off-by-one check of array index
      Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Dan Carpenter (1):
      Bluetooth: sco: prevent information leak in sco_conn_defer_accept()

Desmond Cheong Zhi Xi (7):
      Bluetooth: skip invalid hci_sync_conn_complete_evt
      Bluetooth: schedule SCO timeouts with delayed_work
      Bluetooth: avoid circular locks in sco_sock_connect
      Bluetooth: switch to lock_sock in SCO
      Bluetooth: serialize calls to sco_sock_{set,clear}_timer
      Bluetooth: switch to lock_sock in RFCOMM
      Bluetooth: fix repeated calls to sco_sock_kill

Forest Crossman (1):
      Bluetooth: btusb: Add support for LG LGSBWAC92/TWCM-K505D

Hans de Goede (1):
      Bluetooth: hci_h5: Disable the hci_suspend_notifier for btrtl devices

Ian Mackinnon (1):
      Bluetooth: btusb: Load Broadcom firmware for Dell device 413c:8197

Ismael Ferreras Morezuelas (1):
      Bluetooth: btusb: Make the CSR clone chip force-suspend workaround more generic

Jun Miao (1):
      Bluetooth: btusb: Fix a unspported condition to set available debug features

Kai-Heng Feng (1):
      Bluetooth: Move shutdown callback before flushing tx and rx queue

Kangmin Park (1):
      Bluetooth: Fix return value in hci_dev_do_close()

Kees Cook (1):
      Bluetooth: mgmt: Pessimize compile-time bounds-check

Kiran K (1):
      Bluetooth: Fix race condition in handling NOP command

Larry Finger (1):
      Bluetooth: Add additional Bluetooth part for Realtek 8852AE

Len Baker (1):
      Bluetooth: btmrvl_sdio: Remove all strcpy() uses

Luiz Augusto von Dentz (4):
      Bluetooth: HCI: Add proper tracking for enable status of adv instances
      Bluetooth: Fix not generating RPA when required
      Bluetooth: Fix handling of LE Enhanced Connection Complete
      Bluetooth: Store advertising handle so it can be re-enabled

Max Chou (1):
      Bluetooth: btusb: Remove WAKEUP_DISABLE and add WAKEUP_AUTOSUSPEND for Realtek devices

Michael Sun (2):
      Bluetooth: btusb: Add valid le states quirk
      Bluetooth: btusb: Enable MSFT extension for WCN6855 controller

Pauli Virtanen (1):
      Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS

Pavel Skripkin (1):
      Bluetooth: add timeout sanity check to hci_inquiry

Randy Dunlap (1):
      Bluetooth: btrsi: use non-kernel-doc comment for copyright

Tedd Ho-Jeong An (13):
      Bluetooth: mgmt: Fix wrong opcode in the response for add_adv cmd
      Bluetooth: Add support hdev to allocate private data
      Bluetooth: btintel: Add combined setup and shutdown functions
      Bluetooth: btintel: Refactoring setup routine for legacy ROM sku
      Bluetooth: btintel: Add btintel data struct
      Bluetooth: btintel: Fix the first HCI command not work with ROM device
      Bluetooth: btintel: Fix the LED is not turning off immediately
      Bluetooth: btintel: Add combined set_diag functions
      Bluetooth: btintel: Refactoring setup routine for bootloader devices
      Bluetooth: btintel: Move hci quirks to setup routine
      Bluetooth: btintel: Clean the exported function to static
      Bluetooth: btintel: Fix the legacy bootloader returns tlv based version
      Bluetooth: btintel: Combine setting up MSFT extension

Tetsuo Handa (1):
      Bluetooth: defer cleanup of resources in hci_unregister_dev()

Wai Paulo Valerio Wang (1):
      Bluetooth: btusb: Add support for IMC Networks Mediatek Chip

mark-yw.chen (4):
      Bluetooth: btusb: Enable MSFT extension for Mediatek Chip (MT7921)
      Bluetooth: btusb: Record debug log for Mediatek Chip.
      Bluetooth: btusb: Support Bluetooth Reset for Mediatek Chip(MT7921)
      Bluetooth: btusb: Fix fall-through warnings

 drivers/bluetooth/btbcm.c        |    1 +
 drivers/bluetooth/btintel.c      | 1314 +++++++++++++++++++++++++++++++--
 drivers/bluetooth/btintel.h      |  119 ++-
 drivers/bluetooth/btmrvl_sdio.c  |   29 +-
 drivers/bluetooth/btrsi.c        |    2 +-
 drivers/bluetooth/btrtl.c        |   10 +-
 drivers/bluetooth/btusb.c        | 1510 ++++++++------------------------------
 drivers/bluetooth/hci_bcm.c      |    6 +
 drivers/bluetooth/hci_h5.c       |  116 ++-
 drivers/bluetooth/hci_serdev.c   |    3 +
 drivers/bluetooth/hci_uart.h     |    7 +-
 include/net/bluetooth/hci_core.h |   20 +-
 net/6lowpan/debugfs.c            |    3 +-
 net/bluetooth/cmtp/cmtp.h        |    2 +-
 net/bluetooth/hci_core.c         |   57 +-
 net/bluetooth/hci_event.c        |  223 ++++--
 net/bluetooth/hci_request.c      |   81 +-
 net/bluetooth/hci_sock.c         |   20 +-
 net/bluetooth/hci_sysfs.c        |    2 +-
 net/bluetooth/mgmt.c             |    4 +-
 net/bluetooth/rfcomm/sock.c      |    8 +-
 net/bluetooth/sco.c              |  106 +--
 22 files changed, 2088 insertions(+), 1555 deletions(-)
