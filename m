Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8FA66CDD7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbjAPRnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbjAPRmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:42:32 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F50D367DA
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:20:49 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k18so6919521pll.5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9OrnhmiWvG28p8yGHg8Z8qfwpgLV1Cu+12SjNOPUEmE=;
        b=ZJs3CTXptnhO28MRqeIm6H86+Qh2AA6d1h5kYvPf4djur5iFMI0SaS6IP5feuXpd3z
         34l43Ru7kvjYQM3O/GuGv7fbAK8TknoTlV+QQmt3ZPMp1xdltbhKdm4hZaFut3zCuXyS
         +cUOcYYNvmnOiakLVXjtbmLMT+RkAZj8HHKNKG0lX+a1x1BDPEYsAni8/MLf2G2WVVIG
         nmm0o5Say7xAI9KvXN2gA6CxjgpzpY9ZfIDQZBELWjGi7FLcLu5FMaJLX+10D4dIkPKZ
         1jPNGr7bkw6Cw/bJRbmC/0/63nrJARJ2HNF/i58d94R5g/+S4hRsQw9MooQ+a0nByIT1
         64vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9OrnhmiWvG28p8yGHg8Z8qfwpgLV1Cu+12SjNOPUEmE=;
        b=WWQNULhBKvDxXs3ww1CEi0E9fYm61yh5plNjYq0g4s+eKcPtVCokzZAHKqXWDm/RPw
         IWqPIXCIoB7VdhnuZDxr5b19wpT/OhFpkHXZzjlsw6SNGuTCQJ+IXaJzkQemiu4XQ1Kn
         eXk6C/yWPsNAShjDJX3ukZ7Wi2p0aSerZUU2bbXpdaHW5AKDkywDGcQAtpc1dOEmYIj2
         KyZo5A8u9ndHH2FwANlTSCAjb9ngq42gMYAaq6Yn0HFdGo5XcORdR2SzG1RLM+OuG3FL
         E04oS05fMoFccQmlyfHDgddM5gOyPY85Y1I5cWgoSZcYrM1T1+PY7LA3r+0c2KP8xgh3
         v1Iw==
X-Gm-Message-State: AFqh2krzJ3uU9a8K/HQhuDs1cWbJyYQSlZWtk29NQfsCwOHhYHqvqEvb
        o//hSF/K1BiEOsTe1ym+QwoqwwIpCogG6IzPpKA=
X-Google-Smtp-Source: AMrXdXuarI1UuYiUySH/V+FwwKQUas07qiykGf03VAZMTZXz272cKKtycS+DQsczeZ/MU9JspTX6rQ==
X-Received: by 2002:a17:902:9f93:b0:193:1458:9e00 with SMTP id g19-20020a1709029f9300b0019314589e00mr23528715plq.2.1673889648370;
        Mon, 16 Jan 2023 09:20:48 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d90500b001946119c22esm8611564plz.146.2023.01.16.09.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:20:47 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute] add space after keyword
Date:   Mon, 16 Jan 2023 09:20:46 -0800
Message-Id: <20230116172046.82178-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The style standard is to use space after keywords.
Example:
	if (expr)
verus
	if(expr)

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 dcb/dcb_app.c     | 2 +-
 devlink/devlink.c | 2 +-
 ip/iprule.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index b9ac8f4bce59..eeb78e70f63f 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -264,7 +264,7 @@ static int dcb_app_parse_pcp(__u32 *key, const char *arg)
 {
 	int i;
 
-	for(i = 0; i < ARRAY_SIZE(pcp_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(pcp_names); i++) {
 		if (pcp_names[i] && strcmp(arg, pcp_names[i]) == 0) {
 			*key = i;
 			return 0;
diff --git a/devlink/devlink.c b/devlink/devlink.c
index 931a768a41d1..795f8318c0c4 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1963,7 +1963,7 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 
 			dl_arg_inc(dl);
 			err = dl_argv_str(dl, &sectionstr);
-			if(err)
+			if (err)
 				return err;
 			err = flash_overwrite_section_get(sectionstr,
 							  &opts->overwrite_mask);
diff --git a/ip/iprule.c b/ip/iprule.c
index 654ffffe3cc0..458607efd93f 100644
--- a/ip/iprule.c
+++ b/ip/iprule.c
@@ -695,7 +695,7 @@ static int iprule_list_flush_or_save(int argc, char **argv, int action)
 			else if (ret != 2)
 				invarg("invalid dport range\n", *argv);
 			filter.dport = r;
-		} else{
+		} else {
 			if (matches(*argv, "dst") == 0 ||
 			    matches(*argv, "to") == 0) {
 				NEXT_ARG();
-- 
2.39.0

