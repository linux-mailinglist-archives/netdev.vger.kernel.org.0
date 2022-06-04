Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C7853D7CA
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbiFDQcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 12:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiFDQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 12:32:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C342F2FFF7;
        Sat,  4 Jun 2022 09:32:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so9321430pjf.5;
        Sat, 04 Jun 2022 09:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=feBvHz91O0Ca33nvuwSIX9xdV8Z7lZ5W40GP9R4BSMI=;
        b=LwiGcTyfxTOW9WABE+s7IvGJ6XlZSvazqmpmdyJustl2rnAhLz6BCI7hMhuka1IilF
         i5FMm3jREvV++bz3Je8EO+Y5OLwMnv264mxUdN0S/ex1DhBUWDF0PqhXNJ8BXpzZmpmi
         AjA9ZwunaQ2IcgAvr7XL2/kvBxhrKxNXZB0ykycpL+2XRxJBeNFy4RSKNo3DIhwPhxYU
         PEPrPABnRRw7JsUHWbVG9Bv+hRxHTjM4w0L9O33G2rH496FkcMXmd4HnCoW/87iIa4/F
         RQnGz3AyJuMAuNUvHBuxmjP1xFpKaJvMck0M5yY+/fbFTMcwowT8BYUbmSAs6pimFliN
         yNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=feBvHz91O0Ca33nvuwSIX9xdV8Z7lZ5W40GP9R4BSMI=;
        b=lMXSMb0bg13Nf/pgJ8T1Ou5t18y3AGLRoD6utqtD1X1qX9GJIkktLEszaMXkt48iVb
         Xt5y9dvSnGCMI290/6NgZoGuyHHKlFez4gDltYxPg6MJPdxmAzdNKfblGPYxlTVU+P/t
         W8p3GTNb/9efJXME6fQUH0C/oE4Lj80fkAjKe9x+rNp69JFs05K62WA3R0Mh07pDlK1y
         mnXICOI/NysGXbKjOQbHngRt81raluCbDSfhXo7YG/j5A3mLtA8+S7QDfP3VR3RrB63m
         pcFLhpbEW9BGohdovZ1Ri5uhA5hXwcoSbOe9rnONhbbe7+gaJFj6+zIHWCXeG+zvVmUX
         T96A==
X-Gm-Message-State: AOAM532xqqMtA3+oxzaLqAUxvcds23930lc3Ur8Lhka8yHIYnpXzs0bU
        98AHXb+pg0UanVvCEeat1LuQy73YMw4znQ==
X-Google-Smtp-Source: ABdhPJw/tFtB/fpogoWUXEBp3ozjrY5MVlk78+SuO8TssXthNkp6QPGXQNE49ybo+mYyaBoUSblaCA==
X-Received: by 2002:a17:902:cf0a:b0:156:39c9:4c44 with SMTP id i10-20020a170902cf0a00b0015639c94c44mr15485713plg.124.1654360354184;
        Sat, 04 Jun 2022 09:32:34 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a3b4800b001e34b5ed5a7sm8424874pjf.35.2022.06.04.09.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 09:32:33 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 1/7] can: Kbuild: rename config symbol CAN_DEV into CAN_NETLINK
Date:   Sun,  5 Jun 2022 01:29:54 +0900
Message-Id: <20220604163000.211077-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
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

In the next patches, the scope of the can-dev module will grow to
engloble the software/virtual drivers (slcan, v(x)can). To this
extent, release CAN_DEV by renaming it into CAN_NETLINK. The config
symbol CAN_DEV will be reused to cover this extended scope.

The rationale for the name CAN_NETLINK is that netlink is the
predominant feature added here.

The current description only mentions platform drivers despite the
fact that this symbol is also required by "normal" devices (e.g. USB
or PCI) which do not fall under the platform devices category. The
description is updated accordingly to fix this gap.

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

