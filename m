Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328535A22F7
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343622AbiHZI1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343535AbiHZI1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:27:38 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C363D4F5E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:27:34 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id h22so1793182ejk.4
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=AHZ/4zlaHTomsgSIwyjshtBoizz2eMpOGyzu8HheCIg=;
        b=25zTuuB8DSagFK0Y7T0nvYSqN/5aYi16DTjlBi8S3rJ6oJxPkIRRad2RkmQI/dajzm
         TjBo2INz9E8cU8Fp5b9RggQ1Puzk4gmW3oDBmH+zzT/oDhEw9yd15J2CGJureKsWi3bc
         0i20QIVgVl1wdrUQGEOI5+Gta1kED9WX7DWheP4OmUhptE806yBh9kWJQNLABgFyNR8g
         9ed4y9plGApk3Xa35fWOGtuAVnZebDQ8KN01R9wl4Y+iGlVNV79HDCnBD+Lx98LFBe/2
         PgFp+PdP00wtQ50Xr96WEToMldcMPHp5cokVxQ68ExV8CW/z8DSLLXPGMY7Uo1mW6Xif
         +NSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=AHZ/4zlaHTomsgSIwyjshtBoizz2eMpOGyzu8HheCIg=;
        b=G3EUjsqf35QeCv+IzMI7u6nVCA8epJBsoIcqDLMWJjeBvIM4vFdc4t2o8lx2B0Ucbi
         3jsUqlh7dtAahY3r0M2y63JNnmEL40mlB8jVnii/M0Krb1VawFzGNxz9cRyR7PAvm5Yj
         7CGo9zAyKt4IZBbLCFX8MK7Arn2dKuVBbW8eOALjYHLRAC0oiE4Wjb+stqSeMlNdSjnA
         TmZznHCJgfuy1ICzwOMwPpW96YUHJA65v3b3d7OPe+Ml47AIL5dZ8E7PvJBxvrgHZadS
         eff/dHVHFuwHOWKgqXt79ec2vvBZOqHVt7m2UH87wd3UBhT6K7/BTv8Hmi4hkNy1omT+
         pqWQ==
X-Gm-Message-State: ACgBeo0p8KdA6cCdq8A6fMNYYlMtVyNCH159e/tAOE7ygV1BRKkoe/2J
        ORP4SVORzND3X7oHnqZOU01skvgCSVJBFPKR
X-Google-Smtp-Source: AA6agR6w+pzKUmbvjga0WNh+SAo+CnEdSwirlsMyM4amfCZf1rSdjbeheq2t2uDlw+hQbIuFqT1iDA==
X-Received: by 2002:a17:906:cc16:b0:73d:c874:f89e with SMTP id ml22-20020a170906cc1600b0073dc874f89emr4975593ejb.666.1661502453131;
        Fri, 26 Aug 2022 01:27:33 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j4-20020a50ed04000000b00447bb9843cbsm928237eds.59.2022.08.26.01.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 01:27:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next v2] net: devlink: stub port params cmds for they are unused internally
Date:   Fri, 26 Aug 2022 10:27:30 +0200
Message-Id: <20220826082730.1399735-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Follow-up the removal of unused internal api of port params made by
commit 42ded61aa75e ("devlink: Delete not used port parameters APIs")
and stub the commands and add extack message to tell the user what is
going on.

If later on port params are needed, could be easily re-introduced,
but until then it is a dead code.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
v1->v2:
- added extack message filling to dumpit()
- added Jakub's rvb tag
---
 include/net/devlink.h |  1 -
 net/core/devlink.c    | 78 +++----------------------------------------
 2 files changed, 5 insertions(+), 74 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 119ed1ffb988..0b45d44a3348 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -118,7 +118,6 @@ struct devlink_rate {
 
 struct devlink_port {
 	struct list_head list;
-	struct list_head param_list;
 	struct list_head region_list;
 	struct devlink *devlink;
 	unsigned int index;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b50bcc18b8d9..9a1489dc6bd6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5574,89 +5574,22 @@ static int devlink_nl_cmd_param_set_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 						struct netlink_callback *cb)
 {
-	struct devlink_param_item *param_item;
-	struct devlink_port *devlink_port;
-	struct devlink *devlink;
-	int start = cb->args[0];
-	unsigned long index;
-	int idx = 0;
-	int err = 0;
-
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		devl_lock(devlink);
-		list_for_each_entry(devlink_port, &devlink->port_list, list) {
-			list_for_each_entry(param_item,
-					    &devlink_port->param_list, list) {
-				if (idx < start) {
-					idx++;
-					continue;
-				}
-				err = devlink_nl_param_fill(msg,
-						devlink_port->devlink,
-						devlink_port->index, param_item,
-						DEVLINK_CMD_PORT_PARAM_GET,
-						NETLINK_CB(cb->skb).portid,
-						cb->nlh->nlmsg_seq,
-						NLM_F_MULTI);
-				if (err == -EOPNOTSUPP) {
-					err = 0;
-				} else if (err) {
-					devl_unlock(devlink);
-					devlink_put(devlink);
-					goto out;
-				}
-				idx++;
-			}
-		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
-	}
-out:
-	if (err != -EMSGSIZE)
-		return err;
-
-	cb->args[0] = idx;
+	NL_SET_ERR_MSG_MOD(cb->extack, "Port params are not supported");
 	return msg->len;
 }
 
 static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[1];
-	struct devlink_param_item *param_item;
-	struct sk_buff *msg;
-	int err;
-
-	param_item = devlink_param_get_from_info(&devlink_port->param_list,
-						 info);
-	if (!param_item)
-		return -EINVAL;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = devlink_nl_param_fill(msg, devlink_port->devlink,
-				    devlink_port->index, param_item,
-				    DEVLINK_CMD_PORT_PARAM_GET,
-				    info->snd_portid, info->snd_seq, 0);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
+	NL_SET_ERR_MSG_MOD(info->extack, "Port params are not supported");
+	return -EINVAL;
 }
 
 static int devlink_nl_cmd_port_param_set_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[1];
-
-	return __devlink_nl_cmd_param_set_doit(devlink_port->devlink,
-					       devlink_port->index,
-					       &devlink_port->param_list, info,
-					       DEVLINK_CMD_PORT_PARAM_NEW);
+	NL_SET_ERR_MSG_MOD(info->extack, "Port params are not supported");
+	return -EINVAL;
 }
 
 static int devlink_nl_region_snapshot_id_put(struct sk_buff *msg,
@@ -9846,7 +9779,6 @@ int devl_port_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
-	INIT_LIST_HEAD(&devlink_port->param_list);
 	INIT_LIST_HEAD(&devlink_port->region_list);
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
-- 
2.37.1

