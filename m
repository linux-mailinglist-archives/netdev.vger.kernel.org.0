Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55B4A4E0
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfFRPNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35563 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728905AbfFRPNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5BA64223D2;
        Tue, 18 Jun 2019 11:13:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TPSa8i5hnw8vGOa12r61SBxjGHzl5sckRV2pLCYglt4=; b=AYvmPzDO
        36tnvJ2Dth0DRVfSe9DhJTIh4/6LH40vVq9glJ7fVXAP9JLJhzSGaTgnJflyc7wk
        hj2UNK48GG0xbj+YmeCyCfClPmXETSentVNd1uDOgpWKaoB5+nBl32cHFrl3sBc4
        lxumxQAFE1ODoY2RvS5VhRR5ONGmZ4nKyHQiVXXUNgZVx9uktwV1CIFSTi0T6oxk
        /uVTUWyWaCD0dfiAWOI/oI/D03LgJf/u1QVf6S5FOgo4zPaznZ0tzlkcNkMsEsuX
        Cg0qMuscfsoAYvL8pEFCvx3xSuzT9r9/BlkzI8dZu1zAfajMUYY9G1WA36TBPMDA
        glcOlgcdAPbSfA==
X-ME-Sender: <xms:mf8IXZFDJy0WjXdPy-B9Th3YqeqY2jCXrhSrisCgbW3Jitbq9Qjl9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:mf8IXcIYOGGcSABJIwljNnFcINBdWvAiGpn0TrqaEXaJf90D5Q3hEQ>
    <xmx:mf8IXVkMOoeYTZXzOfC82792mjl-OBEmc3HsScEfJ_cBeOQ2BWtXxQ>
    <xmx:mf8IXcSFcZnXRVl-BGvbgQlqIF9bR9pd85qPAAcTk9lRsTio1e0tbQ>
    <xmx:mf8IXfJdt0odsqn_BjJ2-quBNSWnGBsmNYNrepBaV51WgNgUWPEc1Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B234C380085;
        Tue, 18 Jun 2019 11:13:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/16] netlink: Document all fields of 'struct nl_info'
Date:   Tue, 18 Jun 2019 18:12:43 +0300
Message-Id: <20190618151258.23023-2-idosch@idosch.org>
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

Some fields were not documented. Add documentation.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/net/netlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 28ece67f5312..ce66e43b9b6a 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -378,7 +378,9 @@ struct nla_policy {
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
+ * @nl_net: Network namespace
  * @portid: Netlink PORTID of requesting application
+ * @skip_notify: Skip netlink notifications to user space
  */
 struct nl_info {
 	struct nlmsghdr		*nlh;
-- 
2.20.1

