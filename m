Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8AE79B2
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfJ1UJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:09:58 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40685 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbfJ1UJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:09:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id p5so1024265plr.7;
        Mon, 28 Oct 2019 13:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=wl+iKNA5Jfay9ywIg9f4O45/2oXRJ3Weq7J5t6Tjfas=;
        b=FvvSzQZhtAbnnhD9fehuY1IndRKkyeQFH/Ja4KzmDtuFlsQ4yWC3wDD/uKvTzXdO77
         mRJu3Rm77YcfdaMIXRi38XW4xrNXJmd6jtwnIsHlAISpgUIJEssbEyHw/cJkryhevPZN
         Fgqyy4Br72CBLdf3A6KK7MEGAW5jd/5I3c4hqfd5FEdFkBqtv0DDJ5Dy/73NCCMJFirJ
         NKZDseP2xVBrVl7fL1syApRx1CoyuebQsBP14yBd4bHW2RejGkytU2DR5JTFikrscNYx
         lt1lu33+alUjvvyA5YuTJKMFad3WBiTaJAY0PfsUs5EYRX3iHeUBoYkNhgssY8TS9POy
         VbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wl+iKNA5Jfay9ywIg9f4O45/2oXRJ3Weq7J5t6Tjfas=;
        b=LHJ6jwy0/o46v6TRBpVFdGFdiheG3mBAa5sN+zOmv6aLNqzbvUcWD/VO7bOKyN1MO6
         9C79cWB7wSoWvdnmFqubW58nxdZV7d8Ap2lf+JtKhPGE7E8XkgSUsGYLC1IUWk/lSpd0
         3M4AFC8HTLA/wTqIfnV4/W0CwOeiAOsyuQOWsIDFrH489EZfdMzXwmJDVRmh+jQMxPfz
         T8N5V6JhOJbWviZJ9bMBrYxRZJ+i0Tcdq3JlYiQkn6Ll9iPxdEJp04oo/NcczM9fZW5T
         1zkhlhOAFqSq1sTR/WPxFtOFuGf3RDvJ5yBkFfJZ4hOYm5p4WdC+PBpM8wzcb9B88KLt
         LPmg==
X-Gm-Message-State: APjAAAVHpprEdZVLR2j6toGSMvEZYZdZsHk/tx3zbzvPIqq7zAmXXu2q
        BYpYA/22TW8zEvcx3OPJkbo=
X-Google-Smtp-Source: APXvYqyajeo0OC7xTlcmXfY/Y+R89i/qbP/KRbraF3xD5S+oVDl7mzcP/13Ma6RUFsB5gyTb/AAAbA==
X-Received: by 2002:a17:902:a503:: with SMTP id s3mr20180655plq.203.1572293396691;
        Mon, 28 Oct 2019 13:09:56 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id 31sm12360941pgy.63.2019.10.28.13.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:09:56 -0700 (PDT)
Date:   Tue, 29 Oct 2019 01:39:50 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     sgoutham@cavium.com, rric@kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] cavium: thunder: Fix use true/false for bool type
Message-ID: <20191028200949.GA28902@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use true/false on bool type variables for assignment.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index acb016834f04..1e09fdb63c4f 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1007,14 +1007,14 @@ static void bgx_poll_for_link(struct work_struct *work)
 
 	if ((spu_link & SPU_STATUS1_RCV_LNK) &&
 	    !(smu_link & SMU_RX_CTL_STATUS)) {
-		lmac->link_up = 1;
+		lmac->link_up = true;
 		if (lmac->lmac_type == BGX_MODE_XLAUI)
 			lmac->last_speed = SPEED_40000;
 		else
 			lmac->last_speed = SPEED_10000;
 		lmac->last_duplex = DUPLEX_FULL;
 	} else {
-		lmac->link_up = 0;
+		lmac->link_up = false;
 		lmac->last_speed = SPEED_UNKNOWN;
 		lmac->last_duplex = DUPLEX_UNKNOWN;
 	}
@@ -1023,7 +1023,7 @@ static void bgx_poll_for_link(struct work_struct *work)
 		if (lmac->link_up) {
 			if (bgx_xaui_check_link(lmac)) {
 				/* Errors, clear link_up state */
-				lmac->link_up = 0;
+				lmac->link_up = false;
 				lmac->last_speed = SPEED_UNKNOWN;
 				lmac->last_duplex = DUPLEX_UNKNOWN;
 			}
@@ -1055,11 +1055,11 @@ static int bgx_lmac_enable(struct bgx *bgx, u8 lmacid)
 	if ((lmac->lmac_type == BGX_MODE_SGMII) ||
 	    (lmac->lmac_type == BGX_MODE_QSGMII) ||
 	    (lmac->lmac_type == BGX_MODE_RGMII)) {
-		lmac->is_sgmii = 1;
+		lmac->is_sgmii = true;
 		if (bgx_lmac_sgmii_init(bgx, lmac))
 			return -1;
 	} else {
-		lmac->is_sgmii = 0;
+		lmac->is_sgmii = false;
 		if (bgx_lmac_xaui_init(bgx, lmac))
 			return -1;
 	}
@@ -1304,7 +1304,7 @@ static void lmac_set_training(struct bgx *bgx, struct lmac *lmac, int lmacid)
 {
 	if ((lmac->lmac_type != BGX_MODE_10G_KR) &&
 	    (lmac->lmac_type != BGX_MODE_40G_KR)) {
-		lmac->use_training = 0;
+		lmac->use_training = false;
 		return;
 	}
 
-- 
2.20.1

