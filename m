Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C9E20B119
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgFZMFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 08:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728080AbgFZMFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 08:05:38 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D364BC08C5DB;
        Fri, 26 Jun 2020 05:05:37 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so9138753eje.1;
        Fri, 26 Jun 2020 05:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nR2VtgwF7F9W5HFmQx6MyGh5iwe4EvSvTxPQrcM2OfA=;
        b=QfLAPtlSom2vjh/UgG3x+Z9xdz8P8W5cPtskt7nvEXO6gtIvbXVuLLkzagDi4PjsFa
         StIMhc182BACUjaLImZVGhSOkurSTQ98vBP7h4q1W5nlAhyYkIridmDDZG/pkyVc1prf
         7bpm0EvCuk5ZiZy2j5yJDpNkjsieQ0oUyghQz+PNNopk9kkt1kzUej63Fr8zHmvhuuMt
         tef0eCnPojyQd7q18LDo8A6+yDLWnXOkxq6nbKBzXn6NRpq3bJOhWd86hRB7zqbZIvBx
         M/UsF0HLUAGp29/fZNb4BwXADD/Vv1I9QyZ6gzFApQUoYhKs3zHZHS9T+KV4ZUg9rEef
         IK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nR2VtgwF7F9W5HFmQx6MyGh5iwe4EvSvTxPQrcM2OfA=;
        b=uUjexY9dbXHdcOW7o8yekC/zWPvBv0Nm5jFnoloCcnpiXikviYr8fgmCQYB9c8miBZ
         lPUunSOScdzlIms44CXQsvbib7aGzL/URLEVi74yPe7N49jA/fbnCxh/AHlRO2qBxSuE
         Dt0UcPT5+JWHXhylq7K1Ab8NRxK5gJIE0vYsAsNV+/YuZESQdRtVEx7BV166gfYjeK9Q
         b3BNz2FUXVQz33RYVYlBgCk6nJn61RLmpjfNnK6LXYKzeVcOsc1lmIzkjjd2LGEq1D8c
         vk/DKzyGNTZcoXrmtGosn/Mq+8fkL7S7h7ZYGQcGDSd7Pw06llE+mHdls7vp6whVbvmA
         T3nQ==
X-Gm-Message-State: AOAM533mRTIVADveeDzlJgVPyYDQFq2X+floIwfmiFcx3VmJhqzA2Y3r
        eYEY7AmewNx+bIxte6B6XWc=
X-Google-Smtp-Source: ABdhPJwZ8M1BQ2yH0DeD+1br27YkhVt9aUJrcA1oAtfzVrHHpr0ijzgJNJUutvTNYuggWpiGff/Gbg==
X-Received: by 2002:a17:906:7247:: with SMTP id n7mr2244351ejk.105.1593173136604;
        Fri, 26 Jun 2020 05:05:36 -0700 (PDT)
Received: from debian.home (ip51ccf9cd.speed.planet.nl. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id l27sm5024153ejk.25.2020.06.26.05.05.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 05:05:36 -0700 (PDT)
From:   Johan Jonker <jbx6244@gmail.com>
To:     peppe.cavallaro@st.com
Cc:     alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, heiko@sntech.de,
        linux-rockchip@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: stmmac: add Rockchip as supported platform in STMMAC_PLATFORM help text
Date:   Fri, 26 Jun 2020 14:05:27 +0200
Message-Id: <20200626120527.10562-2-jbx6244@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200626120527.10562-1-jbx6244@gmail.com>
References: <20200626120527.10562-1-jbx6244@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Kconfig menu has an option for DWMAC_ROCKCHIP.
Then add Rockchip also as supported platform in the help text
of STMMAC_PLATFORM.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 8f7625cc8..8309e05b4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -33,7 +33,7 @@ config STMMAC_PLATFORM
 	---help---
 	  This selects the platform specific bus support for the stmmac driver.
 	  This is the driver used on several SoCs:
-	  STi, Allwinner, Amlogic Meson, Altera SOCFPGA.
+	  STi, Allwinner, Amlogic Meson, Altera SOCFPGA, Rockchip.
 
 	  If you have a controller with this interface, say Y or M here.
 
-- 
2.11.0

