Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1231A670EF3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjARAqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjARAq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:46:26 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFA33598;
        Tue, 17 Jan 2023 16:29:47 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i1so9876459pfk.3;
        Tue, 17 Jan 2023 16:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3jkeyT7CpVqcpEQLP9l8BS7No15dv4hWrLsEeuhavzI=;
        b=bfv4/DLeLcJQ9hickiSyNtCp4x3Sn4ouluXxPQtM5NNlak1jnk29M6TLL4nN9TQZN5
         FAcrpetCznua8pP/eQoZNqS7Ev7prittLXQI1ThPrFmvPKlQCcIWSJDKy7L0wr75PpkL
         sQZEmG9lYmdZA3glba2jmtsN67DjMb3qARPH4ZbHUSpi6QESrBaGSY2671HW4cXv/MTE
         YQkdrjv1MRmpGe/e/++e9oqRI0p0rhWLTm78Sl8Uzovw+UPlQTzjAD9iRnCvp+a2j829
         L1jxnvx3hF7NSl9TfvlgOVS50t7MtrjOBthCLWd8MHFlkPKqOt415gEAW37ZZbJWxGcc
         MfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jkeyT7CpVqcpEQLP9l8BS7No15dv4hWrLsEeuhavzI=;
        b=CPbUF+fGbmpyvPA+Vh656W3aKIMrpu/c3t7OKtJeYBczJGamhTtE4GRJ3kG+FhwIe6
         l7f7VBXhgQsrZS5F8cj3U0Jebzr4Xfp5lzquG0PCoxfGZvlesS0CHFoCzHXq8GT0ylnN
         GzVQIihrLK4dptZQVtj5Ex4azXnHftpNczI9QLBPsbSoUy/RYleyZPVnFQUt/B0gndvY
         z4NBgbieTEfLSGf+sPFEbUuBbz/zlkZNnFQkL4XVVft5aVrTHHFTIC2cOFYuzn2BTI5O
         /+Zh5EOWL2JrbXD8HWVQteyPHFudCBBRsN0kVzCeZU6KUmA4HxjIntiYGLVPHkCo64hD
         NALA==
X-Gm-Message-State: AFqh2ko8cDg3cpYUq8RE8A97r7U0OLUu0k2E1JIIlFQuokYwxkypLC7O
        gra7DXTsMLn5kXmMhIkbb6yItc+TDf4=
X-Google-Smtp-Source: AMrXdXu3k5P5SoqB1S0Rc8BFvyjxI8Y9OrVTpLdohORSbqHOeQ5P9FbBYPjREwzSfZxEMgoObMGgRg==
X-Received: by 2002:aa7:9003:0:b0:58b:bfd5:6811 with SMTP id m3-20020aa79003000000b0058bbfd56811mr4571062pfo.12.1674001786872;
        Tue, 17 Jan 2023 16:29:46 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id v3-20020a626103000000b0058ddd699b8asm772910pfb.130.2023.01.17.16.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 16:29:45 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull-request: bluetooth 2023-01-17
Date:   Tue, 17 Jan 2023 16:29:44 -0800
Message-Id: <20230118002944.1679845-1-luiz.dentz@gmail.com>
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

The following changes since commit 1f3bd64ad921f051254591fbed04fd30b306cde6:

  net: stmmac: fix invalid call to mdiobus_get_phy() (2023-01-17 13:33:19 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-01-17

for you to fetch changes up to 1d80d57ffcb55488f0ec0b77928d4f82d16b6a90:

  Bluetooth: Fix possible deadlock in rfcomm_sk_state_change (2023-01-17 15:59:02 -0800)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix a buffer overflow in mgmt_mesh_add
 - Fix use HCI_OP_LE_READ_BUFFER_SIZE_V2
 - Fix hci_qca shutdown on closed serdev
 - Fix possible circular locking dependencies on ISO code
 - Fix possible deadlock in rfcomm_sk_state_change

----------------------------------------------------------------
Harshit Mogalapalli (1):
      Bluetooth: Fix a buffer overflow in mgmt_mesh_add()

Krzysztof Kozlowski (1):
      Bluetooth: hci_qca: Fix driver shutdown on closed serdev

Luiz Augusto von Dentz (4):
      Bluetooth: hci_sync: Fix use HCI_OP_LE_READ_BUFFER_SIZE_V2
      Bluetooth: ISO: Fix possible circular locking dependency
      Bluetooth: hci_event: Fix Invalid wait context
      Bluetooth: ISO: Fix possible circular locking dependency

Ying Hsu (1):
      Bluetooth: Fix possible deadlock in rfcomm_sk_state_change

Zhengchao Shao (2):
      Bluetooth: hci_conn: Fix memory leaks
      Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()

 drivers/bluetooth/hci_qca.c |  7 +++++
 net/bluetooth/hci_conn.c    | 18 ++++++++++---
 net/bluetooth/hci_event.c   |  5 +++-
 net/bluetooth/hci_sync.c    | 19 +++++---------
 net/bluetooth/iso.c         | 64 ++++++++++++++++++---------------------------
 net/bluetooth/mgmt_util.h   |  2 +-
 net/bluetooth/rfcomm/sock.c |  7 ++++-
 7 files changed, 64 insertions(+), 58 deletions(-)
