Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF9C44D3B7
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhKKJHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKJHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:07:52 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9315C061766;
        Thu, 11 Nov 2021 01:05:03 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id e65so4645952pgc.5;
        Thu, 11 Nov 2021 01:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B2+NYimYtAQHeWQJ4JtOcv8cQ+tGOJVExZpBjl/zQdE=;
        b=g8k9FhV8RU+mgoRenwOYCDSFUzr4/9fvQnN6+T5XN/aidqFlIRubk6AVfEho6j+92y
         taihMGwuZpA3CmEVLPTXYWWleALNnmAya6MuEzeKpiYw/yv6utrqVKF5R3AgI9tr+8aF
         ZlB+i6Gjac+VV+/vmIP3SReltHhNonW3G2o4sJPIId482SrbLQz4RydhiHaLx4CRZthf
         kq9hM8m5278DEkrSqOsMyrWygKFFa75ecANdSvhN8Ux0xpElLoTAAK7ciRSjPYA49Fq6
         miBhtduGCxvZX48KzD7Ib/hkg/DLAPxC9L8sEVWFD2i3VGYftrAjPsU/lcVVYMmRvPVC
         AbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B2+NYimYtAQHeWQJ4JtOcv8cQ+tGOJVExZpBjl/zQdE=;
        b=rWW9G8BwLKOhJyqWDACTVClN1PA6YtrEkgD1CtWToGUEbOrvquu2jj79FZeA8/7Kyk
         LAq6T61HEDpmlwDYZxxcjfaIplwQ0x2X+0dTY1gPyVc6wL90LEiPKxaCl2EL5kBbNVUw
         J5ad0qR48dCePYNlJ7gpgqFhIoryn/z0kayS2cWg/kH4jEOZ/B5Tbazt2LxZqRCpe1gQ
         IC3/aJS3BQbxxtiO7aGqOFxJ38abEpdy09TAl6hA78iE3pPQHsnB2l6LlDfB/NJ0sNDY
         eJ0KAncTLyf/Kuu8P3qMH3r5+30hjooWi/b8IqXnKsMtK9jFIbRR04WCSkQRSrdAYnBA
         Az2g==
X-Gm-Message-State: AOAM532S0muQdbp2P1nIuMEv8RMbng07G4hyc1wFAl0mt68iMs+iNaxd
        FBOJBo3PxgggzwGupJVdlWQ=
X-Google-Smtp-Source: ABdhPJzf0W/pq5teO2ouyTyBQTG9ViYcwPEatPljIxm/wRbNJEvCQhTjvguFo2zFWygS/QALhbDqdw==
X-Received: by 2002:aa7:91c5:0:b0:49f:a400:9771 with SMTP id z5-20020aa791c5000000b0049fa4009771mr5236810pfa.79.1636621503159;
        Thu, 11 Nov 2021 01:05:03 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id cv1sm7626011pjb.48.2021.11.11.01.05.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Nov 2021 01:05:02 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
X-Google-Original-From: Wells Lu <wells.lu@sunplus.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     vincent.shih@sunplus.com, Wells Lu <wells.lu@sunplus.com>
Subject: [PATCH v2 0/2] This is a patch series for pinctrl driver for Sunplus SP7021 SoC.
Date:   Thu, 11 Nov 2021 17:04:19 +0800
Message-Id: <cover.1636620754.git.wells.lu@sunplus.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1635936610.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
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

 .../bindings/net/sunplus,sp7021-emac.yaml          | 152 ++++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  36 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/sp_define.h           | 212 +++++++
 drivers/net/ethernet/sunplus/sp_desc.c             | 231 ++++++++
 drivers/net/ethernet/sunplus/sp_desc.h             |  21 +
 drivers/net/ethernet/sunplus/sp_driver.c           | 606 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/sp_driver.h           |  23 +
 drivers/net/ethernet/sunplus/sp_hal.c              | 331 +++++++++++
 drivers/net/ethernet/sunplus/sp_hal.h              |  31 ++
 drivers/net/ethernet/sunplus/sp_int.c              | 286 ++++++++++
 drivers/net/ethernet/sunplus/sp_int.h              |  13 +
 drivers/net/ethernet/sunplus/sp_mac.c              |  63 +++
 drivers/net/ethernet/sunplus/sp_mac.h              |  23 +
 drivers/net/ethernet/sunplus/sp_mdio.c             |  90 +++
 drivers/net/ethernet/sunplus/sp_mdio.h             |  20 +
 drivers/net/ethernet/sunplus/sp_phy.c              |  64 +++
 drivers/net/ethernet/sunplus/sp_phy.h              |  16 +
 drivers/net/ethernet/sunplus/sp_register.h         |  96 ++++
 22 files changed, 2330 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/sp_define.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_driver.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_hal.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_hal.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_int.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_int.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_phy.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_phy.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_register.h

-- 
2.7.4

