Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12A0156B9F
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 17:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgBIQ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 11:56:47 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42015 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBIQ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 11:56:46 -0500
Received: by mail-pl1-f196.google.com with SMTP id e8so1817024plt.9;
        Sun, 09 Feb 2020 08:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bYXiQhC5n5u/ihEX7aKChFXEwfa9YarVLF2hhJhV42c=;
        b=uanZS5YpnfBmwJUJ+r7OgAIA+Wsd5XvpvXQfwihhP7Ttal4Tm5IkYeuk+IiGByv6eF
         /zKEGckzC10V04/gVbf0PsNBDMzyde4Q6MwMdvWd1vaYsLaBTd4gNI45Q6ge6Frucrd7
         rGzwmt9IptGJ8d8hCEX4iHW1wB5sqLu6Xdp4ebKFpfeGRsw9kNaffQOcG/Va3CIoZW4/
         x2MaSGngOv26K/HKqPbqmmpjonL2S465KBSlVsL/znwNp0PfRfN1GiOA4OLcGzLtM8aG
         HjAKy1H5Z0mYFcRt4T9D+Pc7k1GC8Q/wM0FNCu20O1m9qf/WSWCzcgB8kf3CRmHjpzhY
         wVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bYXiQhC5n5u/ihEX7aKChFXEwfa9YarVLF2hhJhV42c=;
        b=tc08Rn5/gI3kqGQ1LHuQhA9vRgUSMolth+IEGAM9KLoNS4Zzh/mBgreCxcubJzriGW
         tWZsuRRShkzIlgakRrlb8snBJRBbUy1c1lUEoTtV1F/s197uFfrP+TpDbhT6mHxX3ek9
         3fPR8F178ZLbcU6782GAcIsahjD+zzESxGdN4JM1MkeR/7ZbqUjXQ2LIMRfvVf+XoWjg
         HrJgl/2apLHZlK47BLUk4Iw6VJbM/LZ5GbW13Hpk15z9q5yXqktrpRbLRYP4gvMQ0X5r
         +BAMo4bi2FfnIlg2VsUgefAMfFK6x47sAJpxUl5aMpNq/xYUveNFsMfuoKabuzCKpa2F
         wPmA==
X-Gm-Message-State: APjAAAViwi3WMpvMTXhoLafBVYGHhcCHQ6CrqEjWCBGAT+JPjrv5bK3U
        yO0DNyNso19CbRWt4RGLuzw=
X-Google-Smtp-Source: APXvYqyTLAgUBwo4RbJ29MJo22d4RDu1W7S/60tnhf9FFhVXSEX981uJZSEVQ790JyDQrCTveCttwQ==
X-Received: by 2002:a17:90b:243:: with SMTP id fz3mr16500653pjb.29.1581267406107;
        Sun, 09 Feb 2020 08:56:46 -0800 (PST)
Received: from localhost.localdomain ([157.44.204.164])
        by smtp.googlemail.com with ESMTPSA id c184sm9785000pfa.39.2020.02.09.08.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 08:56:45 -0800 (PST)
From:   Mohana Datta Yelugoti <ymdatta.work@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ymdatta.work@gmail.com, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: remove spaces at the start of a line
Date:   Sun,  9 Feb 2020 22:26:19 +0530
Message-Id: <20200209165619.18643-1-ymdatta.work@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <ymdatta.work@gmail.com>
References: <ymdatta.work@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "WARNING: please, no spaces at the start of a
line" by checkpatch.pl.

Signed-off-by: Mohana Datta Yelugoti <ymdatta.work@gmail.com>
---
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

