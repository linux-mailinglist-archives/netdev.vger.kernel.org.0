Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9432413BB89
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 09:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAOIzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 03:55:11 -0500
Received: from mail.dlink.ru ([178.170.168.18]:57758 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgAOIzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 03:55:11 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 082191B20EA4; Wed, 15 Jan 2020 11:55:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 082191B20EA4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579078509; bh=yg+Jxrgfes1yBtY1Tjp1FLRu3JE5xDeXDxzwB5HYVEo=;
        h=From:To:Cc:Subject:Date;
        b=qrrkNgMRFgqzznePH1dwMzoJFaBvAP+GxfualKd+TR1/h3dY8KMmL0ElDRhcTbJsc
         bakhX0bnfjqpBiERh9BlCGjkFxhUhZNKTV8eeKvdbynOJPQcCycORGIzWlapiQlw0Z
         CSHPLg3ZpmHhwlxFx9tHebPkjC0H6oTHydGRo9hM=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id BD6621B20857;
        Wed, 15 Jan 2020 11:55:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru BD6621B20857
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 04A171B20AE9;
        Wed, 15 Jan 2020 11:55:04 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 15 Jan 2020 11:55:03 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Lobakin <alobakin@dlink.ru>
Subject: [PATCH net] net: dsa: tag_gswip: fix typo in tagger name
Date:   Wed, 15 Jan 2020 11:54:38 +0300
Message-Id: <20200115085438.11948-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The correct name is GSWIP (Gigabit Switch IP). Typo was introduced in
875138f81d71a ("dsa: Move tagger name into its ops structure") while
moving tagger names to their structures.

Fixes: 875138f81d71a ("dsa: Move tagger name into its ops structure")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_gswip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index b678160bbd66..408d4af390a0 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -104,7 +104,7 @@ static struct sk_buff *gswip_tag_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops gswip_netdev_ops = {
-	.name = "gwsip",
+	.name = "gswip",
 	.proto	= DSA_TAG_PROTO_GSWIP,
 	.xmit = gswip_tag_xmit,
 	.rcv = gswip_tag_rcv,
-- 
2.25.0

