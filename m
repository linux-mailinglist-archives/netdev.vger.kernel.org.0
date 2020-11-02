Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2302A29C6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgKBLqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728626AbgKBLpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:35 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB791C061A48
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:34 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id k18so9187024wmj.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bo49ib5VL9yqey9VyX7XP5zl1YXqZIOtWGudOLG0P1Q=;
        b=SufM/3lmzUDYSfCpW5FTrP8RpUmf0MYSFD4/squLedHDglTvM71nyDDnTfTPMTlY6j
         hvLMCOU+6AUYf9I7/ierRm3DXRgWN9UWRUm160CfQVax37Oowe9aXm9cote2n4gWSEwF
         VPcKX+LN2BR622D2ge4vsb1b6Np/XbFIYOtQ6ICNbyF+ui/k3qHfiyyszNPSUTneVKcw
         D/WrKcp3xHGUwZ9Ixwlosb1js1mN2n5y2I6AFSsw/DHonoxKLSHPnDKsBgtWJPWOXKNZ
         XMVCHODv1+M3Bj5F0X4YAGwPnXKufAsNE8iTQ6znQV5dBio2AT/vciqptNhPTIGRVnhp
         YcPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bo49ib5VL9yqey9VyX7XP5zl1YXqZIOtWGudOLG0P1Q=;
        b=eMxNW/8xbxEC6xX4yUkAjsbXeE9rkBAoQGowT/c/v3K8fWHr/tRhryLixQcAg1FqZo
         QLKvTG5uylHVFmjTGeBmpTaGwVCEqOsbHyDc5vm5DlCb2dcvGRkGup10caY4jOBCbf3C
         4JDotD/n6v1HaNWpsdGi2Z2OXexwf+7lzFilo8qiQYj2U7Fn+y/EryaVAg0/d425p1i5
         PmgK44+ITryoUhfPxSNkOMR7xBxEqdRxGFQ8lIBcow1eSJAO3/7BeB0HGFqxV4OZUAv/
         QN6Ds7tX4uTQr9mgsITyUH8XhL7v8m2/ZrzDA/Cx8ZsIMbRjDNhnKPbcjMK2YTORzoo0
         ZTlQ==
X-Gm-Message-State: AOAM530f79Ps6lD7xfXe/j5gOorUq57T69okVKM7gdEptkglfhq4hPMi
        6XFmhX/A7lmAwTyCk1hg7GW/Qg==
X-Google-Smtp-Source: ABdhPJywSUw4EDLs7UyrJZTutBD0+aK2zdCl2aJlw1IHHat9blk/wCzMnrVg+t7hnA1FwxxU+C+OBA==
X-Received: by 2002:a1c:f002:: with SMTP id a2mr18345798wmb.129.1604317533627;
        Mon, 02 Nov 2020 03:45:33 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:33 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 11/30] net: fddi: skfp: smtinit: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:53 +0000
Message-Id: <20201102114512.1062724-12-lee.jones@linaro.org>
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

 drivers/net/fddi/skfp/smtinit.c:23:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/smtinit.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/smtinit.c b/drivers/net/fddi/skfp/smtinit.c
index 01f6c75cbea81..c9898c83fe304 100644
--- a/drivers/net/fddi/skfp/smtinit.c
+++ b/drivers/net/fddi/skfp/smtinit.c
@@ -19,10 +19,6 @@
 #include "h/fddi.h"
 #include "h/smc.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)smtinit.c	1.15 97/05/06 (C) SK " ;
-#endif
-
 void init_fddi_driver(struct s_smc *smc, u_char *mac_addr);
 
 /* define global debug variable */
-- 
2.25.1

