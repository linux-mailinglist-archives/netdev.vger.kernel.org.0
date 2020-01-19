Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2086E141E2A
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgASN0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:26:35 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:44306 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbgASN0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 08:26:35 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DDBCC9ECDC1DC337FF24;
        Sun, 19 Jan 2020 21:26:33 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sun, 19 Jan 2020 21:26:24 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH -next] i40e: remove unnecessary conversions to bool
Date:   Sun, 19 Jan 2020 21:21:38 +0800
Message-ID: <20200119132138.37781-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversions to bool are not needed, remove these.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 33912cf..24cacfa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1630,7 +1630,7 @@ static int i40e_config_rss_aq(struct i40e_vsi *vsi, const u8 *seed,
 		}
 	}
 	if (lut) {
-		bool pf_lut = vsi->type == I40E_VSI_MAIN ? true : false;
+		bool pf_lut = vsi->type == I40E_VSI_MAIN;
 
 		ret = i40e_aq_set_rss_lut(hw, vsi->id, pf_lut, lut, lut_size);
 		if (ret) {
@@ -11455,7 +11455,7 @@ static int i40e_get_rss_aq(struct i40e_vsi *vsi, const u8 *seed,
 	}
 
 	if (lut) {
-		bool pf_lut = vsi->type == I40E_VSI_MAIN ? true : false;
+		bool pf_lut = vsi->type == I40E_VSI_MAIN;
 
 		ret = i40e_aq_get_rss_lut(hw, vsi->id, pf_lut, lut, lut_size);
 		if (ret) {
-- 
2.7.4

