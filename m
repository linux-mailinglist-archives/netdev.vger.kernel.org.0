Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA011C6F34
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgEFLXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:23:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3818 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727099AbgEFLXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 07:23:10 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A5ABFE62CDF7BBCBE9B0;
        Wed,  6 May 2020 19:23:08 +0800 (CST)
Received: from huawei.com (10.67.174.156) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 19:23:02 +0800
From:   ChenTao <chentao107@huawei.com>
To:     <claudiu.manoil@nxp.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chentao107@huawei.com>
Subject: [PATCH -next] net: enetc: Make some symbols static
Date:   Wed, 6 May 2020 19:22:17 +0800
Message-ID: <20200506112217.161534-1-chentao107@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.156]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following warning:

drivers/net/ethernet/freescale/enetc/enetc_qos.c:427:20: warning:
symbol 'enetc_act_fwd' was not declared. Should it be static?
drivers/net/ethernet/freescale/enetc/enetc_qos.c:966:20: warning:
symbol 'enetc_check_flow_actions' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: ChenTao <chentao107@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 48e589e9d0f7..172acb602ccb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -424,7 +424,7 @@ struct enetc_psfp {
 	spinlock_t psfp_lock; /* spinlock for the struct enetc_psfp r/w */
 };
 
-struct actions_fwd enetc_act_fwd[] = {
+static struct actions_fwd enetc_act_fwd[] = {
 	{
 		BIT(FLOW_ACTION_GATE),
 		BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS),
@@ -963,7 +963,8 @@ static int enetc_psfp_hw_set(struct enetc_ndev_priv *priv,
 	return err;
 }
 
-struct actions_fwd *enetc_check_flow_actions(u64 acts, unsigned int inputkeys)
+static struct actions_fwd *enetc_check_flow_actions(u64 acts,
+						    unsigned int inputkeys)
 {
 	int i;
 
-- 
2.22.0

