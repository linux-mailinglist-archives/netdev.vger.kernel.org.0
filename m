Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C151C5271CF
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 16:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbiENORe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 10:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiENORd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 10:17:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2387E65E1;
        Sat, 14 May 2022 07:17:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w17-20020a17090a529100b001db302efed6so10255781pjh.4;
        Sat, 14 May 2022 07:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HSCzIPZkOxbd67rvgI4t0yXSJkSPovXcOUQj8kg1kKM=;
        b=m1mqQs09ODnGkFJ2JeZTElntbNA5L0Y/sNeehpQQMOhaMCKdKccl4uTGgDp2sEHulg
         1cCAkcPSrbyZ8KgnP4urcVFN6UQhMr1mzeauyfgGVvMUGu8DiEmVHuYIQZ21QYf9o6+l
         LIqcODAOPPqnMi5t/csL2oxvgOx79Txy89p+pS7h4mFpBZKxCDBItp61HIIP02jAip/V
         1iso2r8ZBhkukozh78Mw68J/ZUZg6s8O+zSf+eBzzTpp9szZXp7zpQms30JdRkVkT7Rf
         PNaPle5E+ZkStXq8zX3ayYMJU2tDL7ewQxWIvq2WSlTJJ4kP8lQ752PadkRBa4vw7RQA
         Tdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=HSCzIPZkOxbd67rvgI4t0yXSJkSPovXcOUQj8kg1kKM=;
        b=bP2RMeY/OS5aJlU9ufE/1gG1QMt9o08jTSLIKwhkfXxBQZHmtYj0toFC3oYNYW4t1j
         NsjzrTWJJZCjpMxLpvq1unvWD2EA8eKA1W2AGCLc2Mn5wbHonOzU7tMnSwwAm9V8MFNn
         LOE8FKJw0kTAuU1kFjZhc1wrE0qSZFkQkLldQVG1TOVi2vCYJgBeNqgTUsW4PNQnZwCu
         fJz8itWnWJpPwjP4U/vKp9YxKWIlw+MzSVlIY7m1Onsyo/nn7YT772VDA8HmZZU8PWM6
         uGj3S8dCrwvyW25KBem5dHGKTjUA5Ucq8mhsinlmzjOFPP9/RecmBLmOXwY0k//tEQo6
         QSyA==
X-Gm-Message-State: AOAM532yM7g9OCbjokFnaXyzoRYn3oICmnIbemo9EounfdopZ46U37oc
        TSw9GzmQdlJM0Y0RZvP6MLA=
X-Google-Smtp-Source: ABdhPJzo1AQqaSYYrdBV+tKqIdcFTE6whcQ2CsUdcqMHD6dBFSYcsMdHh9HRQQB7q172F+ZPWWEqqA==
X-Received: by 2002:a17:90b:4f49:b0:1dc:1762:4e00 with SMTP id pj9-20020a17090b4f4900b001dc17624e00mr20941615pjb.87.1652537851522;
        Sat, 14 May 2022 07:17:31 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a530800b001cd4989feccsm5298541pjh.24.2022.05.14.07.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:17:31 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 2/4] can: Kconfig: change CAN_DEV into a menuconfig
Date:   Sat, 14 May 2022 23:16:48 +0900
Message-Id: <20220514141650.1109542-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
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

Currently, only slcan, vcan and vxcan do not depend on CAN_DEV. This
is going to change in the next patch when can_dropped_invalid_skb()
will be moved into skb.c.

In prevision to that, move CAN_DEV one rank up by making it a
menuconfig. The description of CAN_DEV is updated accordingly.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/Kconfig | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index fff259247d52..9bddccfaa0c5 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -1,5 +1,22 @@
 # SPDX-License-Identifier: GPL-2.0-only
-menu "CAN Device Drivers"
+
+menuconfig CAN_DEV
+	tristate "CAN Device Drivers"
+	default y
+	help
+	  This section contains all the CAN device drivers including
+	  the virtual ones.
+
+	  Saying Y here enables the common framework for platform CAN
+	  drivers with Netlink support. This is the standard library
+	  for CAN drivers.
+
+	  To compile as a module, choose M here: the module will be
+	  called can_dev.
+
+	  If unsure, say Y.
+
+if CAN_DEV
 
 config CAN_VCAN
 	tristate "Virtual Local CAN Interface (vcan)"
@@ -48,16 +65,6 @@ config CAN_SLCAN
 	  can be changed by the 'maxdev=xx' module option. This driver can
 	  also be built as a module. If so, the module will be called slcan.
 
-config CAN_DEV
-	tristate "Platform CAN drivers with Netlink support"
-	default y
-	help
-	  Enables the common framework for platform CAN drivers with Netlink
-	  support. This is the standard library for CAN drivers.
-	  If unsure, say Y.
-
-if CAN_DEV
-
 config CAN_CALC_BITTIMING
 	bool "CAN bit-timing calculation"
 	default y
@@ -180,8 +187,6 @@ source "drivers/net/can/softing/Kconfig"
 source "drivers/net/can/spi/Kconfig"
 source "drivers/net/can/usb/Kconfig"
 
-endif
-
 config CAN_DEBUG_DEVICES
 	bool "CAN devices debugging messages"
 	help
@@ -190,4 +195,4 @@ config CAN_DEBUG_DEVICES
 	  a problem with CAN support and want to see more of what is going
 	  on.
 
-endmenu
+endif
-- 
2.35.1

