Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47E35A1D57
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbiHYXqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiHYXqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:46:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0CABBA78;
        Thu, 25 Aug 2022 16:46:02 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso6775325pjj.4;
        Thu, 25 Aug 2022 16:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=1cZ0KNdJZbHkEaF8BRja8MmJEhhYj88L6EqS/Hy6vPQ=;
        b=AEolXUquh8s9hnRxq51QZGCwfR/8O3+HwNqDVXD77uol163+lGggr2G3ixcCxwSyB7
         oFVxo0PAh8YFLchcsS4p3yiq/qRKwaAiNSXgr7mRRrSs5y8r6CzZNEwaWGX7/EmgVHuz
         msajF/H9RWCw5lg0TvMM87uK3JY6dC0YImFLjyjjxqDRB/N4H9A5cxYkXkw4JtiTJul3
         hW8SCk4tzT+v3/DHEGQvarhWnX4W9GD2vPxeT1NM9XsaDow/U5iQP9c/Waa7KWZ/8gUj
         c98RWLiFcPo1dcQZQPHjG4oFq9gUMZk2VVb+54SJFUEiftXPN2Qp0PdteC4c6iYWPpdh
         9AhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=1cZ0KNdJZbHkEaF8BRja8MmJEhhYj88L6EqS/Hy6vPQ=;
        b=EPGyAvb0fqTX7w3xs9Gp6zaI1KnD7AQZ4qR4OJDGoxSfgLlWI4GV0S/1Qn7G+gEg61
         lut6pbVQ3K2p7SqRR8Wbrdqa76IEetqUeF2SZmFrdxY4kYyc8iooTxKPoLl8390YTW1T
         by0VhQ1G72pcH6TXgOqZQCq6DQ3UVSwl3w7fLyIARbMc5P6vh6Biumk5K+ZTA5BXu4tb
         A9GhVCnoCckSLH2rBddtFNA4SstKniasO3Ki+Oudh9Sf7M73R2dqzS2+fJ60rWhdM5QK
         bRMK/Z1JOXKWMu17tQabanKgkHDWcY5C1XQwNGMEJL8nuynXVbVYXaHp5Sr/+URK4tyJ
         Wu8A==
X-Gm-Message-State: ACgBeo121EsCN9uYHexBXJB2KzJ3JRRhxKKRmqeOjse8gBV0s30GETxh
        zZgy/2zPyw1gVS6iuBINXWq+78Z5Z8U=
X-Google-Smtp-Source: AA6agR6NJJBzjfT7aEZrUMuvh60JeXmjHVWBVI73OTtGQVT/FUYzwQx1lzotGpmkna6oBAuHExqG4w==
X-Received: by 2002:a17:902:e5c2:b0:172:f66b:c760 with SMTP id u2-20020a170902e5c200b00172f66bc760mr1354990plf.92.1661471162006;
        Thu, 25 Aug 2022 16:46:02 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id g187-20020a6252c4000000b0052dc5c14ee2sm193829pfb.194.2022.08.25.16.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:46:01 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-08-25
Date:   Thu, 25 Aug 2022 16:45:59 -0700
Message-Id: <20220825234559.1837409-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.2
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

The following changes since commit 4c612826bec1441214816827979b62f84a097e91:

  Merge tag 'net-6.0-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-08-25 14:03:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-08-25

for you to fetch changes up to 2da8eb834b775a9d1acea6214d3e4a78ac841e6e:

  Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn (2022-08-25 16:26:19 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix handling of duplicate connection handle
 - Fix handling of HCI vendor opcode
 - Fix suspend performance regression
 - Fix build errors
 - Fix not handling shutdown condition on ISO sockets
 - Fix double free issue

----------------------------------------------------------------
Archie Pusaka (1):
      Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt

Hans de Goede (1):
      Bluetooth: hci_event: Fix vendor (unknown) opcode status handling

Luiz Augusto von Dentz (4):
      Bluetooth: hci_sync: Fix suspend performance regression
      Bluetooth: L2CAP: Fix build errors in some archs
      Bluetooth: MGMT: Fix Get Device Flags
      Bluetooth: ISO: Fix not handling shutdown condition

Tetsuo Handa (1):
      Bluetooth: hci_sync: fix double mgmt_pending_free() in remove_adv_monitor()

Wolfram Sang (1):
      Bluetooth: move from strlcpy with unused retval to strscpy

Zhengping Jiang (1):
      Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn

 net/bluetooth/hci_event.c  | 13 ++++++++-
 net/bluetooth/hci_sync.c   | 30 +++++++++++--------
 net/bluetooth/hidp/core.c  |  6 ++--
 net/bluetooth/iso.c        | 35 +++++++++++++++-------
 net/bluetooth/l2cap_core.c | 10 +++----
 net/bluetooth/mgmt.c       | 72 +++++++++++++++++++++++++++-------------------
 6 files changed, 105 insertions(+), 61 deletions(-)
