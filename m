Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975734CF6A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732092AbfFTNrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:47:55 -0400
Received: from vps.xff.cz ([195.181.215.36]:36198 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfFTNry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 09:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1561038473; bh=1WLK5mVFKFuv1g4gs40+VCmjvdPbojsyFq5tU/7xRNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svueeyeboGX9r7VcaCtB9qn8TWZCNBYJyBCgsuZcn5ttxs0cqtSZkKZpwQAaTpZRv
         g3wM6EY4kBdAXwWTSsKCjYQncRqQ5amzABcvfxGYM/SoUvYhw/0al+x6t3TVv2n4Qx
         sJinn6G3EW0MiPrGlke0PEtPbwLEMTPTcU8fn4EE=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     Ondrej Jirman <megous@megous.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v7 4/6] dt-bindings: display: hdmi-connector: Support DDC bus enable
Date:   Thu, 20 Jun 2019 15:47:46 +0200
Message-Id: <20190620134748.17866-5-megous@megous.com>
In-Reply-To: <20190620134748.17866-1-megous@megous.com>
References: <20190620134748.17866-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Some Allwinner SoC using boards (Orange Pi 3 for example) need to enable
on-board voltage shifting logic for the DDC bus using a gpio to be able
to access DDC bus. Use ddc-en-gpios property on the hdmi-connector to
model this.

Add binding documentation for optional ddc-en-gpios property.

Signed-off-by: Ondrej Jirman <megous@megous.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/display/connector/hdmi-connector.txt     | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt b/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt
index 508aee461e0d..aeb07c4bd703 100644
--- a/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt
+++ b/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt
@@ -9,6 +9,7 @@ Optional properties:
 - label: a symbolic name for the connector
 - hpd-gpios: HPD GPIO number
 - ddc-i2c-bus: phandle link to the I2C controller used for DDC EDID probing
+- ddc-en-gpios: signal to enable DDC bus
 
 Required nodes:
 - Video port for HDMI input
-- 
2.22.0

