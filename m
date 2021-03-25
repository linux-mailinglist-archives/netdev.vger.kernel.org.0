Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF22349230
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhCYMis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhCYMiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:38:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71FAC06174A;
        Thu, 25 Mar 2021 05:38:18 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so873495pjv.1;
        Thu, 25 Mar 2021 05:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C4nI1KUl9G1G9ZlgtJo82RLpSdsCwNuG0Shl5fKFntc=;
        b=WKQPqIKg4agimS56D6cDGaNG5KHvmw5XghT0krcHJhqubvq9+oda4+76HQrxpwy92M
         4tw99ydS11PAR78gmKTuQ204REhc14lAFG83mTUR3HPe5GOOhtwGrSdQfhw9luyvdJQc
         XSUz3wA5MN+mI9YuxRnx7dGZhIRfXyZXutyeK51aqtw/CoJ5fkZl7zzGNtQB7cjR/DTM
         t9QoEzlNUZZZxXRxZGklmXB1lwvT9rMi8zXXPIgn6EhQqKOC2vHPqN5//1B2C8rrG7ND
         SR3MNn4Z3ClVMy8wtgcVXRVKfXa3BUIU4G8YpY36VqCJkOjgJ0Jp+jlPopJM15AzcOax
         6zOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C4nI1KUl9G1G9ZlgtJo82RLpSdsCwNuG0Shl5fKFntc=;
        b=YzMfDB4G14sO5vnC8r+BE9nSD+HlGpzunoHL0KJS0k57StEvlexK72xY8kZdFkrkg/
         miZF4va9y52OMkkPZvSgLYd0zGiP3GreeeOXEQZeavMwMXKRQQpm72E3fobBTdbOXrni
         DqBRecD1T4isYYs/ig15BZ/nqTKAhNK9qpPGv1Djf+lx/XQCCL14I4r6/nbBMvzT8wTC
         vOapnvcSFVscbPpFD1gAO91iHR8Q1IYraOOitwe04PvWh5Q93WyL5W5T+yyOZVzmFlO4
         m9EhUbGeExH0mbdcXD3FbLtp6Sar/pVJNUgPmfR/JXpNC5giD8Bb2gS8B2Wt7o7ptSsJ
         jfbw==
X-Gm-Message-State: AOAM532qWF2DoT+k/99axGTlm0/Ot26Epa97JoCnL0ifvIfPNzj/Qri0
        eoUqbW09KJO7lzOh7kJAM4A=
X-Google-Smtp-Source: ABdhPJx6X3I/APZn6CqX4+bF0tvSe0zFJoqtbc9gKN/Ctlx3O3qlT58i3FaLe2PpV/tBAxbaMCsOew==
X-Received: by 2002:a17:90a:ab09:: with SMTP id m9mr9153049pjq.122.1616675898283;
        Thu, 25 Mar 2021 05:38:18 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id g18sm5831864pfb.178.2021.03.25.05.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:38:17 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anand Moon <linux.amoon@gmail.com>,
        linux-amlogic@lists.infradead.org
Subject: [PATCHv1 0/6] Amlogic Soc - Add missing ethernet mdio compatible string
Date:   Thu, 25 Mar 2021 12:38:04 +0000
Message-Id: <20210325123810.2624-1-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On most of the Amlogic SoC I observed that Ethernet would not get
initialize when try to deploy the mainline kernel, earlier I tried to
fix this issue with by setting ethernet reset but it did not resolve
the issue see below.
	resets = <&reset RESET_ETHERNET>;
	reset-names = "stmmaceth";

After checking what was the missing with Rockchip SoC dts
I tried to add this missing compatible string and then it
started to working on my setup.

Also I tried to fix the device tree binding to validate the changes.

Tested this on my Odroid-N2 and Odroid-C2 (64 bit) setup.
I do not have ready Odroid C1 (32 bit) setup so please somebody test.

Best Regards
-Anand

Anand Moon (6):
  dt-bindings: net: ethernet-phy: Fix the parsing of ethernet-phy
    compatible string
  arm: dts: meson: Add missing ethernet phy mdio compatible string
  arm64: dts: meson-gxbb: Add missing ethernet phy mimo compatible
    string
  arm64: dts: meson-gxl: Add missing ethernet phy mdio compatible string
  arm64: dts: meson-g12: Add missing ethernet phy mdio compatible string
  arm64: dts: meson-glx: Fix the ethernet phy mdio compatible string

 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
 arch/arm/boot/dts/meson8b-ec100.dts                     | 1 +
 arch/arm/boot/dts/meson8b-mxq.dts                       | 1 +
 arch/arm/boot/dts/meson8b-odroidc1.dts                  | 1 +
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts               | 1 +
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts          | 1 +
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi   | 3 ++-
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi        | 1 +
 arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi  | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts  | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts     | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts         | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi       | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi              | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts   | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts     | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts          | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi      | 1 +
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi       | 1 +
 26 files changed, 29 insertions(+), 5 deletions(-)

-- 
2.31.0

