Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD0A3EED69
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbhHQN3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbhHQN3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:16 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B88AC061764;
        Tue, 17 Aug 2021 06:28:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n5so11560461pjt.4;
        Tue, 17 Aug 2021 06:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mDYDzAJgI3Yi2xQjA7+jur2uQaZxHW2DQmLX7dH4FJA=;
        b=ZRfwhdThkpHil8wPYbDEHSMqGHAjaU05qSU1QcZwvJqnvFT86ZH4tSOFBhmWxUxpJ4
         M2A2WDV2LJsXFowLtBJ/IC5eLUgGABrwMaMcuMelH1h1gjzVcJ3988n596IjuCiOdgO8
         4N6iXxmnqInZiMYnPJ+37t4PCGhgX9JfUcktZ9Z3zS68DFn8sYsGZml838yRXOxI0ZJZ
         FKqhMhKnpSiyEvCoyVoYWyhfYPs6Rc4GJxB05CXe6hATkizB2LpylovUYcszWzYNczRb
         nR0i4xU3uYWRmxwS6cnQLVII1EqE/x045U/Im1e+EHVfVcgh3SJgMosmdg9JJTf0Fh7h
         Z0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mDYDzAJgI3Yi2xQjA7+jur2uQaZxHW2DQmLX7dH4FJA=;
        b=n9gb7T1NdPPs3CW0gx7Bh1rpzGfNDFu2dyJ3VZdWP4FwuwN/py1227SLAuymg4Fwjg
         +laTZPdagqOI4hS5J67zObPPl5ZIfbWiMXv+RB8Z9HAuERfSW7+2Z0PhRuEVeSI5V2Wy
         wjajMQYn4VCDZf+ui4lvzu/WVKvCaLnnXClFoXc2MxXU2afatvvsxAaB5XgdKZ3UCFxJ
         qyfXpa1k6scZos57X7eVA85LoL+AcFZU87poGD/KYbknwVnuae/5b2BxNDJsQiy5T508
         EWyZOlPPyk/IzjvwnG9/s6uD6OhiEoTVkuLzsJXl7FUPDCoqpxq3atp4u7NQabdoJ0CA
         NZQQ==
X-Gm-Message-State: AOAM533TE3nCnw0y04Kt4Qvt8qA0qRjNhX8eqKKVGGq5H9kpjpo9ckju
        tNcbg7UnwMqsbCaiZPWRces=
X-Google-Smtp-Source: ABdhPJyxp1rkPoXeG1+USxftO2aGlLEy3fWxCsE4QPFrhEpsvASwGV5LDchuDdsQmVV0Hdz0cEm8LQ==
X-Received: by 2002:a63:20f:: with SMTP id 15mr3439266pgc.319.1629206922822;
        Tue, 17 Aug 2021 06:28:42 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:42 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 3/8] selftests: nci: Fix the typo
Date:   Tue, 17 Aug 2021 06:28:13 -0700
Message-Id: <20210817132818.8275-4-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Fix typo: rep_len -> resp_len

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 34e76c7fa1fe..b4d85eeb5fd1 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -158,7 +158,7 @@ static int get_family_id(int sd, __u32 pid)
 		char buf[512];
 	} ans;
 	struct nlattr *na;
-	int rep_len;
+	int resp_len;
 	__u16 id;
 	int rc;
 
@@ -167,10 +167,10 @@ static int get_family_id(int sd, __u32 pid)
 	if (rc < 0)
 		return 0;
 
-	rep_len = recv(sd, &ans, sizeof(ans), 0);
+	resp_len = recv(sd, &ans, sizeof(ans), 0);
 
-	if (ans.n.nlmsg_type == NLMSG_ERROR || rep_len < 0 ||
-	    !NLMSG_OK(&ans.n, rep_len))
+	if (ans.n.nlmsg_type == NLMSG_ERROR || resp_len < 0 ||
+	    !NLMSG_OK(&ans.n, resp_len))
 		return 0;
 
 	na = (struct nlattr *)GENLMSG_DATA(&ans);
@@ -194,7 +194,7 @@ static int send_cmd_with_idx(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 
 static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtemplate *msg)
 {
-	int rc, rep_len;
+	int rc, resp_len;
 
 	rc = send_cmd_with_idx(sd, fid, pid, NFC_CMD_GET_DEVICE, dev_id);
 	if (rc < 0) {
@@ -202,14 +202,14 @@ static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtem
 		goto error;
 	}
 
-	rep_len = recv(sd, msg, sizeof(*msg), 0);
-	if (rep_len < 0) {
+	resp_len = recv(sd, msg, sizeof(*msg), 0);
+	if (resp_len < 0) {
 		rc = -2;
 		goto error;
 	}
 
 	if (msg->n.nlmsg_type == NLMSG_ERROR ||
-	    !NLMSG_OK(&msg->n, rep_len)) {
+	    !NLMSG_OK(&msg->n, resp_len)) {
 		rc = -3;
 		goto error;
 	}
@@ -222,21 +222,21 @@ static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtem
 static __u8 get_dev_enable_state(struct msgtemplate *msg)
 {
 	struct nlattr *na;
-	int rep_len;
+	int resp_len;
 	int len;
 
-	rep_len = GENLMSG_PAYLOAD(&msg->n);
+	resp_len = GENLMSG_PAYLOAD(&msg->n);
 	na = (struct nlattr *)GENLMSG_DATA(msg);
 	len = 0;
 
-	while (len < rep_len) {
+	while (len < resp_len) {
 		len += NLA_ALIGN(na->nla_len);
 		if (na->nla_type == NFC_ATTR_DEVICE_POWERED)
 			return *(char *)NLA_DATA(na);
 		na = (struct nlattr *)(GENLMSG_DATA(msg) + len);
 	}
 
-	return rep_len;
+	return resp_len;
 }
 
 FIXTURE(NCI) {
-- 
2.32.0

