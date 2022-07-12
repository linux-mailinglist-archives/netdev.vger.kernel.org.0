Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F1257178F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiGLKtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbiGLKtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:49:06 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED6E1FCD8
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:49:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v12so9546275edc.10
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H26OfbW/YT2X377qgJMvhVMj5grGfc0kIq9uEFQaW9k=;
        b=6rxjBSy6kYL3uz0ZkbyThHhBKBiYS3WaM1Lv+dKCN+V/N/ursA4zuuiYK8oV2oKhS5
         PKEXxb8EDDJypvdmEHwYRhxPJ0/xZBJzo4sr6iiZz87uWxwVOGRzi9OVpFGVcdL1ZsFU
         XtEVbaXW2383ZeEgUiWY1pEDHS1UJ96McmhtwF6frmR9qG/aJYotoR50JydHz65lfH9O
         icY4+Z3O3lbb89kx395x6cLeVkv8AUxLSVXbz4aUP1+LSI7/sDAg/hCZjnIZPmpXwme0
         PXL4n50JSvybZUlquYKoaDmie4J0fyVb5ZJbw+2OGzUuCx5wmca3XarihipsGT5c02Vy
         8Q+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H26OfbW/YT2X377qgJMvhVMj5grGfc0kIq9uEFQaW9k=;
        b=7WuxwH94gz1uEI7MlbgPjp0FnldZeoH2JJ3KaMraahRkBO9vR+Yxxxko78hlKvSWTh
         0pvbNom1JiWSutom8wBjxktqT/tM/spSMiN3xOPQROG8wpEMQ5b2JEJ8sBD56Q5TsLyD
         /NW4TDRBREY77SUUffXYM2bgoFKxc+mYomXAO/PAC4B5EWE0HpcFcXco4bpeGMQsE+TZ
         huSqVyE/cy51qkAiIp8jwiR8Uxmu4hqO3F6UzDbT8YsPTvNUBQdR7yDwqWPeGhD6C04O
         F8+hINez2ll/ugVsdWZ6QjNcwHwfrSAN1FqDB91RVib5Sy6RgYYCuUa1Y/yzpetQHKwX
         tReg==
X-Gm-Message-State: AJIora9YmbsMa4DpfI/HCXTGX432ltIVHLjmUb2jT+2C6+nWjwUBW4ld
        PgFw7hhW8zqAP1GXBNQjauN/Xq5jw2+bV6AYjC8=
X-Google-Smtp-Source: AGRyM1t8slqFVBoKbK1OfM99fI0uXEDjWQiR5KzTfkRk83N0BQrIBvqRtYb18KQddZWh0qGooqAYjQ==
X-Received: by 2002:a05:6402:1502:b0:439:e4a5:4ba9 with SMTP id f2-20020a056402150200b00439e4a54ba9mr31366280edw.19.1657622938820;
        Tue, 12 Jul 2022 03:48:58 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s10-20020a170906354a00b00705cdfec71esm3699505eja.7.2022.07.12.03.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:48:58 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 2/3] net: devlink: fix a typo in function name devlink_port_new_notifiy()
Date:   Tue, 12 Jul 2022 12:48:52 +0200
Message-Id: <20220712104853.2831646-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712104853.2831646-1-jiri@resnulli.us>
References: <20220712104853.2831646-1-jiri@resnulli.us>
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

