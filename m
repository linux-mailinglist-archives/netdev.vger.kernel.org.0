Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933E451ECD3
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 12:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiEHKRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 06:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiEHKRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 06:17:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7501EBF69;
        Sun,  8 May 2022 03:13:32 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c11so11375044plg.13;
        Sun, 08 May 2022 03:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ByYr7aMGGDr8h8TkbEKkYd3QBbrE2CshJtP9jL4rIUg=;
        b=ZV3pJrdNCrloK9Go644vqxakmipQakmvUGH7IXuPAJnmwT+9lGuJO1hCtX4JpHdTxf
         L/4VdezXSGX9dNBy4LYc03zzTa1abdInvmS6ZtoDf35Xrclw/QZ3UOoX72PTcLt6HxGk
         w1f7CLI6qzfQE2u+6SbYxYyU4MNk8kCkfOjUIk00VevlxlNxeEO2BeqbtAU2l3KKm0ze
         VvNteSeQLyvrRp7yg73JzaPCMdijdRkX6Jzeok33qMQ86xrvfpjdh0JNrC4ZH2LloAkt
         1iP26h93+yXndkLx2GJ5CJvKaz+Vu0vTRHZDhApvIotAvkzxV1WAB+67SsvSCSUdEXO1
         VpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ByYr7aMGGDr8h8TkbEKkYd3QBbrE2CshJtP9jL4rIUg=;
        b=y7V+VY6rrYV7m9oPHP+eZKxS8wcTlNTsNep0W6eVuq1aX3JNGb4f7cCqIFjnm6W9YC
         Ei4qpfUZIOCB1C0kv/ivFk7JYXcHY8Nmw7D49s46BMZv/pPFend+LZ5yVGERTFOXnoW/
         fx8oqIJzI668Vq1pS+cnUXrt7T/Mkh2tOMBTKairkx4EPO+zWVx5CDmliKsIhfqV9QM9
         7HqUL2WTT5mbgNKrspXOwzWzl2mEGoWouy9tAv1kNQXl6sON2eI2CZMuicwYSKZEle6G
         wISvY3u1A40hrFl1hrjDTJiNV1SrxYMrxNkPNgmzTfCuyrc+i1gDwHXFC2lZ3elb9Dkk
         gEMg==
X-Gm-Message-State: AOAM530aceVJxTK94XqpmL3HZfOr3QJU8yIXYrKu0/B6ChCdzbD6FUN5
        VJyLAgv9rR+DEh1I1MuTxzE=
X-Google-Smtp-Source: ABdhPJykwCm5x4A2BlKUc+oCoxbEhkoiNiI9kotOHCKbwiwuHW2Ln2GZbjJabvvNgCPkv6pBtM9zqw==
X-Received: by 2002:a17:90b:33c5:b0:1dc:eff1:d749 with SMTP id lk5-20020a17090b33c500b001dceff1d749mr6990239pjb.239.1652004811650;
        Sun, 08 May 2022 03:13:31 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id y2-20020a17090322c200b0015e8d4eb1f6sm4969610plg.64.2022.05.08.03.13.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 May 2022 03:13:31 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v11 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Sun,  8 May 2022 18:13:18 +0800
Message-Id: <1652004800-3212-1-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
etc.) into a single chip. It is designed for industrial control
applications.

Refer to:
https://sunplus.atlassian.net/wiki/spaces/doc/overview
https://tibbo.com/store/plus1.html

Wells Lu (2):
  devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
  net: ethernet: Add driver for Sunplus SP7021

 .../bindings/net/sunplus,sp7021-emac.yaml          | 141 +++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  35 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       | 270 ++++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c         | 228 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       | 578 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.c          | 271 ++++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h          |  13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c          | 274 ++++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h          |  18 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         | 126 +++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h         |  12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |  92 ++++
 drivers/net/ethernet/sunplus/spl2sw_phy.h          |  12 +
 drivers/net/ethernet/sunplus/spl2sw_register.h     |  86 +++
 19 files changed, 2191 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_register.h

-- 
2.7.4

