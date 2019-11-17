Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 592F3FFB9B
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 21:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfKQUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 15:37:50 -0500
Received: from mta-p0.oit.umn.edu ([134.84.196.200]:46466 "EHLO
        mta-p0.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfKQUhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 15:37:50 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Nov 2019 15:37:50 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p0.oit.umn.edu (Postfix) with ESMTP id 47GNvw0rsDzcnh
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 20:28:44 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p0.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p0.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b4E7RanqwCer for <netdev@vger.kernel.org>;
        Sun, 17 Nov 2019 14:28:44 -0600 (CST)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p0.oit.umn.edu (Postfix) with ESMTPS id 47GNvv6vwyzcnd
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 14:28:43 -0600 (CST)
Received: by mail-yb1-f197.google.com with SMTP id t7so11962343ybq.21
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 12:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wBc17qrjKmSItYE88uMyJX08lkaFrl0hKy0d5h7YKUQ=;
        b=eciT/QwSJZ5I9UaCkzJWuOPWuPyFCfOHXD0LRNGhOP1VBRSyhEUwh64543StNvSQUf
         Z+Z0ISeQ56hDEVS2P4UMYioerVMKsWQS3fsFp5vsUS+QRug+X+BqPi6oNddw/nU/o/Pk
         rozJAmvN/48uJmHOLtRu4/tVSnDpH65LDA9PBnVZU20PGmS+Ptg1RNscmJtLPx5mLO4g
         bk++w9wdsY7XSFCLL1E5L1Qb9n4nmec8qgyDPgWvcrpyXG8rpu7rpZlEMd3p7JwAdYt6
         +puD9aHK0+42chQRBvD401ujAfzzeri47MWVTvOQFaJtNkATbda8DHTvoBtX7lERP12I
         0gKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wBc17qrjKmSItYE88uMyJX08lkaFrl0hKy0d5h7YKUQ=;
        b=mleF0iy4lt88RsNzkqtVJGCrKwHv4VzpS4UwgxPMomQsJ6WqgSn8XBPFpjQ5WjqcPE
         hv2pgVuNSCOAoiZVWfP1AqjIUO3B9YolIvtcvZQDsDLAd6PKUd6j+Ozu4gtmjQiMdXRs
         UBwXkE9HaAB6e8xsyEl4UMhuTsUpaLIhg3jJV2k4kQBQk5Xiksp0jRe/s9CassMvJes4
         YAnraP3yLZtKuNhEvyVURTi3IW4p8U2j2YZQnQ6CC3xjubi6L65WDD7+M53K6e6n1hJ/
         IJEFKK92gbMJ6utkB8Xlf1VXvewqDGpvMvMq+GT2+T0Mi7CLJTL1L6+AVQCSaLguG7tw
         3Pbg==
X-Gm-Message-State: APjAAAVkYDof5EAeJqestuhB0L1RR2hWSWGccqvZ39BOCGIWdAwMFvEF
        T/70C9rSOv/AsMh94dUIv5WC7Hw2ledEpBjI/rKMcaV2FyXTSr/3y4zaKoPRP3Rk2qaSsV99xyO
        IYMuIhyS7EeN75WVx+t8U
X-Received: by 2002:a25:6649:: with SMTP id z9mr19227119ybm.132.1574022523434;
        Sun, 17 Nov 2019 12:28:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxDNJLEh5pGjh3lGV7hpQ4vc6QC7P9lu8F5/t/kqjfvi5ZqNAv1YDGfeKXZdy9dA33+lbyKvA==
X-Received: by 2002:a25:6649:: with SMTP id z9mr19227106ybm.132.1574022523191;
        Sun, 17 Nov 2019 12:28:43 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id c9sm7327900ywb.54.2019.11.17.12.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2019 12:28:42 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: atm: Reduce the severity of logging in unlink_clip_vcc
Date:   Sun, 17 Nov 2019 14:28:36 -0600
Message-Id: <20191117202837.7462-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of errors in unlink_clip_vcc, the logging level is set to
pr_crit but failures in clip_setentry are handled by pr_err().
The patch changes the severity consistent across invocations.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 net/atm/clip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/atm/clip.c b/net/atm/clip.c
index a7972da7235d..294cb9efe3d3 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -89,7 +89,7 @@ static void unlink_clip_vcc(struct clip_vcc *clip_vcc)
 	struct clip_vcc **walk;
 
 	if (!entry) {
-		pr_crit("!clip_vcc->entry (clip_vcc %p)\n", clip_vcc);
+		pr_err("!clip_vcc->entry (clip_vcc %p)\n", clip_vcc);
 		return;
 	}
 	netif_tx_lock_bh(entry->neigh->dev);	/* block clip_start_xmit() */
@@ -109,10 +109,10 @@ static void unlink_clip_vcc(struct clip_vcc *clip_vcc)
 			error = neigh_update(entry->neigh, NULL, NUD_NONE,
 					     NEIGH_UPDATE_F_ADMIN, 0);
 			if (error)
-				pr_crit("neigh_update failed with %d\n", error);
+				pr_err("neigh_update failed with %d\n", error);
 			goto out;
 		}
-	pr_crit("ATMARP: failed (entry %p, vcc 0x%p)\n", entry, clip_vcc);
+	pr_err("ATMARP: failed (entry %p, vcc 0x%p)\n", entry, clip_vcc);
 out:
 	netif_tx_unlock_bh(entry->neigh->dev);
 }
-- 
2.17.1

