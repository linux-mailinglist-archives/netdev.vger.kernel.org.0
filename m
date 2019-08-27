Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FDF9E6C5
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfH0LaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:30:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33520 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfH0L37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 07:29:59 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i2Zfe-00022n-Kc; Tue, 27 Aug 2019 11:29:54 +0000
From:   Colin King <colin.king@canonical.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arcnet: capmode: remove redundant assignment to pointer pkt
Date:   Tue, 27 Aug 2019 12:29:54 +0100
Message-Id: <20190827112954.26677-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer pkt is being initialized with a value that is never read
and pkg is being re-assigned a little later on. The assignment is
redundant and hence can be removed.

Addresses-Coverity: ("Ununsed value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/arcnet/capmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/capmode.c b/drivers/net/arcnet/capmode.c
index b780be6f41ff..c09b567845e1 100644
--- a/drivers/net/arcnet/capmode.c
+++ b/drivers/net/arcnet/capmode.c
@@ -44,7 +44,7 @@ static void rx(struct net_device *dev, int bufnum,
 {
 	struct arcnet_local *lp = netdev_priv(dev);
 	struct sk_buff *skb;
-	struct archdr *pkt = pkthdr;
+	struct archdr *pkt;
 	char *pktbuf, *pkthdrbuf;
 	int ofs;
 
-- 
2.20.1

