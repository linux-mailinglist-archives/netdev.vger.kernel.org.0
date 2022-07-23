Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CAC57EC73
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 09:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiGWHe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 03:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiGWHe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 03:34:28 -0400
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B8CD5A164;
        Sat, 23 Jul 2022 00:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Ou64X
        cGXcxxJqUURiTJIAC7Xl0xWJ6QNV6r7RUuijgU=; b=ODwoCwnlgxzxPYi/nfRAu
        PhWPt868LoohwtfPxtSqkRs5n0YEnxba+y/5mR+XNM6iw1NXiUZvMAQarIR85ges
        z2jfrMMnUxZZltG9bLk8o0FjAh5rJXfsPojd3NpEIz7OysqynxTduJKWuFInXB6R
        Fv6AZ5LNIOqSTrXU/TGjCI=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp2 (Coremail) with SMTP id GtxpCgAXJ6cIpNtihfkcQw--.2846S2;
        Sat, 23 Jul 2022 15:32:27 +0800 (CST)
From:   williamsukatube@163.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, marc.dionne@auristor.com,
        William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH net-next] net: delete extra space and tab in blank line
Date:   Sat, 23 Jul 2022 15:32:22 +0800
Message-Id: <20220723073222.2961602-1-williamsukatube@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgAXJ6cIpNtihfkcQw--.2846S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrKw1rtFy7Kw4fXr1fWF17ZFb_yoW8JrW7pa
        y3Aa42krWxAry3Xr18Ar18Gr98Xan8Wa43G3929w4FqFn3GFWxtF1fKw4UWFs5WFW0qFW3
        Zr40qw4rG3Z2yrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bw5rcUUUUU=
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xzlozx5dpv3yxdwxuvi6rwjhhfrp/xtbBSQtHg1aEEPhEPgAAsG
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dean <williamsukatube@gmail.com>

delete extra space and tab in blank line, there is no functional change.

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
---
 net/ethtool/cabletest.c | 2 +-
 net/rxrpc/protocol.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 920aac02fe39..06a151165c31 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -356,7 +356,7 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
- 
+
 int ethnl_cable_test_amplitude(struct phy_device *phydev,
 			       u8 pair, s16 mV)
 {
diff --git a/net/rxrpc/protocol.h b/net/rxrpc/protocol.h
index 49bb972539aa..d2cf8e1d218f 100644
--- a/net/rxrpc/protocol.h
+++ b/net/rxrpc/protocol.h
@@ -57,7 +57,7 @@ struct rxrpc_wire_header {
 
 	uint8_t		userStatus;	/* app-layer defined status */
 #define RXRPC_USERSTATUS_SERVICE_UPGRADE 0x01	/* AuriStor service upgrade request */
-	
+
 	uint8_t		securityIndex;	/* security protocol ID */
 	union {
 		__be16	_rsvd;		/* reserved */
-- 
2.25.1

