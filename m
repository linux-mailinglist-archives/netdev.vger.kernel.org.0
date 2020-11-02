Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9122A29E2
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgKBLse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728652AbgKBLpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:49 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D2DC061A51
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:40 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 205so1440779wma.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=poH1VG0a9WGSQs1vAX3xhce1fVh51gqxCxVcQG61Ecg=;
        b=rTxAago5FX6VjdmUc/zhr+24URMWUlo1ORk7irP6IzLpkmczDExlwfsMw7YfgbfQn4
         Go+oARU+Vuxf2Bv2pJskXIRQda6jc8ngIq86PIUr2jG9c1E7JcPQit5nLomgsttqllRC
         JwIojjwtb9ygLNESd0kMJp/hgOojWCGQ/iN+sTh1+5ybHK0l2/DM2hguAeeVOGwgdwwb
         SQuBdAMxQ7ypgYpxW24F+/ObobpIYFu41sKTn/huR1X4kjkhvEJw6TFMr6X05LGSc7oX
         Dbh1sTMWSwvHB+UVLY2Fci+mJr69YZW4PGJBzHl5aMI+/MeRBhcq/feYMw69pbai374t
         nw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=poH1VG0a9WGSQs1vAX3xhce1fVh51gqxCxVcQG61Ecg=;
        b=HyT34tvJhfXZkbRC58JTFmqmmwWNLrmnBoV/LdZxz+eA2bVfq3ooQRfVofnA394aoC
         T4hT6++Hw6/KM9jirryRrXuBxXRNFF1tl/zyv/lj/nIZHVTjA9QXgPXE74u6b5Nxf3sB
         YgkjuwP92Z6a4ybBFWMMRlOD9stwY60tPEi1D1WQYNdPEn+suBokvbfbeQER+j9repDW
         /qSIj1Qp+UQ89uiuXPBdMUWiWIsSb8P9Yx3HjPkgZVItXui0JHQKoLuVG8g+vcQj9uBG
         2/voSZhnE5JifI9dFFOymAHbVKg7/TF3JGkw4S/J3x1aADLsJtaOPGbpWfz76C/PRNpK
         YHXw==
X-Gm-Message-State: AOAM530PUvVEn4Us1ihSCtNY5ARToIvB45YRay4uhDXECMxAoaIK+lDq
        ocFSt3N+FYfo7VSp1mj9xQbfjg==
X-Google-Smtp-Source: ABdhPJx7Hvq6uXTssI+CthCz6qQMWvOnUVh/2Uidh61gl4Ho2zsNP6B1NEIhfgxn4zHP12hqVJZ1fQ==
X-Received: by 2002:a1c:96ca:: with SMTP id y193mr17097349wmd.22.1604317539185;
        Mon, 02 Nov 2020 03:45:39 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:38 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 16/30] net: fddi: skfp: srf: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:58 +0000
Message-Id: <20201102114512.1062724-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/srf.c:30:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/srf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/fddi/skfp/srf.c b/drivers/net/fddi/skfp/srf.c
index f98d060b0f5b0..4cad68c3f49b3 100644
--- a/drivers/net/fddi/skfp/srf.c
+++ b/drivers/net/fddi/skfp/srf.c
@@ -26,11 +26,6 @@
 #ifndef	SLIM_SMT
 #ifndef	BOOT
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)srf.c	1.18 97/08/04 (C) SK " ;
-#endif
-
-
 /*
  * function declarations
  */
-- 
2.25.1

