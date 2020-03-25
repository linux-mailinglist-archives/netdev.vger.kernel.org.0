Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24F5193353
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgCYWFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:05:53 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:42329 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgCYWFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:05:49 -0400
Received: by mail-il1-f196.google.com with SMTP id f16so3470280ilj.9;
        Wed, 25 Mar 2020 15:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Ulr9pBC4SUbqUU5FsVEbaY1gpVe/0DQ9QLWI1PPgfQ=;
        b=h8lmGFQZlK5QIMgUBSRohVsWI+SzJs+RRumzyzMs4lTHl9FL+n4P1U7I/z+M/2Cc46
         xvnHGLo8n1XWvYmEZOuGa3lRxstQLgXiWfyYEiIEyLN4ybSNpLNAp9ALKqbJ5tedforT
         ZprOTWErdxUVlI7kmKreDbdtCQA+fCofh4uloll27G7t7ma6DzTmmdX8V7UHOoClVBO1
         YpC+Viz0nBDstmgAU8CaAD/XDDoEdajrfvnLm4AqehtzF+lcxYYv9UgMLuehwcGSJ4uF
         x8Pj3UBuzXGAXtropwvHDHnNifpyyPfyIR3HEw8mbYRRNwIYe4gD9X1yBgYzQQql6daT
         bn5w==
X-Gm-Message-State: ANhLgQ0mIqnH4zuwPZrs3JINLpMitAtKylmVqXrGnayRlsNHJ34P+s0w
        KYU5ujb1zUWGsePVJvfmoMsb9JU=
X-Google-Smtp-Source: ADFU+vue8Vxmky7PF9etOIHQcfy9dQqZ6AbqyS9J6TatHClhkfnl2UGT86/bcc6UGlxsmE61Cop/rw==
X-Received: by 2002:a92:6e11:: with SMTP id j17mr5689060ilc.249.1585173946547;
        Wed, 25 Mar 2020 15:05:46 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.250])
        by smtp.googlemail.com with ESMTPSA id v8sm102390ioh.40.2020.03.25.15.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 15:05:45 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhang Rui <rui.zhang@intel.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/4] dt-bindings: iio/accel: Drop duplicate adi,adxl345/6 from trivial-devices.yaml
Date:   Wed, 25 Mar 2020 16:05:38 -0600
Message-Id: <20200325220542.19189-2-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325220542.19189-1-robh@kernel.org>
References: <20200325220542.19189-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'adi,adxl345' definition is a duplicate as there's a full binding in:
Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml

The trivial-devices binding doesn't capture that 'adi,adxl346' has a
fallback compatible 'adi,adxl345', so let's add it to adi,adxl345.yaml.

Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/iio/accel/adi,adxl345.yaml     | 10 +++++++---
 Documentation/devicetree/bindings/trivial-devices.yaml |  4 ----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
index c602b6fe1c0c..d124eba1ce54 100644
--- a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
+++ b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
@@ -17,9 +17,13 @@ description: |
 
 properties:
   compatible:
-    enum:
-      - adi,adxl345
-      - adi,adxl375
+    oneOf:
+      - items:
+          - const: adi,adxl346
+          - const: adi,adxl345
+      - enum:
+          - adi,adxl345
+          - adi,adxl375
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
index 978de7d37c66..51d1f6e43c02 100644
--- a/Documentation/devicetree/bindings/trivial-devices.yaml
+++ b/Documentation/devicetree/bindings/trivial-devices.yaml
@@ -42,10 +42,6 @@ properties:
           - adi,adt7476
             # +/-1C TDM Extended Temp Range I.C
           - adi,adt7490
-            # Three-Axis Digital Accelerometer
-          - adi,adxl345
-            # Three-Axis Digital Accelerometer (backward-compatibility value "adi,adxl345" must be listed too)
-          - adi,adxl346
             # AMS iAQ-Core VOC Sensor
           - ams,iaq-core
             # i2c serial eeprom  (24cxx)
-- 
2.20.1

