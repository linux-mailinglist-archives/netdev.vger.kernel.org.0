Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9862F767
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242388AbiKROdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241824AbiKROde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:33:34 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DE017E0B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:33:32 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id k8so9595975wrh.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=r1O9HZ8MX1IL7UJAa5JH+dfK6/alNEcaVbgB3wjs4gs=;
        b=F/nX0fPsj2tPLUnIyGh9FdlQJm505Li4kv12GOJg/laM/BN4t1o7cDArjx/hBkOv/s
         lgxBXsILzg3UqegTRvrMY/g/ferTWZJj8KFHeAe6h//THsif+i74kXuNhfuaPJqK8exE
         9y6milsbhIokCYIrHGbaz1nj1kyh0MSZgbsSDAEFr5MZOCvT/UJv6yeq/5nn+Ix5zjsK
         a1LXXpOF9E3Xn45knkRZG/88aQnBk+cXFXtEpf5IWdAnEFI8wisDqHs7j02Ijs0/N+F1
         DIXH3nibBE4L2EWIZdFpN/w3XfzgOEkxsFitChKg+FNLGWp5Y6rSv4iWCqDKToriVsqN
         75qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r1O9HZ8MX1IL7UJAa5JH+dfK6/alNEcaVbgB3wjs4gs=;
        b=wj8zJsmC+gjZcQ+M0QmAAFzOMsJNyLynflddPNSSMLOAaPT3cJeAq97fjD3XRSsO/5
         3DsHjwzSEPgWMeSWfBBpFSah7xTRCbGlEK+mIZtBCD0kl2ZrCTsqVZGVOfnwDJLWt9Zz
         DG1LVyMHcz0aNmgG105b5QLV+IgflFBL9haeFsuB/aURWaFfFkTOvY0no2GJJyE9t2Q8
         Q8Z127KtjYuGDqlFYStBayAMLrFL8nwzifblFAkZUikLeejueEbgVoUv+eRcW3WZ6JEF
         SAb9gg5qoWZkuaihiBCe/XKmPm8z96ROJCP1CCGL7hJ+oXnqmPIAE9ae/cWSI+rV2vDC
         eKdQ==
X-Gm-Message-State: ANoB5pmkVBwV92GqEBHtmSUzLSya8v6YDZnk/pa6tGJUnm60df/TLC81
        eLrd+We8R88WKK68MDM5GmX11g==
X-Google-Smtp-Source: AA0mqf6XKcHEDCl9rShqtBbR8Bxs5ZkAhKbK7DnnG5j7Xa9ZYop8ey+c8nEMBxbXJS6hVwShM9KRqA==
X-Received: by 2002:a05:6000:18f:b0:241:a046:91ff with SMTP id p15-20020a056000018f00b00241a04691ffmr4433055wrx.23.1668782010856;
        Fri, 18 Nov 2022 06:33:30 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id j21-20020a05600c1c1500b003cfb7c02542sm5436726wms.11.2022.11.18.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 06:33:30 -0800 (PST)
Subject: [PATCH 00/12] dt-bindings: first batch of dt-schema conversions for Amlogic Meson bindings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-b4-tracking: H4sIALaXd2MC/w3MwQqDMAwA0F+RnBcwxenY37RNVgNdCs3mRfx3e3yXd4JLV3F4Tyd0OdS12QA9Js
 h7tCKoPAxhDoGINkwLxm9tRTMmNVYrjrnZIf2HL/kQb09ewsowhhRdMPVoeR+H/Wu9rhu2AOmCcgAA AA==
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 18 Nov 2022 15:33:26 +0100
Message-Id: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        devicetree@vger.kernel.org
X-Mailer: b4 0.10.1
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
Neil Armstrong (12):
      dt-bindings: firmware: convert meson_sm.txt to dt-schema
      dt-bindings: nvmem: convert amlogic-efuse.txt to dt-schema
      dt-bindings: nvmem: convert amlogic-meson-mx-efuse.txt to dt-schema
      dt-bindings: watchdog: convert meson-wdt.txt to dt-schema
      dt-bindings: media: convert meson-ir.txt to dt-schema
      dt-bindings: rtc: convert rtc-meson.txt to dt-schema
      dt-bindings: power: remove deprecated amlogic,meson-gx-pwrc.txt bindings
      dt-bindings: timer: convert timer/amlogic,meson7-timer.txt to dt-schema
      dt-bindings: phy: convert meson-gxl-usb2-phy.txt to dt-schema
      dt-bindings: mmc: convert amlogic,meson-gx.txt to dt-schema
      dt-bindings: pcie: convert amlogic,meson-pcie.txt to dt-schema
      dt-bindings: net: convert mdio-mux-meson-g12a.txt to dt-schema

 .../bindings/firmware/amlogic,meson-gxbb-sm.yaml   |  36 ++++++
 .../bindings/firmware/meson/meson_sm.txt           |  15 ---
 .../bindings/media/amlogic,meson6-ir.yaml          |  43 +++++++
 .../devicetree/bindings/media/meson-ir.txt         |  20 ----
 .../bindings/mmc/amlogic,meson-gx-mmc.yaml         |  78 +++++++++++++
 .../devicetree/bindings/mmc/amlogic,meson-gx.txt   |  39 -------
 .../bindings/net/amlogic,g12a-mdio-mux.yaml        |  80 +++++++++++++
 .../bindings/net/mdio-mux-meson-g12a.txt           |  48 --------
 .../bindings/nvmem/amlogic,meson-gxbb-efuse.yaml   |  52 +++++++++
 .../bindings/nvmem/amlogic,meson6-efuse.yaml       |  64 ++++++++++
 .../devicetree/bindings/nvmem/amlogic-efuse.txt    |  48 --------
 .../bindings/nvmem/amlogic-meson-mx-efuse.txt      |  22 ----
 .../devicetree/bindings/pci/amlogic,axg-pcie.yaml  | 129 +++++++++++++++++++++
 .../devicetree/bindings/pci/amlogic,meson-pcie.txt |  70 -----------
 .../bindings/phy/amlogic,meson-gxl-usb2-phy.yaml   |  56 +++++++++
 .../devicetree/bindings/phy/meson-gxl-usb2-phy.txt |  21 ----
 .../bindings/power/amlogic,meson-gx-pwrc.txt       |  63 ----------
 .../bindings/rtc/amlogic,meson6-rtc.yaml           |  62 ++++++++++
 .../devicetree/bindings/rtc/rtc-meson.txt          |  35 ------
 .../bindings/timer/amlogic,meson6-timer.txt        |  22 ----
 .../bindings/timer/amlogic,meson6-timer.yaml       |  53 +++++++++
 .../bindings/watchdog/amlogic,meson6-wdt.yaml      |  39 +++++++
 .../devicetree/bindings/watchdog/meson-wdt.txt     |  21 ----
 23 files changed, 692 insertions(+), 424 deletions(-)
---
base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
change-id: 20221117-b4-amlogic-bindings-convert-8ef1d75d426d

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>
