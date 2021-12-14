Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1730E474473
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhLNOFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbhLNOFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:05:41 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AD9C061574;
        Tue, 14 Dec 2021 06:05:41 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q16so17378857pgq.10;
        Tue, 14 Dec 2021 06:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=sNVaZcoVHlxLXa/Jf7uPFM+noQGJmIlvrXPMscQc4Mw=;
        b=UvJcLTnh6X/23E1j6OjJ0TVDMQi/Ytdm54khn+qSbDO7vVYwsjUjfb1NyKmtqrBL6q
         17vSswwDmYdNPVa7mNl8Lh0TgPieRwa/moovzU2e7Q3iWwlExvCTb79QRmJOiCHOOu7A
         8pBEib51xM0xu6ssoAKqrqbxLdj+wRnrskEIVaEOHzd/A2gOnZkaPD0vz+3wbHSVU2GA
         edVzhHPs1laAilmjQoVwD2s8o0BgXPeqPNmtK3JJVeMxxDOVU4P1zofpVDabAqqiRVmy
         9FE6PiRFKHUgQCOfifvWV+nqpXwQh4zUB1I00DHss3YSsZ5KfXbZ62RTr64Ht7YF7Sol
         mgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sNVaZcoVHlxLXa/Jf7uPFM+noQGJmIlvrXPMscQc4Mw=;
        b=VzyEZj1ksk+Pcfa60vpp3q/pvPRsKUg14aYowMRoKGmZAgK1h3+D2FbAhb2LLrN8gC
         NWa63VoXNBgiseMIBhc6uLliAVMD5KHA1A8zI/WxTbsToZ34Fqhkg7kVbOGMJ7dj92AE
         HAWmyo930TWvyNNI170UZeMA5A4OonfsG8TSibZAxNKzsQc1ZKkRMj86ce+yMF5YvcaZ
         oLf9HOAezajFHXLVCoxkBld/ZMnVxpZ8++F2HR5wj2YTVwtjQMvrw/wVWEsg9SVVW1FF
         LwcqdFBEQmDWPLdE8us7YMbhdd9hnlz5snBdELluwIFqYa+kd9BGIpYjqXw5omLiwxa9
         eIQw==
X-Gm-Message-State: AOAM53156+nhsQ+fZyzygJQ3wQnNAl1i6fSgyBSfPyTVvYJ2lQIKuVOR
        rY7tRaZR5JDLo7EQJDG8TKsgNcwGoyo=
X-Google-Smtp-Source: ABdhPJzsSgMntXAntxr6Wpf/UqqvNI6rFWGWNmISDoEra6ndblVbk+16RisTwqybRSV9pKjpk2Hu8w==
X-Received: by 2002:a05:6a00:2181:b0:4a7:ed1f:c5ba with SMTP id h1-20020a056a00218100b004a7ed1fc5bamr4477554pfi.2.1639490741284;
        Tue, 14 Dec 2021 06:05:41 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id j20sm2245986pjl.3.2021.12.14.06.05.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 06:05:41 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     wells.lu@sunplus.com, vincent.shih@sunplus.com,
        Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v5 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Tue, 14 Dec 2021 22:05:41 +0800
Message-Id: <1639490743-20697-1-git-send-email-wellslutw@gmail.com>
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

 .../bindings/net/sunplus,sp7021-emac.yaml          | 149 +++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  36 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       | 282 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c         | 226 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       | 630 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_driver.h       |  12 +
 drivers/net/ethernet/sunplus/spl2sw_int.c          | 253 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h          |  13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c          | 353 ++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h          |  19 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         | 126 +++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h         |  12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |  92 +++
 drivers/net/ethernet/sunplus/spl2sw_phy.h          |  12 +
 drivers/net/ethernet/sunplus/spl2sw_register.h     |  94 +++
 20 files changed, 2344 insertions(+)
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

