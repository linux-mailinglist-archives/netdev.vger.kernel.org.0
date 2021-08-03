Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151EE3DF362
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhHCQ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbhHCQ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:56:09 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB32C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:55:53 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y7so27595534eda.5
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OFRG30nP87HIzrsm/WdzGEWJLKsidV86cFqhRIxvJXQ=;
        b=rB1Smrv4s8r41z1CPmoW1w2wollWIoP+lPJkBRNH4/8F1GISQSmt7tbRwEEGneXdWA
         p/BKClFUnHDUczbDkQxJdz0FfdDGrshnPXmauJoXp2/7atKZujnTWCLSKtKD7b6kD8/a
         2X/FLOoblIYPhjLDDr6IKnrWDXnl25WcLh5syQs5f73FSGtrFtjAXx0a2wujIZGkh/cv
         QrDCVKcDeykF9oQXmta+iW1fQejLu/eN8yteNF4h+3B31z3bY3I1WRUDzvv9EgpXwfN3
         W87oA5D7AFtgfQERcB93yD0cwoRsUnDcbe+2QiUhy7ab6wgmauj7qPQ2ju04GxEXiKxD
         bvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OFRG30nP87HIzrsm/WdzGEWJLKsidV86cFqhRIxvJXQ=;
        b=DwYTIFSNwjBCMZkKeI2swuGo7oa/PvrJIljf/b9c0X3iYOg5IGAzQZ4rjHCQPlzjmp
         r7TmVhdTJ+INx8NCoKaKgymjXFZ1fpsWLdLMRBRZjj5kocBlekyzrNNIrVL1r4/WbnaI
         8vyygHhNUBNtE/CHySC6ZWeqS6oQ4Jo66wHfIHMYYdqPZbIDJzFnUmduFJbHdz0c4X/A
         SwcjrmUeWksutFVYLgUjCptt/d/6iyuk+oViWoktQwi8cQyyKMAk0zFrtCeTXPfRMciM
         klG3PYpJ15GRYicmduEIMK78Q7zDcPt5ExWfwpU7agb2N9Nmp0RLuLFWATUaJ5nMDrgY
         Iscg==
X-Gm-Message-State: AOAM531k1qFK4h1+uueGmwY1BNKtuylrJeUwRvsE/B/nt7kpFk51wpzc
        WWmkpRrgh8nXNN537Mh7YpI=
X-Google-Smtp-Source: ABdhPJyDH34fxZiweQLUciii6cyzBAflYzf8eK8QObRGeu/yJGPyo/9D+K8bLl8ry6bkABV++ImF8g==
X-Received: by 2002:a05:6402:1d90:: with SMTP id dk16mr16225891edb.94.1628009752233;
        Tue, 03 Aug 2021 09:55:52 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:55:51 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/8] dpaa2-switch: integrate the MAC endpoint support
Date:   Tue,  3 Aug 2021 19:57:37 +0300
Message-Id: <20210803165745.138175-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set integrates the already available MAC support into the
dpaa2-switch driver as well.

The first 4 patches are fixing up some minor problems or optimizing the
code, while the remaining ones are actually integrating the dpaa2-mac
support into the switch driver by calling the dpaa2_mac_* provided
functions. While at it, we also export the MAC statistics in ethtool
like we do for dpaa2-eth.

Ioana Ciornei (8):
  dpaa2-switch: request all interrupts sources on the DPSW
  dpaa2-switch: use the port index in the IRQ handler
  dpaa2-switch: do not enable the DPSW at probe time
  dpaa2-switch: no need to check link state right after ndo_open
  bus: fsl-mc: extend fsl_mc_get_endpoint() to pass interface ID
  dpaa2-switch: integrate the MAC endpoint support
  dpaa2-switch: add a prefix to HW ethtool stats
  dpaa2-switch: export MAC statistics in ethtool

 drivers/bus/fsl-mc/fsl-mc-bus.c               |   4 +-
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   2 +-
 .../freescale/dpaa2/dpaa2-switch-ethtool.c    |  56 +++++--
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 151 +++++++++++++-----
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  18 +++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |   5 +
 include/linux/fsl/mc.h                        |   3 +-
 8 files changed, 177 insertions(+), 64 deletions(-)

-- 
2.31.1

