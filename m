Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE1131C8A0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBPKUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhBPKUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:20:31 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD07C061786
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:19:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t2so5653436pjq.2
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mQoP2ZwO5uOXZSSfuJ+0tTHWjDpZOfZ2TG4TVwc3os=;
        b=q70TD0w4Og1vLGIrF0pa32Len72pFwpmGB4r8GZa0spReoe95Grsp5mIrN9vKd4BWb
         nPdue7CW5ZNO+4FhvVkgSKOk4MGGo/xte2hexkM3gF6FS0KKlX7QyFDFDjkhippslAYI
         s5Rg9RFIY1oRKH1p/2PucUkF9ymBEvIRpVWwlj9A7QGbSGbKQt1LGqR7wwqT0aX9cdMv
         gXJ7xTRPEOYvitwBrU7tWiDtyTTxvaXgHVU1We6kMcy0hg+C3MdHBdko0fl2oTjxzPgY
         p+uI3YOQurze0cQ/c/D5VZWDzAP+KSnFuawcZJ9MJImdaYnf3QnwMVYeFo8zJLDpBqVu
         UpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mQoP2ZwO5uOXZSSfuJ+0tTHWjDpZOfZ2TG4TVwc3os=;
        b=s2oD2Ev32ljotPoECe8Ai1k3joQTQD5rkotNrrlXIhdbfzeW3vXoxyAlpJBidl9rUp
         TizamRR584OsWiwRj0/IaNDMDQwNwcJrSxpQ32gJa0mcdRwgwRmgGcH3Qfwn9vXgU1wb
         x25ZyV07lE8sAj3Tw0zZmextsjt/hjdGVw12q2kKRIiNuukw7GwHq9tizrEgxWk/yz96
         yCo8VV+kKKsUrg4ADh/h41riKepmEMVQgGsM/6qpyzznJizdH7BcIkD41j3jt4uXqwKd
         XxXWy/yTdqvC6/jO2Fu17BYHC9msKy8RYKj6PUCM7rQFvb765xprwf678u/hC53X3H2b
         z0AA==
X-Gm-Message-State: AOAM533kxaIlkq5uv9ACtBu+ZWcixPevESX5q3R37dmg3mxJvpaxaCVN
        LswLnS+s1Tj0+XW0foqaEj0=
X-Google-Smtp-Source: ABdhPJySPjluE8i6+lesNADSn9nfvkEDJtmE19V0JGOwK9iQVcmk8F+AtDZXc550DUx7okm2Pu39Lw==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr3458121pjb.29.1613470790562;
        Tue, 16 Feb 2021 02:19:50 -0800 (PST)
Received: from ThinkCentre-M83.c.infrastructure-904.internal ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id b62sm20022268pga.8.2021.02.16.02.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:19:50 -0800 (PST)
From:   Du Cheng <ducheng2@gmail.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        Du Cheng <ducheng2@gmail.com>
Subject: [PATCH v5] staging: qlge: fix comment style in qlge_main.c
Date:   Tue, 16 Feb 2021 18:19:45 +0800
Message-Id: <20210216101945.187474-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix the closing of a one-line block comment,
marked incorrect by scripts/checkpatch.pl.

Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
changes v5:
- improve description

changes v4:
- move "changes" after triple-tiret

changes v3:
- add SUBSYSTEM in subject line
- add explanation to past version of this patch

changes v2:
- move closing of comment to the same line

changes v1:
- align * in block comments

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

