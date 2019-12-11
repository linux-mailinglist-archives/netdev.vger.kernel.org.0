Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E3811BB6E
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbfLKSPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:23 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43505 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731185AbfLKSPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:22 -0500
Received: by mail-yw1-f67.google.com with SMTP id s187so9288888ywe.10;
        Wed, 11 Dec 2019 10:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9JkncaeesNuIE8WTvQZUx23mWDrSVoIuwHyLPtUCqSg=;
        b=lb/1J8qoTqW559dDxbrZtC+Nc0RkCijPhbQu6TquMAUYo9YknkwlnswA/RcJI+TG4t
         eiVoaB+f49UTber3RiaUNi3bt81q0u/5oVbYDWt7nBgBg/lR7/dS9fVZQtVsMDCweT0c
         Ru4/HiFGWOcAciXRc1yKeURXjiupHk2DFzYJm0c4B2kExx7zKP7lUpIBJ8+rpur1oSl5
         XSmbPK6pKbSGUYCEi1Cr5EU6D2gPBDh+n+puUPML+/WX5+HJlGH9jpzygaHddeu9zVjy
         rEsNyp8fvlZog8yeuVVMIMrYzfCFj1fwyH6HzwYm10R0FZp3uz2ftIXFQ0b5NXjM3SBu
         NJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9JkncaeesNuIE8WTvQZUx23mWDrSVoIuwHyLPtUCqSg=;
        b=t5E/Saq4Y1C1gmlCc6c9QSb7GJ8F8XQMbPZ+FG728ysO/CIOrh/grMfKPeKYH4en1x
         ARTKAr7y6IDNthbgotFbyDSZ/UWg7xibyuXhjHph6hQ5hMcgneHz9k4NFou16rRlg6pw
         UykMm3EPTKZ5UcAx6dkrlANzYsaS79806BlPJkbJfX9X8k7jIsd7Y2tqMFMtts2c8FHe
         d1j6otGUxX0/XFbjw9/C0vmRTdGdEMroAErkSwxsbdOeZM8D0tXOnuuGt52gJcrcUqR6
         THXNbFBVkYfuv7SvZAQGuMTKg4MnBIKnxmC7tdsI86Tw03X9yEVr2cH9X5ZtGUou9cjh
         BE2w==
X-Gm-Message-State: APjAAAXj5W4iDet1XbcP+VJ7wr/HRwVWi7eHOkwN0yQUjapOQgmAUgKs
        8NATOZFJgjgmMWmTbjQs0MchX4ICgEWFFA==
X-Google-Smtp-Source: APXvYqx5pecnyYiOx1TlmB0rRSstCJuZC9sA9sSJoO3GNjbXZHsIXz2oRCyF+vJ27Jn3veL28cm4RA==
X-Received: by 2002:a81:7a0d:: with SMTP id v13mr867889ywc.175.1576088120905;
        Wed, 11 Dec 2019 10:15:20 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id c187sm1275416ywb.97.2019.12.11.10.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:20 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/23] staging: qlge: Fix CHECK: braces {} should be used on all arms of this statement
Date:   Wed, 11 Dec 2019 12:12:40 -0600
Message-Id: <0e1fc1a16725094676fdab63d3a24a986309a759.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: braces {} should be used on all arms of this statement in
qlge_ethtool.c and qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c | 18 ++++++++++++------
 drivers/staging/qlge/qlge_mpi.c     |  9 ++++++---
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 794962ae642c..b9e1e154d646 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -260,8 +260,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -274,8 +275,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -291,8 +293,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -305,8 +308,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -317,8 +321,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 		netif_err(qdev, drv, qdev->ndev,
 			  "Error reading status register 0x%.04x.\n", i);
 		goto end;
-	} else
+	} else {
 		*iter = data;
+	}
 end:
 	ql_sem_unlock(qdev, qdev->xg_sem_mask);
 quit:
@@ -489,8 +494,9 @@ static int ql_start_loopback(struct ql_adapter *qdev)
 	if (netif_carrier_ok(qdev->ndev)) {
 		set_bit(QL_LB_LINK_UP, &qdev->flags);
 		netif_carrier_off(qdev->ndev);
-	} else
+	} else {
 		clear_bit(QL_LB_LINK_UP, &qdev->flags);
+	}
 	qdev->link_config |= CFG_LOOPBACK_PCS;
 	return ql_mb_set_port_cfg(qdev);
 }
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 4f8365cf2092..4cff0907625b 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -278,8 +278,9 @@ static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init CAM/Routing tables.\n");
 			return;
-		} else
+		} else {
 			clear_bit(QL_CAM_RT_SET, &qdev->flags);
+		}
 	}
 
 	/* Queue up a worker to check the frame
@@ -351,8 +352,9 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	mbcp->out_count = 6;
 
 	status = ql_get_mb_sts(qdev, mbcp);
-	if (status)
+	if (status) {
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
+	}
 	else {
 		int i;
 
@@ -996,8 +998,9 @@ int ql_mb_get_led_cfg(struct ql_adapter *qdev)
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed to get LED Configuration.\n");
 		status = -EIO;
-	} else
+	} else {
 		qdev->led_config = mbcp->mbox_out[1];
+	}
 
 	return status;
 }
-- 
2.20.1

