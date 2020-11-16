Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6512B4199
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgKPKon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:44:43 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:64294 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729381AbgKPKon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:44:43 -0500
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0AGAiVbL021544;
        Mon, 16 Nov 2020 02:44:32 -0800
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ramaraju@chelsio.com,
        rahul.lakkireddy@chelsio.com, rajur@chelsio.com
Subject: [PATCH net] MAINTAINERS: update cxgb4 and cxgb3 maintainer
Date:   Mon, 16 Nov 2020 16:13:22 +0530
Message-Id: <20201116104322.3959-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update cxgb4 and cxgb3 driver maintainer

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a34b25ecc1f..a72d35490cbf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4710,7 +4710,7 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 F:	drivers/media/dvb-frontends/cxd2820r*
 
 CXGB3 ETHERNET DRIVER (CXGB3)
-M:	Vishal Kulkarni <vishal@chelsio.com>
+M:	Raju Rangoju <rajur@chelsio.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
@@ -4742,7 +4742,7 @@ W:	http://www.chelsio.com
 F:	drivers/net/ethernet/chelsio/inline_crypto/
 
 CXGB4 ETHERNET DRIVER (CXGB4)
-M:	Vishal Kulkarni <vishal@chelsio.com>
+M:	Raju Rangoju <rajur@chelsio.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
@@ -4764,7 +4764,7 @@ F:	drivers/infiniband/hw/cxgb4/
 F:	include/uapi/rdma/cxgb4-abi.h
 
 CXGB4VF ETHERNET DRIVER (CXGB4VF)
-M:	Vishal Kulkarni <vishal@gmail.com>
+M:	Raju Rangoju <rajur@chelsio.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
-- 
2.9.5

