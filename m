Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76083435BA
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 00:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhCUXaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCUX3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 19:29:54 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF02EC061574;
        Sun, 21 Mar 2021 16:29:53 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a7so18342146ejs.3;
        Sun, 21 Mar 2021 16:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C8KL+Iu5KpYzLhe9vn3DRMHLICcP1zJgm+G8vvGgchY=;
        b=ZXxOm2Cwbu+rZVAhrET6HFY47gORJC9JEAbGa18e09clf4vPlOEUFRGBJHz2gl4iG8
         z8oaWgySA9Ma9yO3J6WF58AuAV0jQ+Ho2EpPzTtrVQCa+W/YAOO3JvyF8posQYGOhScq
         RjE711mhyHFpX+NZCUSZkkpaziZLtt+e7WngZQR1E+uXFubAl9z92tryFrhdx3V1H1bR
         vYdTXjxDAqsmwHt2RR1jbnGY9F7Slu1EKDRA+h783fy9MCUwHCDTrJgMKGOlX+2Zt/NV
         GBtFpTLsYRmsP7/Fpkx2lfISE/0wWcOEEW3pZiX2Kop7csCdE/bk6B6snoSeOnGq9Plj
         RMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C8KL+Iu5KpYzLhe9vn3DRMHLICcP1zJgm+G8vvGgchY=;
        b=tHNu9BLUlcS+ilWEc8RJ4hDg5KSaUzLVafxBdE7N1zEVoJlVUSv6/cNbnM0eMlCD1I
         qZL8IoCpAj9DVxA0yU+fblBXxLspcHTURDPfYlrULNmw8l7bYOgJ+asMVU35G1bvfL/x
         CyrOwScjv7uhtJT4anlUSrt7HGusOn5uZZKhtwmHnAioAp1QnUMzkFCu0+iZQTScHpU7
         dqSjOUfcIaXQ0Jnr9K7UdFo4UaZyH5YRqrDvBOMjerjAHt9YIePDBhYTOXt88btGFjup
         n7qukW9qVFLFUxKdfb+qsqX6Rul40zwspETLkX0XOW+9Dhz70m/zeHuGtKjkzp1A9Q6W
         32uw==
X-Gm-Message-State: AOAM533+uwHINO3xGRZSQpJPuQKXRuje8b8kIPaWO3/rt4PqvLjIr+Wp
        VrJi+aBFZ4LY6eC75IxtRIE=
X-Google-Smtp-Source: ABdhPJwyj/tbAPxDYsDD3fNCJVdfg3Bzmh0zBGn6CVueqNP6eH0af2Y/A8U8mZhkYwRu08FFILlGlA==
X-Received: by 2002:a17:906:5495:: with SMTP id r21mr16622609ejo.471.1616369392626;
        Sun, 21 Mar 2021 16:29:52 -0700 (PDT)
Received: from localhost.localdomain ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id bt14sm9801472edb.92.2021.03.21.16.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 16:29:51 -0700 (PDT)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] MAINTAINERS: Add entries for Actions Semi Owl Ethernet MAC
Date:   Mon, 22 Mar 2021 01:29:45 +0200
Message-Id: <3ce5e128842fd132d094af33c83140be6556b0fb.1616368101.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
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
index 14d1ef97c339..f9d147e27fb0 100644
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
2.31.0

