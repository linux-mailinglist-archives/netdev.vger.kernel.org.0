Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE6361731D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 00:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiKBX7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 19:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiKBX7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 19:59:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED5A2AFE;
        Wed,  2 Nov 2022 16:59:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k7so365277pll.6;
        Wed, 02 Nov 2022 16:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iByqjDsI8yxVjMZdPIB03/uaN8B4xJBEg5Q2hHGB0cU=;
        b=LLsd3G17eaWY1UxRCpi+0/xGUOzYwv3fwRWk/2UOhIAf6OO+bWSOk9yw6b8DZwZESx
         IA62NLYYpwLINEij7RAURObd/Q4bFNryA/6OEDnyqD5TYU76gd0RGgGW6fy2E2NA/RS/
         Qbe7JeKW3ApFgrwzEVHOFGq/WnChpgFd2AAtq9f20k3crodAYxjCHRW4UxzEQOUq5ud9
         +MK39u5egxOnzBHJYiGp4ThhpoCvk1+qIf2VxSS5Zi7ZFgYLaoQylmlXe5yrUhhuXiYU
         7BMfa0AWn6m9oGtIImfTA2SozvOXQaGfudS59jnlvALb/Vo9AEKmkv7I/ztJSANuZKX9
         CrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iByqjDsI8yxVjMZdPIB03/uaN8B4xJBEg5Q2hHGB0cU=;
        b=rMEk82u4+w8FQ7Z1brBkZnb6hvC5knnF5DLo6HFFsD3ov3EgQMInutZhiIekwYrK5v
         7vhh6Gn0KXPFlarbFhVw/HvEvEuCs+nvxKJv9FozUqrcV2W2LxMSPd1ePHzEkczgQaJF
         /2SB3DxbPnbuEDwdpkxnzP/CaKodpDLa+9mhBl/6wkV/70mAnGe+EwguHsZFMnGQZyJp
         K5b9KosfLyFzAMB6YcR84bMQfCla5IKvCh1MgdqzjrPQRJL9tmrrfVm9ltmTIUX5Z7is
         DA6x6KErbiYa68ihGH9BbW/TBORHEj0J1jgPGnl9jk7Hs8g1divK4zIHcCLs57vIJtFz
         SC7A==
X-Gm-Message-State: ACrzQf12UDo7BR0zEpH2DWnRP54J8YxfeyXsdbzGNBoPCAMfgkvsZ4mL
        /MUmu6qZkinneMnVLOy3tGvk1uamPXs=
X-Google-Smtp-Source: AMsMyM4R41P97nKS+jW57b21Q5FJEOt0OxM3zaDBKxbavSfOu9bTDGOtY0eB/Umu2VDZKlafJGKiLw==
X-Received: by 2002:a17:903:1c2:b0:187:feb:1f31 with SMTP id e2-20020a17090301c200b001870feb1f31mr23657217plh.92.1667433569666;
        Wed, 02 Nov 2022 16:59:29 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902654d00b00172f6726d8esm8852548pln.277.2022.11.02.16.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 16:59:28 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull-request: bluetooth 2022-10-02
Date:   Wed,  2 Nov 2022 16:59:27 -0700
Message-Id: <20221102235927.3324891-1-luiz.dentz@gmail.com>
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

The following changes since commit ba9169f57090efdee6b13601fced57e123db8777:

  Merge branch 'misdn-fixes' (2022-11-02 12:34:48 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-10-02

for you to fetch changes up to b1a2cd50c0357f243b7435a732b4e62ba3157a2e:

  Bluetooth: L2CAP: Fix attempting to access uninitialized memory (2022-11-02 16:37:00 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix memory leak in hci_vhci driver
 - Fix handling of skb on virtio_bt driver
 - Fix accepting connection for invalid L2CAP PSM
 - Fix attemting to access uninitialized memory
 - Fix use-after-free in l2cap_reassemble_sdu
 - Fix use-after-free in l2cap_conn_del
 - Fix handling of destination address type for CIS
 - Fix not restoring ISO buffer count on disconnect

----------------------------------------------------------------
Hawkins Jiawei (1):
      Bluetooth: L2CAP: Fix memory leak in vhci_write

Luiz Augusto von Dentz (4):
      Bluetooth: hci_conn: Fix not restoring ISO buffer count on disconnect
      Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
      Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Maxim Mikityanskiy (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Pauli Virtanen (1):
      Bluetooth: hci_conn: Fix CIS connection dst_type handling

Soenke Huster (1):
      Bluetooth: virtio_bt: Use skb_put to set length

Zhengchao Shao (1):
      Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

 drivers/bluetooth/virtio_bt.c |  2 +-
 net/bluetooth/hci_conn.c      | 18 ++++++---
 net/bluetooth/iso.c           | 14 ++++++-
 net/bluetooth/l2cap_core.c    | 86 ++++++++++++++++++++++++++++++++++++-------
 4 files changed, 98 insertions(+), 22 deletions(-)
