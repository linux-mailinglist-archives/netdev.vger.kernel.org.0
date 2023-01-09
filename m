Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFD66625F3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjAIMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjAIMxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:53:33 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A795238D
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 04:53:31 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id ay40so6190155wmb.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 04:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ETbCko9qvHlQPPwFTCR8+/m7LxLG307onSAOdNo242Q=;
        b=Qyz1Z0LIS2Jjd0OfSqrclssV2XihZGsbKAIMXdraJ4UGqC8prh3IzWrrMraz6FKtlO
         h1+gsufUj33b4wMU/wDPXNt4nWGKA5DuS0x8K1Syb6jMnem0JN74Nkxv9ql8KNEMvFp5
         TvBvXC6Sf89Jtnb11VzSXs37YUAVOGeUHUm4pbmco0duMZDB42EaHwneYbe0p7ei0J0k
         WadqQP/xlKYM1KU9KdCkBDclMsnJc0AyLOtbHmh80W616whqVHD1xuVytTlyiPxF+l+U
         xcGo+5ELgdNp5uWfv1JAf0CZlctSd4tACHyL/yir8zYzU1hwZ+iBjzkrkGK0tw6Fa7u6
         oIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ETbCko9qvHlQPPwFTCR8+/m7LxLG307onSAOdNo242Q=;
        b=ab68MVANf6W3L7jdZP6tR0LrKAjELGkXaRhppfiVXN3855f6uB/up5+kKfzS5+fdkK
         cS12JW84AJJyXqTY3IkZVw9duc8zz4ZtQRhpsY+1Wf2UOUvMFIC99kgA4pBBxNaravxr
         VYfgFuKITEdIxQCz6ZAAyzNKZODNBgSMWt/SbUnQThyc6LB3YjpJ2MuLYyaNLKHrbA9Z
         0bGOaf8O4wZOlB4a0wM94a6wQV3UZOfB4BSE1I7XnkNIoCdVQfl+X/5Ta6jIvl8AElac
         UMyZv9bHmdotWOOpjjy1i7ckhgwPepDVvs4dwXNmjABnzthv2/WpKKyZ2ew1v5b2n3FI
         gNkA==
X-Gm-Message-State: AFqh2krbuvoQXFUAWYH0i3SJFsFFVxYmYmC5pa+kkABqWQGYX/02Zw/4
        j9PKd54Pj89XiNbSYYgD4RiiGA==
X-Google-Smtp-Source: AMrXdXtFjNw0AODLPqkFELj3Dfl8HXIbCZr81K/+a33HvQyZvXTG1A9oQwKgopu8UN2gnYr6Gscf7w==
X-Received: by 2002:a05:600c:3509:b0:3c6:e60f:3f6f with SMTP id h9-20020a05600c350900b003c6e60f3f6fmr45593896wmq.38.1673268810220;
        Mon, 09 Jan 2023 04:53:30 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id y7-20020a7bcd87000000b003d997e5e679sm12805667wmj.14.2023.01.09.04.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 04:53:29 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH v2 00/11] dt-bindings: first batch of dt-schema conversions
 for Amlogic Meson bindings
Date:   Mon, 09 Jan 2023 13:53:25 +0100
Message-Id: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEYOvGMC/42NOwrDMBAFr2JUZ4Ol+F/lHiGFfpYXlBWsHEEwv
 ntETpDqMa+YOUT2jD6LpTkE+4IZE1VQl0bYTVPwgK6yUK1SUsoRTAf6FVNACwbJIYUMNlHxvMPk
 V+nG3nVqcKIajM4eDGuyW3XQO8Z6bpj3xJ9fscg6j//kRUILt7VVfT/PZh6me0TSnK6Jg3ie5/k
 FLFBWF8wAAAA=
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Batch conversion of the following bindings:
- meson_sm.txt
- amlogic-efuse.txt
- amlogic-meson-mx-efuse.txt
- meson-wdt.txt
- meson-ir.txt
- rtc-meson.txt
- amlogic,meson6-timer.txt
- meson-gxl-usb2-phy.txt
- amlogic,meson-gx.txt
- amlogic,meson-pcie.txt
- mdio-mux-meson-g12a.txt

The amlogic,meson-gx-pwrc.txt is removed since deprecated and unused 
for a few releases now.

Martin Blumenstingl was also added as bindings maintainer for Meson6/8/8b
related bindings.

Remaining conversions:
- meson,pinctrl.txt
- pwm-meson.txt
- amlogic,meson-gpio-intc.txt
- amlogic,meson-mx-sdio.txt
- rtc-meson-vrtc.txt
- amlogic,axg-sound-card.txt
- amlogic,axg-fifo.txt
- amlogic,axg-pdm.txt
- amlogic,axg-spdifout.txt
- amlogic,axg-tdm-formatters.txt
- amlogic,axg-spdifin.txt
- amlogic,axg-tdm-iface.txt
- amlogic,g12a-tohdmitx.txt
- amlogic,axg-audio-clkc.txt
- amlogic,gxbb-clkc.txt
- amlogic,gxbb-aoclkc.txt
- amlogic,meson8b-clkc.txt

To: Rob Herring <robh+dt@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
To: Kevin Hilman <khilman@baylibre.com>
To: Jerome Brunet <jbrunet@baylibre.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Wim Van Sebroeck <wim@linux-watchdog.org>
To: Guenter Roeck <linux@roeck-us.net>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>
To: Alexandre Belloni <alexandre.belloni@bootlin.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Vinod Koul <vkoul@kernel.org>
To: Kishon Vijay Abraham I <kishon@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
To: Bjorn Helgaas <bhelgaas@google.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
To: Heiner Kallweit <hkallweit1@gmail.com>
To: Russell King <linux@armlinux.org.uk>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-amlogic@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
Cc: linux-phy@lists.infradead.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>

---
Changes in v2:
- rebased on v6.2-rc1
- patch 1: fixed power-controller, added const: amlogic,meson-gx-sm
- patch 2: added const: amlogic,meson-gx-efuse, fixed secure-monitor type
- patch 3: updated example subnodes to match reality
- patch 4: added reviewed-by, added interrupts, added const: amlogic,meson8m2-wdt
- patch 5: added reviewed-by, added const: amlogic,meson-gx-ir
- patch 6: dropped applied
- patch 7: dropped patch, replaced with deprecated in the title of the TXt bindings
- patch 8: fixed title, added reviewed-by, added interrupt description
- patch 9: fixed example indent, added reviewed-by
- patch 10: fixed const: amlogic,meson-gx-mmc case, fixed indentation
- patch 11: added reviewed-by, fixed title, fixed bindings after rebase, added clocks/clock-names as required
- patch 12: added reviewed-by
- Link to v1: https://lore.kernel.org/r/20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org

---
Neil Armstrong (11):
      dt-bindings: firmware: convert meson_sm.txt to dt-schema
      dt-bindings: nvmem: convert amlogic-efuse.txt to dt-schema
      dt-bindings: nvmem: convert amlogic-meson-mx-efuse.txt to dt-schema
      dt-bindings: watchdog: convert meson-wdt.txt to dt-schema
      dt-bindings: media: convert meson-ir.txt to dt-schema
      dt-bindings: power: amlogic,meson-gx-pwrc: mark bindings as deprecated
      dt-bindings: timer: convert timer/amlogic,meson6-timer.txt to dt-schema
      dt-bindings: phy: convert meson-gxl-usb2-phy.txt to dt-schema
      dt-bindings: mmc: convert amlogic,meson-gx.txt to dt-schema
      dt-bindings: PCI: convert amlogic,meson-pcie.txt to dt-schema
      dt-bindings: net: convert mdio-mux-meson-g12a.txt to dt-schema

 .../bindings/firmware/amlogic,meson-gxbb-sm.yaml   |  39 ++++++
 .../bindings/firmware/meson/meson_sm.txt           |  15 ---
 .../bindings/media/amlogic,meson6-ir.yaml          |  47 ++++++++
 .../devicetree/bindings/media/meson-ir.txt         |  20 ---
 .../bindings/mmc/amlogic,meson-gx-mmc.yaml         |  75 ++++++++++++
 .../devicetree/bindings/mmc/amlogic,meson-gx.txt   |  39 ------
 .../bindings/net/amlogic,g12a-mdio-mux.yaml        |  80 ++++++++++++
 .../bindings/net/mdio-mux-meson-g12a.txt           |  48 --------
 .../bindings/nvmem/amlogic,meson-gxbb-efuse.yaml   |  57 +++++++++
 .../bindings/nvmem/amlogic,meson6-efuse.yaml       |  60 +++++++++
 .../devicetree/bindings/nvmem/amlogic-efuse.txt    |  48 --------
 .../bindings/nvmem/amlogic-meson-mx-efuse.txt      |  22 ----
 .../devicetree/bindings/pci/amlogic,axg-pcie.yaml  | 134 +++++++++++++++++++++
 .../devicetree/bindings/pci/amlogic,meson-pcie.txt |  70 -----------
 .../bindings/phy/amlogic,meson-gxl-usb2-phy.yaml   |  56 +++++++++
 .../devicetree/bindings/phy/meson-gxl-usb2-phy.txt |  21 ----
 .../bindings/power/amlogic,meson-gx-pwrc.txt       |   4 +-
 .../bindings/timer/amlogic,meson6-timer.txt        |  22 ----
 .../bindings/timer/amlogic,meson6-timer.yaml       |  54 +++++++++
 .../bindings/watchdog/amlogic,meson6-wdt.yaml      |  50 ++++++++
 .../devicetree/bindings/watchdog/meson-wdt.txt     |  21 ----
 21 files changed, 654 insertions(+), 328 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20221117-b4-amlogic-bindings-convert-8ef1d75d426d

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>
