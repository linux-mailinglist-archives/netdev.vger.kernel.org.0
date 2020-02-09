Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E3F156BD8
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 18:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBIRgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 12:36:45 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52637 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbgBIRgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 12:36:45 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep11so3138414pjb.2;
        Sun, 09 Feb 2020 09:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MxZxxqdrvS4s5tnXJDq2WZ6KSwZkXVufIoxtWg0QLPQ=;
        b=XM4zEnqDl0yRWNRbaDzIVDLAWyH7AtL6zTJAK0SvNBT0meYt7yTuMUvYHDcQT5PCMM
         6SK1Rpuo0/BZxDEXOcMjyOgIBjyR7Lia57x2OWttOXzRDF+Ylm5bcRgusTSFxXmZ05la
         SkYZTiNRW9psCdOA33zkFXLbw9b2vpCSI/X1zhVm7wgY+ehjmbwp2nK7sDIX7B8iqW3b
         z9mJRebD5v7E9CU8C9xH18sl142RM9kpU3rU2rscyEl1HbHFRrKEckGZaTKKiKzezOYa
         HTGnl67DWACE6aSAEtpIlveM1aiVEM2TZTiGfacvZ1ckNz3IemWBbu1inWuL06V+jx8T
         CctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MxZxxqdrvS4s5tnXJDq2WZ6KSwZkXVufIoxtWg0QLPQ=;
        b=q1Kt8rCS8NxJ22lAU9lyhswEii2mSpp9mvifsgIM2aLfVhVvHsz5a7Svb+k+XGwtra
         wg8gsPmmpH6ii026C5n8LpoEdiHoOQUc+5PVeXJWzFNRtILAVwj2l20J7QZETRH6ko6M
         VMCsGpZ+B5tIWgLIq+86HzZMg9QUjxddh7jvKlAeFXTwH78YAQrGSboBmnCAvshqzbL9
         3Milbhqi4oTNiOYVtfj1q80QKLz91THVVMV85de3E3Cu/giVcx4N+40vqvPUqLpdlVnr
         8tZwJsy9Frn5/azZ/Sper0uFx3PZ+jmmSpDKfvyYqbgbON2gITOkx5MSghBjwx4GnBOc
         RIVg==
X-Gm-Message-State: APjAAAU7Z00bebIIokegygEzrdkWAGsJDstcmj02PveegpWhne+s/GJB
        goU/RM575/a/jNIcmRvmUUY=
X-Google-Smtp-Source: APXvYqw3WlI2XqIr2fOVvFk/hGJQBakrH3bO0O4lHxK8Kjf832Op4thHm0kx3KEwlDgvQNTtdpropQ==
X-Received: by 2002:a17:90a:a115:: with SMTP id s21mr15701606pjp.23.1581269803400;
        Sun, 09 Feb 2020 09:36:43 -0800 (PST)
Received: from localhost.localdomain ([157.44.204.164])
        by smtp.googlemail.com with ESMTPSA id y18sm9352622pfe.19.2020.02.09.09.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:36:43 -0800 (PST)
From:   Mohana Datta Yelugoti <ymdatta.work@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ymdatta.work@gmail.com, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] staging: qlge: remove spaces at the start of a line
Date:   Sun,  9 Feb 2020 23:06:28 +0530
Message-Id: <20200209173628.21221-1-ymdatta.work@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <ymdatta.work@gmail.com>
References: <ymdatta.work@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "WARNING: please, no spaces at the start of a
line" by checkpatch.pl by replacing spaces with the tab.

Signed-off-by: Mohana Datta Yelugoti <ymdatta.work@gmail.com>
---
Changes from v1 -> v2:
	Improved patch description
Changes from v2 -> v3:
	Added information about changes between patch versions

 drivers/staging/qlge/qlge_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ef8037d0b52e..86b9b7314a40 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -52,16 +52,16 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 static const u32 default_msg =
-    NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
+	NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
 /* NETIF_MSG_TIMER |	*/
-    NETIF_MSG_IFDOWN |
-    NETIF_MSG_IFUP |
-    NETIF_MSG_RX_ERR |
-    NETIF_MSG_TX_ERR |
+	NETIF_MSG_IFDOWN |
+	NETIF_MSG_IFUP |
+	NETIF_MSG_RX_ERR |
+	NETIF_MSG_TX_ERR |
 /*  NETIF_MSG_TX_QUEUED | */
 /*  NETIF_MSG_INTR | NETIF_MSG_TX_DONE | NETIF_MSG_RX_STATUS | */
 /* NETIF_MSG_PKTDATA | */
-    NETIF_MSG_HW | NETIF_MSG_WOL | 0;
+	NETIF_MSG_HW | NETIF_MSG_WOL | 0;
 
 static int debug = -1;	/* defaults above */
 module_param(debug, int, 0664);
-- 
2.17.1

