Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20136D1A34
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjCaIfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjCaIfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:35:05 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A631D873
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:55 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r29so21552441wra.13
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251695;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0V8nry5kWVC4/7uVK2TIBPivIea0+SnMt7iP0mU4Cw8=;
        b=chZXAA03Ktj6cCYt4xjrNnHn2g3CbaZsDusqs4uU9Vhv0+pAm8jD8YNmIH6rxRpV+h
         vZbIeRwPEq02v7H1BQWanP2WxcrxIeZKG+trsgqWf+VelBUfmK5t3LKEmSAqUKxTZ13L
         +G9CVycFJ35xf9hcvHQ/5mpMm4vgT5JJt3pCOGXggW1pTaO5/XGxwGfSkh0l2D4lx3xm
         CdU9FttI+BGLbTmFYxZ4WJMPU0cKt87qQLmEz7fPijrzLc+aEfpd2hBm32tMeL2yzewe
         wa8ggH+56W4skf84z3SrfyGgzpsmcwI8xPuwXPLIfYxeKh5XiRGPo7geoXtpM7Y1dKG0
         wv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251695;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0V8nry5kWVC4/7uVK2TIBPivIea0+SnMt7iP0mU4Cw8=;
        b=SF6L2wn06uF52Qkr8V543ft6osmUgUY7nBqepbFotu8nzY+Fmm4XIzQSSh5rCTJfpL
         v3L+UUC7hrZX+OtqrCj25BGWC24FCy8OBO4up1TfUz1JJvfar+6XwqxxRelaEEYRYh4X
         cYgmh9UNrpPX53S8wOX94sv7yDQroXjx/vXLYL3HVOJhy9o9XHIAx7cmlqtYfFhqfEOz
         V+7b/OherKzwTa6/7+4N1BJctaFop7776sv8hRDrgs+FPr5egsfXZIDm7fK2ljuVCAVa
         GRZee9dRqsmqNbO8ZZTtZQBdTSrlzZcyR6cZA9Sa/yevjhpk4lq5ZlcXAJRDWTZOMhfP
         N7pw==
X-Gm-Message-State: AAQBX9evU7GZ2nZiMJ4o01TuJumI38ilBVLPI98NSsq8ZGZW/s8yAml0
        /6QjimlETo5o22U9w/+z/mxL0Q==
X-Google-Smtp-Source: AKy350bhK+x7s++84IOWEFVO/gMXDRH9T/LCqh08NqEq24KOmp+VFPEpoLewHAutg0wJysva85qmrQ==
X-Received: by 2002:a5d:550c:0:b0:2d9:5608:ee0 with SMTP id b12-20020a5d550c000000b002d956080ee0mr20654106wrv.69.1680251695160;
        Fri, 31 Mar 2023 01:34:55 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:54 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:46 +0200
Subject: [PATCH RFC 08/20] dt-bindings: timer: oxsemi,rps-timer: remove
 obsolete bindings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-8-5bd58fd1dd1f@linaro.org>
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
and since no new features will ever be added upstream, remove the
OX810 and OX820 timer bindings.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/timer/oxsemi,rps-timer.txt      | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/oxsemi,rps-timer.txt b/Documentation/devicetree/bindings/timer/oxsemi,rps-timer.txt
deleted file mode 100644
index d191612539e8..000000000000
--- a/Documentation/devicetree/bindings/timer/oxsemi,rps-timer.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-Oxford Semiconductor OXNAS SoCs Family RPS Timer
-================================================
-
-Required properties:
-- compatible: Should be "oxsemi,ox810se-rps-timer" or "oxsemi,ox820-rps-timer"
-- reg : Specifies base physical address and size of the registers.
-- interrupts : The interrupts of the two timers
-- clocks : The phandle of the timer clock source
-
-example:
-
-timer0: timer@200 {
-	compatible = "oxsemi,ox810se-rps-timer";
-	reg = <0x200 0x40>;
-	clocks = <&rpsclk>;
-	interrupts = <4 5>;
-};

-- 
2.34.1

