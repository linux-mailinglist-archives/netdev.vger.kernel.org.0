Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CA94DE43F
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 23:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbiCRWtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 18:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiCRWtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 18:49:15 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D862CE10;
        Fri, 18 Mar 2022 15:47:55 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r2so6819165ilh.0;
        Fri, 18 Mar 2022 15:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MwzLzX6KYxlrwjE5LlzBAS8J3usPQiScv9cGK2HQv+Q=;
        b=l7nHDag6eEtyxrlAOeP5VLfRsmWREueSWvjhAU8hAWlvVgrixsGtogI4TjhYKsiuHv
         Gar+Ux33uRlIga8m4S2vK37IIGMUjV7i/Gdqis5m+ic977PGptA8PWssOavSpSXYfHGZ
         prVrjJ65gmZlGKyMQV8tBWmANnnRrw+VHmMEL3bPheaFTZIdkwzHSR5XgML0TU2ePRgz
         T/fRwuPXHzfQt0UtXNtNTR3OYDgouC+fvUmTqqSZnN7KxjMpUruPsYg6Lgr5DOX2aEg6
         2LSw1w01m6lCmn1kzn+3kLf8l6EBH/QPYp0xhoiKKTNdw+OiE0BdfF37lOrXXPYDFqFm
         i+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MwzLzX6KYxlrwjE5LlzBAS8J3usPQiScv9cGK2HQv+Q=;
        b=ebHX/fUyLKUWzy1vClidWSa0ueVCwwBO2TkT3M3GqdVicYvO16g0dklwuH9vjE5oVL
         lLzUGtIwShAfVH9eUgHdWog1XkPqOJX19LKst1X7yH2GM+i8Dym9yzHV6ZHiaDp18Kg6
         YG/eT3IKuaP5po+8qfa30lhb22ltTcf4mj1qk/rGkMdsvLIpiuaW2VN6ajPT2dDSLeUo
         AlRAiWfuySKyOpLO9iBnQ7QWfwdmCcPrD3In247uXdke3iAvHRBuBsrSBaSWqGQfWsrm
         R8+6r+ujAmYSu609brj2gJF/1wpLgkkFq6kqrkPzeplYYb2DV/8+bByWNzcwrMrRN/r5
         xU0A==
X-Gm-Message-State: AOAM532s6drdBtl0Vm1LsZEtlxqi3HIQrNTL6e3aCDunvKorfIh/ZrCd
        /jcnbs7PzEAxFtk2+KQ4Kk0=
X-Google-Smtp-Source: ABdhPJwratCEHFusl/rPOXwf/sPpJhspjD7rtVYdKIwJUU6ZNjEx2va91WP0Pg5WkVlFMOdaF0DWjw==
X-Received: by 2002:a05:6e02:881:b0:2c5:b12f:8ee0 with SMTP id z1-20020a056e02088100b002c5b12f8ee0mr4884437ils.277.1647643674575;
        Fri, 18 Mar 2022 15:47:54 -0700 (PDT)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id k15-20020a92c24f000000b002c79ec214f9sm6059464ilo.30.2022.03.18.15.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 15:47:54 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2022-03-18
Date:   Fri, 18 Mar 2022 15:47:52 -0700
Message-Id: <20220318224752.1477292-1-luiz.dentz@gmail.com>
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

The following changes since commit e89600ebeeb14d18c0b062837a84196f72542830:

  af_vsock: SOCK_SEQPACKET broken buffer test (2022-03-18 15:13:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-03-18

for you to fetch changes up to 726c0eb7cb15be3e5fe9a9f1c8aad12c5cbe4675:

  Bluetooth: ath3k: remove superfluous header files (2022-03-18 17:12:09 +0100)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for Asus TF103C
 - Add support for Realtek RTL8852B
 - Add support for Realtek RTL8723BE
 - Add WBS support to mt7921s

----------------------------------------------------------------
Christophe JAILLET (1):
      Bluetooth: Don't assign twice the same value

Colin Ian King (1):
      Bluetooth: mgmt: remove redundant assignment to variable cur_len

Dan Carpenter (1):
      Bluetooth: btmtkuart: fix error handling in mtk_hci_wmt_sync()

Gavin Li (1):
      Bluetooth: fix incorrect nonblock bitmask in bt_sock_wait_ready()

Hans de Goede (1):
      Bluetooth: hci_bcm: Add the Asus TF103C to the bcm_broken_irq_dmi_table

Ismael Ferreras Morezuelas (2):
      Bluetooth: hci_sync: Add a new quirk to skip HCI_FLT_CLEAR_ALL
      Bluetooth: btusb: Use quirk to skip HCI_FLT_CLEAR_ALL on fake CSR controllers

Luiz Augusto von Dentz (1):
      Bluetooth: Fix use after free in hci_send_acl

Manish Mandlik (2):
      Bluetooth: msft: Clear tracked devices on resume
      Bluetooth: Send AdvMonitor Dev Found for all matched devices

Max Chou (1):
      Bluetooth: btrtl: Add support for RTL8852B

Mianhan Liu (2):
      Bluetooth: bcm203x: remove superfluous header files
      Bluetooth: ath3k: remove superfluous header files

Niels Dossche (1):
      Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed

Pavel Skripkin (1):
      Bluetooth: hci_uart: add missing NULL check in h5_enqueue

Sean Wang (3):
      Bluetooth: btmtkuart: rely on BT_MTK module
      Bluetooth: btmtkuart: add .set_bdaddr support
      Bluetooth: btmtkuart: fix the conflict between mtk and msft vendor event

Takashi Iwai (1):
      Bluetooth: btusb: Add missing Chicony device for Realtek RTL8723BE

Yake Yang (5):
      Bluetooth: btmtksdio: Fix kernel oops in btmtksdio_interrupt
      Bluetooth: mt7921s: Set HCI_QUIRK_VALID_LE_STATES
      Bluetooth: mt7921s: Add .get_data_path_id
      Bluetooth: mt7921s: Add .btmtk_get_codec_config_data
      Bluetooth: mt7921s: Add WBS support

 drivers/bluetooth/Kconfig         |   1 +
 drivers/bluetooth/ath3k.c         |   1 -
 drivers/bluetooth/bcm203x.c       |   1 -
 drivers/bluetooth/btmtk.c         |   1 +
 drivers/bluetooth/btmtk.h         |   1 +
 drivers/bluetooth/btmtksdio.c     |  75 ++++++++++++++-
 drivers/bluetooth/btmtkuart.c     | 198 ++++++--------------------------------
 drivers/bluetooth/btrtl.c         |  13 +++
 drivers/bluetooth/btusb.c         |   7 +-
 drivers/bluetooth/hci_bcm.c       |  44 +++++++--
 drivers/bluetooth/hci_h5.c        |   8 +-
 include/net/bluetooth/bluetooth.h |   2 +-
 include/net/bluetooth/hci.h       |  10 ++
 net/bluetooth/af_bluetooth.c      |   4 +-
 net/bluetooth/hci_conn.c          |   2 +
 net/bluetooth/hci_event.c         |   3 +-
 net/bluetooth/hci_sync.c          |  16 +++
 net/bluetooth/l2cap_core.c        |   1 -
 net/bluetooth/mgmt.c              |  72 +++++++-------
 net/bluetooth/msft.c              |  19 +++-
 20 files changed, 251 insertions(+), 228 deletions(-)
