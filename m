Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4868A19E66A
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDDQQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39846 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgDDQQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id p10so12263814wrt.6
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r6RcQ0D3q+mp04TlRs1vLXwtVfdubi4L7nlj47ubmjk=;
        b=e1miN34xxQwyyXHV2R7lbzNW9uIr8R3oOkfoTWFDrtZK78gh991Xfok1Cm03Rlzm3J
         W+8c+vC/15Mj0yE58+TeyZtAdlNBSgOswBrVLUIvosxb6mHL5vp2MW6FNoOIQ95LSila
         gDecRfIY/lSsMLzhgbPjIgqBy9rCTi/HWVQhFHtY5S0CWB2NkROvc+l59EYaEGz0RCLy
         1x1bkUb4ZeqnBgGMdbM3Msl8P6JFg6/yEFh1CQuEa8tV09vj1ek1/lf4BagvYsOts/mS
         0OpYQwXa9tmynbNNaoMU1TM4FU8pNna84UBA8mtIKJNtu13ucJnTq3Ag/fmMzCLl01T2
         WYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r6RcQ0D3q+mp04TlRs1vLXwtVfdubi4L7nlj47ubmjk=;
        b=lkkdviu4GvVqamWop8DtfNlIch4phQjjrukUZZIfEyLdaSj1kJh7xllfvTMNu/FzWt
         nnE64GFBjwrvKcE142rAa3e/DWV5QFoEXqlMlSi72fC1llkV6C5pPe4HWbYwdsL9uSWy
         XkeeGMs80fV/J4BgcMwTHz93bwbnue+niRzeUnZoY20ue1YZuiD9/ZR3hDAGyo6cfbkV
         Jgk9xbTvI+YQ/H/vQ+KgKggpbQ4mwcReK0HMehIqf15LwZHRizpRW02oIcF3YKQqOel8
         JbxkmcBprhStv1lv2d0jezieRBQb3vJNXqAF/lahefrglcE6sCGkV+QRM6IUWRsBO5JV
         FZ7A==
X-Gm-Message-State: AGi0PuYVtjW8f8lfCyZjUtF/MuGY+wtKUUqYB+bCFBnyiBnHNg27hM4S
        qyfdSf1wMoRJzr3vAu9MZ6p4mCtaL1g=
X-Google-Smtp-Source: APiQypIEjzOQQusLIQiMFiG8OB6gfGcpiQliBWcuT7fApVNUHQJN1qSzq1VRJDTWlM8rzOCAl2gi+Q==
X-Received: by 2002:a5d:4305:: with SMTP id h5mr14305939wrq.69.1586016990016;
        Sat, 04 Apr 2020 09:16:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w67sm16631957wmb.41.2020.04.04.09.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:29 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 6/8] devlink: Fix help message for dpipe
Date:   Sat,  4 Apr 2020 18:16:19 +0200
Message-Id: <20200404161621.3452-7-jiri@resnulli.us>
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

Have one help message for all dpipe commands, as it is done for the rest
of the devlink object. Possible and required options to the help.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 575737fff985..14ea91726892 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -4953,15 +4953,19 @@ static int cmd_dpipe_headers_show(struct dl *dl)
 	return err;
 }
 
-static void cmd_dpipe_header_help(void)
+static void cmd_dpipe_help(void)
 {
-	pr_err("Usage: devlink dpipe headers show DEV\n");
+	pr_err("Usage: devlink dpipe table show DEV [ name TABLE_NAME ]\n");
+	pr_err("       devlink dpipe table set DEV name TABLE_NAME\n");
+	pr_err("                               [ counters_enabled { true | false } ]\n");
+	pr_err("       devlink dpipe table dump DEV name TABLE_NAME\n");
+	pr_err("       devlink dpipe header show DEV\n");
 }
 
 static int cmd_dpipe_header(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
-		cmd_dpipe_header_help();
+		cmd_dpipe_help();
 		return 0;
 	} else if (dl_argv_match(dl, "show")) {
 		dl_arg_inc(dl);
@@ -5777,16 +5781,10 @@ out:
 	return err;
 }
 
-static void cmd_dpipe_table_help(void)
-{
-	pr_err("Usage: devlink dpipe table [ OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { show | set | dump }\n");
-}
-
 static int cmd_dpipe_table(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
-		cmd_dpipe_table_help();
+		cmd_dpipe_help();
 		return 0;
 	} else if (dl_argv_match(dl, "show")) {
 		dl_arg_inc(dl);
@@ -5802,12 +5800,6 @@ static int cmd_dpipe_table(struct dl *dl)
 	return -ENOENT;
 }
 
-static void cmd_dpipe_help(void)
-{
-	pr_err("Usage: devlink dpipe [ OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { header | table }\n");
-}
-
 static int cmd_dpipe(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
-- 
2.21.1

