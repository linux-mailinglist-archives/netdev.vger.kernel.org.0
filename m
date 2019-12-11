Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC5B11BB4E
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbfLKSPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:42 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:37140 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731334AbfLKSPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:39 -0500
Received: by mail-yw1-f68.google.com with SMTP id v84so2956832ywa.4;
        Wed, 11 Dec 2019 10:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+x/b256hi/BiDL31JHY2PQmq0IAPIM+EJHKCtlj8/GQ=;
        b=fX6sP+zsfo7QiNbgczb4g4RwNHoCbsE1Qdyiv+e78chsM5SpDb4VEhKpowEc//NJoF
         FjK35PxJAduy/TX/48sMOL3RShtFhvUhNwsxT+kqQaC0P0K8epI0Z9BONFqdXhvqaS+Z
         JdChIJ1NIBh4GYo0JeyRRonR7dGvME5szcK+5dxOzjyME0JL+5hqPSLt0c3rVPZ/CA/k
         TPT3c9y4uC/H5pA25FeD5hZNcBfMikGd+GN2ODylL4gQzHbNIveYNbU3TCBOyxk7Oodl
         3ncupRw6DqkxFFMCl21ApGz5DExaUQ+K3+3oorm/IcwlBs/ngNQvTk+jo09qZUQCAVn2
         CgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+x/b256hi/BiDL31JHY2PQmq0IAPIM+EJHKCtlj8/GQ=;
        b=T8bpSbqhp99dTOScYbbWChBTW4wZYI5ESZKOTBt3I2Po64sjkXDKUpRnpq4VBl14iO
         vKmhhJVXZFx2KeBgQkPs2AMNpyqTP0W6IcA+NGGv4qlSloIkr34pRVdF9d+uF3yb5zjW
         5fJS5pKIG9oYtZNdFbo0/Luso3LGOiLJx7pPPfgLR5hfrIF4AKWhqmhcMrsoxuReJaIE
         jg5dwsUHeksAvE30MFaCF+7Ehd3AtC+UN33YbG5VTXvxPryOIx7iVV0Myia6SVoHs1AM
         3nxXxm1S9S8zPybhUkI9GZGv8/gCWVzrIowr57ChkXbNtiEXitxwf5i9xc88LRfvWKoP
         aDLA==
X-Gm-Message-State: APjAAAWTzeo8apgtoHYRqj2SNMHCyTwNPOOxb43G1JLfSSOtLycbaAc/
        pQx4LzBQ2av/vBdQFlnMqVgLAWNrMd2TRw==
X-Google-Smtp-Source: APXvYqy+8SSiMyc2gSAf5nlC+pArO37lD4CnuaJdfKdo8miRp32JKEQHg5OHDfOWK1+LzEnk0ZTCWg==
X-Received: by 2002:a81:ad1a:: with SMTP id l26mr852793ywh.481.1576088138380;
        Wed, 11 Dec 2019 10:15:38 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id i84sm1341120ywc.43.2019.12.11.10.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:37 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 22/23] staging: qlge: Fix CHECK: Unbalanced braces around else statement
Date:   Wed, 11 Dec 2019 12:12:51 -0600
Message-Id: <943bad431329fc77f515158444c6d06fbeeb66fe.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Unbalanced braces around else statement in file qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_mpi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index ba8ce3506a59..c9d45c8feabe 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -244,12 +244,12 @@ static int ql_idc_cmplt_aen(struct ql_adapter *qdev)
 		netif_err(qdev, drv, qdev->ndev,
 			  "Could not read MPI, resetting RISC!\n");
 		ql_queue_fw_error(qdev);
-	} else
+	} else {
 		/* Wake up the sleeping mpi_idc_work thread that is
 		 * waiting for this event.
 		 */
 		complete(&qdev->ide_completion);
-
+	}
 	return status;
 }
 
@@ -353,8 +353,7 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	status = ql_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
-	}
-	else {
+	} else {
 		int i;
 
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN detected.\n");
-- 
2.20.1

