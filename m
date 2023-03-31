Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01116D1A67
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjCaIhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjCaIgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:36:33 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55F01FD0A
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l12so21567654wrm.10
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251712;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lfco65EqQfHZJxTK1kxWA78ZamfCWUWZKPHL0Bp1xH4=;
        b=SqOTTD4EeiNGBszaNOzDLqviTo9jI0ZhAKSeRT3l5LeAaBvHoV1VbnUiNYxQjrF5S5
         UUujdXiQCveG/Iy+PsAnxgkKeorfMhJAmQ2J1mYgkX8eg020zgf6nL/f/EExNZqkpRUx
         XcdDXQ5bnCtHLOcSYFcdnuXeE9b+QxZG2/mH1nfNDIA7j4YtTmk1Al3zY4k3rR5puTQU
         l2NatRLdUPmY31rjFWxbQkcwmbAI5FXvErZOPP+aB0G/SM/9J1u6rMIIFKuvCVysu2q3
         VMSa4Jt860AaDpWD2pjM4fb8tv0/a2sxwe3l0seQy7PhpYace6EYCoZskI6VrPmid9Ji
         W8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251712;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lfco65EqQfHZJxTK1kxWA78ZamfCWUWZKPHL0Bp1xH4=;
        b=QWvzlKcXn94W6WJ2pQ2e2A51jalKPlGFf7mQLgzq8+ys9bPpI/LG3G3MN+N+zlfK6w
         Rserp/PyqvxpO+9CBwkYHfoqVb+RGZoCLHMmjJxaa8B9EKbbc2zlxxHgrKDxQfNQ81Vr
         fZv/04TM/FJNNVmWvafYXAuuFwGnuKjdAAIqjwBxUVZ/HmKrdN7rEPBe1XWSFFCw64u9
         SXIFfO9GmUfLiE5VezZR2E4HQhwDVyMbnQnVN0xNopThyOznS6nYutJ3Kte/szVrdutt
         Zx/jyJqp/VKOpI8uDPtP56QDpUkjCCxRaY+SxuUvRlx1KPBONFk5mCpeH3iYR1ZpLF4T
         7v2w==
X-Gm-Message-State: AAQBX9dpevnApXSWFTJL65LeyZ2qnzRu5cmrgTeae0zoC1w4VB3mvzxy
        WxnfL11Fo/1eJEBZ1PeitzoyOQ==
X-Google-Smtp-Source: AKy350YfLJVXZRDyUNg84s43q40a428Zli09J7iKvodwvFp3SatohdxhFRTG46DXiPWYNxkqIkfYZA==
X-Received: by 2002:adf:f348:0:b0:2d7:9206:488d with SMTP id e8-20020adff348000000b002d79206488dmr20315336wrp.36.1680251712356;
        Fri, 31 Mar 2023 01:35:12 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:35:11 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:58 +0200
Subject: [PATCH RFC 20/20] MAINTAINERS: remove OXNAS entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-20-5bd58fd1dd1f@linaro.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to lack of maintainance and stall of development for a few years now,
and since no new features will ever be added upstream, remove MAINTAINERS
entry for OXNAS files.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 MAINTAINERS | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d5bc223f305..c9a29d839ea2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2551,16 +2551,6 @@ S:	Maintained
 W:	http://www.digriz.org.uk/ts78xx/kernel
 F:	arch/arm/mach-orion5x/ts78xx-*
 
-ARM/OXNAS platform support
-M:	Neil Armstrong <neil.armstrong@linaro.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-L:	linux-oxnas@groups.io (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/boot/dts/ox8*.dts*
-F:	arch/arm/mach-oxnas/
-F:	drivers/power/reset/oxnas-restart.c
-N:	oxnas
-
 ARM/QUALCOMM SUPPORT
 M:	Andy Gross <agross@kernel.org>
 M:	Bjorn Andersson <andersson@kernel.org>

-- 
2.34.1

