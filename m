Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83F831C7A1
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 09:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhBPIyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 03:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhBPIyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 03:54:12 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F48C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 00:53:31 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d15so5127652plh.4
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 00:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jL3Fm59Frnboz02UpkPj4GnEzKkAjnqtoiCL6DPXY9Y=;
        b=S5c4W5nEWPY5YyBxNKaEoTdJCTpvwtbtQUYXlssH5LIxQivAN6rUL6U3XjdJAFsSIG
         L4tJVE+NxWrHjmlETpI0Mm4adiKpc+AzhPJAfGU7i5ch/CdbK1W77qUrlOe8n+7E8Dt9
         rYKNy/1Me9tzzK/6AZFNbVE+3b9d7osnyadHFXViiZxLHBymoImYO7wn/J+q1fz+B2gp
         QIV0JiDtvwFGFfGpKc3SVMjWCwMU4tam4CPiBNvnwsb5IT7oubr+x17UfyLtKhWNec+B
         Rbkzxtjxg0abe8WIPuaYlIm0b6Gy0S4dBBzMEH6l6zI7qjtLconKdDrPbxXAugwjhcr4
         +SMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jL3Fm59Frnboz02UpkPj4GnEzKkAjnqtoiCL6DPXY9Y=;
        b=kyK4XMRIlJO6NVg4eZs+hQL9UuR0clfDDB0dzZ9ICJulHUDnC6LiH8lJMQiSx+uwxX
         SZHeUuS3kn1yqxWc2ulu9Suu1MtpFbS+aU6AZY6I3qKVYWYgUZsi4WPVmlbculgCOUpU
         tHL87fZKWtjeqpz/ZABAM1wlFUYUjRhfc+JmQeK8FL0BxApqXztnUKuiweEPaUS5iuAT
         vMw6bxMz1NsLPTghdRdZQElTtJj9JicjO3RQRQ7P/lKOImaYqH21WH2sE340EXYMy78u
         E4/DeBBFd86RG1qxukhIL8aTvkG2K1LkWTLkjJuCUdQ+QhO14KD4oHwUeZOB1r58cN+W
         SKog==
X-Gm-Message-State: AOAM5312g1/95hsivmWQZrb6ZyqBlojZc0vkueL03KH+dpCZUJWL/hwk
        vexTFKQqzImUMeyGddy1zVc=
X-Google-Smtp-Source: ABdhPJzfBx15FyaMe1ky/fF5UyDGuRzlZO+HqRLnABFYeGo24qDOshKtA7oNtNpprorR2v0z5QnlTw==
X-Received: by 2002:a17:90a:aa07:: with SMTP id k7mr3261078pjq.3.1613465611542;
        Tue, 16 Feb 2021 00:53:31 -0800 (PST)
Received: from ThinkCentre-M83.c.infrastructure-904.internal ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id hi15sm2053510pjb.19.2021.02.16.00.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 00:53:31 -0800 (PST)
From:   Du Cheng <ducheng2@gmail.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        Du Cheng <ducheng2@gmail.com>
Subject: [PATCH v3] staging: fix coding style in driver/staging/qlge/qlge_main.c
Date:   Tue, 16 Feb 2021 16:53:26 +0800
Message-Id: <20210216085326.178912-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

align * in block comments on each line

changes v3:
- add SUBSYSTEM in subject line
- add explanation to past version of this patch

changes v2:
- move closing of comment to the same line

changes v1:
- align * in block comments

Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3af898..2682a0e474bd 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3815,8 +3815,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
 
 	qlge_tx_ring_clean(qdev);
 
-	/* Call netif_napi_del() from common point.
-	*/
+	/* Call netif_napi_del() from common point. */
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		netif_napi_del(&qdev->rx_ring[i].napi);
 
-- 
2.27.0

