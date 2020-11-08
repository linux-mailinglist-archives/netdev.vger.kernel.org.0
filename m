Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55D42AA8B5
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 02:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgKHBMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 20:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKHBMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 20:12:06 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6399C0613CF;
        Sat,  7 Nov 2020 17:12:06 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y7so4848787pfq.11;
        Sat, 07 Nov 2020 17:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PJ6pbPsgfV69uxn7Wd3OP+li9YYh0k+lJUu4SV9HT1k=;
        b=vUqQ6qaiYblfX0a/cUKKF0Hkg1/Y9zvNQgqoG+btG305wBt9A6CF32gSVdF9nrbn56
         rRISFuqP5QXSHMtYqvNk6M5iVpgYg45yLPHxgI50jAEChaGDGoyKAMZGeFk7PHnX0XdB
         q6TFaNXwEA8RicWtuvLOri7NZtF9dmNC3QrXgE2CsRhEdHBvXHwmWBjOkQEIi3VSre7j
         jEg8MI4iXmMvIhk/hdCKk7J+wCz6LbnoM8Pdj/mpzEbPM047WVoUNPrrCe4v8XsPIPVG
         qjDOhBkaivREVQoAVelvC06csFtbmlbWESlaBOYocpkeieFC9jtPoSNtB8hq68GKQmAx
         qgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PJ6pbPsgfV69uxn7Wd3OP+li9YYh0k+lJUu4SV9HT1k=;
        b=SstKyX/T1NdyvHeYzKrlPFMpAMGSX9sgeo4QYuThEJhenAF01Ia6mWmVGulaHs28n5
         YYrNUNFPyolt/DVqJ6/YC7mvnhUxmnQ8wYbuiopKbV9OXDnipgH0L4skebezyirzKWQy
         MzRe3F2G8yr2YTRKxXx++9GIRbZ/3kj/Z/hjdX+AbylzQ+rqYrSSpQWFBpdgQIvfSs/+
         AUwaVJAHrkzTyTNu12XgZ5EsUchAKb1a7NrkRtp64sOqVbsE59NN4gnQnpHOnf/eKR6o
         ocpo0izpNG3i3OjwPWfHiyKX9MluTfc0nRI1pl/y3XmBZd3EPGvKCeHK/CmP7MPGoutx
         gfWQ==
X-Gm-Message-State: AOAM533H+fsDKfw71KVKWW2CNWA6q3r6pFkC5/snyTKS7vC5Z3mYzlHP
        TuoiIj7PxKf/N4iEVt8XxdMoVaaew2vMY0g=
X-Google-Smtp-Source: ABdhPJxSr7mJoYy54ZWcv/jwCbiExGM4dd9i4tuuhLmORxxOIdEkY91emU9ZFTVGGZL0QF6o5GnDaA==
X-Received: by 2002:aa7:8b03:0:b029:152:a364:5084 with SMTP id f3-20020aa78b030000b0290152a3645084mr7838050pfd.29.1604797926394;
        Sat, 07 Nov 2020 17:12:06 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id o16sm6353275pgn.66.2020.11.07.17.12.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Nov 2020 17:12:05 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     irusskikh@marvell.com, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2] net: atlantic: Remove unnecessary conversion to bool
Date:   Sun,  8 Nov 2020 09:11:59 +0800
Message-Id: <1604797919-10157-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The '!=' expression itself is bool, no need to convert it to bool.
Fix the following coccicheck warning:

./drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1477:34-39: WARNING: conversion to bool not needed here

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index bf5e0e9bd0e2..6c049864dac0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1474,7 +1474,7 @@ int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 		for (i = 0; i < sizeof(cfg->prio_tc_map); i++)
 			cfg->prio_tc_map[i] = cfg->tcs * i / 8;
 
-	cfg->is_qos = (tcs != 0 ? true : false);
+	cfg->is_qos = !!tcs;
 	cfg->is_ptp = (cfg->tcs <= AQ_HW_PTP_TC);
 	if (!cfg->is_ptp)
 		netdev_warn(self->ndev, "%s\n",
-- 
2.20.0

