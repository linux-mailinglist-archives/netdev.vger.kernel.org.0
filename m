Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833CF1C036C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgD3RBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60205 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgD3RBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 98E765C00EA;
        Thu, 30 Apr 2020 13:01:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=l5tpTKSrCBvkabEfcVd3sJ/ZhJJnxUf4N/aIQ4IsTRg=; b=UkAj9961
        fBU0368+smTW5ROJ+1LVqR7zsVB98QFPNWf3MdkyUCP3HgPj+bPx5Np91mxBkyy9
        l5cq24NOVaj5uAbOWuxxpfwjj++7TN1IobSbx4nOZ2XbDqP08o+0knWhqfWYxIzf
        awDjxgPoZdiYSCCMo+xBPsACsC3k/OLPAGLiptkj2tiIaQosIaI9gC2c3vfpuVZc
        tVE+AtjW3E+4Webvwc76695hGkeFRA+OjO9pj7TokdAqv20Axq8xqBrF2LLmid7J
        lGt0o+6jtt9vpHciRmVZF2wEWF1dYgsKD2vRFsVsKvZaUQBPvGRyU31B/jQxZ+tH
        NMi6RXOggW6MtQ==
X-ME-Sender: <xms:fgSrXtXLItVpBCf0KD5g-GQci40vBPnBHXmxTKfaaOR5ttkwDkDUNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fgSrXosYNRhUhLJhqElXm_zMIVmR4LvloSmAMGgLY6eh7XsbWA6LnA>
    <xmx:fgSrXjuFQARjiGbRKfJ0kE1GAJfMbU2Q7YHFfN6qEfh_hvzyczSAFA>
    <xmx:fgSrXs6zWGLouWxSMuc33YoxpIZ7vXIelXYqCtY1aiMBbWRejBvhHw>
    <xmx:fgSrXsXe6ZV79BnxPib8DSwa8nRjkvvQ46N5WC84Iz9dEzw2lFZaoA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 139E93065F2F;
        Thu, 30 Apr 2020 13:01:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_span: Rename function
Date:   Thu, 30 Apr 2020 20:01:10 +0300
Message-Id: <20200430170116.4081677-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200430170116.4081677-1-idosch@idosch.org>
References: <20200430170116.4081677-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Next patch will introduce mlxsw_sp_span_port_buffer_disable() function
that disables the egress buffer on an analyzed port. Rename the opposite
function that updates the buffer on an analyzed port accordingly.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Suggested-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c  | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 5edf9d1bf937..c52f79a97f36 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -784,7 +784,7 @@ static bool mlxsw_sp_span_is_egress_mirror(struct mlxsw_sp_port *port)
 }
 
 static int
-mlxsw_sp_span_port_buffsize_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
+mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char sbib_pl[MLXSW_REG_SBIB_LEN];
@@ -809,7 +809,7 @@ int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu)
 	 * updated according to the mtu value
 	 */
 	if (mlxsw_sp_span_is_egress_mirror(port))
-		return mlxsw_sp_span_port_buffsize_update(port, mtu);
+		return mlxsw_sp_span_port_buffer_update(port, mtu);
 	return 0;
 }
 
@@ -825,8 +825,8 @@ void mlxsw_sp_span_speed_update_work(struct work_struct *work)
 	 * updated according to the speed value.
 	 */
 	if (mlxsw_sp_span_is_egress_mirror(mlxsw_sp_port))
-		mlxsw_sp_span_port_buffsize_update(mlxsw_sp_port,
-						   mlxsw_sp_port->dev->mtu);
+		mlxsw_sp_span_port_buffer_update(mlxsw_sp_port,
+						 mlxsw_sp_port->dev->mtu);
 }
 
 static struct mlxsw_sp_span_inspected_port *
@@ -888,7 +888,7 @@ mlxsw_sp_span_inspected_port_add(struct mlxsw_sp_port *port,
 
 	/* if it is an egress SPAN, bind a shared buffer to it */
 	if (type == MLXSW_SP_SPAN_EGRESS) {
-		err = mlxsw_sp_span_port_buffsize_update(port, port->dev->mtu);
+		err = mlxsw_sp_span_port_buffer_update(port, port->dev->mtu);
 		if (err)
 			return err;
 	}
@@ -1135,14 +1135,14 @@ mlxsw_sp_span_analyzed_port_create(struct mlxsw_sp_span *span,
 	if (!ingress) {
 		u16 mtu = mlxsw_sp_port->dev->mtu;
 
-		err = mlxsw_sp_span_port_buffsize_update(mlxsw_sp_port, mtu);
+		err = mlxsw_sp_span_port_buffer_update(mlxsw_sp_port, mtu);
 		if (err)
-			goto err_buffsize_update;
+			goto err_buffer_update;
 	}
 
 	return analyzed_port;
 
-err_buffsize_update:
+err_buffer_update:
 	list_del(&analyzed_port->list);
 	kfree(analyzed_port);
 	return ERR_PTR(err);
-- 
2.24.1

