Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A5958E60
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfF0XNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:13:12 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34420 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfF0XNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:13:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id t8so3284838qkt.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M/tzt4Ud4OWGYwGbH4v8JxL+UiBTvmPDKJRmUMjOJBw=;
        b=i6wafNMBwEpuSD00esGSLxkfx1fxHZ7aFHWoRJai3e/RltrImG4u3pWe/gcnwAUXoU
         X0dR2MHwiQuRPqGgiDaMUTaDLZYmvMU1jlZsZDQRpls9D8LS0G2AQz7DR+sQMjMH618X
         4nVQPiWCa1fyppHuNT7NRSQ/tQ4odnDyxE1M4/e7KKTuaQcROjAf+psQy9TdEeKoEqGQ
         Fm+gZ6otPYO5qFU8oh7MugHefX0BBSSbJWPlsc5geMuuMdJipkTSu5V0H1ahNeg+2SlB
         CB+LvYKMi9Ycm0CA8rClRRX7B5AeoDWIcIaOh5RI3z9GSYg/8KOP0UEYDDn7+jp2J06/
         mQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/tzt4Ud4OWGYwGbH4v8JxL+UiBTvmPDKJRmUMjOJBw=;
        b=OBEubEBWH4Xi6SrRamSyf/LjepbeqO2Szs24QIzHq4e4W2sYFzane0qJfRyuNSnN0U
         nu5AV+66YmrpnzdkYxI0rfM8MzEQtqdozMG6MoLdBMT720V5geR4q0Y5J48jqQZ+kPKC
         54ULrb8M0WVb6QRCIIpFdKqwXyg4qdurAyNGL/KhegkXAOEqBJ6iUems/Tlfy8WbZif8
         zbhl+FmmKdhl+IwhDRpL7MrN3f8qlnt3sC+8ylOOY9VQMYIOKuVN+fB1lw281xKbUt7x
         uTYTNcIAkWS0A2Qwazz/h1e+CPoeuWYc+lSnX3hYBW0O+fW1+rBg/h9V5D/M+PP+V4/m
         5hKg==
X-Gm-Message-State: APjAAAXEgsiYaT05n7y/SQfgyJ4g/HK6OBba1zsQoz2yNdPYOEHDSgql
        Mv7ETD/RDw5UdYkVIZUFdNV43Q==
X-Google-Smtp-Source: APXvYqxsBTYGv+oYZHezUqeuuvhEW0s+KMTfdj6+S+NAN3RkWm3kht69/SCXd6MwfKnnRkm8z7WfPA==
X-Received: by 2002:a37:6086:: with SMTP id u128mr5932809qkb.270.1561677189531;
        Thu, 27 Jun 2019 16:13:09 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm253518qtk.67.2019.06.27.16.13.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 16:13:09 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 3/5] nfp: flower: rename tunnel related functions in action offload
Date:   Thu, 27 Jun 2019 16:12:41 -0700
Message-Id: <20190627231243.8323-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627231243.8323-1-jakub.kicinski@netronome.com>
References: <20190627231243.8323-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Previously tunnel related functions in action offload only applied
to UDP tunnels. Rename these functions in preparation for new
tunnel types.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
---
 .../ethernet/netronome/nfp/flower/action.c    | 30 +++++++++----------
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |  2 +-
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 8bea3004d66c..88fedb5ada97 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -171,8 +171,8 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 }
 
 static enum nfp_flower_tun_type
-nfp_fl_get_tun_from_act_l4_port(struct nfp_app *app,
-				const struct flow_action_entry *act)
+nfp_fl_get_tun_from_act(struct nfp_app *app,
+			const struct flow_action_entry *act)
 {
 	const struct ip_tunnel_info *tun = act->tunnel;
 	struct nfp_flower_priv *priv = app->priv;
@@ -281,15 +281,13 @@ nfp_fl_push_geneve_options(struct nfp_fl_payload *nfp_fl, int *list_len,
 }
 
 static int
-nfp_fl_set_ipv4_udp_tun(struct nfp_app *app,
-			struct nfp_fl_set_ipv4_udp_tun *set_tun,
-			const struct flow_action_entry *act,
-			struct nfp_fl_pre_tunnel *pre_tun,
-			enum nfp_flower_tun_type tun_type,
-			struct net_device *netdev,
-			struct netlink_ext_ack *extack)
+nfp_fl_set_ipv4_tun(struct nfp_app *app, struct nfp_fl_set_ipv4_tun *set_tun,
+		    const struct flow_action_entry *act,
+		    struct nfp_fl_pre_tunnel *pre_tun,
+		    enum nfp_flower_tun_type tun_type,
+		    struct net_device *netdev, struct netlink_ext_ack *extack)
 {
-	size_t act_size = sizeof(struct nfp_fl_set_ipv4_udp_tun);
+	size_t act_size = sizeof(struct nfp_fl_set_ipv4_tun);
 	const struct ip_tunnel_info *ip_tun = act->tunnel;
 	struct nfp_flower_priv *priv = app->priv;
 	u32 tmp_set_ip_tun_type_index = 0;
@@ -845,7 +843,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		       struct nfp_flower_pedit_acts *set_act,
 		       struct netlink_ext_ack *extack)
 {
-	struct nfp_fl_set_ipv4_udp_tun *set_tun;
+	struct nfp_fl_set_ipv4_tun *set_tun;
 	struct nfp_fl_pre_tunnel *pre_tun;
 	struct nfp_fl_push_vlan *psh_v;
 	struct nfp_fl_pop_vlan *pop_v;
@@ -898,7 +896,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	case FLOW_ACTION_TUNNEL_ENCAP: {
 		const struct ip_tunnel_info *ip_tun = act->tunnel;
 
-		*tun_type = nfp_fl_get_tun_from_act_l4_port(app, act);
+		*tun_type = nfp_fl_get_tun_from_act(app, act);
 		if (*tun_type == NFP_FL_TUNNEL_NONE) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported tunnel type in action list");
 			return -EOPNOTSUPP;
@@ -914,7 +912,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		 * If none, the packet falls back before applying other actions.
 		 */
 		if (*a_len + sizeof(struct nfp_fl_pre_tunnel) +
-		    sizeof(struct nfp_fl_set_ipv4_udp_tun) > NFP_FL_MAX_A_SIZ) {
+		    sizeof(struct nfp_fl_set_ipv4_tun) > NFP_FL_MAX_A_SIZ) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at tunnel encap");
 			return -EOPNOTSUPP;
 		}
@@ -928,11 +926,11 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 			return err;
 
 		set_tun = (void *)&nfp_fl->action_data[*a_len];
-		err = nfp_fl_set_ipv4_udp_tun(app, set_tun, act, pre_tun,
-					      *tun_type, netdev, extack);
+		err = nfp_fl_set_ipv4_tun(app, set_tun, act, pre_tun,
+					  *tun_type, netdev, extack);
 		if (err)
 			return err;
-		*a_len += sizeof(struct nfp_fl_set_ipv4_udp_tun);
+		*a_len += sizeof(struct nfp_fl_set_ipv4_tun);
 		}
 		break;
 	case FLOW_ACTION_TUNNEL_DECAP:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 0d3d1b68232c..d0d57d1ef750 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -203,7 +203,7 @@ struct nfp_fl_pre_tunnel {
 	__be32 extra[3];
 };
 
-struct nfp_fl_set_ipv4_udp_tun {
+struct nfp_fl_set_ipv4_tun {
 	struct nfp_fl_act_head head;
 	__be16 reserved;
 	__be64 tun_id __packed;
-- 
2.21.0

