Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A8453C8BA
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbiFCK32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243662AbiFCK31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:29:27 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999893BA47;
        Fri,  3 Jun 2022 03:29:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d12-20020a17090abf8c00b001e2eb431ce4so6912090pjs.1;
        Fri, 03 Jun 2022 03:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OAzqFSeGawzZvXT7dH0M+6XyxMAQAoLYxatmC4o6MuM=;
        b=Vtt3oW12TJSpEmc6BbX1Q7Sgg9gXtFxTD9WRloXBEdty3tE6s6hGpEHJEmN1kGRpz7
         O5ErQkkpI7wIoflk1XJcYTqnmjUYvY7rYG6hsDGozUCSVDjemUHQoReimfPbUSw0DXqi
         KtG5vRg9yQDGcZXnViCAJNaGRuVhTGxi57epBzGlav83NCOnwqOHC7Fdxnh09EgXV3Cq
         YXz1oDorIMirgl/2GgExha5UbFl8Fh6xLSJQAFzZrqEenJ5tP+f9o6dIri+bGBWyoj2o
         zmvGvN294uGDu1wP8vdnSAvI/XEgWpZaSMMqsFKVxbocc7oxjePka2N9NYscNJFtmRa1
         CF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=OAzqFSeGawzZvXT7dH0M+6XyxMAQAoLYxatmC4o6MuM=;
        b=yiOgqrDwWszSznEa9A65Y/83C5eGqT+TSiLziNHdDi/7qD5jy70Lnk+TUVF36SlYRf
         7qbviCzs/VdD75DZlW/fpM4nJ2Za0dihHNERm7d9rHijeYPyh6jpatqy5fPJRP1uhqQg
         rg4zvdxHmxEsMEjvicCIV3pepvuyD/JWbFJ4xNjwakXl/ZXTbewc712LJl9q/b1fGH/l
         5AxXyDkq6Z174P9nEIXOSaiYUX/Wg9U3e4srCEYEJEVIhjYw5rqyzWIPt2nWX0gIlFxm
         L+JAXWMx5GGwD6wvyaXbT2qW0inkA4jctPuhlX143hFAiHz5GdmxlcvJBDNqk3xiQ6td
         ekLg==
X-Gm-Message-State: AOAM531vhCnIabRQyIlOEE1I8WTvcKisYSjFCD3IQTLR/SNCrFpiJ+p5
        O1bYdyq1J65wK0VtLFYPS9bjHOA8TmwLpw==
X-Google-Smtp-Source: ABdhPJxhWYYsNGHaQ21EEPYsG1lnZNam/n4ZLV6wvAgjz6qLUxrlWMrSiOm9wwuivXMTxNm2NUt7ew==
X-Received: by 2002:a17:902:f815:b0:163:c524:e475 with SMTP id ix21-20020a170902f81500b00163c524e475mr9663297plb.37.1654252163965;
        Fri, 03 Jun 2022 03:29:23 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id b22-20020a056a0002d600b0050dc7628182sm3041676pft.92.2022.06.03.03.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:29:23 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 1/7] can: Kbuild: rename config symbol CAN_DEV into CAN_NETLINK
Date:   Fri,  3 Jun 2022 19:28:42 +0900
Message-Id: <20220603102848.17907-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the next patches, the scope of the can_dev module will grow to
engloble the software/virtual drivers (slcan, v(x)can). To this
extent, release CAN_DEV by renaming it into CAN_NETLINK. The config
symbol CAN_DEV will be reused to cover this extended scope.

The rationale for the name CAN_NETLINK is that netlink is the
predominant feature added here.

The current description only mentions platform drivers despite the
fact that this symbol is also required by "normal" devices (e.g. USB
or PCI) which do not fall under the platform devices category.

The description is updated accordingly to fix this gap.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Please share if you have any suggestion on the name. I hesitated a lot
between CAN_NETLINK or CAN_DEV_NETLINK (because netlink is the
predominant feature) and CAN_DEV_HW (because this targets the
non-software only drivers, i.e. the hardware ones).
---
 drivers/net/can/Kconfig      | 18 +++++++++++-------
 drivers/net/can/dev/Makefile |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index b2dcc1e5a388..99f189ad35ad 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -48,15 +48,19 @@ config CAN_SLCAN
 	  can be changed by the 'maxdev=xx' module option. This driver can
 	  also be built as a module. If so, the module will be called slcan.
 
-config CAN_DEV
-	tristate "Platform CAN drivers with Netlink support"
+config CAN_NETLINK
+	tristate "CAN device drivers with Netlink support"
 	default y
 	help
-	  Enables the common framework for platform CAN drivers with Netlink
-	  support. This is the standard library for CAN drivers.
-	  If unsure, say Y.
+	  Enables the common framework for CAN device drivers. This is the
+	  standard library and provides features for the Netlink interface such
+	  as bittiming validation, support of CAN error states, device restart
+	  and others.
+
+	  This is required by all platform and hardware CAN drivers. If you
+	  plan to use such devices or if unsure, say Y.
 
-if CAN_DEV
+if CAN_NETLINK
 
 config CAN_CALC_BITTIMING
 	bool "CAN bit-timing calculation"
@@ -164,7 +168,7 @@ source "drivers/net/can/softing/Kconfig"
 source "drivers/net/can/spi/Kconfig"
 source "drivers/net/can/usb/Kconfig"
 
-endif
+endif #CAN_NETLINK
 
 config CAN_DEBUG_DEVICES
 	bool "CAN devices debugging messages"
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index af2901db473c..5b4c813c6222 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CAN_DEV)		+= can-dev.o
+obj-$(CONFIG_CAN_NETLINK) += can-dev.o
 can-dev-y			+= bittiming.o
 can-dev-y			+= dev.o
 can-dev-y			+= length.o
-- 
2.35.1

