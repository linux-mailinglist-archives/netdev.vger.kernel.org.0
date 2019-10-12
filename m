Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759ECD4F9B
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 14:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfJLMTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 08:19:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36913 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbfJLMTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 08:19:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so7340595pgi.4;
        Sat, 12 Oct 2019 05:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=de7pMEs9LKVtJo6O4/BRSw82wkOMM20mHerUxCwWeQY=;
        b=JFofZzk0nuklgTFaynlcoaNch2ZDGDf+S07DhtVnM5Sn/FgWeQYT6OGmdh+HzuYiG7
         LLe8s5iLeSnUXLv8/ANLlBLEwiYamBhYuGUTiwR2OR1G1udGKe0orLsMMwV9RmoR0d5w
         yJamoMq0YFsWVmNCsAzPwRbHTEIufuQr73WsGFvMi83iHIzUTD8Z3byWweoF4iqYD1Vy
         nAMk1e+GYP1IgESULoC6dEShMPNjPz3CY6ruGRwKSPXPO4tkMLgRSkK/TLLTD3HEwf7+
         jNapwROPFGapGnPete58TTpBjuTY1ukZns05AS8Jpyp+jWEsedj9z6Z9gHGreNRXyPrX
         uczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=de7pMEs9LKVtJo6O4/BRSw82wkOMM20mHerUxCwWeQY=;
        b=kRH5Bq7OTfZT/9Qtmi18UfFa1r0E430HNvV5Oj8ERkbSJL3XI9vxcHVuDbhK0zOyNh
         ipVeGs5JOAyw6SieulJ5S3TTTNoUls5axqBBdPcxVSw+1qCr08169CSXstzHU+ACbhZd
         dsZwkrUYC+EpD7xfIVKknWTlYmFwTWp2y+igkFxWeKIoSk9U1bSvVMdvlidGPBO42kr8
         ZtwJCoKiM8gOmYPTlTp3Le2lq4PzKmh+M0lltxd1mmVJm0qpt5CEqbFW0fjn8MwUuhFu
         RzfGN4/JUxI7QzmvpYeADQURCe58071EYezcgiwacQwQGx+zaAIVhB5fnorIbY97eI8P
         zw7w==
X-Gm-Message-State: APjAAAWSp+RnaYPfDv0b2jRZt5PwMKb0ROSJ/GKDlT5cYDVbPtMD/hXy
        qt35nk2WRrvxIdBzPPoikl0=
X-Google-Smtp-Source: APXvYqw2upToKCdi3nWsBIIzZmW7ZApdif7r/c5nG6W5vmA4NOvZeQtxpFvVfwaYywKuonkjq/b0+g==
X-Received: by 2002:a62:e40d:: with SMTP id r13mr21924401pfh.135.1570882745895;
        Sat, 12 Oct 2019 05:19:05 -0700 (PDT)
Received: from nishad ([2406:7400:54:9230:b578:2290:e0c4:6e96])
        by smtp.gmail.com with ESMTPSA id d11sm2567387pfo.104.2019.10.12.05.19.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 12 Oct 2019 05:19:05 -0700 (PDT)
Date:   Sat, 12 Oct 2019 17:48:56 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: microchip: Use the correct style for SPDX License
 Identifier
Message-ID: <20191012121852.GA6071@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style
in header files related to Distributed Switch Architecture
drivers for Microchip KSZ series switch support.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477_reg.h | 4 ++--
 drivers/net/dsa/microchip/ksz_common.h  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 2938e892b631..16939f29faa5 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
  * Microchip KSZ9477 register definitions
  *
  * Copyright (C) 2017-2018 Microchip Technology Inc.
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index dd60d0837fc6..64c2677693d2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Microchip switch driver common header
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip switch driver common header
  *
  * Copyright (C) 2017-2019 Microchip Technology Inc.
  */
-- 
2.17.1

