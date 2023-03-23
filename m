Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48066C719F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCWUXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCWUXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:23:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3FA1E9F1;
        Thu, 23 Mar 2023 13:23:38 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so3276246pjb.0;
        Thu, 23 Mar 2023 13:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679603017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4subVKgPXkKfzo/vmEBk9Q9vczgkdwx4inemRKlfvp4=;
        b=jmhMp73fB3C5vPmHUFJe1aAgbVDQvPER+I5RbVKE1PtK6yhA6SNTIjeS4aehdWDM6/
         nV8Ro0WHYLrdpamYWD9wWQUISL9PtjoS/AwOxaGPFmHODOv/hAzbbDGZk/sU767pUoGL
         D4MteYqnYz2BjaYnO6F/matRJhshitB14YGGI1i9Dm03IEqoa0cuZ76aHO8J3eFxTl9L
         oWaJumeoAIzj62Qb2IQGqUN0t+tsFJ6a/12wl1kbuehhbGK8lAq7kUPCncXIAbETZCzO
         ctsWCTQH5bH4b7F752bAP84N0rC64wguqkWPbxegBpRcu8aHQqoKxY2D0a34cp6fZ3dE
         giNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679603017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4subVKgPXkKfzo/vmEBk9Q9vczgkdwx4inemRKlfvp4=;
        b=fPGexKfoypUntBlP+r5p4azg2ZCuGSnH5PrYlGOP6oZp308IBzS+TMgIhzBFiJt9ai
         ivZXATCILVNDppuC8tXXeYy6tF0MD0//e30QupakQw9TObjFAxBFA5woCekyLbHzRazM
         cvRyXXd3Iwr2x82ATYY1WckhjwOBBHH2YiqhbiiepfdMkxs5MsaU7KguV8T6G/gDOKkJ
         Q1uiMfctyF4ZTahyOiO78wSukCft2pYy3+2Sp1+37Ed/IWHNrksmzBHwKaA+cQ3Obljk
         3EEyqOcvYeDzjIrSfGqb8ySEc+sDMdmijv0hB3W2fY74RNO6mTzfsWrf4ksvkgDeud6w
         0Qfw==
X-Gm-Message-State: AO0yUKV5vGrnxyEHITcheAW9e7FLKFHzWVBS0U5/JggdFzfxT8GnfeMf
        1dP7/P/m9wNMCMBv63aSQNyMj1OiGmo=
X-Google-Smtp-Source: AK7set8Opev8Ne0BBATRKDzR22cX3a1vtfg16iJ0HIGKjwFMIO3e2psoGkoZGHgmlZdnSj3Gi6kROA==
X-Received: by 2002:a05:6a20:c426:b0:d5:e640:15ec with SMTP id en38-20020a056a20c42600b000d5e64015ecmr596515pzb.29.1679603017292;
        Thu, 23 Mar 2023 13:23:37 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79185000000b0062612b97cfdsm12315581pfa.123.2023.03.23.13.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 13:23:36 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull-request: bluetooth 2023-03-23
Date:   Thu, 23 Mar 2023 13:23:35 -0700
Message-Id: <20230323202335.3380841-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit bb765a743377d46d8da8e7f7e5128022504741b9:

  mlxsw: spectrum_fid: Fix incorrect local port type (2023-03-22 15:50:32 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-03-23

for you to fetch changes up to bce56405201111807cc8e4f47c6de3e10b17c1ac:

  Bluetooth: HCI: Fix global-out-of-bounds (2023-03-23 13:09:38 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix MGMT add advmon with RSSI command
 - L2CAP: Fix responding with wrong PDU type
 - Fix race condition in hci_cmd_sync_clear
 - ISO: Fix timestamped HCI ISO data packet parsing
 - HCI: Fix global-out-of-bounds
 - hci_sync: Resume adv with no RPA when active scan

----------------------------------------------------------------
Brian Gix (1):
      Bluetooth: Remove "Power-on" check from Mesh feature

Howard Chung (1):
      Bluetooth: mgmt: Fix MGMT add advmon with RSSI command

Kiran K (2):
      Bluetooth: btintel: Iterate only bluetooth device ACPI entries
      Bluetooth: btinel: Check ACPI handle for NULL before accessing

Luiz Augusto von Dentz (3):
      Bluetooth: hci_core: Detect if an ACL packet is in fact an ISO packet
      Bluetooth: btusb: Remove detection of ISO packets over bulk
      Bluetooth: L2CAP: Fix responding with wrong PDU type

Min Li (1):
      Bluetooth: Fix race condition in hci_cmd_sync_clear

Pauli Virtanen (1):
      Bluetooth: ISO: fix timestamped HCI ISO data packet parsing

Stephan Gerhold (1):
      Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Sungwoo Kim (1):
      Bluetooth: HCI: Fix global-out-of-bounds

Zheng Wang (1):
      Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

Zhengping Jiang (1):
      Bluetooth: hci_sync: Resume adv with no RPA when active scan

 drivers/bluetooth/btintel.c      |  51 +++++++++++------
 drivers/bluetooth/btintel.h      |   7 ---
 drivers/bluetooth/btqcomsmd.c    |  17 +++++-
 drivers/bluetooth/btsdio.c       |   1 +
 drivers/bluetooth/btusb.c        |  10 ----
 include/net/bluetooth/hci_core.h |   1 +
 net/bluetooth/hci_core.c         |  23 ++++++--
 net/bluetooth/hci_sync.c         |  68 ++++++++++++++++-------
 net/bluetooth/iso.c              |   9 ++-
 net/bluetooth/l2cap_core.c       | 117 ++++++++++++++++++++++++++-------------
 net/bluetooth/mgmt.c             |   9 +--
 11 files changed, 206 insertions(+), 107 deletions(-)
