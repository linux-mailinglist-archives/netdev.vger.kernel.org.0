Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F8A7D257
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 02:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfHAApP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 20:45:15 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45763 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfHAApO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 20:45:14 -0400
Received: by mail-pg1-f182.google.com with SMTP id o13so32913383pgp.12
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 17:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sWr/XTVtoSVqeHm5XWxCB4dM+MZPu5eIKyrimvUgDzo=;
        b=fAojip6TuKbk0sMOXwM+shTH8xJmvqHTsz9V5Nx2wcL9f8SV4qfPxsXLlexHAP9mhj
         sOUMfk6wmsqdPlore6Sbb641KZlpegk+zrShTufrVaH+0JOhcMG99nR/QgQOJ19ol/rL
         Ny0v+BnEQY6LrZAgQCC89GnxTc665yOcUdTZeXFr9hBWjmrICgFRxZA27nWdYn0kTdhP
         mkMFaMwSv88c9m9Ty4c1uj5ddanyLQiAL0xY81ApWoDyOnq1gR+S6ys1frNiN71/iEhh
         A/3y9UEqXsDpLzvgfDBY0Z+wJBFgCeYAarLRGKRCyJdJrGtwO+AekjrzSYMK2mPfYsZB
         ncGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sWr/XTVtoSVqeHm5XWxCB4dM+MZPu5eIKyrimvUgDzo=;
        b=rzbEslxZaSKfkVfpRKtbRhocbaOiWpcq95XjQ3NbcfxJD8kaZFlnXifQgcVJxRdtB0
         0Ay8KD6Oguh7n0xDVEpYcsLw4xkGtyjRDv+BhCh0ezooBaQmti+4hWccyVepJpRy14Kw
         JYe2+qz9O8HJkqTgxAOz858omC0+liNKNKQG3z1UTgXVw3HefekvBLiU35XQKvNInt2q
         MQqdoi32ovrNSnZaegmJ3DQMKKz24ULUZKS+6zubU6F7SS2tTuMp7Tx1o0vC8CqIoqTt
         3YH9CkOeYDTDSDzsenX2/n8mO1eEKr//b5TC30cGbQfK+XmDQevot0KMY9Y5FBThgJzQ
         teTQ==
X-Gm-Message-State: APjAAAUaWE4dUldy7ZKw2qz5j1YtCp40oRl+aHve2/iv/4GVSPemNaos
        GB4XW+L7cXfKKVcZAZqnvDeY9stS
X-Google-Smtp-Source: APXvYqybQpm5kJQ7MkJqKbwllbx6JxC05GxtPoKNZ4WQBA+YdOXyXkME34jZU0kNs+Qu9KC398wuwQ==
X-Received: by 2002:aa7:8189:: with SMTP id g9mr50996604pfi.143.1564620314027;
        Wed, 31 Jul 2019 17:45:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f32sm2435978pgb.21.2019.07.31.17.45.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 17:45:13 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     jiri@resnulli.us, chrism@mellanox.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 1/4] Revert "tc: Remove pointless assignments in batch()"
Date:   Wed, 31 Jul 2019 17:45:03 -0700
Message-Id: <20190801004506.9049-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801004506.9049-1-stephen@networkplumber.org>
References: <20190801004506.9049-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 6358bbc381c6e38465838370bcbbdeb77ec3565a.
---
 tc/tc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tc/tc.c b/tc/tc.c
index 64e342dd85bf..1f23971ae4b9 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -326,11 +326,11 @@ static int batch(const char *name)
 	struct batch_buf *head = NULL, *tail = NULL, *buf_pool = NULL;
 	char *largv[100], *largv_next[100];
 	char *line, *line_next = NULL;
+	bool bs_enabled_next = false;
 	bool bs_enabled = false;
 	bool lastline = false;
 	int largc, largc_next;
 	bool bs_enabled_saved;
-	bool bs_enabled_next;
 	int batchsize = 0;
 	size_t len = 0;
 	int ret = 0;
@@ -359,6 +359,7 @@ static int batch(const char *name)
 		goto Exit;
 	largc = makeargs(line, largv, 100);
 	bs_enabled = batchsize_enabled(largc, largv);
+	bs_enabled_saved = bs_enabled;
 	do {
 		if (getcmdline(&line_next, &len, stdin) == -1)
 			lastline = true;
@@ -394,6 +395,7 @@ static int batch(const char *name)
 		len = 0;
 		bs_enabled_saved = bs_enabled;
 		bs_enabled = bs_enabled_next;
+		bs_enabled_next = false;
 
 		if (largc == 0) {
 			largc = largc_next;
-- 
2.20.1

