Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469702A29E7
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgKBLss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgKBLpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:31 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B48EC061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:31 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c18so9078815wme.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s8uoq2NTqcU9/GZu8TClmlUCrHQkyQ7sDiNoJZkjYgE=;
        b=vAXWx6/5P9RNoz41owRIxlCUNS6pTDSvi8iEDC7bc5eVIy7dWDEvqkBnb/+B8VCC5h
         vKRv6FncC403gCgly1EBy0D7G9ACjQ90tp8PyGSGqB0FcdFe84IX39qxwEqGhapq7KCl
         u/MhPY/y+80sir4OZZZagrF3oy+KaFEmzpBUIx02yWavPSIRG4uquJCPkbLwFiOLYavD
         Fp8421yZq/GmvkVTeq6SqVN7JD+XEKNlcvHVcTFi2gAe0rrKU+9BR2N0ERsVAxGiRDX/
         e7QQ3qMS3J7dQXGwPJ9WhWnBIkQp6sVD62vFqicb3ArDnXemliqwIRugY8w8VcYvwdd1
         4zsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s8uoq2NTqcU9/GZu8TClmlUCrHQkyQ7sDiNoJZkjYgE=;
        b=iCihWRNlxQj8RVLhcR0VOcPnVYh9i6+rsgGoK4GWMlxrAnvddxf+yqA9ZrsL8AEEuG
         kSB6HtXW8eiB+hyXkK9szf9C+qDyZoFzQci2X0TdMJowQp/uq4bIPTUop36EAho+9PZ8
         vINc8p27F7a6fyD+DfAk1dX2rrJG+M0C3Gy5v3/LGmCIwVAS19O+6lLXgrtskN/zU2/7
         sZIr4rmY/cj+H/nzK8R4eGfvQVKgdIm8NQHW8IgLOK0Db9+TSw4UjJsQSahXn0RbZuK3
         1SVlOKYbVbVwf41UyenL3BINdGoiCgoy3A0rVVZYYXeWOLEn9zXVaICq2d8Mp9QaHWSX
         zvPw==
X-Gm-Message-State: AOAM531DgVNDfqI93gxzimvu5gOasEzUfU7LXCNNU3TMTsj48wRGHI+j
        Ss1OwxrrEZxpw6OaHhb4v5MtXA==
X-Google-Smtp-Source: ABdhPJyXzWkITGxxQ9FjUyHajtWPlgfvwJItE4etXIVGEyPXrEJUxHMPKUaCkrkgeWhPJUdZDuBypA==
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr17511311wmf.162.1604317530266;
        Mon, 02 Nov 2020 03:45:30 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:29 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 08/30] net: fddi: skfp: queue: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:50 +0000
Message-Id: <20201102114512.1062724-9-lee.jones@linaro.org>
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

 drivers/net/fddi/skfp/queue.c:22:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/queue.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/queue.c b/drivers/net/fddi/skfp/queue.c
index ba022f723bd77..abe155ad777fa 100644
--- a/drivers/net/fddi/skfp/queue.c
+++ b/drivers/net/fddi/skfp/queue.c
@@ -18,10 +18,6 @@
 #include "h/fddi.h"
 #include "h/smc.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)queue.c	2.9 97/08/04 (C) SK " ;
-#endif
-
 #define PRINTF(a,b,c)
 
 /*
-- 
2.25.1

