Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1264FECEF
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiDMCeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiDMCea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:34:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E3927CD5;
        Tue, 12 Apr 2022 19:32:08 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t13so475158pgn.8;
        Tue, 12 Apr 2022 19:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=O+ahXoMssk8BUaJjsqYAqh/OAZB1KiMoVxuzJ8FBLZg=;
        b=IZiGoD16K5gmDcA1EQLX+5qOZSbL/EfFHI8NoLYAXSb+KRIMLoRV3wCucju83YhgnE
         a8tRWg3RzKK2I3s3/O7sdgg2lAxzoqGU8mjwAFczjdMrOlfRSEv2mH3KXim/OagNznjX
         kw+DeORieYBgalNggS+4gLRpuUDe9tF2DmzYaZ74Zc77c0vUr/lxaCgWUfTuFcGLh+gN
         8gJxLVSXqo9zoTa/qNorQx/SIOslPqD814Z3ClRTjcOFLvQuObJ22WNWkZy5bwjCoDX4
         RxPRKNweLoUG3YNfzyf+PxxVJ29nt5QIb6HJ89qIchpvHP4s3STitE6X7Oqoz7SEGTLc
         Toxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O+ahXoMssk8BUaJjsqYAqh/OAZB1KiMoVxuzJ8FBLZg=;
        b=Rhcd5tUW8oYvy+AhTa50XxG0+TK5FmI5ohRBWc4lfj4T31m82y4Wld//iZD4yG6xcd
         EyTMNYuVkmEE/P8h5EBtIaDu4fbAplBDwF7Ar/djke/HSlpi/Bm3KhBqc0/u9juzULmn
         A/Zbtie8boGVJRlzFPRPwAF1bNUlATqqBkNRU5h3NUUOPHedt2SBtRvx4kCT5HwvPYZJ
         Xe7NtSFNr9ElUgH9h5stsRQz6nvZGdTx7FQTa+yqp0icYEKe79BfISOuq9dYUu3gRVan
         rbX+hF/7KXl6YKonzOP8hFTHipPi8jV3Idg+gIzIbmuNgbflB706aPdzMOxX7hj3EQ8F
         fuog==
X-Gm-Message-State: AOAM533tn2aIpMlt80r8+DTH5nwtbShR7AMeWKNPakEtUyQt7f3iQxtG
        h1unWlB7ov6fdgqHBqOQrek=
X-Google-Smtp-Source: ABdhPJy0AC4PMx41u069HaFpYg4Cajwk3Fg09nf1+kbxr18C1GC8K3Oy3NrHANn23K+K95zUbrmPzQ==
X-Received: by 2002:a63:104c:0:b0:39d:460f:5c58 with SMTP id 12-20020a63104c000000b0039d460f5c58mr12188647pgq.559.1649817127718;
        Tue, 12 Apr 2022 19:32:07 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id q28-20020a656a9c000000b00372f7ecfcecsm4255943pgu.37.2022.04.12.19.32.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Apr 2022 19:32:07 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v8 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Wed, 13 Apr 2022 10:31:56 +0800
Message-Id: <1649817118-14667-1-git-send-email-wellslutw@gmail.com>
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
 drivers/net/ethernet/sunplus/Kconfig               |  35 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       | 271 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c         | 226 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       | 604 +++++++++++++++++++++
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

