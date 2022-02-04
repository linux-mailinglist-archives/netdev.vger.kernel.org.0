Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C874A9571
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 09:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiBDIsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 03:48:15 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:14750 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiBDIsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 03:48:15 -0500
Received: from localhost.localdomain (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 2148m4Nd008578;
        Fri, 4 Feb 2022 00:48:05 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH V2] MAINTAINERS: Update maintainers for chelsio crypto drivers
Date:   Fri,  4 Feb 2022 14:17:36 +0530
Message-Id: <20220204084736.105975-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the maintainer info for chelsio crypto drivers.

V2:
This updates the maintainers for CXGB4 INLINE CRYPTO DRIVER.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb83dcbcb619..61ccc887e9a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5183,8 +5183,6 @@ F:	drivers/crypto/chelsio
 
 CXGB4 INLINE CRYPTO DRIVER
 M:	Ayush Sawal <ayush.sawal@chelsio.com>
-M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
-M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
-- 
2.18.2

