Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6759644404D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhKCLGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhKCLGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 07:06:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DAAC061714;
        Wed,  3 Nov 2021 04:03:39 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u33so1917424pfg.8;
        Wed, 03 Nov 2021 04:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=dS65XzKwl8ojyL7MraWTB+GhRIeBZiyjjZmqBKNgxXU=;
        b=JNuUBu9iJsOZrf6/7IHqscb7+EuJwDQ0OpuFD69HpKWfg1ILchqTnaXFQSHR2Wcpal
         7DIkyq2L0C6oPL0TVvTaISBy+hxk+1o54GZ/sbNROi3eoRofpuPKNlKCdSTaYJarHvnf
         O8jU7Gfm9tfhOAm1ZFR7jUiGwVCkPSa2NkArXww78zNCGEuP7zqot3GHhw5rGp4VcMWj
         zWauQ26Uwbpq1VE0/Emkmb/+Ha5KXaZWgTzY50s/gZsZIDOc/+C/RPrjysKO+hxbdAP9
         +wOIA87yW17ZbUCFm25Y/Y+cofA6qCMTSwfgGOCArGZbvLIQTvKzZNKVqHj5N0RW84Ep
         ViEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dS65XzKwl8ojyL7MraWTB+GhRIeBZiyjjZmqBKNgxXU=;
        b=rsH/NKW6dmju/9g7JnAFT+xE9fE5jN569ujb0HcyMD+woeQFjag7KjCDteq5D2ZjGc
         ndmECqqXyAVrhTkwXveErc8227fEe9IhCdKVezDVW5cVC5xT7j1L+WqM4o53bk463pmm
         ve6aq5RTr346u2epvEZehXXm/lKwF1pj4UPCm69TX6/qXSpoVK4K4VzSjnVGTS1Z+Uwd
         eBfo3z0++ZzAmRv1Kxmje6URBWbcs5RllFmCCb+sOFT7msiu7K8U1bIty/B/XZFzIQ9U
         vawlWwFZmfV/xNqlb9g8ZG0br0UQgrVUJW054H26pMk/AOemgjfvZbW6o8u5Np1qoMXS
         WJiA==
X-Gm-Message-State: AOAM533V6yM+PSAQaokOCHfDdMb94tXcPBIA54I6NL8ZX+9vV8CuM6G+
        WCCw4qccRT1y3Eh3vxLBxFdH7StxEwrO9w==
X-Google-Smtp-Source: ABdhPJw5AUqpkml2iG7TZlH5rZS/44z1sfz/0KwdKfFbn7lGBYSq2PYjFFbGzh2ZjZuHtYua3eRHjA==
X-Received: by 2002:a62:384a:0:b0:481:2fd1:98ad with SMTP id f71-20020a62384a000000b004812fd198admr8591324pfa.29.1635937419363;
        Wed, 03 Nov 2021 04:03:39 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id qe16sm2440222pjb.5.2021.11.03.04.03.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Nov 2021 04:03:38 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
X-Google-Original-From: Wells Lu <wells.lu@sunplus.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     Wells Lu <wells.lu@sunplus.com>
Subject: [PATCH 0/2] This is a patch series of ethernet driver for Sunplus SP7021 SoC.
Date:   Wed,  3 Nov 2021 19:02:43 +0800
Message-Id: <cover.1635936610.git.wells.lu@sunplus.com>
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

 .../bindings/net/sunplus,sp7021-l2sw.yaml          | 123 ++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  20 +
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/l2sw_define.h         | 221 ++++++
 drivers/net/ethernet/sunplus/l2sw_desc.c           | 233 ++++++
 drivers/net/ethernet/sunplus/l2sw_desc.h           |  21 +
 drivers/net/ethernet/sunplus/l2sw_driver.c         | 779 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/l2sw_driver.h         |  23 +
 drivers/net/ethernet/sunplus/l2sw_hal.c            | 422 +++++++++++
 drivers/net/ethernet/sunplus/l2sw_hal.h            |  47 ++
 drivers/net/ethernet/sunplus/l2sw_int.c            | 326 +++++++++
 drivers/net/ethernet/sunplus/l2sw_int.h            |  16 +
 drivers/net/ethernet/sunplus/l2sw_mac.c            |  68 ++
 drivers/net/ethernet/sunplus/l2sw_mac.h            |  24 +
 drivers/net/ethernet/sunplus/l2sw_mdio.c           | 118 ++++
 drivers/net/ethernet/sunplus/l2sw_mdio.h           |  19 +
 drivers/net/ethernet/sunplus/l2sw_register.h       |  99 +++
 20 files changed, 2575 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_register.h

-- 
2.7.4

