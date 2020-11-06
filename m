Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD80C2A8D43
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 03:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgKFC6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 21:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgKFC6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 21:58:05 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86401C0613CF;
        Thu,  5 Nov 2020 18:58:05 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id t18so5069plo.0;
        Thu, 05 Nov 2020 18:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ApwtLKpCcHdcGK+ytVxITWZylBiKpvRjj//XYnHu5eQ=;
        b=RxqAB9pK2ZahI/KXzCmpo35u41IwHTOKXayKnxi1fbSlcwrAdIz5xBHRhwl4hRIDNI
         aYSyGVMcp/Zrz8o+epI2rNff3voSenCrDAesSCk2FPFCGUPJmiviaZLg7d4jNgXOoRRA
         3gDTlKLIkSEFwzVM8+3RizSK1Sx83xb0n1xL+sDCYNzapKykn1dZMfcNK/nQ/H4Vj1I+
         83Azd1rIMG9fGCOqBU/uTPLkMYgpadCgs53UJ3kPlpbZsghqLgdeh6zvlaYnlN8e1r/Y
         EpW8qassbWqSyzRE6nXIkF+0aF8eWE2yyy849/snKmQxQLXaQVCXjK7GdFT+EJwi0Sym
         3nmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ApwtLKpCcHdcGK+ytVxITWZylBiKpvRjj//XYnHu5eQ=;
        b=fCpyGsbWtZxtyI7DaNtxZ7P2Ltjd4BCACV/ExWDRZkNacddsnGM2Z2RzI/VoLMbMed
         13/+b+yasCwIHq9JLMDqtP8FxUc2bCL2SIIXNwdXPSoacjmgrk9F+W+KIMVWiY9wvk5L
         yKFk8JsFYia0CxlMaMvdVcSo+83tp4U6gfY2cEzxXne3KpLuD8rr++6u7xGPNitixO4B
         sMv6FWeX2Fm5dknV5SgDhaGnnCrGw15OIt0z3uYOTwDi1i8jFlpo7Gd+nUMI+v+GqSW2
         zwDCxMewn/XDqCxL1dSKQFTHjSvGe2l4TkkEtsxXGhR5PmZN4S3eZdM+bIOSvXIpwyD3
         KA4Q==
X-Gm-Message-State: AOAM531VSWFTIj+m2QmDeT1Env8MjqCXVZxZwullD8OOsvGX4jlF8B/Q
        r1cBF/rk05MPSuEMuP2TRw==
X-Google-Smtp-Source: ABdhPJybjYR7DAMHspWtzQvDZyUXX1DN+DV4jvFyj2ksgsjYApiKQ6zhMno+dIRh5gjKdNeW0vSuIg==
X-Received: by 2002:a17:902:e9c4:b029:d6:d5d6:c288 with SMTP id 4-20020a170902e9c4b02900d6d5d6c288mr90976plk.22.1604631485103;
        Thu, 05 Nov 2020 18:58:05 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id w13sm4087489pfd.49.2020.11.05.18.58.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 18:58:04 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     irusskikh@marvell.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] net: atlantic: Remove unnecessary conversion to bool
Date:   Fri,  6 Nov 2020 10:57:59 +0800
Message-Id: <1604631479-32279-1-git-send-email-kaixuxia@tencent.com>
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
index bf5e0e9bd0e2..2087581b31ad 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1474,7 +1474,7 @@ int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 		for (i = 0; i < sizeof(cfg->prio_tc_map); i++)
 			cfg->prio_tc_map[i] = cfg->tcs * i / 8;
 
-	cfg->is_qos = (tcs != 0 ? true : false);
+	cfg->is_qos = (tcs != 0);
 	cfg->is_ptp = (cfg->tcs <= AQ_HW_PTP_TC);
 	if (!cfg->is_ptp)
 		netdev_warn(self->ndev, "%s\n",
-- 
2.20.0

