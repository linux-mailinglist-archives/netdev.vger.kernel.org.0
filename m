Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B913D33698B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhCKBUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhCKBUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:20:22 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76FCC061574;
        Wed, 10 Mar 2021 17:20:21 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c76-20020a1c9a4f0000b029010c94499aedso12200813wme.0;
        Wed, 10 Mar 2021 17:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZOFX3Z+Nh1qGoQBD8/kOpxjm8rGJnIajKjvGxPffQVU=;
        b=tiHVeYDJLsTTaxGjUEeKhXB4TZi93pOY0n1egph0QHJ0skAQKwVCL8/5UcxVU1O9pE
         0DI34vCZgRKfxhuGjRmlysaBxjy4vuXNMd9CJiXLmwudzV2n+Yasno7p1CjlG18iE/Fk
         Z8hGtJkBkj6LaRCYKkHW/z5+rMIdLJFvTBm/VAdotOaQeDo8r2h55eBLvEucGX4JdQ5w
         O1izMfV5+y7hmD8/m+Q2zHZXizU19HVZftfpFvogxFMrQwizJ+I9MtXSRdg7VAv4229R
         tvETpf5wm+pfIl2BV/czmt7JvIO3Ofz50NUMgLaW3Sk9AY2OD+jiPpuVwiGbolnKMcyO
         tzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZOFX3Z+Nh1qGoQBD8/kOpxjm8rGJnIajKjvGxPffQVU=;
        b=kks0LL9wQJSX59W6LtNQLaqTaUdE4Bu+1l3M6JVyy8F3lMgZcE7V/sDu8iSljSYMfn
         zciGhjuA6qAFh9yeEUi7UvmD+XNJv6AQ3MCkJIMPA6Gxm+r++fifBlX1WbiQAHLB+uNc
         gSQmxBA2Qp8LsstJuejaytxBoIU1SYIMVj9HZp3xtY5laIoyrK7Jnop4nX33/HQH0smK
         +Dds9ajLkVSZsl3LL+cXsJANfxzqKRhbpqOvAB3L364AP1sLVmir8ca+JOfiYuYNJy4z
         lF9WfTAAHNKaBtQhJi6MwvOfUopZenHb/UGlKHVbYNNSEdyb2/yqztAFG+UNwFJcahvf
         txSg==
X-Gm-Message-State: AOAM533q3DWBXdcYVCG+bnLoPR0l0mpaIvsFM2sMBxdCoavuCce+4GhY
        NEiogxuYhWkBX6jbo+spTWs=
X-Google-Smtp-Source: ABdhPJzyjYjhesQwlSuQw6NMILKlt0zGlivLRJUCZMQWHSoKuQTNmeAt5TSvumQcvLsss7XjHGuBow==
X-Received: by 2002:a1c:7210:: with SMTP id n16mr5601345wmc.13.1615425620689;
        Wed, 10 Mar 2021 17:20:20 -0800 (PST)
Received: from localhost.localdomain ([81.18.95.223])
        by smtp.gmail.com with ESMTPSA id d85sm1199127wmd.15.2021.03.10.17.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:20:20 -0800 (PST)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: Add entries for Actions Semi Owl Ethernet MAC
Date:   Thu, 11 Mar 2021 03:20:14 +0200
Message-Id: <45c3e736093d362629ad895ab75df06b70d94b2a.1615423279.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries for Actions Semi Owl Ethernet MAC binding and driver.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e372d606c5c..b6cd438083e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1530,6 +1530,7 @@ F:	Documentation/devicetree/bindings/dma/owl-dma.yaml
 F:	Documentation/devicetree/bindings/i2c/i2c-owl.yaml
 F:	Documentation/devicetree/bindings/interrupt-controller/actions,owl-sirq.yaml
 F:	Documentation/devicetree/bindings/mmc/owl-mmc.yaml
+F:	Documentation/devicetree/bindings/net/actions,owl-emac.yaml
 F:	Documentation/devicetree/bindings/pinctrl/actions,*
 F:	Documentation/devicetree/bindings/power/actions,owl-sps.txt
 F:	Documentation/devicetree/bindings/timer/actions,owl-timer.txt
@@ -1542,6 +1543,7 @@ F:	drivers/dma/owl-dma.c
 F:	drivers/i2c/busses/i2c-owl.c
 F:	drivers/irqchip/irq-owl-sirq.c
 F:	drivers/mmc/host/owl-mmc.c
+F:	drivers/net/ethernet/actions/
 F:	drivers/pinctrl/actions/*
 F:	drivers/soc/actions/
 F:	include/dt-bindings/power/owl-*
-- 
2.30.2

