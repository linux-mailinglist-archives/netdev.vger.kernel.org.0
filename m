Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6CD533581
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbiEYCxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiEYCxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:53:16 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB993E0FB
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:53:14 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id ej7so15573480qvb.13
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uBhCzmqzgb010Pbxq+nybhXov3w41PJ4SfGCmM0apCI=;
        b=FqRln8F6zL7lK5lkoTxROXgO/CNJGZs5I7rMTVabesE9+MJlpq6aEZ4LMeiu9MHyFn
         XwLx8CyK1N24k/hbfsCvGZ/d2bhJpx7mevaHt0CCDh9BsYEO3O+v9R1nYhdVk/I0rrDv
         96xXfoOo3Gia/HOWUxZQ5+kBQt6awlGtPLjwWHeq3HlKT887DAjRFL726ZfsES1GSWXO
         br8C8CkV77zliBRBhNf3+FTcW5AwIl3i/LvXKW/f1vfGAmZrz3rx6K8+ybRUWISKDHPK
         8OMsMFh7gLM/lneW/FyMJ0c5sq/M2M7FOZWWIjGhagOLcejMEq79uS+ivJrEAm3kFI+t
         H1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBhCzmqzgb010Pbxq+nybhXov3w41PJ4SfGCmM0apCI=;
        b=NDELRri+vhp6RuzQqTf9qYnsmenYWpCcp2Sj3qL81Yhb/MGSIqeRjK9Gl9wGF6jsOh
         uGnL/0SC2/DX7CdAChxF9rDNXpYQpMf1us99rvrzVXRs2HxLgiYm/omLLr4+g9dHKg9e
         0ZI5nZGk5RIGHEMiDxw2EupXHWdMg2qXMRV48IZbgpVF6k1xe04aG+IrUQhNNp0aA7/N
         VJ1FjK5Et9r0uOkzd2oekk7IvZ11AyqYd3d43EQwneVluKg5o7YFbMjjWootOMIqc7wm
         rKxD0UdPnJGsJkm4+5YuSzHxHaj5t6Jq+1A1nHfAKEWIxqqAH30RRc1yBb3AMc0GlEAH
         u4Dg==
X-Gm-Message-State: AOAM533xDGFUA+IBsP0bE/ZRCeE8wDYd5HwE5wJKs+q6wQ0vaXHO9mgu
        K8Ojczopbc3sutUaQlINYA==
X-Google-Smtp-Source: ABdhPJyeE+8PoNxfgpaeDUMOndroR8zgVrS3CO8yHJhJksMrFthNe+c/3c7W0mmGZiR/nU8JNbm/hw==
X-Received: by 2002:ad4:5f4e:0:b0:462:3d31:6faf with SMTP id p14-20020ad45f4e000000b004623d316fafmr10929569qvg.119.1653447194082;
        Tue, 24 May 2022 19:53:14 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id 74-20020a37064d000000b0069fc13ce204sm558352qkg.53.2022.05.24.19.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:53:13 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 5/7] ss: Fix coding style issues in user_ent_hash_build()
Date:   Tue, 24 May 2022 19:53:05 -0700
Message-Id: <d32e90ccce3003fa0cdf05b95e0427de8a28684e.1653446538.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
References: <cover.1653446538.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Make checkpatch.pl --strict happy about user_ent_hash_build().

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 misc/ss.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index ec14d746c669..42d04bf432eb 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -599,7 +599,7 @@ static void user_ent_hash_build(void)
 
 	strlcpy(name, root, sizeof(name));
 
-	if (strlen(name) == 0 || name[strlen(name)-1] != '/')
+	if (strlen(name) == 0 || name[strlen(name) - 1] != '/')
 		strcat(name, "/");
 
 	nameoff = strlen(name);
@@ -622,7 +622,8 @@ static void user_ent_hash_build(void)
 
 		snprintf(name + nameoff, sizeof(name) - nameoff, "%d/fd/", pid);
 		pos = strlen(name);
-		if ((dir1 = opendir(name)) == NULL) {
+		dir1 = opendir(name);
+		if (!dir1) {
 			freecon(pid_context);
 			continue;
 		}
@@ -640,9 +641,9 @@ static void user_ent_hash_build(void)
 			if (sscanf(d1->d_name, "%d%*c", &fd) != 1)
 				continue;
 
-			snprintf(name+pos, sizeof(name) - pos, "%d", fd);
+			snprintf(name + pos, sizeof(name) - pos, "%d", fd);
 
-			link_len = readlink(name, lnk, sizeof(lnk)-1);
+			link_len = readlink(name, lnk, sizeof(lnk) - 1);
 			if (link_len == -1)
 				continue;
 			lnk[link_len] = '\0';
@@ -650,7 +651,8 @@ static void user_ent_hash_build(void)
 			if (strncmp(lnk, pattern, strlen(pattern)))
 				continue;
 
-			sscanf(lnk, "socket:[%u]", &ino);
+			if (sscanf(lnk, "socket:[%u]", &ino) != 1)
+				continue;
 
 			if (getfilecon(name, &sock_context) <= 0)
 				sock_context = strdup(no_ctx);
@@ -658,16 +660,16 @@ static void user_ent_hash_build(void)
 			if (process[0] == '\0') {
 				FILE *fp;
 
-				snprintf(tmp, sizeof(tmp), "%s/%d/stat",
-					root, pid);
-				if ((fp = fopen(tmp, "r")) != NULL) {
+				snprintf(tmp, sizeof(tmp), "%s/%d/stat", root, pid);
+
+				fp = fopen(tmp, "r");
+				if (fp) {
 					if (fscanf(fp, "%*d (%[^)])", process) < 1)
 						; /* ignore */
 					fclose(fp);
 				}
 			}
-			user_ent_add(ino, process, pid, fd,
-					pid_context, sock_context);
+			user_ent_add(ino, process, pid, fd, pid_context, sock_context);
 			freecon(sock_context);
 		}
 		freecon(pid_context);
-- 
2.20.1

