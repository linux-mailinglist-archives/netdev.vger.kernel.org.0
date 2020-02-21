Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EEE1686F7
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgBUSuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:50:24 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44431 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbgBUSuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:50:24 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so1215939plo.11
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=es-iitr-ac-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=0k6g4uJ0ZA5B8EEB6+wWGSb0kBAwGtaPTJoeE/KO6EY=;
        b=cTgf7YYBzjjKYDeSSov8Ngrm0EB/oHuDMO3f76yGWBHxsKiJgSEqcTSMspWlwVemva
         9kEaN3vp+1YndpdsOBEEuYfcqvTxzvqvkzLbPMoxKRriQuWfsf93TY4VH0YJkyjffLys
         aU3+ZomPrvurD3bLvSTNIHn63hUwWGn3D2y3hbhvljIQoOY9wP33ADHuFKijyY7+GsT/
         rV4EroPWfgmn6Jbd40lSpjukVOkGu2aSNo0R6EG1/8cjg2EHCjyD5rViioVv9kiEvF+3
         68YgXvsBr89yaEgpd0KRHU7TAHPLwWu8YTzvwAeLFiSYrK+IqyieuE9yvXyirJJ0jTee
         tMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0k6g4uJ0ZA5B8EEB6+wWGSb0kBAwGtaPTJoeE/KO6EY=;
        b=K0/JOc1WjmhEnxRBGXFXh0yinSfpOH1JQEET6v6Z0tqLPn1L+AApXry4I98jpDnVlG
         fTDuR27QFooo0ELe/0kj3Wvq0hfE+9QVzhDyvAQghIpoMK6foVUQoqN733I4yeIA1Ps8
         XjonW8D+dmCqPkhmGr+hOgI+GTWW0Lrt7CUmxeDz5HtlhkvS3ie40uWDl8D2i5JjAG/D
         SgBoy1V5YhW6l3pZel6lXQbCnA1TvOH/cbJILZQJC8v76hOj1ZHu3VuTo7vc+PSSJvQC
         ddjTw8wlbHplDo4hUXazbSkUIWqD+UUbJWoGPRQ5NasLIsQvLGwXAPQvqXWHht8bwUhk
         feTw==
X-Gm-Message-State: APjAAAU7ZVPcQudfDhwzErftW1aVSUD58459+7ncvtKoW6lS5/HO7FZk
        XCa/g5S/u/x9pFGAMZEeyAo8Hw==
X-Google-Smtp-Source: APXvYqzdOnHcE734UeoNfIg6UA7sYXb/onSusxfzPp6mfZ8rMrJD2viJqDfq0GktC3i6ug9UROadOg==
X-Received: by 2002:a17:90a:da04:: with SMTP id e4mr4410210pjv.26.1582311023240;
        Fri, 21 Feb 2020 10:50:23 -0800 (PST)
Received: from kaaira-HP-Pavilion-Notebook ([103.37.201.178])
        by smtp.gmail.com with ESMTPSA id b27sm3206242pgl.77.2020.02.21.10.50.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 10:50:22 -0800 (PST)
Date:   Sat, 22 Feb 2020 00:20:12 +0530
From:   Kaaira Gupta <kgupta@es.iitr.ac.in>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: unify multi-line string
Message-ID: <20200221185012.GA16841@kaaira-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch.pl warning of 'quoted string split across lines' in
qlge_dbg.c by merging the strings in one line. Fixing this warning is
necessary to ease grep-ing the source for printk.

Signed-off-by: Kaaira Gupta <kgupta@es.iitr.ac.in>
---
 drivers/staging/qlge/qlge_dbg.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 8cf39615c520..28d8649ab384 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1333,16 +1333,16 @@ void ql_mpi_core_to_log(struct work_struct *work)
 		     "Core is dumping to log file!\n");
 
 	for (i = 0; i < count; i += 8) {
-		pr_err("%.08x: %.08x %.08x %.08x %.08x %.08x "
-			"%.08x %.08x %.08x\n", i,
-			tmp[i + 0],
-			tmp[i + 1],
-			tmp[i + 2],
-			tmp[i + 3],
-			tmp[i + 4],
-			tmp[i + 5],
-			tmp[i + 6],
-			tmp[i + 7]);
+		pr_err("%.08x: %.08x %.08x %.08x %.08x %.08x %.08x %.08x %.08x\n",
+		       i,
+		       tmp[i + 0],
+		       tmp[i + 1],
+		       tmp[i + 2],
+		       tmp[i + 3],
+		       tmp[i + 4],
+		       tmp[i + 5],
+		       tmp[i + 6],
+		       tmp[i + 7]);
 		msleep(5);
 	}
 }
-- 
2.17.1

