Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2B11BB76
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfLKSPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:14 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43495 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731074AbfLKSPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:12 -0500
Received: by mail-yw1-f68.google.com with SMTP id s187so9288650ywe.10;
        Wed, 11 Dec 2019 10:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hG8SSrSMjGXENG9FtwgNHRKUSBYB279zh/9HfEeLdlg=;
        b=SFCv+Dy8JK6iTtiVINTIW483rnpfX1DCbm/ACl7OLyTVcAjbl4psdVD/Kgnaovm3ky
         8Dfl7wPFcmdoG74f7mRj7HaTo9Bs5IinIBDoMKZGtriKYlvXFwNighzMHA2wEz8KQXDD
         xbXast2JCelPZEi6Dawwkok36exSUOK2gCsDz2aTBRBDKFBAL7efErVqMuOKaTEX89iS
         p0irw/CZjx5qgSg/m69yiPeRQmCLHInHwLNk3ZayNQp2X+bondF810Dm9K+ZuwnnrcoJ
         vuN1QW/US7nDvRRnPLbXC2Ac89pJDyHwbnkL1GYzPQCIXPCfO1ZJUY/yLObr6jF1cFVY
         TIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hG8SSrSMjGXENG9FtwgNHRKUSBYB279zh/9HfEeLdlg=;
        b=BuY+uj7jE3x7vr7VB78U+xbThHyK6ZKvgdLppVrhfMHg8EL3QxyZignbaJO2FqVDtB
         vheLA5UVM0S2xJhjfWMLYRBK11NUpvSEUNG9/ZLnXtnbEiSEKqYuli5CTm9KIWXimUXK
         3/7tBnE9oLYLiQNoz8n804Hxzkh2G5gh/4J98vxyCPaVk4MHFD7B2caZhVHjz/Gcb3dC
         5K4e9efMXjEwktvBAtCobxgvQ+Jp/LgLE+XAKdhXDmHmmefN/N6dXdFEO42ekVKpTZ5Z
         d4cxUxPIUp9DBUoh0caTsZ2uogBH84tauAMs0MJUrY6yOn/VlCOdzMaygiA34T/ysYpL
         l0iw==
X-Gm-Message-State: APjAAAU5u7qWvz7KW+jnwuJrgyI5ExBivfwpYOEiuOsTye8y/jeUt4E+
        VV3frrHtMWvodrJngPmuJVj1n4Wsnx9r8g==
X-Google-Smtp-Source: APXvYqzI09j+iI9VlzxzIt3J86LSOyuAGfFjie2v5mkyADXX0r06wRpML08SdBCGfCWqDNt1AkQmYg==
X-Received: by 2002:a81:a00a:: with SMTP id x10mr838433ywg.475.1576088111598;
        Wed, 11 Dec 2019 10:15:11 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id y9sm1332383ywc.19.2019.12.11.10.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:11 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/23] staging: qlge: Fix CHECK: Blank lines aren't necessary before a close brace '}'
Date:   Wed, 11 Dec 2019 12:12:34 -0600
Message-Id: <ca11055798ea77bfe8f8e78f3f6f721b48eeea6a.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Blank lines aren't necessary before a close brace '}' in the
following files:

qlge_dbg.c
qlge_main.c
qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c  | 3 ---
 drivers/staging/qlge/qlge_main.c | 3 ---
 drivers/staging/qlge/qlge_mpi.c  | 2 --
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 71fce1f850c7..b44f80e93b27 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -553,7 +553,6 @@ static int ql_get_probe_dump(struct ql_adapter *qdev, unsigned int *buf)
 	buf = ql_get_probe(qdev, PRB_MX_ADDR_FC_CLOCK,
 			   PRB_MX_ADDR_VALID_FC_MOD, buf);
 	return 0;
-
 }
 
 /* Read out the routing index registers */
@@ -1205,7 +1204,6 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 err:
 	ql_sem_unlock(qdev, SEM_PROC_REG_MASK); /* does flush too */
 	return status;
-
 }
 
 static void ql_get_core_dump(struct ql_adapter *qdev)
@@ -1860,7 +1858,6 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 	pr_err("tbd->flags = %s %s\n",
 	       tbd->len & TX_DESC_C ? "C" : ".",
 	       tbd->len & TX_DESC_E ? "E" : ".");
-
 }
 
 void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 34786e2c0247..1a5b82b68b44 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -775,7 +775,6 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 				  "Error reading flash.\n");
 			goto exit;
 		}
-
 	}
 
 	status = ql_validate_flash(qdev,
@@ -1244,7 +1243,6 @@ static void ql_unmap_send(struct ql_adapter *qdev,
 						     maplen), PCI_DMA_TODEVICE);
 		}
 	}
-
 }
 
 /* Map the buffers for this transmit.  This will return
@@ -1358,7 +1356,6 @@ static int ql_map_send(struct ql_adapter *qdev,
 		dma_unmap_addr_set(&tx_ring_desc->map[map_idx], mapaddr, map);
 		dma_unmap_len_set(&tx_ring_desc->map[map_idx], maplen,
 				  skb_frag_size(frag));
-
 	}
 	/* Save the number of segments we've mapped. */
 	tx_ring_desc->map_cnt = map_idx;
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 22ebd6cb8525..0f9bd9a8b523 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -122,7 +122,6 @@ int ql_own_firmware(struct ql_adapter *qdev)
 		return 1;
 
 	return 0;
-
 }
 
 static int ql_get_mb_sts(struct ql_adapter *qdev, struct mbox_params *mbcp)
@@ -363,7 +362,6 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
 				  i, mbcp->mbox_out[i]);
 
 	}
-
 	return status;
 }
 
-- 
2.20.1

