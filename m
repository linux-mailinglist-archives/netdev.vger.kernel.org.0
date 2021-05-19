Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78C38876B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhESGTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:19:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3035 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbhESGTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 02:19:03 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlMzy0615zmXGT;
        Wed, 19 May 2021 14:15:26 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 14:17:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 14:17:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/5] net: e1000: remove repeated words for e1000_hw.c
Date:   Wed, 19 May 2021 14:14:42 +0800
Message-ID: <1621404885-20075-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
References: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

There are double "in" and "to" in comments, so remove the redundant one.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 19cf36360933..1042e79a1397 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -2522,7 +2522,7 @@ s32 e1000_check_for_link(struct e1000_hw *hw)
 				 * turn it on. For compatibility with a TBI link
 				 * partner, we will store bad packets. Some
 				 * frames have an additional byte on the end and
-				 * will look like CRC errors to to the hardware.
+				 * will look like CRC errors to the hardware.
 				 */
 				if (!hw->tbi_compatibility_on) {
 					hw->tbi_compatibility_on = true;
@@ -2723,7 +2723,7 @@ static void e1000_shift_out_mdi_bits(struct e1000_hw *hw, u32 data, u16 count)
  * e1000_shift_in_mdi_bits - Shifts data bits in from the PHY
  * @hw: Struct containing variables accessed by shared code
  *
- * Bits are shifted in in MSB to LSB order.
+ * Bits are shifted in MSB to LSB order.
  */
 static u16 e1000_shift_in_mdi_bits(struct e1000_hw *hw)
 {
-- 
2.8.1

