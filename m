Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290A63B4E62
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 13:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFZLcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 07:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZLcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 07:32:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115C0C061574;
        Sat, 26 Jun 2021 04:30:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so7135581pji.0;
        Sat, 26 Jun 2021 04:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=17yjFWpV5LaTQXQYRjJtUi+sXaiDlDLeKKNbuSlzlx0=;
        b=kJ+xFniWGC9k9BvWDrq8mM0kge4O65m8573p/mFcdQxFG/DUGRu8fMW3/xD1e1eu4b
         oBcq+24sUrR4k+Kea+mjt20WSpuEyVXsWFnZAUdUO8LVzPgRz+cN5cNBE6JX08HwgUBC
         dyA52EYh1+4ulGt3q3ttsZEGV4d9Wul5h8wQnp17/wE/w12KAGFNuxCar95JCh6n0/vd
         YcUvMI/5w7MKud0eHyCQGe29T5A7IcoKqDy3Yu6qrF3Pk6FX1EW9fZUGlJVUn+a0dRVN
         blk3+hw4dUvHGU3BYljbE76RNn84v4Z1rpNMv2mDZn1FVHMmgAQLDz+kibwnrTkxCjol
         uUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=17yjFWpV5LaTQXQYRjJtUi+sXaiDlDLeKKNbuSlzlx0=;
        b=QMgECDFDw/cvoW+k3c6FfQ5bqG2yLoFYDbo9bRJTLyM6c6O4NAtUVmxUz6f3+A2/gB
         2Zy4Nxfou0LoLsT1UtOYb6BbxHEtCLyw5biKWoTJJVUvpytQConERSSiKxNqT86oD9U6
         EW0/JAEsPUhSB/wUZ/J58vrNHYQ/NDUu0Eu2SH/bEfweb3EHWJ9NoFns135sYhwWTG77
         G8aclH4sLAJMEoPs9QUAF5CL4tAZMTAS+WklEtUl6LT6VoMBQs66GtSh63QobBO7E0lH
         jD7Q972wKIphhZsCKJXins4UNhcsKhXHKCHBAQ8+Th9q6HdEvR27dafrct9KsNTI2fT7
         +WoQ==
X-Gm-Message-State: AOAM533ENJYxLRJFE51IB5scxm80m90umtiiWVgYMIlgQLuxP8malXUI
        Oue2hnndMZHJI8PsjDoGPHI=
X-Google-Smtp-Source: ABdhPJxXx55UhpU/bj+BcousF2vwV9QT+8tGc0gmZkQioSwjTk1lupLMV+Ch/b1AenNfnKptkWVYIw==
X-Received: by 2002:a17:902:d2c1:b029:122:ef41:c4cc with SMTP id n1-20020a170902d2c1b0290122ef41c4ccmr13285456plc.83.1624707029191;
        Sat, 26 Jun 2021 04:30:29 -0700 (PDT)
Received: from nishal-pc ([183.87.54.190])
        by smtp.gmail.com with ESMTPSA id d2sm7854344pgh.59.2021.06.26.04.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 04:30:28 -0700 (PDT)
Date:   Sat, 26 Jun 2021 17:00:21 +0530
From:   Nishal Kulkarni <nishalkulkarni@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: Remove unnecessary parentheses around
 references
Message-ID: <YNcPzWXkKkmip95x@nishal-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes checkpatch.pl warning:

CHECK: Unnecessary parentheses around mpi_coredump->mpi_global_header

Signed-off-by: Nishal Kulkarni <nishalkulkarni@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 37e593f0fd82..66d28358342f 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -733,7 +733,7 @@ int qlge_core_dump(struct qlge_adapter *qdev, struct qlge_mpi_coredump *mpi_core
 	}
 
 	/* Insert the global header */
-	memset(&(mpi_coredump->mpi_global_header), 0,
+	memset(&mpi_coredump->mpi_global_header, 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
 	mpi_coredump->mpi_global_header.header_size =
@@ -1221,7 +1221,7 @@ static void qlge_gen_reg_dump(struct qlge_adapter *qdev,
 {
 	int i, status;
 
-	memset(&(mpi_coredump->mpi_global_header), 0,
+	memset(&mpi_coredump->mpi_global_header, 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
 	mpi_coredump->mpi_global_header.header_size =
-- 
2.31.1

