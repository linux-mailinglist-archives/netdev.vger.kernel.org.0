Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A76019E667
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgDDQQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45460 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgDDQQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id v5so1308503wrp.12
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eLvmp6A3nGOQm6VmOzL+HZWrPUPixMgr6EG8rA6Q21c=;
        b=IaCFVISaNF7r8Ev2Oy+JsBBfmUcPfi0qdEXPe+m64hRvF0rsNyWq2jqyOeHBCQ8rHu
         erImGtCXUME/AFuB8vo1PhrZKvR0D2v3DJSa9LVakin0jeeDT3fcpqzid6tmdkFC334w
         8eyXs9iKf6dllq/1Rh2hQSNps2GqZ2zqK4kfb5lS9dzhb7KWI3En7/dXZFV77QeJkVJq
         Ndit3zz33G8Qb2Ed86a8uoyFQDsmQonLPDOvZeyorrSC1bm2NqXLEQyPA/fGQe36ezMD
         /P29bC3Pbq46mikoPp0gkG65jOo5V+KtSPX1ifofjpqmJWl4dpY/rv1m1h2KXWkJxk/F
         /8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eLvmp6A3nGOQm6VmOzL+HZWrPUPixMgr6EG8rA6Q21c=;
        b=CoLxtP1kZa65z4WPDOLxBfRlEM+ZhfI0sm5rAMJaqO5sdqP1iKqDw+RxiSfO+r+a5U
         qG0zU6WYsHAAjic7q9LepCzTsL8x26kPdW2XvZ963fN5pbx9Q6YQoT8St/Eq7yOEAd7l
         HUSCZlZD43FCPeDICygLH7CHhCHB0lQn2dZPFGghK0BpWXbxY9nxV0Kzyjyh26kd9vL5
         B5x/TstHkVCuB53AWbRY5KcsnjIH0bqfhoMvxaDq1JWdeP9v6tEFbIVm7cOZt3evO1Fh
         9fFWOPULRwV+X9zoLQdnC1TiIO8NBvZLxBY5OGxE1Tm3GdLCxIRvScgWh7GRu8tA0LuE
         acAw==
X-Gm-Message-State: AGi0PuYKcSZf7m6eexEf1pXVtCX0tnZcRlWWm6YNGEpQL24T9Q+c3175
        EEqI7yMQZlWRAuRgfYaGzd66Kddb1VM=
X-Google-Smtp-Source: APiQypJbRoSIV5ii2944rn1K3Opf3M8QEa3feNv7UQMp09j7B9G2k4mxDTwMG74IppXid3pa37qT5g==
X-Received: by 2002:a5d:6588:: with SMTP id q8mr12298630wru.189.1586016991111;
        Sat, 04 Apr 2020 09:16:31 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r5sm16240323wmr.15.2020.04.04.09.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:30 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 7/8] devlink: remove "dev" object sub help messages
Date:   Sat,  4 Apr 2020 18:16:20 +0200
Message-Id: <20200404161621.3452-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200404161621.3452-1-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Remove duplicate sub help messages for "dev" object and have them all
show help message for "dev".

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 14ea91726892..efc5591d5ebf 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2740,18 +2740,13 @@ static int cmd_dev_show(struct dl *dl)
 	return err;
 }
 
-static void cmd_dev_reload_help(void)
-{
-	pr_err("Usage: devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
-}
-
 static int cmd_dev_reload(struct dl *dl)
 {
 	struct nlmsghdr *nlh;
 	int err;
 
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
-		cmd_dev_reload_help();
+		cmd_dev_help();
 		return 0;
 	}
 
@@ -2873,11 +2868,6 @@ static int cmd_versions_show_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static void cmd_dev_info_help(void)
-{
-	pr_err("Usage: devlink dev info [ DEV ]\n");
-}
-
 static int cmd_dev_info(struct dl *dl)
 {
 	struct nlmsghdr *nlh;
@@ -2885,7 +2875,7 @@ static int cmd_dev_info(struct dl *dl)
 	int err;
 
 	if (dl_argv_match(dl, "help")) {
-		cmd_dev_info_help();
+		cmd_dev_help();
 		return 0;
 	}
 
@@ -2906,12 +2896,6 @@ static int cmd_dev_info(struct dl *dl)
 	return err;
 }
 
-static void cmd_dev_flash_help(void)
-{
-	pr_err("Usage: devlink dev flash DEV file PATH [ component NAME ]\n");
-}
-
-
 struct cmd_dev_flash_status_ctx {
 	struct dl *dl;
 	char *last_msg;
@@ -3059,7 +3043,7 @@ static int cmd_dev_flash(struct dl *dl)
 	int err;
 
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
-		cmd_dev_flash_help();
+		cmd_dev_help();
 		return 0;
 	}
 
-- 
2.21.1

