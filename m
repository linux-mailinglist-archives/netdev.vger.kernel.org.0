Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E512CB79E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387482AbfJDJu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:50:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729093AbfJDJu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 05:50:29 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B669A90E2BA0B3EC2BBD;
        Fri,  4 Oct 2019 17:50:26 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 17:50:18 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] net: dsa: sja1105: Make function sja1105_xfer_long_buf static
Date:   Fri, 4 Oct 2019 17:57:30 +0800
Message-ID: <1570183050-136729-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/dsa/sja1105/sja1105_spi.c:159:5: warning: symbol 'sja1105_xfer_long_buf' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 4688467..b224b1a 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -156,9 +156,9 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
  * must be sent/received. Splitting the buffer into chunks and assembling
  * those into SPI messages is done automatically by this function.
  */
-int sja1105_xfer_long_buf(const struct sja1105_private *priv,
-			  sja1105_spi_rw_mode_t rw, u64 base_addr,
-			  void *packed_buf, u64 buf_len)
+static int sja1105_xfer_long_buf(const struct sja1105_private *priv,
+				 sja1105_spi_rw_mode_t rw, u64 base_addr,
+				 void *packed_buf, u64 buf_len)
 {
 	struct chunk {
 		void *buf_ptr;
--
2.7.4

