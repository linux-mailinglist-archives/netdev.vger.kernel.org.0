Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F112A45AEFC
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbhKWW1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbhKWW1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:27:35 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AB3C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:24:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so2946954pjb.1
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QL85HYqgA6GF4uhQ8ZyFWJFwb8eqGfhc4B+itvTUuGA=;
        b=A3RNJUDpL2H/03nkPkWgzYfulNxd6QFiJba7/iE00X0VOPl79+jNW9IBDex/zHl+V4
         nnzMcnfiNJeSHZWbi5ovkicJFp5WDL89otFRu0/4Qv6BFWWDb0eindLQ0wBanktf3zp9
         oGUKLWjTekhq25oboiLVQ29oqL9HshYkZJQY3HdUClxwCahipGhsoRH0qtGBSzsnhteS
         m+g5Ln1Wjj6/MMjLt62U6bPCM3XQST2yP2DpxDE2ewN7ekgHREqejxKXu8agwO7Gu5HM
         RWNxwG65ll0bRKT9CuMmiG+Z6ovf5oTY1hI/6nYd5/Hmgclu/pnaiBl7JQjYj3oHoLqs
         kQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QL85HYqgA6GF4uhQ8ZyFWJFwb8eqGfhc4B+itvTUuGA=;
        b=KfbVyRg9uZnB23bkPEIKTDjHPb4YiPxDcGMNEE1SipFuOLXda/rg1mjB2mfDEtt+8p
         S9a+AiRWmlwtaOyZZtxBH8bDPX1KWxDvisK7oi8ePhZA5MPN6kXt7cUpZbVmUJoPkY1e
         lfxYlf2VHthEt09e0DWIL8CxQ4dxNgikTwCh6EeBODnnbQbf5il9b//k/JpHOGKGJ5X8
         hCCfpAXc5dBx4OKugswIdMrbjz5SELxaEqmtU5oAeMHEHWbn3R9LtUOpQMTAs8iOj18b
         iflfFNf4E7OMz6TcjNo7FmQ93l3uoKgCIemKQPG9jr3wjrBsFfxAY4StUAcrGntvRugg
         PRgQ==
X-Gm-Message-State: AOAM531msnB5KSeKfvu9Rsx4W1MSKD+WqvHhq3Ouwl43gttAJh6klPKs
        0Hv9Ku0FuMtrE53lxH10tsABpiSjrho=
X-Google-Smtp-Source: ABdhPJxk9pPSYgt5Ezz19h6wohxHimlCx8ZSn1fCUced6+F22UZLdPdkdN2amDpRAE6qyDiNOcJFyA==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr7890320pjb.0.1637706265884;
        Tue, 23 Nov 2021 14:24:25 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n71sm13124643pfd.50.2021.11.23.14.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:24:25 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next] MAINTAINERS: Update B53 section to cover SF2 switch driver
Date:   Tue, 23 Nov 2021 14:24:22 -0800
Message-Id: <20211123222422.3745485-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the B53 Ethernet switch section to contain
drivers/net/dsa/bcm_sf2*.

Reported-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10c8ae3a8c73..dbe05daf17fa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3570,13 +3570,14 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/b44.*
 
-BROADCOM B53 ETHERNET SWITCH DRIVER
+BROADCOM B53/SF2 ETHERNET SWITCH DRIVER
 M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	netdev@vger.kernel.org
 L:	openwrt-devel@lists.openwrt.org (subscribers-only)
 S:	Supported
 F:	Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
 F:	drivers/net/dsa/b53/*
+F:	drivers/net/dsa/bcm_sf2*
 F:	include/linux/dsa/brcm.h
 F:	include/linux/platform_data/b53.h
 
-- 
2.25.1

