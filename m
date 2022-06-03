Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4400953C8B0
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243769AbiFCKaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243719AbiFCK35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:29:57 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDBD3BA43;
        Fri,  3 Jun 2022 03:29:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c14so6870614pgu.13;
        Fri, 03 Jun 2022 03:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Xl6xu0Aw25nnxFjpI/ytCht+0ZMiXtWlwE+X5IO8Rw=;
        b=cH0fbl6gjR8G2h0T06PeQ48eHX+R4+HoCrYF+3y4VdM3+ZoYizHOh9iBwlijNo4EKo
         L3gXnroQWbHI/nTFzDDulkL3VccduQ8TtEWA0hDF25/Nf1ujpySz+0agM8TB2v/Ksh9R
         lLqlyiUjUjNvNpfxXzoQdLeOi3S1zjB4UwMUilRxPUQnKr1Ge26ctDuk8dd3k6ms2pGX
         L9o9OpEjVHMlkQaI/3Ryyr9EQc4ah3PFUdPf9K4fjILPr+HX9UmauQuVl5vCq4uPBJnw
         /6eIBnw2LCBJEM8jIQwIZRoQWL6hsMyjmFK2NNbiAVfaZuS49RWqSDDYg7eUAPAP6in5
         2FvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=0Xl6xu0Aw25nnxFjpI/ytCht+0ZMiXtWlwE+X5IO8Rw=;
        b=inoObU1yMeisw7nkkr/aPXhQMA1TZxYmgN8Di36Wxx0xl0rEtJa4LW5E/96xUoADmI
         99WjoiN7hagCNFObl8DMaN9NcyA31cAxVV+WN/XBQ6Bqj6ZRSDIxHLiTFGjZJFNhD/ih
         rqc8M3/L89FufuC+t+nn2+j8V/lMwuB/rtUzDQ2t1U0BzGlwoUi9rVzDEOWkzDRiG3bN
         sdSSOGgB+eYoj56Kbbkk/ySwd4mFAWMzZ3SIPi9gQTjdlxc2DMPSrqVo2FUjBPyKSVpg
         k09P3gNfI7/r1nHlxXBAjFAlgmw5wkxje7IfBIWJp98JjpjooZ+YFDFNaxFRSwklpSSs
         /I0A==
X-Gm-Message-State: AOAM5314ClbxxAABzx1AA9qXfEZzmAPHNiGk/LhLXOI0u3RIn7oFEpmE
        1P/bYZTIXCMuHJmo2z4GVTY=
X-Google-Smtp-Source: ABdhPJyqR9UwyNCCAVCui8LXCFOIVVG40hhX79nLDfF9eT69veYyiVFukEK2JlvpAFncfA8+zQ+pcA==
X-Received: by 2002:a63:1c7:0:b0:3fb:cff3:f327 with SMTP id 190-20020a6301c7000000b003fbcff3f327mr8225710pgb.571.1654252195996;
        Fri, 03 Jun 2022 03:29:55 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id b22-20020a056a0002d600b0050dc7628182sm3041676pft.92.2022.06.03.03.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:29:55 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 5/7] net: Kconfig: move the CAN device menu to the "Device Drivers" section
Date:   Fri,  3 Jun 2022 19:28:46 +0900
Message-Id: <20220603102848.17907-6-mailhol.vincent@wanadoo.fr>
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

The devices are meant to be under the "Device Drivers" category of the
menuconfig. The CAN subsystem is currently one of the rare exception
with all of its devices under the "Networking support" category.

The CAN_DEV menuentry gets moved to fix this discrepancy. The CAN menu
is added just before MCTP in order to be consistent with the current
order under the "Networking support" menu.

A dependency on CAN is added to CAN_DEV so that the CAN devices only
show up if the CAN subsystem is enabled.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/Kconfig     | 2 ++
 drivers/net/can/Kconfig | 1 +
 net/can/Kconfig         | 5 ++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b2a4f998c180..5de243899de8 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -499,6 +499,8 @@ config NET_SB1000
 
 source "drivers/net/phy/Kconfig"
 
+source "drivers/net/can/Kconfig"
+
 source "drivers/net/mctp/Kconfig"
 
 source "drivers/net/mdio/Kconfig"
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 1f1d81da1c8c..4ab80507c353 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -3,6 +3,7 @@
 menuconfig CAN_DEV
 	tristate "CAN Device Drivers"
 	default y
+	depends on CAN
 	help
 	  Controller Area Network (CAN) is serial communications protocol up to
 	  1Mbit/s for its original release (now known as Classical CAN) and up
diff --git a/net/can/Kconfig b/net/can/Kconfig
index a9ac5ffab286..cb56be8e3862 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -15,7 +15,8 @@ menuconfig CAN
 	  PF_CAN is contained in <Documentation/networking/can.rst>.
 
 	  If you want CAN support you should say Y here and also to the
-	  specific driver for your controller(s) below.
+	  specific driver for your controller(s) under the Network device
+	  support section.
 
 if CAN
 
@@ -69,6 +70,4 @@ config CAN_ISOTP
 	  If you want to perform automotive vehicle diagnostic services (UDS),
 	  say 'y'.
 
-source "drivers/net/can/Kconfig"
-
 endif
-- 
2.35.1

