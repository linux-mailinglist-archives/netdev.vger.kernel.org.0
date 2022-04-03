Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C984F0C70
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 22:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376412AbiDCUJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 16:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiDCUJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 16:09:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7811E3A1A6;
        Sun,  3 Apr 2022 13:07:56 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f10so6560812plr.6;
        Sun, 03 Apr 2022 13:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=4UTb8E/mCbW8t6j2F7bYq2PlhXqC62wTANJk5So/Xmw=;
        b=Fjxaw3RVHJARRhuzeY42JaYkPhY3VWv+ygeM3oQL1dCXroyCtrq7o2hjHDv8BdWPzV
         lVtd4b2gWh01Lleg48yP4i79hmVkj0PqakcGOHSj6NKmeyAVFQOEsQRmwFjgakjf8Mc3
         w2jilr6xAunXiWAJ/N0QzfXCeozO/xo+0127oecNMqzGpzUyW2LMhPni7PQr1CLMn4s5
         0NvZUOQCvVgCiW8t004FkRTSQwAvDoUVvhzBe/3vxvvuuprrXIpiHJSc+ZfY5EaOcX5c
         LAQWK1gB3jOWtFesp1H/L7dI2uBQuDLdeeGUhEhrIB6SeR7lrHBdl7RMiOxXEncqZTht
         pvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4UTb8E/mCbW8t6j2F7bYq2PlhXqC62wTANJk5So/Xmw=;
        b=swnds0WYEimZ2AKa+GUNyOZkoSdCGSSe2eEVE/QV+WfPF5ifZP+6GRsWxwZ150cFPM
         WV2KRzCU7FRIE2zJcrVHzjwDSswxgXH6nA0t8BH4S/8IVji031m0VqIJhXkybev1M1vU
         52zAsZ71b1e+gHyRicrX6EscE/IBfF7kMAjHme8O6J9Z4EyF95/vFLRDm5k9+l5+Hxr9
         gsWeC1j5043wiGOlSZNQFIBVSq+kV93H+V30pJCSKRtrjtbPjxOYRjQa63Zi1M8Pbjm2
         UE9RlReqkmqEJHMk81i45He2jGNLESbGYJ2j7CJLU+tr7HEpuP9kpQwMVjFAmhxgv6kq
         SUmg==
X-Gm-Message-State: AOAM532K/cM679BOyhzoHffcJobw/4xbIXjnb37nwM6BgJH7wFkiyinY
        FpfXtcbXKCGM6tCqkwxzcMY=
X-Google-Smtp-Source: ABdhPJz6Rwxmab/rZl6Sao5quil0+Foh8WAqeWdLWXBPbjAe2exO0b6TGF6IDqZuEY4um7OYsv08NQ==
X-Received: by 2002:a17:90a:5409:b0:1ca:8a21:323b with SMTP id z9-20020a17090a540900b001ca8a21323bmr3936698pjh.135.1649016475622;
        Sun, 03 Apr 2022 13:07:55 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm8154660pgn.2.2022.04.03.13.07.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Apr 2022 13:07:55 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v6 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Mon,  4 Apr 2022 04:07:37 +0800
Message-Id: <1649016459-23989-1-git-send-email-wellslutw@gmail.com>
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

 .../bindings/net/sunplus,sp7021-emac.yaml          | 140 +++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  36 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       | 271 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c         | 226 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       | 603 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_driver.h       |  12 +
 drivers/net/ethernet/sunplus/spl2sw_int.c          | 253 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h          |  13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c          | 346 ++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h          |  19 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         | 126 +++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h         |  12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |  92 ++++
 drivers/net/ethernet/sunplus/spl2sw_phy.h          |  12 +
 drivers/net/ethernet/sunplus/spl2sw_register.h     |  86 +++
 20 files changed, 2282 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.h
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

