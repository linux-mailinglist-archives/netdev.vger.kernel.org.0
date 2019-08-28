Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72620A0E1C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfH1XOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:14:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57671 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfH1XOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:14:54 -0400
Received: from cpc129250-craw9-2-0-cust139.know.cable.virginm.net ([82.43.126.140] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i379O-0000SZ-K7; Wed, 28 Aug 2019 23:14:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] arcnet: capmode: remove redundant assignment to pointer pkt
Date:   Thu, 29 Aug 2019 00:14:50 +0100
Message-Id: <20190828231450.22424-1-colin.king@canonical.com>
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
and pkt is being re-assigned a little later on. The assignment is
redundant and hence can be removed.

Addresses-Coverity: ("Ununsed value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: fix typo in patch description, pkg -> pkt

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

