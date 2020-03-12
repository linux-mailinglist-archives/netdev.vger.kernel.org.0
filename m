Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA01182F77
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 12:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCLLnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 07:43:05 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:28798 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLLnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 07:43:05 -0400
Received: from fcoe-test9.blr.asicdesigners.com (fcoe-test9.blr.asicdesigners.com [10.193.185.176])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02CBgwmY018472;
        Thu, 12 Mar 2020 04:42:59 -0700
From:   Shahjada Abul Husain <shahjada@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, shahjada@chelsio.com
Subject: [PATCH net-next] cxgb4: update T5/T6 adapter register ranges
Date:   Thu, 12 Mar 2020 17:12:40 +0530
Message-Id: <20200312114240.12862-1-shahjada@chelsio.com>
X-Mailer: git-send-email 2.23.0.256.g4c86140
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more T5/T6 registers to be collected in register dump:

1. MPS register range 0x9810 to 0x9864 and 0xd000 to 0xd004.
2. NCSI register range 0x1a114 to 0x1a130 and 0x1a138 to 0x1a1c4.

Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 844fdcf55118..df97200c52ee 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -1379,8 +1379,7 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x9608, 0x9638,
 		0x9640, 0x96f4,
 		0x9800, 0x9808,
-		0x9820, 0x983c,
-		0x9850, 0x9864,
+		0x9810, 0x9864,
 		0x9c00, 0x9c6c,
 		0x9c80, 0x9cec,
 		0x9d00, 0x9d6c,
@@ -1389,7 +1388,7 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x9e80, 0x9eec,
 		0x9f00, 0x9f6c,
 		0x9f80, 0xa020,
-		0xd004, 0xd004,
+		0xd000, 0xd004,
 		0xd010, 0xd03c,
 		0xdfc0, 0xdfe0,
 		0xe000, 0x1106c,
@@ -1430,10 +1429,8 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x1a0b0, 0x1a0e4,
 		0x1a0ec, 0x1a0f8,
 		0x1a100, 0x1a108,
-		0x1a114, 0x1a120,
-		0x1a128, 0x1a130,
-		0x1a138, 0x1a138,
-		0x1a190, 0x1a1c4,
+		0x1a114, 0x1a130,
+		0x1a138, 0x1a1c4,
 		0x1a1fc, 0x1a1fc,
 		0x1e008, 0x1e00c,
 		0x1e040, 0x1e044,
@@ -2162,8 +2159,7 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x9640, 0x9704,
 		0x9710, 0x971c,
 		0x9800, 0x9808,
-		0x9820, 0x983c,
-		0x9850, 0x9864,
+		0x9810, 0x9864,
 		0x9c00, 0x9c6c,
 		0x9c80, 0x9cec,
 		0x9d00, 0x9d6c,
@@ -2172,7 +2168,7 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x9e80, 0x9eec,
 		0x9f00, 0x9f6c,
 		0x9f80, 0xa020,
-		0xd004, 0xd03c,
+		0xd000, 0xd03c,
 		0xd100, 0xd118,
 		0xd200, 0xd214,
 		0xd220, 0xd234,
@@ -2240,10 +2236,8 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x1a0b0, 0x1a0e4,
 		0x1a0ec, 0x1a0f8,
 		0x1a100, 0x1a108,
-		0x1a114, 0x1a120,
-		0x1a128, 0x1a130,
-		0x1a138, 0x1a138,
-		0x1a190, 0x1a1c4,
+		0x1a114, 0x1a130,
+		0x1a138, 0x1a1c4,
 		0x1a1fc, 0x1a1fc,
 		0x1e008, 0x1e00c,
 		0x1e040, 0x1e044,
-- 
2.23.0.256.g4c86140

