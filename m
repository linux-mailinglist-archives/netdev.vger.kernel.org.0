Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39E212D0B7
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfL3Ocd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:32:33 -0500
Received: from fd.dlink.ru ([178.170.168.18]:41126 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbfL3Ocb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:32:31 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 05EB11B21941; Mon, 30 Dec 2019 17:32:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 05EB11B21941
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716349; bh=7OSwCRil5bvUGDc9SU5jjL6pENQDuKNpW1Evf4I2LJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WgsGWKE1FopPv6JqeCKM4JUz3cny8cfdZsDoWjlAyoXTeen9xXtdpOFQd2dosrWev
         Qoo8rqVzNrcOjZu3ZekSV87RxDW1DRbcANXzEF+N0fQP5OJT47sXGZSkSzqTMeJRxr
         vJtjBVaMeZL5tOktab75taS9+zEYXUyYINYVq0jo=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id CE9171B2085D;
        Mon, 30 Dec 2019 17:31:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru CE9171B2085D
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 02BE81B229D1;
        Mon, 30 Dec 2019 17:31:13 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:12 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 06/19] net: dsa: tag_gswip: fix typo in tag name
Date:   Mon, 30 Dec 2019 17:30:14 +0300
Message-Id: <20191230143028.27313-7-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"gwsip" -> "gswip".

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
2.24.1

