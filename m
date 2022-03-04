Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD1D4CDDFD
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiCDUSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiCDURm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:17:42 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B6CC8F82;
        Fri,  4 Mar 2022 12:14:17 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id 195so10849540iou.0;
        Fri, 04 Mar 2022 12:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3HzqQP1KC7y7MVdIYLOONNXlQIe0kZIuhD7eE/pgTM=;
        b=kgGd9pMRtCj6/JHxEDcKGFQ0tuYTYldJVrrfutWg3nVXkn51yxiqgRN/xHbH45h09p
         JeiBXGCcuRm4H9ZlkmxsfvxnNEgEgyn9zsl8uZ6egstmLdWFObrfSx6bLQbGQolYAuOy
         msOCk5IrS+XGgk6AN677Tfwd1ur+bBAx6VJey195AbZLp3DHgEV57m0jx2Yu5TvBkn+H
         Xe8iDI9ssOomS4pGxaE+64oVh9GUzgwLPUjiQ7r7GPGhn4EyV9wY2wT4MrWWvy274i4Y
         GI7WqRb7sD9JQCRWgQdIsuP+rlH5IQnSYmoPFLBmz+tH+X8eVkKfppVecxsS2iQEfKaK
         Lhig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3HzqQP1KC7y7MVdIYLOONNXlQIe0kZIuhD7eE/pgTM=;
        b=AzG54a2uTJKC0hRGAuq5vqUaABu6fpjkkomj5K/XTTVfECnIhACgS0tTwhmDHv3JqB
         a7SBSu++JOvbkF+rqE3Kw+B0zXYInrrrXGmVjkT186srQ8CFwiuC+4WfWBwUZcqAEhwR
         rR6bxMnYtSgTn3Ef5r749EwgUDl8vjOqTDVYKu106QelqAOPvEuvN6oKWVV1UubIAENT
         vvzlQ2qTu4kAAzhqPDuNmwhTri8LGwbANZQXqjz0urU1P4d666+1AUmgRa1oGJeQDjAN
         0JzGPVBqDuzGrADsFBGsdmOH7dVYG277+qSt+/LMjXQJGhXilSu6r281PrXrqPZcIPwL
         L/iw==
X-Gm-Message-State: AOAM533oylzCNa3VZDw6kDJ+/7FEaLuCdJxR3zr0a3y69InlqzJK0eWS
        xmSGiEChBADswO8SvJjpgEviHka6WjI=
X-Google-Smtp-Source: ABdhPJxAPBJQuPy9+BtOUh7FGRm150+QGtm6IiLk//Fi//I4qmvJWVobehU4IrWjgFBahNYtxLTBbw==
X-Received: by 2002:a02:c6b4:0:b0:315:3d31:b6e5 with SMTP id o20-20020a02c6b4000000b003153d31b6e5mr131354jan.44.1646422760750;
        Fri, 04 Mar 2022 11:39:20 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id g4-20020a92cda4000000b002c24724f23csm6334863ild.13.2022.03.04.11.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 11:39:20 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2022-03-04
Date:   Fri,  4 Mar 2022 11:39:19 -0800
Message-Id: <20220304193919.649815-1-luiz.dentz@gmail.com>
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

The following changes since commit 1039135aedfc5021b4827eb87276d7b4272024ac:

  net: ethernet: sun: Remove redundant code (2022-03-04 13:07:54 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-03-04

for you to fetch changes up to 6dfbe29f45fb0bde29213dbd754a79e8bfc6ecef:

  Bluetooth: btusb: Add another Realtek 8761BU (2022-03-04 16:58:13 +0100)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add new PID/VID (0x13d3/0x3567) for MT7921
 - Add new PID/VID (0x2550/0x8761) for Realtek 8761BU
 - Add support for LG LGSBWAC02 (MT7663BUN)
 - Add support for BCM43430A0 and BCM43430A1
 - Add support for Intel Madison Peak (MsP2)

----------------------------------------------------------------
Changcheng Deng (1):
      Bluetooth: mgmt: Replace zero-length array with flexible-array member

Chih-Ying Chiang (1):
      Bluetooth: mt7921s: support bluetooth reset mechanism

Christophe JAILLET (1):
      Bluetooth: 6lowpan: No need to clear memory twice

Colin Ian King (1):
      Bluetooth: make array bt_uuid_any static const

Helmut Grohne (1):
      Bluetooth: btusb: Add another Realtek 8761BU

Kiran K (1):
      Bluetooth: btusb: Add support for Intel Madison Peak (MsP2) device

Luca Weiss (1):
      Bluetooth: hci_bcm: add BCM43430A0 & BCM43430A1

Luiz Augusto von Dentz (2):
      Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}
      Bluetooth: btusb: Make use of of BIT macro to declare flags

Minghao Chi (1):
      Bluetooth: mgmt: Remove unneeded variable

Minghao Chi (CGEL ZTE) (1):
      Bluetooth: use memset avoid memory leaks

Niels Dossche (2):
      Bluetooth: hci_event: Add missing locking on hdev in hci_le_ext_adv_term_evt
      Bluetooth: move adv_instance_cnt read within the device lock

Piotr Dymacz (1):
      Bluetooth: btusb: add support for LG LGSBWAC02 (MT7663BUN)

Radoslaw Biernacki (2):
      Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt_device_connected()
      Bluetooth: Improve skb handling in mgmt_device_connected()

Sean Wang (1):
      Bluetooth: mediatek: fix the conflict between mtk and msft vendor event

Tom Rix (1):
      Bluetooth: hci_sync: fix undefined return of hci_disconnect_all_sync()

Yake Yang (2):
      Bluetooth: btusb: Add a new PID/VID 13d3/3567 for MT7921
      Bluetooth: btmtksdio: Fix kernel oops when sdio suspend.

Zijun Hu (1):
      Bluetooth: btusb: Improve stability for QCA devices

 drivers/bluetooth/btmtk.h         |   7 +++
 drivers/bluetooth/btmtksdio.c     | 126 ++++++++++++++++++++++++++++++++++----
 drivers/bluetooth/btusb.c         |  81 +++++++++++++-----------
 drivers/bluetooth/hci_bcm.c       |   2 +
 include/net/bluetooth/bluetooth.h |  14 +++--
 include/net/bluetooth/mgmt.h      |   2 +-
 net/bluetooth/6lowpan.c           |   1 -
 net/bluetooth/eir.h               |  20 ++++++
 net/bluetooth/hci_event.c         |  19 +++---
 net/bluetooth/hci_sync.c          |   2 +-
 net/bluetooth/l2cap_core.c        |   1 +
 net/bluetooth/mgmt.c              |  58 ++++++++----------
 12 files changed, 237 insertions(+), 96 deletions(-)
