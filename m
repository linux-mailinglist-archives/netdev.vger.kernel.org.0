Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5F363B668
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbiK2AKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiK2AKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:10:17 -0500
X-Greylist: delayed 3306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 16:10:15 PST
Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCF4DD;
        Mon, 28 Nov 2022 16:10:15 -0800 (PST)
Received: from beagle8.blr.asicdesigners.com (beagle8.blr.asicdesigners.com [10.193.80.125])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 2ASNEj99013901;
        Mon, 28 Nov 2022 15:14:46 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        fmdefrancesco@gmail.com, anirudh.venkataramanan@intel.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH] MAINTAINERS: Update maintainer list for chelsio drivers
Date:   Tue, 29 Nov 2022 04:43:48 +0530
Message-Id: <20221128231348.8225-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.18.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the maintainers for chelsio inline crypto drivers and
chelsio crypto drivers.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 MAINTAINERS | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61fe86968111..fbcd630e658f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5586,8 +5586,6 @@ F:	drivers/scsi/cxgbi/cxgb3i
 
 CXGB4 CRYPTO DRIVER (chcr)
 M:	Ayush Sawal <ayush.sawal@chelsio.com>
-M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
-M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
@@ -5595,8 +5593,6 @@ F:	drivers/crypto/chelsio
 
 CXGB4 INLINE CRYPTO DRIVER
 M:	Ayush Sawal <ayush.sawal@chelsio.com>
-M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
-M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
-- 
2.18.1

