Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8B96DB43D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 21:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjDGTcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 15:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjDGTcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 15:32:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B13EC7;
        Fri,  7 Apr 2023 12:32:04 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x3so11562315iov.3;
        Fri, 07 Apr 2023 12:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680895923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uCcpAAc7Lo1mI2as7Sj3tUk2xdIlzgPobTEnp8UpVZg=;
        b=g7V1FaIVtcNZmr4tth/JGLmuBoQ4Rg1WKnwCqscVxF1UHj2NQU7iFgYaYf58x7cGSS
         QpyWTXiaLAV0WRCndEklRFFKUbdm+ktnzwaSJsGuFxvgaNKIJ3h+d1SUqL4jSSA+vmPW
         QSDsgFSq4dcmVnNPnmJMZme52G/0QH0p7Ukotj3xfuGvOLrwyMnr337EDMkYR7zkA7Tw
         r/5VbCqHJJeQz1I7ZEYiDwZcpLIuaWidWLta7eP/Mj4WauyZp8z8obzHcfiuH9elrRwG
         9UoRWZmvFjq/KSZrmGaAij0XjGaLAsDw96ZQBg9ITaLr65vnCCuiOgZOEr7/43f9y3If
         HYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680895923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uCcpAAc7Lo1mI2as7Sj3tUk2xdIlzgPobTEnp8UpVZg=;
        b=0YDFtnf3kcHsgUyvuON8x0f8j7tPIuApkVA9aHo6HPOgI8xzQ8+Mw/PjouMuvu1Qoi
         yIMQFPqjeG5mmrDFWOIWCbZ4A/qrUJy51t5CHwrC0PJfZ61yKR9iiLgL1jU2lO6BWvES
         ETirc2kkj8JAX73PiEIY+eF5kH92QyWZxr2LPNRGqdA+EqJXmnmyYC+Msy6MNkQ/lP/9
         9qJZUWTgWWxa5vr7FFUJtxp52VIOp16ZgtwPNnWfmE5oXmqabqWGjrd+EV3AmOGgAwbW
         tADkLbl8EiUB5nrqOuI+7d8SwsmBekXHubujK3JGTYlQrmnFOS7FCovyrdHJ6h8eJi5E
         PIeQ==
X-Gm-Message-State: AAQBX9cmt6AvVoFxxdwzluwdGvvJA3Rzu3OMvkGcDsKaXSdSC1X1l5l8
        p5ZDQdbee9bbohZpiOYhU9nxq3Eskyc=
X-Google-Smtp-Source: AKy350YO8Uwfk0enNGSpx4GswyPgZ0sHshw/BvHGwennhvrKnJAJLeFMaRena7Ehu4XpUWVXdjkdGQ==
X-Received: by 2002:a05:6602:2e05:b0:759:410c:99b6 with SMTP id o5-20020a0566022e0500b00759410c99b6mr8973737iow.2.1680895923639;
        Fri, 07 Apr 2023 12:32:03 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id cn6-20020a0566383a0600b0040b4b0128d4sm113924jab.153.2023.04.07.12.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 12:32:02 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull-request: bluetooth 2023-04-07
Date:   Fri,  7 Apr 2023 12:32:01 -0700
Message-Id: <20230407193201.3430140-1-luiz.dentz@gmail.com>
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

The following changes since commit b9881d9a761a7e078c394ff8e30e1659d74f898f:

  Merge branch 'bonding-ns-validation-fixes' (2023-04-07 08:47:20 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-04-07

for you to fetch changes up to 501455403627300b45e33d41e0730f862618449b:

  Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp} (2023-04-07 12:18:09 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix not setting Dath Path for broadcast sink
 - Fix not cleaning up on LE Connection failure
 - SCO: Fix possible circular locking dependency
 - L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}
 - Fix race condition in hidp_session_thread
 - btbcm: Fix logic error in forming the board name
 - btbcm: Fix use after free in btsdio_remove

----------------------------------------------------------------
Claudia Draghicescu (1):
      Bluetooth: Set ISO Data Path on broadcast sink

Luiz Augusto von Dentz (6):
      Bluetooth: hci_conn: Fix not cleaning up on LE Connection failure
      Bluetooth: Fix printing errors if LE Connection times out
      Bluetooth: SCO: Fix possible circular locking dependency on sco_connect_cfm
      Bluetooth: SCO: Fix possible circular locking dependency sco_sock_getsockopt
      Bluetooth: hci_conn: Fix possible UAF
      Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Min Li (1):
      Bluetooth: Fix race condition in hidp_session_thread

Sasha Finkelstein (1):
      bluetooth: btbcm: Fix logic error in forming the board name.

Zheng Wang (1):
      Bluetooth: btsdio: fix use after free bug in btsdio_remove due to race condition

 drivers/bluetooth/btbcm.c        |  2 +-
 drivers/bluetooth/btsdio.c       |  1 +
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_conn.c         | 61 ++++++++++++++++++----------
 net/bluetooth/hci_event.c        | 18 ++++-----
 net/bluetooth/hci_sync.c         | 13 ++++--
 net/bluetooth/hidp/core.c        |  2 +-
 net/bluetooth/l2cap_core.c       | 24 +++---------
 net/bluetooth/sco.c              | 85 +++++++++++++++++++++++-----------------
 9 files changed, 116 insertions(+), 91 deletions(-)
