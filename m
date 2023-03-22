Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEEE6C5A4E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCVXZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjCVXZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:25:48 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EB81BEC;
        Wed, 22 Mar 2023 16:25:47 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id qh28so13206096qvb.7;
        Wed, 22 Mar 2023 16:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679527546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=514CEmmrey20BbSdy5jRIw8n1wj/BRirLWozPNOMpUo=;
        b=UBqaO9OEWOKRzrmwRhFTCMhWsSKgU9IUOg9aWZJXBTJ9zIDvWslrAugLurPr6Dpv9k
         AsL7gKWyhw8oZG5ZxFH8cydgsNBcsTuDT43quobMSAPYMGDsMFxWuwwpZSY+QGJRRK71
         JyGlV+d/T71DPmFs+1G9JRnTY1CSA3pGPTaB+0HtMertJM+7gFg078NVdxO8IWZzzlve
         1Cp04XLtjaiYxvKqb32FSvCXkZTJ6p7Z3cNtk7poaeW4KyHu4sIkqhAJawEA6vbsrZQG
         PWAwKg32b30sCiRYP41mVzwubLwXjQerHXcv/Eb7qz+h64F91KPUWfleX6Cp44HeIHUi
         qDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679527546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=514CEmmrey20BbSdy5jRIw8n1wj/BRirLWozPNOMpUo=;
        b=8BhwD4MOdfE/gKSMdaASMI/asv4kwf6Fl6rzmQ+xco1p/K6+tg0a51TszuAPxMRRqh
         WqlvNbv1eLIKDKy3tS6HJX8L4u81Rq6UXIT/uSeK4cbh+Xi01J62cy0Wxj283VtEBPvx
         GbLnrGXGrCE9sGBEWBNsI+HvgVABwaPPhGf3JtmjzMp4ldSRoKPetS9VTynnSYd/RvXU
         z5DWdk5t7FB8p+0myRJfNbwvhlnureLmuuI3TNgb+EFAWQVMH/Src1hjCZ1ZvjGN82xh
         3gXLWSNCv3cXiLAc3c0qdYveCGSNLZ1cfo1fZarHlbLWAlaN/zx3sLckJXxsA9qbQRNX
         pJIQ==
X-Gm-Message-State: AO0yUKVQibUj9EdsAnVAlBknFTybxpjx+PhX4m5YVi9JuHHDfUi/91sj
        uJbdZBZW8WRkiRBkF7usqKfSZIxnMIo=
X-Google-Smtp-Source: AK7set/MIlNF7z5CUuaFfZ4gn7pYffxcL5dCZArMV669cUpnZujFNEri42n/JjgqI43iP/EXRQ9GEw==
X-Received: by 2002:ad4:5d62:0:b0:5c8:ad0d:3b82 with SMTP id fn2-20020ad45d62000000b005c8ad0d3b82mr10528633qvb.29.1679527546267;
        Wed, 22 Mar 2023 16:25:46 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id d124-20020ae9ef82000000b007469587115dsm5284240qkg.19.2023.03.22.16.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 16:25:45 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull-request: bluetooth 2023-03-22
Date:   Wed, 22 Mar 2023 16:25:43 -0700
Message-Id: <20230322232543.3079578-1-luiz.dentz@gmail.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-03-22

for you to fetch changes up to 3c8c5eef8bfcd3ab012a295e5550312152315a0e:

  Bluetooth: HCI: Fix global-out-of-bounds (2023-03-22 16:05:56 -0700)

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
