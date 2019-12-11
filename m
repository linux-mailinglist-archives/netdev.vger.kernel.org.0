Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F5E11BB42
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbfLKSPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:32 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33677 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731249AbfLKSP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:28 -0500
Received: by mail-yb1-f194.google.com with SMTP id o63so9412409ybc.0;
        Wed, 11 Dec 2019 10:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4awfmVKPws5vxP93HnYWNI+fZRnhVZj4z7QMlkLCxoc=;
        b=DaxkaBWzP/miLV6xViB100JHzouBPUUAx3i+z9hL9GJAU5P5azAY5pzUDbMNu+Cehd
         AU84mesIjytm+s1sJA1SB7DK6GN7F3gZbxQbJqvawyMErooS6aCe1CNiGjBwynyutjBW
         wz2UJX69cdLQUQGEYRuaxFy+T8YVq1DbpcfSVo/qtHrhZSCIhLLBI0Vmtw5F+hF09HTQ
         Cx14URfY/KOxLqyJC67HoZIjoFeidI2cu9G+cFVtmb3xxFqUV8tS8hRKyZ+5UJpVIl7X
         FbNi/P1rTcsBx+jxFYR7ftTIt56L63JuPQDLpdnF2vHbr/2er2qoJ+5+sYF9R5niGGeb
         K9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4awfmVKPws5vxP93HnYWNI+fZRnhVZj4z7QMlkLCxoc=;
        b=Au4naWedgzWyKbX13rFwbi+qg0rteNJranGZsGMNj6GhBxwfBiRb1hGEJTS7RB8yD9
         1a5yYRURwUasQzeLiqtl8Ugwyq0jV59e8YGuiaQrEUfFHY6nUnHedsDkSRClzt7Dp+7j
         NtOFQgM5wnxhsocWFuS8M2bJgia0PR1Xw4TDqjdrztLDJFLqP1kjwDghuS72f5QIND/g
         3pQtjOkd72dgXiJcX3n+Ye9ttHYeE6uQdGdNd9ZF8Zird2G8Iy+R6cLwhYGGy+w2Tj5t
         FI6p1GS9zo1Gvy0rfBS1gpjyFeWFznNmhFpYsOaqqeRnMuc4vKwcdPqG5owrunrD1Kyo
         z3TA==
X-Gm-Message-State: APjAAAVjzxQkoCKgi37ypf0URnvk69vt8LpjAb2c/sN6kcwBsq91e0EH
        pmQ3vJ0uO2lFxdFe9ux5DkIJtLaJVjtWgg==
X-Google-Smtp-Source: APXvYqwB8EyYkZ5Vifm/xgiLEtGAKGndz9AKxvYQpmI2B23qc99C6RAXG9eweb+X3uRymoNYiZ5xbQ==
X-Received: by 2002:a5b:451:: with SMTP id s17mr1014875ybp.8.1576088127402;
        Wed, 11 Dec 2019 10:15:27 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id d186sm1340039ywe.0.2019.12.11.10.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:27 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/23] staging: qlge: Fix WARNING: please, no spaces at the start of a line
Date:   Wed, 11 Dec 2019 12:12:44 -0600
Message-Id: <8fe7607b122493540f7c746d654b4a87afb9bd77.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: please, no spaces at the start of a line in qlge_main.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 38d217ae4002..024c77518af3 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -52,16 +52,16 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 static const u32 default_msg =
-    NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
+	NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
 /* NETIF_MSG_TIMER |	*/
-    NETIF_MSG_IFDOWN |
-    NETIF_MSG_IFUP |
-    NETIF_MSG_RX_ERR |
-    NETIF_MSG_TX_ERR |
+	NETIF_MSG_IFDOWN |
+	NETIF_MSG_IFUP |
+	NETIF_MSG_RX_ERR |
+	NETIF_MSG_TX_ERR |
 /*  NETIF_MSG_TX_QUEUED | */
 /*  NETIF_MSG_INTR | NETIF_MSG_TX_DONE | NETIF_MSG_RX_STATUS | */
 /* NETIF_MSG_PKTDATA | */
-    NETIF_MSG_HW | NETIF_MSG_WOL | 0;
+	NETIF_MSG_HW | NETIF_MSG_WOL | 0;
 
 static int debug = -1;	/* defaults above */
 module_param(debug, int, 0664);
-- 
2.20.1

