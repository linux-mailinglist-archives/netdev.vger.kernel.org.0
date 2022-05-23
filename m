Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB755317BB
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiEWUDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiEWUDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:03:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58596FD05;
        Mon, 23 May 2022 13:03:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gg20so14983987pjb.1;
        Mon, 23 May 2022 13:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bgGL9vPmn7It6mSSxr4xGr9tZVsKClEQVSniSkYH9fU=;
        b=GE86hsPlFU9fmFoSIlqWDWgt2YfjoQRW+B5ylZy5SX1PT1Vy/rvDKs37FuWU6c74it
         jMIpVcCh6G0kB3SSJH9F+NMRpdSsJt4uCe/TLFwrq28xBfejN4Wo+mMiJf+CNpveUWTz
         M43C3XJeYVMGmb3+zQzN8hvT7NZMFQgFp+KFHENUofAelFMr5GQLTQNZAEFxEWOaqsAl
         dsTBFchscGvi6lGY9NKISv2AmVTRgTplD95uqQHQhdNqlogxfn/nc6Bhnl0L7bjEL5tB
         xnTv8dsE9m1rZHybus+M55rlspWZ0tJ38xpqWB+Dj1cw6v2EPpgTNx+Yq7R6s9r4Lq/7
         Zh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bgGL9vPmn7It6mSSxr4xGr9tZVsKClEQVSniSkYH9fU=;
        b=HRa7jONrdOY0iuX+GHwO/GOzotezl5TxC8OLuJxzMbyQfJ2/EAqfjmAlavuGhACFlu
         09XHDwRYzkbBNqx0iYJE2AtbpgQg1FeJzOGahyf/ASkeZUopxYTF+Jo5X04ePZavzqsE
         aver1poMEEOby8adj6acaJTXZx5Ba0fesg5OmeIM79BC/exLM9SlYXv+QbhceG56DCAi
         4GRlRb9nN/5Sjvl3SVzZ3y4B80R8OL3XvND1uHRKJTd1XOEKW3hj4QH34Ji1RSlPhupM
         fOqhdTeimcqkqqtrWbUEVlQTrr6AA6HM0TPO86NhP2wkr0gfZ7JFE0RUcR9FmszZquWs
         qZaQ==
X-Gm-Message-State: AOAM532vhQR6OOE3VhknERHm6T1VSC8ZQ5fj1eT7xCz0csLeEJTipj88
        +PYkQtsFrbqVNldOYvEEGUc=
X-Google-Smtp-Source: ABdhPJxcIHbC9EvTvMnGhbgmpbygP3NhEXAyMP5iKCGiKLYCCVb0xq8q1edxgLSOQP93nvBri5lkBw==
X-Received: by 2002:a17:902:ef45:b0:155:cede:5a9d with SMTP id e5-20020a170902ef4500b00155cede5a9dmr24005769plx.93.1653336231305;
        Mon, 23 May 2022 13:03:51 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id l17-20020a629111000000b0050dc76281ccsm7507465pfe.166.2022.05.23.13.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 13:03:50 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-05-23
Date:   Mon, 23 May 2022 13:03:49 -0700
Message-Id: <20220523200349.3322806-1-luiz.dentz@gmail.com>
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

The following changes since commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d:

  net/smc: fix listen processing for SMC-Rv2 (2022-05-23 10:08:33 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-05-23

for you to fetch changes up to c9f73a2178c12fb24d2807634209559d6a836e08:

  Bluetooth: hci_conn: Fix hci_connect_le_sync (2022-05-23 12:52:06 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix crash when an LE Connection fails to be established.

----------------------------------------------------------------
Luiz Augusto von Dentz (1):
      Bluetooth: hci_conn: Fix hci_connect_le_sync

 net/bluetooth/hci_conn.c  | 5 +++--
 net/bluetooth/hci_event.c | 8 +++++---
 2 files changed, 8 insertions(+), 5 deletions(-)
