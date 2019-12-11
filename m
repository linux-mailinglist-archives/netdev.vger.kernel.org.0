Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3911BB73
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbfLKSQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:16:51 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38751 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbfLKSPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:17 -0500
Received: by mail-yb1-f196.google.com with SMTP id l129so9394094ybf.5;
        Wed, 11 Dec 2019 10:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d13RLX6NhyAv5ZdFefjfKBGNP9hWY+i8u20CJzTC+ac=;
        b=TfUavIKv9uEq7wg4iS9gbh0Jx4VTX8vw7590D9U3L/bJblXqToqS+gM0nQJenfkwwf
         J2qowTuuhNz7s1dDFWqOc4okguAuLh7D0y6sj5RkdydhdeAyNtHuv4z3jNUFL//vwAAl
         DbCRxN2us9teEcCyPEcl3YMnkYYdnlurYPcghdf3Qghy49cdIHa2AmH/UNKvQ558hQEI
         MhHWHrTgpUAGIX7FFALKsP9zE28NUn3kWjNmQvRHvSbRh71v4el+egZB4xvHWbO193wf
         T3TOxVavcWjWgX+6IHzjgc3LnPKS6VRFpnjZZJNDB0TVHFm3GdvQddiTp/StY3FBg4Py
         4kvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d13RLX6NhyAv5ZdFefjfKBGNP9hWY+i8u20CJzTC+ac=;
        b=UP0sBOn+GyU06aGwPyjETAPYQGCE7+mw7a7Z98kawp2oL7mQT1Gy7kkuJ7DV8FTKTH
         cnuG8vdMKdF39KhHaJGmpHUK12g7FYLNmh8grF7+FFfpXokGxVMiZbWnL2PkZgs/qTAe
         Lq8rHsD0YdTQ0omI3vNF9ZYx4QRf+3QZWv/E8V5sv8IbMHW3u4WEpdXp6BVTj/bieDGw
         O9iBHbCMygO/8pLQLQ1iEeSKYlEPTy55eU+8Ro4zALwVbOljfxx1M+aehGZ7G3Dt/8iF
         cjv/JjEa5FvUjx8qOcVxklp/SJRdXof5lpOK6noL4j15jq1D7T0BY79U9BFLZ0ax9Znc
         ouDw==
X-Gm-Message-State: APjAAAUojgq9v056S53tyFVxRkYFSMP1DC5DyHEPyjcsTx0ihvmd+yme
        DyUQqxyya7xBQShunICsWyepqQV1uML6qA==
X-Google-Smtp-Source: APXvYqx0PyEq0X95gP3rmHgsA/8bcB8XqHkjAz3WmSh1MSMIo6lwgD82jrxWNNN1M/6fp2nXGr+LQQ==
X-Received: by 2002:a25:aa05:: with SMTP id s5mr926645ybi.513.1576088116289;
        Wed, 11 Dec 2019 10:15:16 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id 207sm1260876ywq.100.2019.12.11.10.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:15 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/23] staging: qlge: Fix CHECK: Unnecessary parentheses around mpi_coredump->mpi_global_header
Date:   Wed, 11 Dec 2019 12:12:37 -0600
Message-Id: <d6b36b83cf1069b20cc0a720c2fd82974b9053d5.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Unnecessary parentheses around
mpi_coredump->mpi_global_header in file qlge_dbg.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 1d4de39a2a70..f8b2f105592f 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -737,7 +737,7 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 	}
 
 	/* Insert the global header */
-	memset(&(mpi_coredump->mpi_global_header), 0,
+	memset(&mpi_coredump->mpi_global_header, 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
 	mpi_coredump->mpi_global_header.header_size =
@@ -1225,7 +1225,7 @@ static void ql_gen_reg_dump(struct ql_adapter *qdev,
 {
 	int i, status;
 
-	memset(&(mpi_coredump->mpi_global_header), 0,
+	memset(&mpi_coredump->mpi_global_header, 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
 	mpi_coredump->mpi_global_header.header_size =
-- 
2.20.1

