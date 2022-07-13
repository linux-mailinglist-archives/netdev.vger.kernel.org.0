Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779E8573893
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiGMOTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236455AbiGMOTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:19:01 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D7FE08D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:19:00 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id oy13so15263190ejb.1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IUSKZ5hVydPYGMVd2QIHCwI22Wd1tI7e9fbKWH3ODT4=;
        b=ie8SHxnYD1RfWCEquafqtutY8+AaZnyaFH1zqvsv0QvZKQstNGAjDfwH9Rr4jyglKZ
         0xhXLuFahazETgRQlXNBkEx6rKE6waEgLCiE98hV9Zy4BR5orpHnAKxSXuTb1ZGKaJ11
         8JPQ//MAmkSTcXkltb6Lp+VQyp+stwXVXmY+b4H+tbaTeNAGbvZi0t+1+E63pZR70DiC
         8inAA3F0gOzRwo6UJ0w9lsvdY6WaBKOmvjPhRvQXit4ZBIRnpijCFTnHJfNZ5PcZAWNE
         lWVHf2At3zh2oyZa+58hVStFDy8ErjH6ExK8JTgD5aAMzjFGscPTI3rCsTOjxIid1jBx
         As5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IUSKZ5hVydPYGMVd2QIHCwI22Wd1tI7e9fbKWH3ODT4=;
        b=I/uGMNZX4fYuwo7ag7AjXMCvnskOTQ6eMwqQFAQ6+5U30kuT5+/45v1NgprP1VOH9F
         emNv3SlAOYLogKmbCZcNsx58ZA2Kj6eQeVPOLANxCQFU8j7e2aeSa0K+mKGgMss0kqOh
         OGD35nE4UDRUrDjBJS//fMcnZ0b5BsnoGLTBGe9GUmws2vQPgiWv2XB6wCftPbTFt1dc
         wRT5ZBAK8AB5jhQ074EWOkTBPC5sMB7BmeYTPoZ29tO7qMe+dfsqnHLk+25LkIDcHg6V
         Z6EGKxM1xTmHaRMV6W774zPorGG7zv51M4mijMxU6KCn4/EN+kzRN4wF0vh5mNHNGX22
         yKzw==
X-Gm-Message-State: AJIora+bE2tnYmBQRAQI6X5WnIsbHDB03sD9p66pV2aBNVbnGnXwIYTT
        lJCAhkRKS+s1FM6o0154sx2YlPjEtW5Iq7/MaWk=
X-Google-Smtp-Source: AGRyM1v5d+G6aQ4x3CXgxDWs/Ii26MgaZqVZkNWuI1z07BArMXYixmgeSEie4q1LNI6XFr71mwl9nw==
X-Received: by 2002:a17:906:98c7:b0:72b:2f8a:66b4 with SMTP id zd7-20020a17090698c700b0072b2f8a66b4mr3630260ejb.692.1657721938527;
        Wed, 13 Jul 2022 07:18:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g24-20020a170906539800b00727c6da69besm5007811ejo.38.2022.07.13.07.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:18:58 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next repost 2/3] net: devlink: fix a typo in function name devlink_port_new_notifiy()
Date:   Wed, 13 Jul 2022 16:18:52 +0200
Message-Id: <20220713141853.2992014-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220713141853.2992014-1-jiri@resnulli.us>
References: <20220713141853.2992014-1-jiri@resnulli.us>
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

Fix the typo in a name of devlink_port_new_notifiy() function.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index c261bba9ab76..2f22ce33c3ec 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1700,9 +1700,9 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 	return devlink->ops->port_unsplit(devlink, devlink_port, info->extack);
 }
 
-static int devlink_port_new_notifiy(struct devlink *devlink,
-				    unsigned int port_index,
-				    struct genl_info *info)
+static int devlink_port_new_notify(struct devlink *devlink,
+				   unsigned int port_index,
+				   struct genl_info *info)
 {
 	struct devlink_port *devlink_port;
 	struct sk_buff *msg;
@@ -1775,7 +1775,7 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	err = devlink_port_new_notifiy(devlink, new_port_index, info);
+	err = devlink_port_new_notify(devlink, new_port_index, info);
 	if (err && err != -ENODEV) {
 		/* Fail to send the response; destroy newly created port. */
 		devlink->ops->port_del(devlink, new_port_index, extack);
-- 
2.35.3

