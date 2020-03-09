Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73017DDD3
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgCIKoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:44:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39810 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgCIKoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 06:44:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id w65so4098024pfb.6;
        Mon, 09 Mar 2020 03:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c8Bp+nPwovSicihOby87B5XLTMrdw3sYjYxEEbv5wt8=;
        b=slEGYIg59gh6ysTpgSZttggAxcCpjbi50lHHcbsbIvU2DKukrc3Q01mNHaf73uKUHZ
         FLMlK1HQrX9d49sNjBYmr9ojzqBg50RXrzUiV46ls92cKW3m4Uga03vcJWYzEeGZPfl+
         djqkwwCJ3/bWcEQi358FTnDB79G9mezvU5/ebwKPn9h7YRa7qxM7HGoip1Un+3+J8TGt
         v5k07WOj7xS+V+jfX8mNVBfggRglrlkx7WsDUL1nqFb9Tc40jr4v9+7LqB6UEv1b0Lc/
         o/sbT+7hqJWfAbS8Q0Y44pW7UbokiWk6cnykKsTGCvzC+j4weI9X7KTgdAxa+WnVlQnR
         509A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c8Bp+nPwovSicihOby87B5XLTMrdw3sYjYxEEbv5wt8=;
        b=R0uf4tOLOYsff7fdETvbEh2/+/ANaIUV205UFGTEiVlxC8pVWsVryxh/+czM5K6mGp
         13hdfMCSB/P6NtaHPJG9QcGBXNEJxuMkr9zpKXzepxgRNypQM3lgWiZYqkyxGIlYy1cF
         xOsgUAys8iIyk03Q8xoSi4/GPmgr/tdZPc3jTS9+HyiWLsK/5AiDr+K6MT+r0r0fU9Mg
         y5eSdRxpWmW7DQInZwFXqJy9njXEtcguP3gRfO26EQshB6CsqWFVp9/k6H3SYLxyXQ+0
         CS9yIfIsLpKZRG8+d214Ug2YMTPeQayi7Ufur9YWFtIkM25YvZ6q1jtExntJpCiEUdT5
         LybQ==
X-Gm-Message-State: ANhLgQ10FrGWWHnN325cco6ZqpJZe3Hzl4BQjVsBCDGUzt4dUmZA+XfL
        qMoeu2EDtAZ/R7KbjsjF4Rw=
X-Google-Smtp-Source: ADFU+vtRFX96zmPBwSppbimg+E/3Q+27jc5AiBLwDOEZdexKbH3UdJJl5iZcxnooBzPcmb+JPQQZtQ==
X-Received: by 2002:a63:b34d:: with SMTP id x13mr15895811pgt.317.1583750640989;
        Mon, 09 Mar 2020 03:44:00 -0700 (PDT)
Received: from masabert (i118-21-156-233.s30.a048.ap.plala.or.jp. [118.21.156.233])
        by smtp.gmail.com with ESMTPSA id t17sm44323051pgn.94.2020.03.09.03.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 03:44:00 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id BF2902360374; Mon,  9 Mar 2020 19:43:58 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     linux-kernel@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] linux-next: DOC: RDS: Fix a typo in rds.txt
Date:   Mon,  9 Mar 2020 19:43:56 +0900
Message-Id: <20200309104356.56267-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.26.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix a spelling typo in rds.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/networking/rds.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/rds.txt b/Documentation/networking/rds.txt
index f2a0147c933d..eec61694e894 100644
--- a/Documentation/networking/rds.txt
+++ b/Documentation/networking/rds.txt
@@ -159,7 +159,7 @@ Socket Interface
 	set SO_RDS_TRANSPORT on a socket for which the transport has
 	been previously attached explicitly (by SO_RDS_TRANSPORT) or
 	implicitly (via bind(2)) will return an error of EOPNOTSUPP.
-	An attempt to set SO_RDS_TRANSPPORT to RDS_TRANS_NONE will
+	An attempt to set SO_RDS_TRANSPORT to RDS_TRANS_NONE will
 	always return EINVAL.
 
 RDMA for RDS
-- 
2.26.0.rc0

