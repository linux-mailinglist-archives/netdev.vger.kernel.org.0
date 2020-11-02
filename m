Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC772A29B7
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgKBLpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbgKBLp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:27 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE06C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:26 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id a9so14187060wrg.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yNA/lsoUC0LQBBnCzXfTlR1/o1qLqZQkYjPe/aZZUWk=;
        b=VJ7OQqxCtsMIFKYTVkbAQsy4Gl9fa43vLa9eRWIIWy83//s/L6RVTdlWoNurw28qak
         RLF6Z7wCmTpYP4Ezmq/ji3TCV0jSs345gzdEvm2bDiZW+/rx/UMs47jwhZ+F4mRHfY4L
         VdDLv8oXbAQS/zpMKs3v836D25W7uolqLtcj2c5ZNC0VqZCN+t2t9LU6vwumhKv0ew48
         UPhgAIszuq7G0Lcbux7lR8Sjl6Ff6zfqvnHW3FxurZUIjieAyiKIZaPCha57yAYnSHSW
         fgFrWHiIRBG1v25ceQ5XPV/55I5AvrsSfEkSJNq7ALMJoIggQVDQizmNXEmDbblKe0Jv
         gsew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yNA/lsoUC0LQBBnCzXfTlR1/o1qLqZQkYjPe/aZZUWk=;
        b=L5B5zi6g19nVTBgFYAnnl/a0Mc7dDhRSZElIkudqzAteepcU4dMie8fDCU+9iUXHDI
         W7O1PN2gL5CJH+AsoFPDiP4NHnhn+0jWvKSRNrYjoXTpGc2/aGhF8WHbTm1YGF0WyE+2
         1rHuFISOcK8+mvMr+6Jc5NN6vb+4EcX0+MaT1C2Yy7V08K4pOpp6P4cnJDjMk3vN0A3F
         qvUCaFtJxr6IYR+tscyhLVrBWVLHVqsJDcdf0vBcG8sZek7GPDCWeINSGqNh9LglXL6H
         igIMetnFFzMF3ea0JXVR7BXVLJ2obvrmbQi+GUwcbqaj3+00KPoAYChdvLioyDj0xa9D
         wnmw==
X-Gm-Message-State: AOAM530ItaNvSDkUD6It3vmsHfsq8vxw2udfqv0MoXHQBJJLAoCak1gJ
        zqFwXD6wz/kGCOaMMVqYvAgOIg==
X-Google-Smtp-Source: ABdhPJyMDwWSXDu4EYwBHjPgqYG7q1YuMC8d2HWbou7grThryxqWTPwEwgzghHp+jOXfgaBsD8F5FQ==
X-Received: by 2002:adf:cf10:: with SMTP id o16mr19694571wrj.264.1604317524782;
        Mon, 02 Nov 2020 03:45:24 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:24 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 03/30] net: fddi: skfp: pcmplc: Remove defined but not used variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:45 +0000
Message-Id: <20201102114512.1062724-4-lee.jones@linaro.org>
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

 drivers/net/fddi/skfp/pcmplc.c:49:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/pcmplc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/pcmplc.c b/drivers/net/fddi/skfp/pcmplc.c
index 554cde8d6073e..90e8df6d9a88a 100644
--- a/drivers/net/fddi/skfp/pcmplc.c
+++ b/drivers/net/fddi/skfp/pcmplc.c
@@ -45,10 +45,6 @@
 #define KERNEL
 #include "h/smtstate.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)pcmplc.c	2.55 99/08/05 (C) SK " ;
-#endif
-
 #ifdef	FDDI_MIB
 extern int snmp_fddi_trap(
 #ifdef	ANSIC
-- 
2.25.1

