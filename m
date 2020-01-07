Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B191D132988
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgAGPDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:03:13 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50337 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgAGPDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:03:13 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so9134289pjb.0;
        Tue, 07 Jan 2020 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7Vp5Vy5j9yM6zzEKiWqAsDsmN6F0gjsulGDFzYzW5ms=;
        b=FRdc/pEtLxybKATPi0gWX2OnrpPVH/gGawy/tcqojjMjvopFGGM068hu4YFt3qmt8A
         6R5y0yJvntjkO8rsWhyzfx23MOZxhzl/6e8Z+UKVVBc1Gihd/WO9l45YcNrgpYi9rKXD
         tWIIDANUvg28Kn7rZ9lTElzHP9SNKUJwcKPS6+aZR3KuKyMWVSR3aJ2aGRsUgKXN+aRD
         hUqAoVldM0Wyh88gr372bKNGydSXKln+wJOHPMUw8udR26H1B/JSx3TpR0H+RTBJJfYV
         huQgd0dDZJWNtdUEMbumFGCV7R864/LXirQdWi2VM5u/CpZOL4tJmLKL4i+gsWM2v2qk
         /wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7Vp5Vy5j9yM6zzEKiWqAsDsmN6F0gjsulGDFzYzW5ms=;
        b=BQgaBnYb372ibzhYZNO5JT0EmwzYVAMBxKhLMHnQBEUNwSsyGw4895KNoXPu3kTkUP
         +OH5T+6Jk/sZ5YeNpQDrdSp1ZUJ9OxB9FoM6yY+8RrnHkYiSH4b/0Xwv0Vr9uFS7nxe8
         KKam3q10BxwV6QFS4A+JryiWb+2GLzizpwjClLTGUw/Yhzj9fPspGdXfS/0RsY5kMTMo
         zxVUmC0qxfUHs2Gt5tgf/SgH1r1aN2T251PpFO45LXMdwDdHa/L6KQNOceLyvaL4znDq
         jsSSaLMOhivGx4M0TFmPZ0/FP9avpC1GhjvWv+kO2mBdEh2XqAbgW8C5ffYc4+K3dSmC
         nhew==
X-Gm-Message-State: APjAAAVPTiN5m2ZWBR/sAAbii41lgjJgqnUz4jOlaJziZwmUlEBbqC0N
        H4u5543H1sStMj+0JThIHNw=
X-Google-Smtp-Source: APXvYqzftM+e7fYt4IHv4fHcbdCZwaijynpYGwn5PKAuo5WlUzUl87fCknMZfMefV1A2363vPvEgwQ==
X-Received: by 2002:a17:902:654d:: with SMTP id d13mr33352pln.187.1578409392867;
        Tue, 07 Jan 2020 07:03:12 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id h3sm35881215pfo.132.2020.01.07.07.03.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 07:03:12 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     davem@davemloft.net, corbet@lwn.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, linus.walleij@linaro.org
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH] Documentation: networking: device drivers: sync stmmac_mdio_bus_data info
Date:   Tue,  7 Jan 2020 23:02:54 +0800
Message-Id: <20200107150254.28604-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes in the stmmac driver, it removes the phy_reset hook
from struct stmmac_mdio_bus_data by commit <fead5b1b5838ba2>, and
add the member of needs_reset to struct stmmac_mdio_bus_data by
commit <1a981c0586c0387>.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 Documentation/networking/device_drivers/stmicro/stmmac.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/stmicro/stmmac.txt b/Documentation/networking/device_drivers/stmicro/stmmac.txt
index 1ae979fd90d2..3d8a83158309 100644
--- a/Documentation/networking/device_drivers/stmicro/stmmac.txt
+++ b/Documentation/networking/device_drivers/stmicro/stmmac.txt
@@ -190,17 +190,17 @@ Where:
 For MDIO bus The we have:
 
  struct stmmac_mdio_bus_data {
-	int (*phy_reset)(void *priv);
 	unsigned int phy_mask;
 	int *irqs;
 	int probed_phy_irq;
+	bool needs_reset;
  };
 
 Where:
- o phy_reset: hook to reset the phy device attached to the bus.
  o phy_mask: phy mask passed when register the MDIO bus within the driver.
  o irqs: list of IRQs, one per PHY.
  o probed_phy_irq: if irqs is NULL, use this for probed PHY.
+ o needs_reset: make MDIO bus reset optional.
 
 For DMA engine we have the following internal fields that should be
 tuned according to the HW capabilities.
-- 
2.17.1

