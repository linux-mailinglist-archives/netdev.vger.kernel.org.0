Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BF5141DEE
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgASNBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:34 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35959 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbgASNBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2AAC221D2B;
        Sun, 19 Jan 2020 08:01:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=vTRbpxiC8xsAGGBN7sAupepctF/gHBSp4xfXXt40GkU=; b=UizgEHfs
        K7WK2PNZ/EzlBlI7pTVX3Dr7tqNIKKY3e9cf3HPSBz7RxwsHx16zs3GrTNyXOYTa
        JCZOEMO+4QUzMirA2HRe70IV8mAGzq3akr14nDR02zgs/G+Nee4fUlGkncFbM4zN
        fOsmyxTAZNzcTNJHLCdWzAVnlGV+0iGSOM4WZC5YfCFyTjMXTaiztOSwzOi3tt1P
        b4ev7rMu3ecESNazqvUBNsDW2CBS3FH3SU7+1ul8ZMXAUteCP3v1N462/PJrotqP
        YTnZcQSFCZGuY+YGdk4Fz2+sk8O3bV6HKRv6sq1Qdk+f7k8PuezKWCL9fk11mISO
        s4t70ZyGqMWM9g==
X-ME-Sender: <xms:LFMkXowGikP9aMYsazTRSHYtHZ9wEl9gJJU_uvA9Fz8Kn3U1oIl1eA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:LFMkXgiH29VxkRucVkJrWDmW4neSPVvz-osKomtWbcdAAaPJwwkM7g>
    <xmx:LFMkXlWb1Hbve9DW8O-ojpn4iRDpk7uNCInetVCSQ50wVn7DPJd5gg>
    <xmx:LFMkXq2Kb5MWCU_vYW9njuF2iqZxYKNUhZBw1f8JP0h1M0oucLcYfg>
    <xmx:LFMkXkxNACSAfuSbJRnNOmTYEdgK3GVG-MskHT9TcyaZJtDGziwDHQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE1E380061;
        Sun, 19 Jan 2020 08:01:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/15] mlxsw: reg: Add Tunneling IPinIP Encapsulation ECN Mapping Register
Date:   Sun, 19 Jan 2020 15:00:50 +0200
Message-Id: <20200119130100.3179857-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

This register performs mapping from overlay ECN to underlay ECN during
IPinIP encapsulation.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 31 +++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index fd59280cf979..19a84641d485 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10140,6 +10140,36 @@ static inline void mlxsw_reg_tigcr_pack(char *payload, bool ttlc, u8 ttl_uc)
 	mlxsw_reg_tigcr_ttl_uc_set(payload, ttl_uc);
 }
 
+/* TIEEM - Tunneling IPinIP Encapsulation ECN Mapping Register
+ * -----------------------------------------------------------
+ * The TIEEM register maps ECN of the IP header at the ingress to the
+ * encapsulation to the ECN of the underlay network.
+ */
+#define MLXSW_REG_TIEEM_ID 0xA812
+#define MLXSW_REG_TIEEM_LEN 0x0C
+
+MLXSW_REG_DEFINE(tieem, MLXSW_REG_TIEEM_ID, MLXSW_REG_TIEEM_LEN);
+
+/* reg_tieem_overlay_ecn
+ * ECN of the IP header in the overlay network.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, tieem, overlay_ecn, 0x04, 24, 2);
+
+/* reg_tineem_underlay_ecn
+ * ECN of the IP header in the underlay network.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, tieem, underlay_ecn, 0x04, 16, 2);
+
+static inline void mlxsw_reg_tieem_pack(char *payload, u8 overlay_ecn,
+					u8 underlay_ecn)
+{
+	MLXSW_REG_ZERO(tieem, payload);
+	mlxsw_reg_tieem_overlay_ecn_set(payload, overlay_ecn);
+	mlxsw_reg_tieem_underlay_ecn_set(payload, underlay_ecn);
+}
+
 /* SBPR - Shared Buffer Pools Register
  * -----------------------------------
  * The SBPR configures and retrieves the shared buffer pools and configuration.
@@ -10684,6 +10714,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(tndem),
 	MLXSW_REG(tnpc),
 	MLXSW_REG(tigcr),
+	MLXSW_REG(tieem),
 	MLXSW_REG(sbpr),
 	MLXSW_REG(sbcm),
 	MLXSW_REG(sbpm),
-- 
2.24.1

