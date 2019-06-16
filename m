Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3294760B
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 19:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfFPRPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 13:15:05 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35692 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfFPRPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 13:15:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id l128so4860876qke.2
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EhF6MN43aTSzEpvd4U2cKVhLxUc43hI7bAyD4Ixl+AI=;
        b=LwqLEzQpvvRro9h8Hoy0z22HvnSANLLyHrDJ7mK83ITfyvM8eTVbAZcycd/W24oTDy
         XGtfsnoAJqy/CwIx5rNY0Sqc1n6CgrCRhH9hLtPgMIPkpvDIjoC8t3lyWn1CmtiN/0OO
         PkL1JcqHJHhfSdikKTi2T3gCJx30buEJMrgT0oT3UqTqMX6rwERcZ0DxOQSO8btUueDi
         gke3Nkv4n9FKzO1k4D5nLwG7RiNsIG27UWBqrXlsMoS5y1gP0VNeklnnn+0uB6icLgcT
         iQxScjiNVXF1UFoPFUwvTlAhqh6eUSMxg49TaZx2qXPqjIlO3oAcxSYvoQB4fAvFIRvR
         jv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EhF6MN43aTSzEpvd4U2cKVhLxUc43hI7bAyD4Ixl+AI=;
        b=bfPcAMFPnQebwDXgcQhrxTarIfwpxTF+DFVrTPip3flIZGebsvch5h+sA3Z4kaQ7fd
         GVjTwKNyWZhQPX8jr2o//3QeRcoUtr8lsAH7pfuB0X3whIv3pKvG9YCnaRzKETzBRl/o
         R2WLnHvVYFL+hAuy9JpZq14KuHg8mfWdmmP5yK168qA1L2rI/q3gLgN6OClgcoPfr2Hs
         yCZzY9XeYCBAvljI4CXCvMP276UoUDyQUKLHxgHItT8SWUR14CGeJeuhu2qwUZCmYE9I
         6R5HMrySEKeKe5FdKA9gFVRNhqN6YNniMuBP0EtYFmcycVfQzX7bc5ctjo9aJJqC+5l2
         RWQg==
X-Gm-Message-State: APjAAAUxugw8ZFG8fuvb8zL+RX1gO+eliDhFV4I/Ao0nNEyx8wWeCj/K
        Kcj8GoFoAPBoUiUe2iCTobz8Dm0Q
X-Google-Smtp-Source: APXvYqy4FdGdjLMhYr6KydgQ9w3Tzh7qBQqcN/Dm24eQadOhAwGTvWmQu+qefdvSk+TREvtVeW46RQ==
X-Received: by 2002:a37:66cb:: with SMTP id a194mr66061810qkc.312.1560705304011;
        Sun, 16 Jun 2019 10:15:04 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id n10sm5340708qke.72.2019.06.16.10.15.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 10:15:03 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jbaron@akamai.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: fix warnings in TFO key rotation selftest
Date:   Sun, 16 Jun 2019 13:15:01 -0400
Message-Id: <20190616171501.142551-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

One warning each on signedness, unused variable and return type.

Fixes: 10fbcdd12aa2 ("selftests/net: add TFO key rotation selftest")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/tcp_fastopen_backup_key.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_fastopen_backup_key.c b/tools/testing/selftests/net/tcp_fastopen_backup_key.c
index 58bb77d9e7e1..9c55ec44fc43 100644
--- a/tools/testing/selftests/net/tcp_fastopen_backup_key.c
+++ b/tools/testing/selftests/net/tcp_fastopen_backup_key.c
@@ -51,7 +51,7 @@ static const int PORT = 8891;
 static void get_keys(int fd, uint32_t *keys)
 {
 	char buf[128];
-	int len = KEY_LENGTH * 2;
+	socklen_t len = KEY_LENGTH * 2;
 
 	if (do_sockopt) {
 		if (getsockopt(fd, SOL_TCP, TCP_FASTOPEN_KEY, keys, &len))
@@ -210,14 +210,13 @@ static bool is_listen_fd(int fd)
 	return false;
 }
 
-static int rotate_key(int fd)
+static void rotate_key(int fd)
 {
 	static int iter;
 	static uint32_t new_key[4];
 	uint32_t keys[8];
 	uint32_t tmp_key[4];
 	int i;
-	int len = KEY_LENGTH * 2;
 
 	if (iter < N_LISTEN) {
 		/* first set new key as backups */
-- 
2.22.0.410.gd8fdbe21b5-goog

