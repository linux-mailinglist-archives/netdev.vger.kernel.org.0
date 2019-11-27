Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C45C10AFAE
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfK0MkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:40:05 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:50426 "EHLO
        faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbfK0MkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:40:04 -0500
Received: from faui04s.informatik.uni-erlangen.de (faui04s.informatik.uni-erlangen.de [IPv6:2001:638:a000:4130:131:188:30:149])
        by faui03.informatik.uni-erlangen.de (Postfix) with ESMTP id 9D986241835;
        Wed, 27 Nov 2019 13:31:02 +0100 (CET)
Received: by faui04s.informatik.uni-erlangen.de (Postfix, from userid 66121)
        id 8088A15E0B50; Wed, 27 Nov 2019 13:31:02 +0100 (CET)
From:   Dorothea Ehrl <dorothea.ehrl@fau.de>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     linux-kernel@i4.cs.fau.de, Dorothea Ehrl <dorothea.ehrl@fau.de>,
        Vanessa Hack <vanessa.hack@fau.de>
Subject: [PATCH 3/5] staging/qlge: add braces to conditional statement
Date:   Wed, 27 Nov 2019 13:30:50 +0100
Message-Id: <20191127123052.16424-3-dorothea.ehrl@fau.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127123052.16424-1-dorothea.ehrl@fau.de>
References: <20191127123052.16424-1-dorothea.ehrl@fau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "CHECK: braces {} should be used on all arms of this
statement" by checkpatch.pl.

Signed-off-by: Dorothea Ehrl <dorothea.ehrl@fau.de>
Co-developed-by: Vanessa Hack <vanessa.hack@fau.de>
Signed-off-by: Vanessa Hack <vanessa.hack@fau.de>
---
 drivers/staging/qlge/qlge_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 587102aa7fbf..f5ab6cc7050a 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -178,8 +178,9 @@ int ql_wait_reg_rdy(struct ql_adapter *qdev, u32 reg, u32 bit, u32 err_bit)
 				    "register 0x%.08x access error, value = 0x%.08x!.\n",
 				    reg, temp);
 			return -EIO;
-		} else if (temp & bit)
+		} else if (temp & bit) {
 			return 0;
+		}
 		udelay(UDELAY_DELAY);
 	}
 	netif_alert(qdev, probe, qdev->ndev,
@@ -3731,8 +3732,9 @@ static int ql_adapter_reset(struct ql_adapter *qdev)

 		/* Wait for the NIC and MGMNT FIFOs to empty. */
 		ql_wait_fifo_empty(qdev);
-	} else
+	} else {
 		clear_bit(QL_ASIC_RECOVERY, &qdev->flags);
+	}

 	ql_write32(qdev, RST_FO, (RST_FO_FR << 16) | RST_FO_FR);

--
2.20.1

