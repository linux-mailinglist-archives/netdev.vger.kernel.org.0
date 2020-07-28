Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03A82311A3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732365AbgG1S01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgG1S0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:26:25 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FE9C061794;
        Tue, 28 Jul 2020 11:26:25 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 74so3163538pfx.13;
        Tue, 28 Jul 2020 11:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6DV3V+yX4qgHFBt1ioftJ+TEjupDH3OyuvsUob7/Y3g=;
        b=WcN/VsHOC53DbWa5NRGel2NucDFS+cAcQ87OwXgxKNzF0kTGpqhwJouf7ir+jj1HH2
         osJetdnSxRwmu9LeVZeKJQVkCSte65Qs+XdScpdhiSlGKJWThg79s3m+8ICr+cD6f3Mw
         Mf3d4HtqlTdeXz6lLK7pmd0ncaPGMVr7RCL+n8+/8PAFKj1bpta+w0YQbtAelX6aBa0n
         BMxyUewsBOEjj/syMOiQJhtqsQKxAOx7rZwt6OLFLmsEKeSJQ4AzZSIE5URmeAk867Hn
         7QsqLCijlP1oUJQYjUTgTdRv3aEblNrEqGzwr1D+EqatjiGN1HyIQiqvVPC/JKPckOKF
         EAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6DV3V+yX4qgHFBt1ioftJ+TEjupDH3OyuvsUob7/Y3g=;
        b=HGbtVnNfoSR/qV2ICa9K8vgPYQE3D1d8nJDczuFHFp4qxPxnVt6JWD5HWXlT5F6dF7
         n1qY5jZODCLj8GKVmVBl4+ksyx6gbStJwUtX9gR3FKoZ3FC9mq3/wsqeIH8oavEKaq/8
         wyg+fixD2xlTI1Df9bp1p+r723FOgeQopGn7aDCIvjhXtIpG2m3nNQw1LRjak5VXOCw4
         SVXUNcjJllg8cXSVVZStq+kEd8zLz4mBuowCNPt0onEdjp6EPxKgj0PTcQe4xNoHtwI8
         abOewAy9iBCzC9F4WWw5tWhqzz5pZEey8wpjYF4Mh50FW4YDhlsj0CPiCXSksVE5/r1z
         G8iQ==
X-Gm-Message-State: AOAM533CSCpJKQWhwquCfADvIdJOAmNFd2gD++zIDabCVjeESorx/U/1
        YjPi8+ISSKQxUUD52YL1DwI=
X-Google-Smtp-Source: ABdhPJyeRavnmxgxHczvOxuczSEdzmGjktFz6w3Y0da7zpoupkk9LJF153KOnrxabgGU6VQvuDSlRQ==
X-Received: by 2002:a63:531e:: with SMTP id h30mr24547863pgb.165.1595960785240;
        Tue, 28 Jul 2020 11:26:25 -0700 (PDT)
Received: from localhost.localdomain ([132.154.123.243])
        by smtp.gmail.com with ESMTPSA id e8sm8580395pfd.34.2020.07.28.11.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 11:26:24 -0700 (PDT)
From:   Dhiraj Sharma <dhiraj.sharma0024@gmail.com>
To:     manishc@marvell.com, gregkh@linuxfoundation.org
Cc:     Dhiraj Sharma <dhiraj.sharma0024@gmail.com>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: qlge_dbg: removed comment repition
Date:   Tue, 28 Jul 2020 23:56:10 +0530
Message-Id: <20200728182610.2538-1-dhiraj.sharma0024@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inside function ql_get_dump comment statement had a repition of word
"to" which I removed and checkpatch.pl ouputs zero error or warnings
now.

Signed-off-by: Dhiraj Sharma <dhiraj.sharma0024@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 985a6c341294..a55bf0b3e9dc 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1298,7 +1298,7 @@ void ql_get_dump(struct ql_adapter *qdev, void *buff)
 	 * If the dump has already been taken and is stored
 	 * in our internal buffer and if force dump is set then
 	 * just start the spool to dump it to the log file
-	 * and also, take a snapshot of the general regs to
+	 * and also, take a snapshot of the general regs
 	 * to the user's buffer or else take complete dump
 	 * to the user's buffer if force is not set.
 	 */
--
2.17.1

