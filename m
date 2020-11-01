Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667582A1E74
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 15:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKAOHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 09:07:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726458AbgKAOHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 09:07:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604239660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=EQ7i+/lF3EujJ95sQqC9i7wHrofb94VFCyP+azCPi/I=;
        b=hbcEqjK5PXVBbaw1nXqNgohMOKjtWoN/M/dNwCmci8N84BrlNaZ5Tl5Wp7RmbyRsmIoreD
        UvZoyKhxgP2dV4NVWj04BBqkyN7aguSlF1GHI6eR7tQhnIA03aNQAnzLW0P9H1IouSgGFL
        oMErBbnt7Lu/KIpx3IEd2maT/I2mkRw=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-JvFBFb_kNIWRclPtj8yfGQ-1; Sun, 01 Nov 2020 09:07:39 -0500
X-MC-Unique: JvFBFb_kNIWRclPtj8yfGQ-1
Received: by mail-ot1-f71.google.com with SMTP id x18so5127806otp.5
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 06:07:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EQ7i+/lF3EujJ95sQqC9i7wHrofb94VFCyP+azCPi/I=;
        b=amfb5l6AqoUV0sXG4F7o7mEKNpEUi8h25OGWzvplRVrPKvLbr7Vy2EIDwMrPaPBzPj
         rG1cAW5zijCtJNLTHl/qKYpO8o/ogPQHjzC8yp5+wFGcYIm8Sle1F6vywmV+jo8tJKTg
         z07U3agnfGDda3/Qo+dX3GjkEP4zyZSLFmS7DpQaDjz131N2Sy9uCuN9b7Kj0zrVmHql
         konT2t8CJ2o9acgxVkMv0x2VsEAbhN5dyHPuU2XwEvcd9ty3jhAuUtOKQbsK7eAFcVuk
         Uy2FSSA2nfrSKCq+t2FIqE5VMtdVwcDZk1VEpHvKHBvj/Ti4FrGg+pXQwnM7Dc3zAOqn
         fu+Q==
X-Gm-Message-State: AOAM531QsLQnHYc0EqreiPeYzAZX7+ozFWOlu1+zPzOOmCfL+3uikRY6
        EER1XXFptFfq2cV2jdl7IJJmVzBgh8Sw74+AiH0zqXvS4njDdCMcqtZgctZT6BRNCUbKTXUzRi/
        zO1ujwxKJWXfxDyYe
X-Received: by 2002:aca:e0c3:: with SMTP id x186mr6987540oig.140.1604239658333;
        Sun, 01 Nov 2020 06:07:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzcu+/hiKh26DPEvMTbBAZGfTPVYBsLJwAAjV5P0Oa0ZdQWckM+cGghBgyRCnt32yB+IjjJCQ==
X-Received: by 2002:aca:e0c3:: with SMTP id x186mr6987526oig.140.1604239658186;
        Sun, 01 Nov 2020 06:07:38 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id i18sm2881929oik.7.2020.11.01.06.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 06:07:37 -0800 (PST)
From:   trix@redhat.com
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com,
        martin.blumenstingl@googlemail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: stmmac: dwmac-meson8b: remove unneeded semicolon
Date:   Sun,  1 Nov 2020 06:07:20 -0800
Message-Id: <20201101140720.2280013-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 5afcf05bbf9c..dc0b8b6d180d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -299,7 +299,7 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 		dev_err(dwmac->dev, "unsupported phy-mode %s\n",
 			phy_modes(dwmac->phy_mode));
 		return -EINVAL;
-	};
+	}
 
 	if (rx_dly_config & PRG_ETH0_ADJ_ENABLE) {
 		if (!dwmac->timing_adj_clk) {
-- 
2.18.1

