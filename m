Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF54A4E4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfFRPNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60779 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729042AbfFRPNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6920121FE5;
        Tue, 18 Jun 2019 11:13:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=8SIgl/mfVbuupzqe7seDQjko3F5oeWmAmC09py9L3g8=; b=T7JCHqKa
        8knAxWlcBgD/PTUTQYWqETNwmHp+J5tQBlui5fHo9AjyqpwNFtXBduH5yWo1kqJh
        YrH4mpQi2mw/sMOgH1xvsVIdBNpNGmTl6Hor/7CtYZnL/l9kz0+9JhIsQnZE2d1c
        a8wkaXKBXXHhc9ZHSpIOtrL9IN29VciBiHDufXhZmux3f5yU3gZqou0/KLZqCFNT
        t1hlT9egc5Ycozf9DA81X805hZBdF7/W/VSLVBZu3W4ktc3aIPOPgvXN0GcmFEB3
        ysRqnTVo8ILNnkYOmem7JgoxRA2wmSDcyeQgNKQ9LDZwn+Fn6ykKT/vuHWKlz2FU
        68fumZORZ+NamA==
X-ME-Sender: <xms:n_8IXVknPGzRboZpeg3dViftu3WoVSNQ54MgiJBcaifVfgdpYq-inw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:n_8IXcW92uvI2MxdTJzZHKCe_k5xp_UKAkXc901U7SR4a4eIqA4J7w>
    <xmx:n_8IXRqC7qEf2_HHc06zhtkcW0Ht33-0ZJkFPP8tPvCz3nBXKgsUog>
    <xmx:n_8IXTWW8O0voNzl17QblhY-g_H3KuTkoYyeRYV3B6YRjY00H8g6Sg>
    <xmx:n_8IXXbSzZbPREj_EzSlwamhKSFO_dYZZ1K6c4oBFtONMG04-C4AoA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D83BF380083;
        Tue, 18 Jun 2019 11:13:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/16] netdevsim: Ignore IPv6 multipath notifications
Date:   Tue, 18 Jun 2019 18:12:47 +0300
Message-Id: <20190618151258.23023-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to previous patch, have netdevsim ignore IPv6
multipath notifications for now.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/fib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 8c57ba747772..83ba5113210d 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -190,6 +190,13 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 
 	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
+		if (info->family == AF_INET6) {
+			struct fib6_entry_notifier_info *fen6_info = ptr;
+
+			if (fen6_info->multipath_rt)
+				return NOTIFY_DONE;
+		}
+
 		err = nsim_fib_event(data, info,
 				     event == FIB_EVENT_ENTRY_ADD);
 		break;
-- 
2.20.1

