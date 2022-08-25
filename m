Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E205A0B77
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbiHYI10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239952AbiHYI0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:26:51 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23F3A61E9
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:26:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z2so25134034edc.1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=WbSBIkWfRgNeFzO5j6qSn7xF1+G8byIT7X1hOQo1CDQ=;
        b=Y4CaTwejz1nc8qwBEO4OEGiTbk6gfMauiTDL5U7Jc9gNnTP59jEuOr1Jy20DO+29XG
         UDXsevU05wB566fZQ8etZzcTtkVw+T1TGoqetIJpCVwdcHhX51az+ScDMfd0S0E4e7e6
         tB55piwreRWI9HE/n2ZFnd7d/z8lhlDzFrhv9MMPu3DYEbCPJhbY3K80sKqfVlFlDT5E
         Gh6pyi71Nj9yMmwHzXr2vyMrMzQgi1R13EfV1tAJEBJZANx6Hi+I0f2nR1i7bXyjGfeZ
         lhzNiBFnuX9fYE9ZmW5KSEvzfXekeJERl0NRJUHONq9gK/63215h3cv70UYQuZWpra1p
         FUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=WbSBIkWfRgNeFzO5j6qSn7xF1+G8byIT7X1hOQo1CDQ=;
        b=qT/aSjgKayfZqNYlyVmlywdSqv0cYWcl9b2devplbazJ/S3BWZNzk1ZR+yl1yWbBog
         BcHt2cbPp4+jiqk26EKIJ1DOXvrWDZ4xS4/ph2HAq0u+kOxYIsmEIBDr32fqEDaMEran
         4yVI6TGL+QrPM6ECkiIBQ6KkixlX85bYgxd43vMq8EBsidOT03nqLM9OkTjEosOk5YFS
         TNTv+1aleDj1lxOuliSj+8YVgi5vgK/hhBaI/40kzTENLpDWHfkEgSdoIczT72Bw8vXd
         N7pW59ogpLaePJpK0eL9a0Ej/GGpt/wI5KOH27t2WRhe9jh4Xz/zsqfurFphUg0VzvaX
         G5qA==
X-Gm-Message-State: ACgBeo1curzm/OsMnhmaya8EkVA5SptpWvM9OCkoJ2zo1uLYL8UMeX3b
        tKuWO8rvGIKRE6YVn7OW7FrT4qtGDXrnHplS
X-Google-Smtp-Source: AA6agR52hFW9cViM8mV/rpaX5d8u3LCKdZDmbpYQyHx+/vEUhvrkBRu2uMYiMliq6XBVyxdCnEih4Q==
X-Received: by 2002:a05:6402:191:b0:445:cf66:25c5 with SMTP id r17-20020a056402019100b00445cf6625c5mr2286178edv.58.1661415989348;
        Thu, 25 Aug 2022 01:26:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e4-20020a056402088400b0043cb1a83c9fsm4401231edy.71.2022.08.25.01.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:26:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next] net: devlink: stub port params cmds for they are unused internally
Date:   Thu, 25 Aug 2022 10:26:28 +0200
Message-Id: <20220825082628.1285458-1-jiri@resnulli.us>
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
---
 include/net/devlink.h |  1 -
 net/core/devlink.c    | 77 +++----------------------------------------
 2 files changed, 4 insertions(+), 74 deletions(-)

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
index b50bcc18b8d9..6854f574e3ae 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5574,89 +5574,21 @@ static int devlink_nl_cmd_param_set_doit(struct sk_buff *skb,
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
@@ -9846,7 +9778,6 @@ int devl_port_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
-	INIT_LIST_HEAD(&devlink_port->param_list);
 	INIT_LIST_HEAD(&devlink_port->region_list);
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
-- 
2.37.1

