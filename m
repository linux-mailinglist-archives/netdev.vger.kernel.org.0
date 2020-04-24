Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879F11B7A63
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgDXPoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:44:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45623 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727091AbgDXPoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:44:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CBEF05C07BE;
        Fri, 24 Apr 2020 11:44:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 24 Apr 2020 11:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jl0IZhhvl51akOH0/EQYSopI6P6yBivzsNzjmJp0VgE=; b=sVrk3qkg
        PsBRjwcN47XTpPl2v1ftBYiMqCkUar8FFXbS3HtidMnt3Jxe+keDeo+BQ3M/f33s
        ugqA2y1dckBBDdSZlC8QaEdoRmyczkjYQh76T+d3HiIvKQVzVn73t0+5lgAJImYo
        QWtZgFIDYPCTzAhhBHd+/lAPTJKXDak0b2wRknM2N5NXgqdgj65Z1OHH5LdoliOf
        ve/3DQLeK6RbwWqgVDCf+SMZpw+5Ql9aMWIBpvRHUl2HSLcuwWTZL71ShD9e8SXA
        HREy6To/Atkh5YMu3WyfGD6QgIEmn4iqSZ054M9CHjXlbvpNlFP/EASl4a9yzazA
        EVTQg2DD4e3ueg==
X-ME-Sender: <xms:UAmjXmQs9zHME-iRNfBPA2Vy3-y3OqK30SDkNyvwjVePNOGOSgm-Tg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrhedugdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:UAmjXgC0dJ2ZQ610a-LNbIXKjYXJsWVHkPkXHBcglMWzkM7Bek-Mhg>
    <xmx:UAmjXu2QE5bV2FLe_pzvB_IlvquHwt3VojN6Vuso0_PlNEyGjua_jA>
    <xmx:UAmjXmWsBKq408BUkY2sCSRXVd_REf8_iz0UOqbn_0P6hfaIetevWA>
    <xmx:UAmjXgTuwtShVE6TpkEM__bjeFPB7GrPQBjUltAyu8fz4M7WuPUydw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CF483065D9F;
        Fri, 24 Apr 2020 11:44:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] mlxsw: spectrum_span: Remove unnecessary debug prints
Date:   Fri, 24 Apr 2020 18:43:43 +0300
Message-Id: <20200424154345.3677009-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424154345.3677009-1-idosch@idosch.org>
References: <20200424154345.3677009-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

To the best of my knowledge, these debug prints were never used. Remove
them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index eb4a1c0f2788..14c5edc71239 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -978,9 +978,6 @@ int mlxsw_sp_span_mirror_add(struct mlxsw_sp_port *from,
 	if (!span_entry)
 		return -ENOBUFS;
 
-	netdev_dbg(from->dev, "Adding inspected port to SPAN entry %d\n",
-		   span_entry->id);
-
 	err = mlxsw_sp_span_inspected_port_add(from, span_entry, type, bind);
 	if (err)
 		goto err_port_bind;
@@ -1004,8 +1001,6 @@ void mlxsw_sp_span_mirror_del(struct mlxsw_sp_port *from, int span_id,
 		return;
 	}
 
-	netdev_dbg(from->dev, "removing inspected port from SPAN entry %d\n",
-		   span_entry->id);
 	mlxsw_sp_span_inspected_port_del(from, span_entry, type, bind);
 }
 
-- 
2.24.1

