Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9B9463081
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbhK3KGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbhK3KGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:06:08 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE99C061574;
        Tue, 30 Nov 2021 02:02:49 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s137so19241399pgs.5;
        Tue, 30 Nov 2021 02:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=l1L3Wfgv7hXmKfSeVoSWOOaT+iJpEmEXH9jk/Ny4R8w=;
        b=JIH0xpiC8UwqgJ0Q+ip+i0xbc7GbhnUSTJnZeRdPMvHuKRRcnPcbsYLf9FhUlqLr6j
         Aprtsrx1+Lu45+1JDNAN1yoC1sCv3rj+oXqUbkHkT/Nvn4hxW5FeufRTDq55o/PhKSeU
         ev7PL1DwOSsov7IY+Ysg3JvZeU3/cJkyaLYC7tcJ3ZLA2a3T/+KTUPv/QJVmKbWu111Q
         W0FezK3m37t+oS+gyhhaGQhrPMgKvXQzULZ7aGT/iNJftYso7nQlFf/SKhiXHeEE16bG
         roFWj1E5vEyeJhi0xLL3aQ369q3aZrTDqhzXi/Lvizbksqeyy7SUsFh0ooGY2g6HFhx0
         JwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l1L3Wfgv7hXmKfSeVoSWOOaT+iJpEmEXH9jk/Ny4R8w=;
        b=5OlCgM9DVA5RVedwWB9eGJ1VOgXdtCST9TxuFWYldAN03VaVsDcZ88E1a9uVGvideE
         0/RZFugPm1sIHH0tbZaKgL1XD7Tcmue8XMigE4d24JRV+mkPgY7TbSdnuqOgf1faf++l
         acNu1c2oap6ljMQwSJQ4cS7EJlzU2rcfTGgX7XWiFvXK1CltbSxknEFzpXfEgA4Xhi5T
         Dq5DT3wNySC7aEuVgcXisiavQWklKl7RcqT0jz+N0M5SCxkMSEdRjtBcD3RWo8E8ryh/
         1ZPR8hb5HZ2b69IyK74bmkgLq7OcSRi/R1mkCuIOdexeq9CBP4N/M7WAHjR5iOVd4oXS
         SRVA==
X-Gm-Message-State: AOAM532tj4seVyXsw7vFmmGzREzYsUyv8+EfG4jZyrgNfdv+wVOwfScC
        T7o7DN0XwEple/V0scJ4L8NKMstIrDw=
X-Google-Smtp-Source: ABdhPJw9oFmGRTwNh6ojXx3ZFK+VMY1kzKTWTS0rX6bVQvk9rIYW5j/f9daHAJuUlLVOE44osnWoZw==
X-Received: by 2002:a63:1d63:: with SMTP id d35mr5562570pgm.135.1638266569159;
        Tue, 30 Nov 2021 02:02:49 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id e29sm10497114pge.17.2021.11.30.02.02.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Nov 2021 02:02:48 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     wells.lu@sunplus.com, vincent.shih@sunplus.com,
        Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v3 0/2] This is a patch series for pinctrl driver for Sunplus SP7021 SoC.
Date:   Tue, 30 Nov 2021 18:02:50 +0800
Message-Id: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
etc.) into a single chip. It is designed for industrial control
applications.

Refer to:
https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
https://tibbo.com/store/plus1.html

Wells Lu (2):
  devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
  net: ethernet: Add driver for Sunplus SP7021

 .../bindings/net/sunplus,sp7021-emac.yaml          | 172 ++++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  36 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       | 301 ++++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c         | 224 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |  21 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       | 627 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_driver.h       |  19 +
 drivers/net/ethernet/sunplus/spl2sw_int.c          | 272 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h          |  15 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c          | 336 +++++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h          |  23 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         | 117 ++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h         |  14 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |  89 +++
 drivers/net/ethernet/sunplus/spl2sw_phy.h          |  14 +
 drivers/net/ethernet/sunplus/spl2sw_register.h     |  96 ++++
 20 files changed, 2392 insertions(+)
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

