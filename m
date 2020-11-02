Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB252A29DD
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgKBLsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgKBLpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:52 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42B3C061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:42 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id k10so12873477wrw.13
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HI+eieWXuwyz8PcdZT+p31GivdwC/vuYT4tAZQpGNKs=;
        b=TENsMfs6lnqr8/OGtVcbodT5BW0/AHHyX8VH8Wr26SQTsxCLQFxX7ReD0GAMYBBl5I
         1LiZcLx1tnEbNtBftzZoPGO3e86/6jRCj2j30ITfpd29Fa42nYoofjxOerqk003UW4ok
         IL7YTl3N/WzH3XJHN/O7kVWu1yPX5kVW/m2ssFKO6KFxZZySwXj3ehbQCAVpAIH7mm8b
         7ULswcoGba7CGhFOiKZHWsjYPPbBoukqKkg2ATGUpTgwVuyTDeCjMwG6WMQuqIMy/MxM
         P6AChpG1bKuLRv3l7y2x88yOBg/DfAGyeQGDTxwcV5A4tBiKqF4S0f4+9WfGlJC2+Axn
         kF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HI+eieWXuwyz8PcdZT+p31GivdwC/vuYT4tAZQpGNKs=;
        b=MrfIj90nNS8G0ANM+jXqvYcmGif0pV38ZqFEZqtBdb28+5jr5FC8Y2QCLmld9rmAaJ
         c6QzP+yGvDj4ITUC11jEyyEsEQeYYw95uwXSSC/6zbYp2Hib6RjMtu5f4CLqad0h9nDd
         QLxdBZi8vqGQPA3cO87Aq5Q5+UEl4MlTt/B0CnZyhfykiI8pcMflfEjGal445CtKqPV7
         lymUoVu8JwUHL9BwH3YF7RzL48Py8GTocBJ6nra7CF1TkKCD00uZwOL/AGxnKGg2gzL5
         xidOdu9W7SAqO1St83akEzxvlEdi3y6bS24/4dInYegqMUpM9lhsV/ynJ1rsPIhMX8fJ
         KzJQ==
X-Gm-Message-State: AOAM533rxvYKWC1wAiD8SSqOT0ct15B2DkHnOj2acqXfj1vXP1rALAhW
        OzqycMYml4IFKJ7Nuh/7v5frFQ==
X-Google-Smtp-Source: ABdhPJyEcjdGLfyFckCwi2FifsndwmgroBJiGMYfufwGXa+ttr437NvQYTVTAcsF7RvxNZ5ZgzbK+A==
X-Received: by 2002:adf:f381:: with SMTP id m1mr21735375wro.347.1604317541432;
        Mon, 02 Nov 2020 03:45:41 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:40 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 18/30] net: fddi: skfp: drvfbi: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:45:00 +0000
Message-Id: <20201102114512.1062724-19-lee.jones@linaro.org>
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

 drivers/net/fddi/skfp/drvfbi.c:26:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/drvfbi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index cc9ac572423e9..e9b9614639cdd 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -22,10 +22,6 @@
 #include <linux/bitrev.h>
 #include <linux/pci.h>
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)drvfbi.c	1.63 99/02/11 (C) SK " ;
-#endif
-
 /*
  * PCM active state
  */
-- 
2.25.1

