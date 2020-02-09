Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A828156BBF
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 18:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBIROt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 12:14:49 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53756 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbgBIROt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 12:14:49 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so3128579pjc.3;
        Sun, 09 Feb 2020 09:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DM5IK0DECKxUrASVycyGmFhL+Y5jkj05TGZSDzLZlAw=;
        b=hFsOM/4KNJNbuM2fyLAO2zsm6P72skJDUudaxwQkYJ30UvQRtF3rdUYLcZ7FsU+Jl4
         fd2ouUWqFHSFSD+eIr+Yz0AcJepE7/x7cppSbVT/Rlg60vkZqG/oS0W6rjNMf6G/wdrl
         Pt1bFB9Zpq0VahUI+C33yPmNgtiVkt1bbA52f5JOboIMKxrfMBgMmxes4Mb0LU8XmpKl
         xWEIOieHtQtOT+gy6i7AanLlqux+bG7L6eNyuigPWDZj/C+3cQnJjqa62P3TnFmhlEFN
         5duSab27N3GIf9V5tnRVbi/skUQbS3AUMudlFaaaEbMhQs4LVoI1nJOPLwyax6o0W84k
         krvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DM5IK0DECKxUrASVycyGmFhL+Y5jkj05TGZSDzLZlAw=;
        b=kKNzVh6qQrS27RkDDgtrYLhFsz06m4y92gY+VE2vUmuWHLLtxNcI7hP+Yx0NN9wsH2
         NS8DlElQUTJf3LrqYE+Rv0m00VtYtJCZw0b80qaS4f0URp6HOaPJnwDBGNtPoyP0QG+Z
         IYZJ+TKy/y3ZOkEgKM6/Ab28Zw2Y3So0HU5XrxAFyOKixyd5Kbs4dL/RQ+wCGkajUi3o
         eEqWjzGqHCVgPLiybKkFkgPjCgxQ0ukCwO3+L6q4cqF+nNcA2NAuig+Pn/Ti9ZVgvOM/
         9LTqlEMmQwDi2cB1AJJJXDDAueH/QNWpXDC4q/6bqPWSmwuaaMFJnevPPAmPvcqXI0d8
         FUPg==
X-Gm-Message-State: APjAAAVey0YavYWVizzzrUWr+2h5xPfkdJTAgb79urmQLRYwrhrrJ8kM
        TT4nvrHwpelEKoaRzQ1Tq+c=
X-Google-Smtp-Source: APXvYqwoMABm+6xETYfKXdtttba+JXWqTZK6qPOzFn/8bDHq1WTEHXVY7EmGdRjPDHUz+8uxnUK8zw==
X-Received: by 2002:a17:902:6bcb:: with SMTP id m11mr9373043plt.10.1581268488364;
        Sun, 09 Feb 2020 09:14:48 -0800 (PST)
Received: from localhost.localdomain ([157.44.204.164])
        by smtp.googlemail.com with ESMTPSA id t66sm9587357pgb.91.2020.02.09.09.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:14:47 -0800 (PST)
From:   Mohana Datta Yelugoti <ymdatta.work@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ymdatta.work@gmail.com, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: qlge: remove spaces at the start of a line
Date:   Sun,  9 Feb 2020 22:44:30 +0530
Message-Id: <20200209171431.19907-1-ymdatta.work@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <ymdatta.work@gmail.com>
References: <ymdatta.work@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "WARNING: please, no spaces at the start of a
line" by checkpatch.pl by replacing spaces with the tab.

Signed-off-by: Mohana Datta Yelugoti <ymdatta.work@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ef8037d0b52e..86b9b7314a40 100644
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
2.17.1

