Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387421F9DBA
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgFOQm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbgFOQmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:42:55 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEE1C061A0E;
        Mon, 15 Jun 2020 09:42:55 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id x25so5071430edr.8;
        Mon, 15 Jun 2020 09:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L92fq33nqzq0VJxoYFBOkUey07sS0DeHdh+aBwRYdtY=;
        b=a9caaMjILEkWqJIQOvtpf++raUfUUZZ09h7gQGAs7Mjd5NbUmqd0eALkXOV3Vf/pHy
         GmFcCJ3rFekyFp0wMtSEZC88libqTjpviaAfOlc/unQziVu7m6tA5cZ6Om3rd1+zcbDd
         dhxHu/ZpDFppPPBvxuTz3MiPmL39ppEOsPhfGvueoOqI+CpfkJM3jr8Xqn0emJ4iqtjQ
         XoXMsvVjAcmJNQfZqNU66bXk2YPFG10C/lQIdciZjDDOm8+mspVuOBR1OcbfxiKmA0me
         SdQYhP3CO9bVEz/4JU3z7XaKy+wUYvv0D/7+bQF22ttR/pGIC3E1Qde89if0X2nRfHgp
         tTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L92fq33nqzq0VJxoYFBOkUey07sS0DeHdh+aBwRYdtY=;
        b=bItVvW5DylUP5HQFswVn3JZkcRkS4sydNg69pJ+NULKFut0w+QCc1VcU2NvqMWWMpH
         SiZhHbBf4ipauph35Aew3dt5JKNmChJcCgfAOmFlBpbJsbcAZjpN57U9aJlKd4gZlEVf
         89tlBjHFHqz3yAAcMKfkPWLSQ6UjC7ERuANQ8sOAtM910JYBDNkAiHWuOhx2TPoXY5q7
         ypH6NO/LYG8oBorF0DOG8oftNu+GkoBSd8jhSINlj8/V23wkoDI7sI5xOL5TogdfFmlA
         7e9fYKcJ+470grNxp91FhwynGpXhr9Jqm0YX/9s4/N5xB2L/mz4kY1YgQw6UCI2noShj
         VjZQ==
X-Gm-Message-State: AOAM531axHnN4opAWkrXggpM9iuy6WVcr4kbsJPLiZLjgxuyEj4FUYI0
        elaMmaWuELDybbcvquTB3Ac=
X-Google-Smtp-Source: ABdhPJy+7pkfjBD37Fxes1/82V3io3wxWkG/aR1sRWnXcXun0Qy3ETzxWP47I1WtRS0X2yG/0KNK1Q==
X-Received: by 2002:a50:ba8b:: with SMTP id x11mr24914397ede.201.1592239373922;
        Mon, 15 Jun 2020 09:42:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o5sm9327969eje.66.2020.06.15.09.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 09:42:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] MAINTAINERS: merge entries for felix and ocelot drivers
Date:   Mon, 15 Jun 2020 19:42:44 +0300
Message-Id: <20200615164244.2012128-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot switchdev driver also provides a set of library functions for
the felix DSA driver, which in practice means that most of the patches
will be of interest to both groups of driver maintainers.

So, as also suggested in the discussion here, let's merge the 2 entries
into a single larger one:
https://www.spinics.net/lists/netdev/msg657412.html

Note that the entry has been renamed into "OCELOT SWITCH" since neither
Vitesse nor Microsemi exist any longer as company names, instead they
are now named Microchip (which again might be subject to change in the
future), so use the device family name instead.

Suggested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 MAINTAINERS | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f08f290df174..25be0066e345 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11339,14 +11339,6 @@ L:	dmaengine@vger.kernel.org
 S:	Supported
 F:	drivers/dma/at_xdmac.c
 
-MICROSEMI ETHERNET SWITCH DRIVER
-M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
-L:	netdev@vger.kernel.org
-S:	Supported
-F:	drivers/net/ethernet/mscc/
-F:	include/soc/mscc/ocelot*
-
 MICROSEMI MIPS SOCS
 M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
 M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
@@ -12305,6 +12297,18 @@ M:	Peter Zijlstra <peterz@infradead.org>
 S:	Supported
 F:	tools/objtool/
 
+OCELOT ETHERNET SWITCH DRIVER
+M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+M:	Vladimir Oltean <vladimir.oltean@nxp.com>
+M:	Claudiu Manoil <claudiu.manoil@nxp.com>
+M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/dsa/ocelot/*
+F:	drivers/net/ethernet/mscc/
+F:	include/soc/mscc/ocelot*
+F:	net/dsa/tag_ocelot.c
+
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
 M:	Frederic Barrat <fbarrat@linux.ibm.com>
 M:	Andrew Donnellan <ajd@linux.ibm.com>
@@ -18188,14 +18192,6 @@ S:	Maintained
 F:	drivers/input/serio/userio.c
 F:	include/uapi/linux/userio.h
 
-VITESSE FELIX ETHERNET SWITCH DRIVER
-M:	Vladimir Oltean <vladimir.oltean@nxp.com>
-M:	Claudiu Manoil <claudiu.manoil@nxp.com>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/net/dsa/ocelot/*
-F:	net/dsa/tag_ocelot.c
-
 VIVID VIRTUAL VIDEO DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
2.25.1

