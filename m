Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3613CE3E36
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfJXVbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:31:35 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41164 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbfJXVbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:31:35 -0400
Received: by mail-lj1-f194.google.com with SMTP id f5so250112ljg.8;
        Thu, 24 Oct 2019 14:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p39xTv4sKo80Xm3DLceSvp617U2UIbahdj33O5TXl5I=;
        b=iA3S+3Xtp65LsLubFrkEuvCT6eaxOKOQgpIwDp2Fx6qnB32bsh5uP4jFQXJf3lv9rt
         tVK8hK9J4fiPiBnEojSwTKJyf3ycYIj/OSUIix8efVHvsKjAqu/mxnaZ+5j14xX88CZ7
         bhTUa3eco9M70KhiaUK6t9pFquOtBSsS/M5H+yElgQ7AKJ+Vv2ja4xM/lzV73A1/ceDM
         bGnihJzxaDTHnKpri0nqbsoeIkxDcSxC2QlfZCJIIdewyeCGgZbhLTZMgFNj+SsX4IGn
         ni7K4rbW/y9GdOeR5099E6VJj7Hd7BESRY0OpFtR1W5yC5G05IEZhn/vMItqavFxzqZG
         Tziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p39xTv4sKo80Xm3DLceSvp617U2UIbahdj33O5TXl5I=;
        b=adwT2VzOtbpKVgU5mFucZD7Nm73J9G+I/CQD9nhneL77XsARJKjEcRa4cEQ0Z0vOyZ
         gPVHNUoE1u1e85nmx4TryVCM2H+TRBBIFTG4Q8tP8U/fgpo+t9FsYIfEkFhFFLt+vBU/
         pgmwo80VYWb8tJEbyjs3P+lpv6FHoqwA/cAMJ5BydKMbUyUnCXstxg0StZXXsTEnOWZ5
         UN7OqDMQ9LWnC1UNclJVPIn9qsp+dsCOF0qboNwrRLjjcZl8xhG8w3Jz5BzX5MM0E9T6
         TunTK0P2FriE0hiy/adgTcEUB1Hs9M5fZ2gGE8XI8/0T+7coVPyvs2Ro9zw/UHoc5exQ
         3OKA==
X-Gm-Message-State: APjAAAVuQFjPGlwAV+s4RruvynEbCFSBe3tIrcZ0aXcA8Wvu5IZq9UK7
        c/KUJWp725cWAQl2dj3n3a7ChlTbPitn8w==
X-Google-Smtp-Source: APXvYqxYgcU3NnCkgfM+uvyW+kgAv24qmOqR8Xo77ROFiV7qnSHrzqFgY3kEgvvlnpIdUBr5Vr10/A==
X-Received: by 2002:a2e:8856:: with SMTP id z22mr7964407ljj.78.1571952693460;
        Thu, 24 Oct 2019 14:31:33 -0700 (PDT)
Received: from localhost.localdomain ([93.152.168.243])
        by smtp.gmail.com with ESMTPSA id t8sm20228336ljd.18.2019.10.24.14.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 14:31:32 -0700 (PDT)
From:   Samuil Ivanov <samuil.ivanovbg@gmail.com>
To:     gregkh@linuxfoundation.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Cc:     samuil.ivanovbg@gmail.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Staging: qlge: Rename prefix of a function to qlge
Date:   Fri, 25 Oct 2019 00:29:39 +0300
Message-Id: <20191024212941.28149-2-samuil.ivanovbg@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
References: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is from the TODO list:
In terms of namespace, the driver uses either qlge_, ql_ (used by
other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
prefix

Function ql_soft_reset_mpi_risc renamed to
qlge_soft_reset_mpi_risc and it's clients updated.

Signed-off-by: Samuil Ivanov <samuil.ivanovbg@gmail.com>
---
 drivers/staging/qlge/qlge.h     | 2 +-
 drivers/staging/qlge/qlge_dbg.c | 2 +-
 drivers/staging/qlge/qlge_mpi.c | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 6ec7e3ce3863..e9f1363c5bf2 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2262,7 +2262,7 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data);
 int ql_unpause_mpi_risc(struct ql_adapter *qdev);
 int ql_pause_mpi_risc(struct ql_adapter *qdev);
 int ql_hard_reset_mpi_risc(struct ql_adapter *qdev);
-int ql_soft_reset_mpi_risc(struct ql_adapter *qdev);
+int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev);
 int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf, u32 ram_addr,
 			  int word_count);
 int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump);
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 019b7e6a1b7a..df5344e113ca 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1312,7 +1312,7 @@ void ql_get_dump(struct ql_adapter *qdev, void *buff)
 
 	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags)) {
 		if (!ql_core_dump(qdev, buff))
-			ql_soft_reset_mpi_risc(qdev);
+			qlge_soft_reset_mpi_risc(qdev);
 		else
 			netif_err(qdev, drv, qdev->ndev, "coredump failed!\n");
 	} else {
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 9e422bbbb6ab..efe893935929 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -88,9 +88,10 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data)
 	return status;
 }
 
-int ql_soft_reset_mpi_risc(struct ql_adapter *qdev)
+int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev)
 {
 	int status;
+
 	status = ql_write_mpi_reg(qdev, 0x00001010, 1);
 	return status;
 }
@@ -1280,5 +1281,5 @@ void ql_mpi_reset_work(struct work_struct *work)
 		queue_delayed_work(qdev->workqueue,
 			&qdev->mpi_core_to_log, 5 * HZ);
 	}
-	ql_soft_reset_mpi_risc(qdev);
+	qlge_soft_reset_mpi_risc(qdev);
 }
-- 
2.17.1

