Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0161B7A61
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgDXPoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:44:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33971 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbgDXPoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:44:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 578A65C07F1;
        Fri, 24 Apr 2020 11:44:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 24 Apr 2020 11:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=X0Aa3AJK3y0dEhpJAz3yOMPD63ZhuVtycTGEtdTw/eU=; b=AE23EPGH
        5lra7iw8qeu3sDiMkXQkUGK21ugMzDzsiKlx5KDlpUOwWn6/IXOVyxkmvIfFepaw
        XMs/RHM8ib+0TBAOtkZoLrP+pGHUR9pdU5ufRXjyBCC5OEQwBqLYDPVGGsl1Xxab
        n1ppMbCN1w+48RhICqDSgRPTf/SJ2jAidGwDaB4psYyoeZOGVZM+KvaEC04VY7kQ
        WpSXSP4Fob96OLmtQwWP5uDLUAkTDOvB96/Prl6EAXNjOJG6R19bZIKAluKVnafc
        /szfw1lUbVrj1THdAjE7Yw839AwFpMdb5Tg9K+SpwjMsaPqj5tOvuMmUdeMuir3m
        Id3BKvKygZwP4g==
X-ME-Sender: <xms:TwmjXltEQ2EtfWArDm9vjtRGjcDdGZXmhOYNWgI_vRNeVtMN1rKVdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrhedugdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:TwmjXnVOVZI7YkIV0ECKpUnWfs5yy6WU_rE5Flec9yYco4evrHSsuQ>
    <xmx:TwmjXns2-Hj08Y5Fg565cWYtc4I8sj1RN5RC3Refloa1FzY2TwYFnA>
    <xmx:TwmjXmRoWprAAlhH_2xGwTpRC7wwFsmiHxPKdp3pMjge9FyesAag5A>
    <xmx:TwmjXimQuiaBZAb0ZeACZnWkr4ERYq3Tge0voU594SRLsHWgDeqlxA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19C913065D9A;
        Fri, 24 Apr 2020 11:44:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] mlxsw: spectrum_span: Rename parms() to parms_set()
Date:   Fri, 24 Apr 2020 18:43:42 +0300
Message-Id: <20200424154345.3677009-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424154345.3677009-1-idosch@idosch.org>
References: <20200424154345.3677009-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Use a more meaningful name for parms() function.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    | 14 +++++++-------
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h    |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index e7be1bfe7f75..eb4a1c0f2788 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -130,7 +130,7 @@ mlxsw_sp_span_entry_phys_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_phys = {
 	.can_handle = mlxsw_sp_port_dev_check,
-	.parms = mlxsw_sp_span_entry_phys_parms,
+	.parms_set = mlxsw_sp_span_entry_phys_parms,
 	.configure = mlxsw_sp_span_entry_phys_configure,
 	.deconfigure = mlxsw_sp_span_entry_phys_deconfigure,
 };
@@ -418,7 +418,7 @@ mlxsw_sp_span_entry_gretap4_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 
 static const struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_gretap4 = {
 	.can_handle = netif_is_gretap,
-	.parms = mlxsw_sp_span_entry_gretap4_parms,
+	.parms_set = mlxsw_sp_span_entry_gretap4_parms,
 	.configure = mlxsw_sp_span_entry_gretap4_configure,
 	.deconfigure = mlxsw_sp_span_entry_gretap4_deconfigure,
 };
@@ -519,7 +519,7 @@ mlxsw_sp_span_entry_gretap6_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_gretap6 = {
 	.can_handle = netif_is_ip6gretap,
-	.parms = mlxsw_sp_span_entry_gretap6_parms,
+	.parms_set = mlxsw_sp_span_entry_gretap6_parms,
 	.configure = mlxsw_sp_span_entry_gretap6_configure,
 	.deconfigure = mlxsw_sp_span_entry_gretap6_deconfigure,
 };
@@ -575,7 +575,7 @@ mlxsw_sp_span_entry_vlan_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_vlan = {
 	.can_handle = mlxsw_sp_span_vlan_can_handle,
-	.parms = mlxsw_sp_span_entry_vlan_parms,
+	.parms_set = mlxsw_sp_span_entry_vlan_parms,
 	.configure = mlxsw_sp_span_entry_vlan_configure,
 	.deconfigure = mlxsw_sp_span_entry_vlan_deconfigure,
 };
@@ -612,7 +612,7 @@ mlxsw_sp_span_entry_nop_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 }
 
 static const struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_nop = {
-	.parms = mlxsw_sp_span_entry_nop_parms,
+	.parms_set = mlxsw_sp_span_entry_nop_parms,
 	.configure = mlxsw_sp_span_entry_nop_configure,
 	.deconfigure = mlxsw_sp_span_entry_nop_deconfigure,
 };
@@ -970,7 +970,7 @@ int mlxsw_sp_span_mirror_add(struct mlxsw_sp_port *from,
 		return -EOPNOTSUPP;
 	}
 
-	err = ops->parms(to_dev, &sparms);
+	err = ops->parms_set(to_dev, &sparms);
 	if (err)
 		return err;
 
@@ -1026,7 +1026,7 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work)
 		if (!curr->ref_count)
 			continue;
 
-		err = curr->ops->parms(curr->to_dev, &sparms);
+		err = curr->ops->parms_set(curr->to_dev, &sparms);
 		if (err)
 			continue;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 59724335525f..01273e54ba20 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -49,8 +49,8 @@ struct mlxsw_sp_span_entry {
 
 struct mlxsw_sp_span_entry_ops {
 	bool (*can_handle)(const struct net_device *to_dev);
-	int (*parms)(const struct net_device *to_dev,
-		     struct mlxsw_sp_span_parms *sparmsp);
+	int (*parms_set)(const struct net_device *to_dev,
+			 struct mlxsw_sp_span_parms *sparmsp);
 	int (*configure)(struct mlxsw_sp_span_entry *span_entry,
 			 struct mlxsw_sp_span_parms sparms);
 	void (*deconfigure)(struct mlxsw_sp_span_entry *span_entry);
-- 
2.24.1

