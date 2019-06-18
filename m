Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5E74A4E9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfFRPNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39233 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729594AbfFRPNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 20564223A4;
        Tue, 18 Jun 2019 11:13:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=jFU+b7eLR2k2NwCVG5ybdp7PiktI4prQkYgyQnFeUiA=; b=O+ljG+YX
        CwSJoZd6DkkecAIwdam2JO9KPIh2UpQYa8kvS3ElRuQkYSAIMbOgCjBbZCSjj3kA
        Jyxb/E3svcU0GEU44BZXA/sKVOMw4qblZq4t8GbL06i4XS7y92zcbfGu1iStoxWi
        qErZ7ZJHdykPMru/+4lo5fViqNBlwMv/PVdO0HtWefBK/vHnquU9AsTWFYCURQCE
        zbtc1QdFItrvQfeOVn5BzT3AdditvVe5MVJ2lC1jO0aIug+KyK0wdXjcXpH6YXPK
        698ZNoHKJr9UC0UUFCfR8Be3jcvvkZaN+Fdvw29+gnb/+iONb2jUYCMFn5Zp6A0L
        pBRW3IR2z1nRsw==
X-ME-Sender: <xms:o_8IXW9mFVv5qD6Z3EF_jyVOkl_Wjs4pwzTh4dIvZe1Q2A9wFHFPnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepie
X-ME-Proxy: <xmx:o_8IXQxiYku_KrrNqGn-wDqOgE-I6gLazkXn8wFN90Ke90Yml7n3SQ>
    <xmx:o_8IXQ_TtFUZLsE72URCpD9jOXna2OOA-uIFa5gysbdXXjI4X0xD8A>
    <xmx:o_8IXWM6XwFhV0xl0nlDcrmlsBLNsTUkl3b0-a5Pyg3VQ-ZxI2zPYA>
    <xmx:pP8IXa3ngebR668VEdzPTUJjIAU_-kdNnCiUzkv5J2UA5R8O6nQA5w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 628EA380084;
        Tue, 18 Jun 2019 11:13:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/16] mlxsw: spectrum_router: Remove processing of IPv6 append notifications
Date:   Tue, 18 Jun 2019 18:12:50 +0300
Message-Id: <20190618151258.23023-9-idosch@idosch.org>
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

No such notifications are sent by the IPv6 code, so remove them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ca47aa74e5d5..8bfd53a1497b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5965,7 +5965,6 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
 	case FIB_EVENT_ENTRY_ADD:
 		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
 		err = mlxsw_sp_router_fib6_add(mlxsw_sp,
@@ -6072,7 +6071,6 @@ static void mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
 	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		fen6_info = container_of(info, struct fib6_entry_notifier_info,
-- 
2.20.1

