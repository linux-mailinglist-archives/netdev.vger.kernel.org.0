Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60A9677180
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 19:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjAVSZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 13:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjAVSZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 13:25:55 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9729A1E28A;
        Sun, 22 Jan 2023 10:25:54 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id CF12B1C0006;
        Sun, 22 Jan 2023 18:25:48 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Sam Creasey <sammy@sammy.net>,
        Diederik de Haas <didi.debian@cknow.org>,
        netdev@vger.kernel.org (open list:8390 NETWORK DRIVERS
        [WD80x3/SMC-ELITE, SMC-ULT...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net/ethernet: Fix full name of the GPL
Date:   Sun, 22 Jan 2023 19:25:32 +0100
Message-Id: <20230122182533.55188-1-didi.debian@cknow.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
---
 drivers/net/ethernet/8390/mac8390.c      | 2 +-
 drivers/net/ethernet/i825xx/sun3_82586.c | 2 +-
 drivers/net/ethernet/i825xx/sun3_82586.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index 7fb819b9b89a..8b3ddc7ba5a6 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -5,7 +5,7 @@
    Jes Sorensen, and ne2k-pci.c by Donald Becker and Paul Gortmaker.
 
    This software may be used and distributed according to the terms of
-   the GNU Public License, incorporated herein by reference.  */
+   the GNU General Public License, incorporated herein by reference.  */
 
 /* 2000-02-28: support added for Dayna and Kinetics cards by
    A.G.deWijn@phys.uu.nl */
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index 3909c6a0af89..f9595df610d4 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -9,7 +9,7 @@
  * net-3-driver for the NI5210 card (i82586 Ethernet chip)
  *
  * This is an extension to the Linux operating system, and is covered by the
- * same Gnu Public License that covers that work.
+ * same GNU General Public License that covers that work.
  *
  * Alphacode 0.82 (96/09/29) for Linux 2.0.0 (or later)
  * Copyrights (c) 1994,1995,1996 by M.Hipp (hippm@informatik.uni-tuebingen.de)
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.h b/drivers/net/ethernet/i825xx/sun3_82586.h
index d82eca563266..eb1ab3ffd774 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.h
+++ b/drivers/net/ethernet/i825xx/sun3_82586.h
@@ -2,7 +2,7 @@
  * Intel i82586 Ethernet definitions
  *
  * This is an extension to the Linux operating system, and is covered by the
- * same Gnu Public License that covers that work.
+ * same GNU General Public License that covers that work.
  *
  * copyrights (c) 1994 by Michael Hipp (hippm@informatik.uni-tuebingen.de)
  *
-- 
2.39.0

