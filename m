Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6161B7A65
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgDXPoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:44:21 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59139 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728759AbgDXPoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:44:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A054D5C0042;
        Fri, 24 Apr 2020 11:44:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 24 Apr 2020 11:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=NnloYDas3tRWwjx6xqFSmKw1iGHeba/TDMtwv7JWQp8=; b=vDGPsolp
        rCSbiXx3CdkuS2PeEGcw2cK0wZ3EWFZAttBoSGS7PjchKmfxo7ya0VB6cCsYnoFu
        aHHJATKIS0TsSbOB2ttqly0RTFLfynRpPae2KlkvIgQ3ZEFsyE/24w/1EgeRm0jV
        8zgQ3vqiEIoVCqC2VutsZ9MMtmdPEGqR2rykxqpqiXZiFgccIMx/xWLC3sMulOpK
        TUKtUCnXv4lNJWqUTV0+F9yyMqLia9gDOEH9/C/daaKt3e8dbdMi3C05exGivfj8
        T69Fnn3la3+znLorjTFXEPs3osvwpjbj2keaeXF1pAWI08BswsQfrNoeO0Zn5PEj
        nq4crfpa39TBBA==
X-ME-Sender: <xms:UwmjXvNd4QK8av7_u3QU-zAXOFLoH33YPlcYkwMS0W126Ng-CIG5vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrhedugdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:UwmjXn1YNoNZl2ADHL-DSbRDPnuOXGVQbYRE3O8n25fbUM3K-IclZQ>
    <xmx:UwmjXnVvtVYKga3ZFDDnco-bk-v8GqM6nUHFbudJ9BhlZYJSnl94Bw>
    <xmx:UwmjXk_wUb5_dvhMFkk-SLZ-kFIKtPTmzKnqcCyMJK57Tv-EAWl76A>
    <xmx:UwmjXttcMTjMMBJmnZ9UheFS5_jpZX0Mk05aecWr0zt-T1rqhuA7lg>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 50CD33065D9A;
        Fri, 24 Apr 2020 11:44:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] mlxsw: spectrum_span: Replace zero-length array with flexible-array member
Date:   Fri, 24 Apr 2020 18:43:45 +0300
Message-Id: <20200424154345.3677009-6-idosch@idosch.org>
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

In a similar fashion to commit e99f8e7f88b5 ("mlxsw: Replace zero-length
array with flexible-array member"), use a flexible-array member to get a
compiler warning in case the flexible array does not occur last in the
structure.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 235556be58f5..ae3c8a1e9a43 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -22,7 +22,7 @@ struct mlxsw_sp_span {
 	struct mlxsw_sp *mlxsw_sp;
 	atomic_t active_entries_count;
 	int entries_count;
-	struct mlxsw_sp_span_entry entries[0];
+	struct mlxsw_sp_span_entry entries[];
 };
 
 static void mlxsw_sp_span_respin_work(struct work_struct *work);
-- 
2.24.1

