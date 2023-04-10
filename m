Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41466DC9FC
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 19:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjDJR1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 13:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDJR1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 13:27:22 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01862116;
        Mon, 10 Apr 2023 10:27:21 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id q8so11413002ilo.1;
        Mon, 10 Apr 2023 10:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681147641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XKQ6ReevTt40Ptj72kGc+kL2uvJcKHgSOVWQGBjPVDA=;
        b=er9Kg2XJhpbind9LQX4e7F89kEQKqPEJG5/8+fDdo4lj8IGzO1jFV3GY8H+jgz+Snz
         vNSwJG56CNJcffKc/TptuVJ+VmE3lRMTlf599q+PbuvqCi6MUj+cvJx8GXrpJ/O5eCRJ
         p1CQ/aJgKDZakuPuIXNxjQtdsoe7EFmkFCxPnDQY8lKkH0CHDz7hzc4ve5m896+Mie8w
         isXc8Y3GX/jjIN5be7/vI05dpAzZOtQBHHC7lnVXG6gnsqe0pGgvRxbKp8gQ/M1SzNDk
         eJS44cGGymlQT/9L05MzAohiXa0mOyjBh7b/SpNwvvXWvQvh/JHoenmvlad0gL/wBWK4
         NVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681147641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XKQ6ReevTt40Ptj72kGc+kL2uvJcKHgSOVWQGBjPVDA=;
        b=ixZ+qLWCW4v7ZtLc0AFjPkBIgFuqXaxomdaY+1xP57uTfefMWO8zIfvPmyMeIJ+ZyS
         Kg1/zEjxu5riFo8OzhF5HjuWawTHZzl8Nb7iHAxKXTr3HLH9VMjBq35GfinmQtfKFec8
         mGxQQTR4iFbbOMsFlWzDWOEed+10yX1QWaA7wM0RN5k4IyIOBRfp1T1TT98kDS+s3pJx
         LOjCfZ7tTRQyi9XxtR8MpyzyXb4QO+X3Y9XyLv4xSWG9Y+x6sLQyLqzfsc3Vk47y3pYS
         wnrhv4bsSQxenD8XPSCZ895qPV5y0dYYeDxp9eBSO6M1NUnMu6uju1F87U4rBVQt0hSW
         HI2Q==
X-Gm-Message-State: AAQBX9f4FNP21szEyDVtWHxXEXHRmn1nfk4/iUFjEiv9Ivcb0/WDywWd
        JAG96cX8SVZTi3D0KxR7N195KltCnw0=
X-Google-Smtp-Source: AKy350bhwHgi/c8hl3JlwD6f1hYZ2F5l2fuhXlNL5eZ1faNRXRsLhasVRMkfhh7ys/pVnAGPlPEW7A==
X-Received: by 2002:a92:d409:0:b0:323:1394:a48 with SMTP id q9-20020a92d409000000b0032313940a48mr7735353ilm.5.1681147641170;
        Mon, 10 Apr 2023 10:27:21 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id z63-20020a0293c5000000b003e80d0843e4sm3341016jah.78.2023.04.10.10.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 10:27:20 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull-request: bluetooth 2023-04-10
Date:   Mon, 10 Apr 2023 10:27:18 -0700
Message-Id: <20230410172718.4067798-1-luiz.dentz@gmail.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-04-10

for you to fetch changes up to a2a9339e1c9deb7e1e079e12e27a0265aea8421a:

  Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp} (2023-04-10 10:24:32 -0700)

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
 net/bluetooth/hci_conn.c         | 89 ++++++++++++++++++++++++----------------
 net/bluetooth/hci_event.c        | 18 ++++----
 net/bluetooth/hci_sync.c         | 13 ++++--
 net/bluetooth/hidp/core.c        |  2 +-
 net/bluetooth/l2cap_core.c       | 24 +++--------
 net/bluetooth/sco.c              | 85 ++++++++++++++++++++++----------------
 9 files changed, 129 insertions(+), 106 deletions(-)
