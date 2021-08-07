Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EFF3E356D
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 15:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhHGNI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 09:08:28 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:44067 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232207AbhHGNI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 09:08:27 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id CM3WmQm3XPvRTCM3bmIfYk; Sat, 07 Aug 2021 15:08:08 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628341688; bh=h42hvfOsVcsxyMi5VYbK7VWGEQ0NFsL2rgTVmpybmxg=;
        h=From;
        b=vLOFj436iHwG4y9ulGw15LMD3n4sZmLh/QhYvFT0j/r54aKABMIwgrXpdSyVGtE4N
         BzaOzZ88bs4csZO4dnol+oTJOMAjB/f0UVEhO/wb/ZByAIBw+YHlKKDMaH3PIyqCjD
         DgjvzgxeZht+jJsopCBfG/VGyx3SQ64GvVbrHi5ne/DVGJQITKXzePravHbVLqlyj7
         1RetIaAAv1jEFLzJdbW4VTSPqGjSp6/TIr5Qd1AmCCOfAy2H7OhRi6JfciJR+jT01D
         nFGlIkMwAg+x2MQhZYyMHLlh+5ew8VhwD7nALYGpexb1olNwupW8AZC9x39XQInA61
         pk0b8y9lY+Ztg==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610e85b8 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17
 a=TSeAaTSCjiJB7GOU1roA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Tong Zhang <ztong0001@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 1/4] can: c_can: remove struct c_can_priv::priv field
Date:   Sat,  7 Aug 2021 15:07:57 +0200
Message-Id: <20210807130800.5246-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210807130800.5246-1-dariobin@libero.it>
References: <20210807130800.5246-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfFXjyjkSSREEemsSXHD6ghKK6Ear5v3Gm1j9QSAtbp+ZLi0S+dxRbwa1ixcbKnNpPW9G15s+HZxGOUSaQCbbhZ2TQURMi8QBGm6Z54yoHyPdL3QXcVNP
 BMiNJz8LTXzQtOjmHx2DGyNucM60bl0VQXUxG+aANmgHbpd+u8SoVLDRdxIRLejPEEAuQ6Dvesb6kPHJXQ1G62S0+DikujHvIa9JIBJp/au1CHnHj0GaTiYk
 u3awC2snpN5WVznLBOIl2MtJsoXQTlWmSO21ILaZAZLvgDD/YWu7/CNWj3DrET0L+X7wVyj6k3sZzENm4o0UPgVdKSLyok8ftZXN4jmTP/M6aleRo+jJok6g
 ux+9cxLLZa9C2RQpYjqhObEH0vkMkV4cbt2fWjdS0i/24rlrZFzOuTLL0aArxVpALPZ1y6rklrmYRaUInu98FhLsT1HO4kvJhc0ba5yIIATAdUh5ssJhOWtq
 isYUDbfqV4JrZ8T9GTInV8bx6nq7gWQUs5yBdplHzVH5fU5m8PUIsEykyOyKUMtdBohhlUb1gJ2nweVv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It references the clock but it is never used. So let's remove it.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

 drivers/net/can/c_can/c_can.h          | 1 -
 drivers/net/can/c_can/c_can_platform.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 4247ff80a29c..8f23e9c83c84 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -200,7 +200,6 @@ struct c_can_priv {
 	void (*write_reg32)(const struct c_can_priv *priv, enum reg index, u32 val);
 	void __iomem *base;
 	const u16 *regs;
-	void *priv;		/* for board-specific data */
 	enum c_can_dev_id type;
 	struct c_can_raminit raminit_sys;	/* RAMINIT via syscon regmap */
 	void (*raminit)(const struct c_can_priv *priv, bool enable);
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 36950363682f..86e95e9d6533 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -385,7 +385,6 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	priv->base = addr;
 	priv->device = &pdev->dev;
 	priv->can.clock.freq = clk_get_rate(clk);
-	priv->priv = clk;
 	priv->type = drvdata->id;
 
 	platform_set_drvdata(pdev, dev);
-- 
2.17.1

