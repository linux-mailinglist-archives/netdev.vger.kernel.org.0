Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9033B11F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhCOL34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCOL31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:29:27 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED357C06175F;
        Mon, 15 Mar 2021 04:29:26 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p8so65519541ejb.10;
        Mon, 15 Mar 2021 04:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T1+7Mrsw6CzyaM4FpYeuvBkBqhhzKEMHsKD84SMx5F0=;
        b=P2AFujM1vM46WLp5SdanFbuNp3qS1gpbU/DCBWjpEdpgm7YDc0KKCfKJIls82mbwWd
         Sf/4hR4lG6mS77k2JTH+CHaJ6Qb3W9ZJ9twrdbHc/HjaUDi6T0EYzt9ZjzcHfwfJwvkD
         3yuEemzVkpDG4JxI6RNibR/jZsbQ++CQ1Mz3pZ3qZItDUiL/jXomQe9T92AxHoSq3jU1
         or97TMFIC10kHGcJbXAf80PAD2OCK8rcV/fLrJHuXCtsBG6R0nawnWc0SJiXBFo/aPVz
         UXl2GrGM1SMzpUg1Zij6ohFfEOjoQruBxyz/lDfZZZIa5fhviS9bY2yjljfpWw061On+
         dX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T1+7Mrsw6CzyaM4FpYeuvBkBqhhzKEMHsKD84SMx5F0=;
        b=PDAUVT/+JQrPF1sD59eMdprO7zYqKL4GJZxZOG56EgyWA6sIaFvWM/PkcKmZ9ICmwh
         pXb32p/u1KcphpZ6tRIt5TzLIyaIH8eC/J6hcXeszbtkZqLrgW6f+42ODd6XYQOUOYNH
         S5cOFsqcpLF4zEovnCDz1Zbi8b3bCAOJXMeV5DCaq6agC2qe2Lzwz/QKDLrYSPTyNQqh
         OCNYhsoeO5+t/MLIUzndbs4mDv5YHLK2SQFMXGCRe5GYH0KI7Sn5Ox3Ea++Ct2R+HhRY
         0/Y7C/jDQ9Qi/6AY0SA97oWceQp0bbZI54XJWlaYKkcRT3F92lfP/oYaD6LPlg6FibnT
         BtBQ==
X-Gm-Message-State: AOAM531iCvgwxsYpaiHoXx8i0G59dBtR3YzZMoRTG2JQ9/lJu6Jh96WV
        tXwqCF2bgYOIJCQhdW15dzTyc57MIFU=
X-Google-Smtp-Source: ABdhPJy8oChfZUA18N9ho+T33JmbHrpqseT6TuO8iski30y5N6MLku7Ixbi+fRBX4MJQQpOh77ELbg==
X-Received: by 2002:a17:907:72d5:: with SMTP id du21mr23636149ejc.167.1615807765749;
        Mon, 15 Mar 2021 04:29:25 -0700 (PDT)
Received: from localhost.localdomain ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id q25sm3921423edt.51.2021.03.15.04.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:29:25 -0700 (PDT)
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
Subject: [PATCH v2 3/3] MAINTAINERS: Add entries for Actions Semi Owl Ethernet MAC
Date:   Mon, 15 Mar 2021 13:29:18 +0200
Message-Id: <219b00100eba76c33693e51a07d6d36cacc9ab2f.1615807292.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615807292.git.cristian.ciocaltea@gmail.com>
References: <cover.1615807292.git.cristian.ciocaltea@gmail.com>
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
index 411df197e4a1..20b8e37ea34c 100644
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

