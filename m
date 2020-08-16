Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD622459FC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 01:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgHPXDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 19:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHPXC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 19:02:59 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07F3C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 16:02:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 2so6872496pjx.5
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 16:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YlXi8oq2SkSLWERMryVrYIvryhN3KAGKMsv9HpQvI4g=;
        b=KBmfdDgojhtizcS+NteyMMOYsP6/jMPxf6GAp6fehbnz0JfsOxsPS5ZbeAfGFcwlAb
         /eBQngwhvI8mllBCirn3yP5WlzYV69TFw93mGV9NfJt74TnC0y+oYL+97PWK1IKJQ7pv
         pvbp1PsYr5Z6pDaAHX3VC6EGPL00sGrz3vb6N0ep6JyTdWNZPa+2NCmd8wLFLFikq1X+
         ch87J7Z4aZmUDkDzoa2aVsfRNy8U3fmTlq7uat/JgZkSKpRmeboBITb0KTF2OWqMYljq
         uRBTESotSInQJ5SbT7GzHQRyZtPe21k/bzwodhvVHatKzx83koD+oCqve0T74JiTgdSb
         CKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YlXi8oq2SkSLWERMryVrYIvryhN3KAGKMsv9HpQvI4g=;
        b=gDbAPlxEi6mOwqb8OT5pKcSQs4zKnCPRFC14MXNsMS35Fu3vxCLcI5l4FUCsa6Mad9
         IPOJuiPdEdPz4CzyPJH8t55Ls6ujNouJq7HVLfOlrFaYctAgDxweUO8JWzuFGvYggegI
         7f5UPGu/xPJ3cfQDtBJ/fQPDpdHxIOlTkKul1g1rsu7HxaqvnVlrRFGVdOzuU4Wa5rJz
         OM3SNvf6ScTQAWS+tgNx24ZhgS4UzWgxvC4fxdEHPwksFPaL92YeOAc/WsLUdEQ9Eemw
         s1zVISnhVDZDHX9ragcJmXQWAh5Q/y731q0ZGaqQUBGnjuRWRG+2i01vL8l9FLcq1pfw
         CzeQ==
X-Gm-Message-State: AOAM533+NJusmSf+2M3v0rb6sTgdItS6Z7daN1FVlNUe47kJupZ29Co5
        M4yjBTHqAX4qfgmsDvriGuuwXnx9VuD42w==
X-Google-Smtp-Source: ABdhPJwbKnqZU5lTDqo+bERARUx44glYWD6PjnW0tzczLehJbuhZe0ppbiWmlNcD0unj1Qoozvc4Ig==
X-Received: by 2002:a17:90a:3ac3:: with SMTP id b61mr9612581pjc.1.1597618979094;
        Sun, 16 Aug 2020 16:02:59 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 198sm16382760pfz.120.2020.08.16.16.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 16:02:58 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     leon@kernel.org
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v1 1/2] rdma: colorize interface names
Date:   Sun, 16 Aug 2020 16:02:55 -0700
Message-Id: <20200816230256.13839-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the standard color outputs for interface names

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 rdma/dev.c  | 2 +-
 rdma/link.c | 2 +-
 rdma/res.c  | 6 +++---
 rdma/stat.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index a11081b82170..fd4c2376550c 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -203,7 +203,7 @@ static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
 	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	print_color_uint(PRINT_ANY, COLOR_NONE, "ifindex", "%u: ", idx);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "%s: ", name);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "%s: ", name);
 
 	dev_print_node_type(rd, tb);
 	dev_print_fw(rd, tb);
diff --git a/rdma/link.c b/rdma/link.c
index bf24b849a1e0..4b68eb28ec36 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -244,7 +244,7 @@ static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 	open_json_object(NULL);
 	print_color_uint(PRINT_JSON, COLOR_NONE, "ifindex", NULL, idx);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "link %s/", name);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "link %s/", name);
 	print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
 	link_print_subnet_prefix(rd, tb);
 	link_print_lid(rd, tb);
diff --git a/rdma/res.c b/rdma/res.c
index dc12bbe4bffe..4661dda4c303 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -76,7 +76,7 @@ static int res_no_args_parse_cb(const struct nlmsghdr *nlh, void *data)
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	open_json_object(NULL);
 	print_color_uint(PRINT_ANY, COLOR_NONE, "ifindex", "%u: ", idx);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "%s: ", name);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "%s: ", name);
 	res_print_summary(rd, tb);
 	newline(rd);
 	return MNL_CB_OK;
@@ -167,7 +167,7 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 void print_dev(struct rd *rd, uint32_t idx, const char *name)
 {
 	print_color_int(PRINT_ANY, COLOR_NONE, "ifindex", NULL, idx);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "dev %s ", name);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "dev %s ", name);
 }
 
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
@@ -176,7 +176,7 @@ void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 	char tmp[64] = {};
 
 	print_color_uint(PRINT_JSON, COLOR_NONE, "ifindex", NULL, idx);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", NULL, name);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", NULL, name);
 	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]) {
 		print_color_uint(PRINT_ANY, COLOR_NONE, "port", NULL, port);
 		snprintf(tmp, sizeof(tmp), "%s/%d", name, port);
diff --git a/rdma/stat.c b/rdma/stat.c
index a2b5da1c7797..274e4aca5172 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -711,7 +711,7 @@ static int stat_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
 	open_json_object(NULL);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "link %s/", name);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "link %s/", name);
 	print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
 	ret = res_get_hwcounters(rd, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], true);
 
-- 
2.27.0

