Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043349733D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfHUHUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:20:31 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35795 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727537AbfHUHU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 03:20:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ECC9221AEF;
        Wed, 21 Aug 2019 03:20:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 21 Aug 2019 03:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dn9tB3h9kzGquXkh/3On7EDW3lc/lqg9GXjtRZW7mmg=; b=ybmzFpQv
        z+2KKVnpKsyZW7LmY7IMHk5X+infvdC6UJU3rQd7QA+5mF1zMNGAnh0i0SDOBVIm
        L+SoBL1M+nFbRMLtug/JWZ6WQ83mtiAUQqGzqzJ7BXcS7FXKgLvUSGpbN7wkv6IA
        +WtYSn8kxWr0+v7boMcBTBOok8Pz5wEP8ALyHWMg5+ZO65MSLf3o8/+SEOmLSQ8X
        FAFLCDuENFmmDflnCc4SHq3qBC0gxKg8Tt0LpzS3+ZYlSqCd52GGwijGWyKsmsQF
        sm1LrEVG2NUviZHZ/25B32LnpLDMlTVlJXXo8tLxtVbh1c+WxO2GdTVrM/aRtMra
        pyIst0hWDV3i3Q==
X-ME-Sender: <xms:vPBcXbtve20jWKVoHSfca2OlWwhOD7vjEqpmKwB83ur7q_IcU86xuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:vPBcXRZK4bvP5pgF2n2xB4C8eeVV1FH1-Exqvbloai2sUqIjLReRww>
    <xmx:vPBcXTB_RElC21MRw0SYvMFcWvo8mBnU7HGludF3ixn1OIXGBKUj0Q>
    <xmx:vPBcXZ_9UK4uczhaTUbeAYrOzTPbNvKbMupNjalKyHJ_nqY02Lk2UQ>
    <xmx:vPBcXVyczCNM3RvKjltEGe19QlavffO2_p6wxsDX1CQV-KBBWksNfQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE96CD6005E;
        Wed, 21 Aug 2019 03:20:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/7] mlxsw: Add layer 2 discard trap IDs
Date:   Wed, 21 Aug 2019 10:19:33 +0300
Message-Id: <20190821071937.13622-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821071937.13622-1-idosch@idosch.org>
References: <20190821071937.13622-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add the trap IDs used to report layer 2 drops.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/trap.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 19202bdb5105..7618f084cae9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -66,6 +66,13 @@ enum {
 	MLXSW_TRAP_ID_NVE_ENCAP_ARP = 0xBD,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
+	MLXSW_TRAP_ID_DISCARD_ING_PACKET_SMAC_MC = 0x140,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VTAG_ALLOW = 0x148,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VLAN = 0x149,
+	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_STP = 0x14A,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_UC = 0x150,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_MC_NULL = 0x151,
+	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_LB = 0x152,
 	MLXSW_TRAP_ID_ACL0 = 0x1C0,
 	/* Multicast trap used for routes with trap action */
 	MLXSW_TRAP_ID_ACL1 = 0x1C1,
-- 
2.21.0

