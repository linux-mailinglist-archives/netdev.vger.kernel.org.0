Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D20E35FD
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409525AbfJXOwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:52:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38261 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409512AbfJXOwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:52:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2C72222087;
        Thu, 24 Oct 2019 10:52:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 24 Oct 2019 10:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Wzk4n39A1qkwO+y5TomPTuH7SbW3bz2Z6z4SkpVuzw0=; b=S2uWS8Fi
        Md3Ajek1xuryTlNewoOnagVONDo9r3YMvssrfUjYP47cHAgiLbcn7LOkv6qemucZ
        YuYrDvyM//EdxbxWbkg/YGvY1LIIWHg+uLiuOPc8WqtyP+L9aKM/5bihZsDWg/md
        PrraclXHeeLVprmw1MqHfPPYFbZh1k0C4dDFVD7Vf4Dl9GRk6i0UeTuWdJaJYwCn
        P4bsOGqVhCg8oIMmy1gXknW0YjVM2OHuTRG9cP56Xlt21gkRuv3RDHDB3LVE8ZUZ
        3EF/ORbN70mSHrTNJbHVQtgcMKB/3YaLSKTRUsUQVILwTVZlew+tQg5lll8aaKeP
        +k7pRkHengV93w==
X-ME-Sender: <xms:r7qxXf3BtzKNWyM4o0s-xiDOrstnccEYYKaIKIhiYRm3UQIY_rF5Fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrledugdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:sLqxXcUWN8PeryWsrfPIOLCBLHz98IrQJlvZBXrWhJzxTyKmNjK3aw>
    <xmx:sLqxXZCnTg_JrV70vrdk3VdkKMFC6CrD6DofCV7iIxa7JVvB6T2PkA>
    <xmx:sLqxXWDiXRXIMwLipRJ101mJrC2Z5wfeoD0dEWUr5Q0hrVa_84wq2Q>
    <xmx:sLqxXQmuQgkXLtOS2h4ey1h98W5W5pzHT2eDtpUmFjDmGWnMUD7WvA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B826C80068;
        Thu, 24 Oct 2019 10:52:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] mlxsw: Bump firmware version to 13.2000.2308
Date:   Thu, 24 Oct 2019 17:51:48 +0300
Message-Id: <20191024145149.6417-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024145149.6417-1-idosch@idosch.org>
References: <20191024145149.6417-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The version adds support for querying port module type. It will be used
by a followup patch set from Jiri to make port split code more generic.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1275d21e8fbd..8a797fad2d56 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -48,7 +48,7 @@
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2000
-#define MLXSW_SP1_FWREV_SUBMINOR 1886
+#define MLXSW_SP1_FWREV_SUBMINOR 2308
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
-- 
2.21.0

