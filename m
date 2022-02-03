Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D7D4A8220
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350025AbiBCKNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:13:32 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:14272 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiBCKNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:13:31 -0500
Received: from localhost.localdomain (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 213ADCou007747;
        Thu, 3 Feb 2022 02:13:13 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH] MAINTAINERS: Update maintainers for chelsio crypto drivers
Date:   Thu,  3 Feb 2022 15:42:22 +0530
Message-Id: <20220203101222.57121-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the maintainer info for chelsio crypto drivers.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 MAINTAINERS | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb83dcbcb619..95b7463c54cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5174,8 +5174,6 @@ F:	drivers/scsi/cxgbi/cxgb3i
 
 CXGB4 CRYPTO DRIVER (chcr)
 M:	Ayush Sawal <ayush.sawal@chelsio.com>
-M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
-M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
@@ -5183,8 +5181,6 @@ F:	drivers/crypto/chelsio
 
 CXGB4 INLINE CRYPTO DRIVER
 M:	Ayush Sawal <ayush.sawal@chelsio.com>
-M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
-M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
-- 
2.18.2

