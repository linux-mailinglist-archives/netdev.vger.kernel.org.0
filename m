Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C888D581BFE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbiGZWNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGZWNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:13:31 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A20BC2C;
        Tue, 26 Jul 2022 15:13:31 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id e16so14407808pfm.11;
        Tue, 26 Jul 2022 15:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rt32uwDxrevGvXgTVIxvtsQF+F6DO9LcL8djQTteugY=;
        b=GeM6zmlPYCClXI2NfGKd2nyL9/quQY/tm3RvcI5mdBMLXB02pyJgIXdmY1VgZWP+Cc
         jjDpzNDCoESVAAmjaEwucmfy+TGGPiJezGIykbP2Kq3vXKM21gzmgKa+2y0tGyBKEYDL
         HCfFCn6qQWpzli0oybekwUfWDVKO4Hl68+nDA8KhZ+jgTXvZmzAm04xAF0sBVWy9PqXX
         jPEPi5M+49KlAd1Dn+Kkk4BUwFRvQyQc7YyirfFNkZPF0M6pGesLXnh2mgUInWB9sGXW
         VpfhMqh7JyGznwOHAFVvHz+qVr3KcTdL/s3ZDYWtRXDYsT+x0r0E/6diDrUavUcj0X1k
         BSvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rt32uwDxrevGvXgTVIxvtsQF+F6DO9LcL8djQTteugY=;
        b=IuQFz7ykQVSPBrXe80aymGsiZusRh1Lr2znwHcxCIIqzShioDDApPyE9zlWx4cdlcV
         0Ahu7x3VWFP6GKrFj+uHHG98X7qiyq+hBzElNcAYwZGtj85xkT3TszePfkynNs007Otr
         zt/C2znWr8bUhBncKPfODe480BqQSUF7KM68eyjq968PsNjvbR1d8zXNkdCBXD6cTmP2
         t4L0l7NUOO82It1WyWsRRcGlNWzHxfA6pIWlMW7zJmUzVX3s8bOTho3gcFnYW+C0+7UG
         MuXBfC8gULiYVO9AkEXksTJVP9RCQNhc3GHr6Yjx08UjHmWzffn3LxuSQvm/tO56Slqc
         +bgQ==
X-Gm-Message-State: AJIora9INU9YDlQ+XkzngLeyGWVBkr0okcNXx8CPiK19Xnjn6gxAVPdo
        k2wS6NSMrYNCyeztDoYxqPU=
X-Google-Smtp-Source: AGRyM1u/af+qw7wXKDBbIijJkPz0Iz3BZlJMRrdxPenqnzvXurAHoeqpZb05SBAz5CJ9Er2Qny8Stw==
X-Received: by 2002:a63:ff19:0:b0:41a:8f88:5703 with SMTP id k25-20020a63ff19000000b0041a8f885703mr16930552pgi.355.1658873610338;
        Tue, 26 Jul 2022 15:13:30 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id d24-20020a63f258000000b004168945bdf4sm10537892pgk.66.2022.07.26.15.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 15:13:29 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-07-26:
Date:   Tue, 26 Jul 2022 15:13:28 -0700
Message-Id: <20220726221328.423714-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.1
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

The following changes since commit 9b134b1694ec8926926ba6b7b80884ea829245a0:

  bridge: Do not send empty IFLA_AF_SPEC attribute (2022-07-26 15:35:53 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-07-26

for you to fetch changes up to d0be8347c623e0ac4202a1d4e0373882821f56b0:

  Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put (2022-07-26 13:35:24 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix early wakeup after suspend
 - Fix double free on error
 - Fix use-after-free on l2cap_chan_put

----------------------------------------------------------------
Abhishek Pandit-Subedi (1):
      Bluetooth: Always set event mask on suspend

Dan Carpenter (1):
      Bluetooth: mgmt: Fix double free on error path

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put

 include/net/bluetooth/l2cap.h |  1 +
 net/bluetooth/hci_sync.c      |  6 ++---
 net/bluetooth/l2cap_core.c    | 61 ++++++++++++++++++++++++++++++++++---------
 net/bluetooth/mgmt.c          |  1 -
 4 files changed, 52 insertions(+), 17 deletions(-)
