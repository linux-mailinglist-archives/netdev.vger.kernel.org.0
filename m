Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3EF2A29B6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgKBLpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbgKBLp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:26 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61D6C061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:24 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id k18so9186543wmj.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qTLTOT3UiP7umQhbUytVP5DdKiqnXHZ+scIPpasRwX8=;
        b=U5nOshcFMkIRwnZ7WqYwgy6vgOAvLlNMafEdOqovcaGuQwSbUQWG303JSKW26Wb/v2
         Wm7N3kcb57OsFvdqqctn29+vCJkLykuCstn7Kf+KTjXLTeVzOB6B9zWVJ97mTkkG904P
         jES3hBetpsvS+hZxnmz0VRDE3tcSS+cNQi67hYIJ/eHe01+gAmL82vcxCxq8tovNtMdM
         pjD7qVkTLueYl+u1DBXXpXhf/Bhifzq3YVn9x8UBUKK23Qpn0Ndf7/A/fiCX36JR1fGl
         A4pKRVkQWYegPLIExk7PXwb0R1yZUwiQ5G3dwUZE1Db/DjSCjPd9ZFaYyhpzGAj1yKg9
         hSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qTLTOT3UiP7umQhbUytVP5DdKiqnXHZ+scIPpasRwX8=;
        b=fB2tyMhqjhyseXdDIGi2mtsQP/QysZUTMCco0CZ+3UVO/DivLNjNSCGq0VmVfn+0Rm
         2RNoq2BmvPwwtFMQxtV8VhIj31O4HNr6Y+Gy9kcbf9+sFY4ZMwsk2SQfN+2Xxwxs1xTv
         WMdTGd7TSPBeZL2302qCyqh8TIAuzeFYNqZ+KpEf+AG6501uIlmsDFpyKkkXPjJEZjlv
         eyYeVxAq4P8Hpss6xij7b3T7WZTp7nXEcLAQl5Ib48owkGJFv9ZGi4+39+YgDBmajqgz
         324kscIqX9U5fpLjtq6/MF87EPkwA6lY188Lg5kUNNNIQGTLRBdh2jNzmV4XSAwHk+cH
         hpUQ==
X-Gm-Message-State: AOAM532sDYtZWheCSkUSLuT46gBIveIgFVs6YcH1w3e4yXGfrFYoCfs1
        rf9HwZojH0CC6RkMg6E6rtMR2w==
X-Google-Smtp-Source: ABdhPJxWBIDDJ9Hbor8TSdj63tk0OaicVZFIzsP+XZstpxjIm4DgBlg8Z2N9iqjfTPYvgVIY+d3b2A==
X-Received: by 2002:a1c:c286:: with SMTP id s128mr17255914wmf.88.1604317523577;
        Mon, 02 Nov 2020 03:45:23 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 02/30] net: fddi: skfp: ecm: Remove seemingly unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:44 +0000
Message-Id: <20201102114512.1062724-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This variable is present in many source files and has not been used
anywhere (at least internally) since it was introduced.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/ecm.c: In function ‘ecm_fsm’:
 drivers/net/fddi/skfp/ecm.c:44:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/ecm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/ecm.c b/drivers/net/fddi/skfp/ecm.c
index 97f3efd5eb13c..2f5f5f26bb434 100644
--- a/drivers/net/fddi/skfp/ecm.c
+++ b/drivers/net/fddi/skfp/ecm.c
@@ -40,10 +40,6 @@
 #define KERNEL
 #include "h/smtstate.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)ecm.c	2.7 99/08/05 (C) SK " ;
-#endif
-
 /*
  * FSM Macros
  */
-- 
2.25.1

