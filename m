Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8259C336990
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCKBUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCKBUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:20:18 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12F8C061574;
        Wed, 10 Mar 2021 17:20:17 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so11818436wmj.1;
        Wed, 10 Mar 2021 17:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7uMncpPAE4jWoflI5coLB5nSFQY4/AWNCX9VZjYJxzI=;
        b=Nc8MYQYGmJoLdEd5ZZcCH+7s+60s9bd/sJLF8qjzYXn6l7+txx7hTxtnP5Sw6c0YEL
         bAcOivsyT3iQ7BNoJ5lscEOXY1jkjKc1p8fzQB0IDMsROHUt/Sr53iUVQT6Ltx57eEBf
         vrn6YVe8AGS8B8nmLJrPnhuwAAXEadzk/ATK8DN88N1nUPy+ni4d3wDO5XdSq1F9np9e
         94CUx7XFusbAZWXY27KYS038loBRa6l3QtLTrmtmZWbDRBL9rPQDnKx55Ohh92pf2Rpp
         03GJmKh7lSg4yd+6d220RMg91o3FNxJ2b52JgKKThg8RtrQi7hE4l3XxzVYEudf3I+O4
         gY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7uMncpPAE4jWoflI5coLB5nSFQY4/AWNCX9VZjYJxzI=;
        b=keLk1ZFPIfZEvuSXAyWO6ivV94g5jHHO9blok0Id6wDX5OpyHnPhLw2S7HD2HAjeX0
         oIvSwHphnHxq+51PFy7E/qWREmKLGIqaoyEKfXhusNWoFXiDwkWUJRusPCZtnRg7ll2A
         3/FpqwWNhjgkkb4nWPMriheXXt8AsaZTzkQ0PCBR5mKrbg0V+xUUhygNKjZ684yDBP0S
         dka1hNcGto20duakUkiaWPk4gmK/LSVOxHy7f6oFU4aAklzxhDNeGbwGWLruS3QV1z9Z
         ZCSiGkSRSc+4SE4Ff4O9OFDxyIhUKlaZtx+X5q4LA2vLtPr5ERn8MCpfg83r99WnDv3/
         y7xw==
X-Gm-Message-State: AOAM531ePzMtLy9+9tYdq+8TIUPJfRydmnPkuBkWz53QFbQyRL1OkTzC
        AScmpeSnjKfAXgU6smSudst/2XpB0/w=
X-Google-Smtp-Source: ABdhPJwkA4xwc4RDlD/r9Gu6ew3RAMijLC75fiSCNAWFfjnKG95xxAfGFd47g2ZGBxvGN9qANG/Plw==
X-Received: by 2002:a1c:541a:: with SMTP id i26mr5562580wmb.75.1615425616652;
        Wed, 10 Mar 2021 17:20:16 -0800 (PST)
Received: from localhost.localdomain ([81.18.95.223])
        by smtp.gmail.com with ESMTPSA id d85sm1199127wmd.15.2021.03.10.17.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:20:15 -0800 (PST)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add support for Actions Semi Owl Ethernet MAC
Date:   Thu, 11 Mar 2021 03:20:11 +0200
Message-Id: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the Ethernet MAC found on the Actions
Semi Owl family of SoCs.

For the moment I have only tested the driver on RoseapplePi SBC, which is
based on the S500 SoC variant. It might work on S900 as well, but I cannot
tell for sure since the S900 datasheet I currently have doesn't provide
any information regarding the MAC registers - so I couldn't check the
compatibility with S500.

Similar story for S700: the datasheet I own is incomplete, but it seems
the MAC is advertised with Gigabit capabilities. For that reason most
probably we need to extend the current implementation in order to support
this SoC variant as well.

Please note that for testing the driver it is also necessary to update the
S500 clock subsystem:

https://lore.kernel.org/lkml/cover.1615221459.git.cristian.ciocaltea@gmail.com/

The DTS changes for the S500 SBCs will be provided separately.

Thanks,
Cristi

Cristian Ciocaltea (3):
  dt-bindings: net: Add Actions Semi Owl Ethernet MAC binding
  net: ethernet: actions: Add Actions Semi Owl Ethernet MAC driver
  MAINTAINERS: Add entries for Actions Semi Owl Ethernet MAC

 .../bindings/net/actions,owl-emac.yaml        |   91 +
 MAINTAINERS                                   |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/actions/Kconfig          |   39 +
 drivers/net/ethernet/actions/Makefile         |    6 +
 drivers/net/ethernet/actions/owl-emac.c       | 1660 +++++++++++++++++
 drivers/net/ethernet/actions/owl-emac.h       |  278 +++
 8 files changed, 2078 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/actions,owl-emac.yaml
 create mode 100644 drivers/net/ethernet/actions/Kconfig
 create mode 100644 drivers/net/ethernet/actions/Makefile
 create mode 100644 drivers/net/ethernet/actions/owl-emac.c
 create mode 100644 drivers/net/ethernet/actions/owl-emac.h

-- 
2.30.2

