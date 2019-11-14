Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3D7FC4F8
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfKNLDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:03:02 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41462 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKNLDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:03:01 -0500
Received: by mail-lf1-f67.google.com with SMTP id j14so4673098lfb.8
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 03:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U/A2f9kHIFOCYbqEWyI5d4hToF+Uq4/YnGy8bo4uWSk=;
        b=SAME1HQB5rY5pUNyNZsdPmdctskGsxNP86PGXuOQvqwHZitiEqwgM65CFboMlUfOo7
         Gze5msi1z8T9q8JRe5/BrQDm8YBynytpYR6QM5e8fYB/UknphcTyNeBUHn54xd8JiffI
         yHJWSOWGah1xzsTPJCxnZENQecaEXAsjxr/pk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/A2f9kHIFOCYbqEWyI5d4hToF+Uq4/YnGy8bo4uWSk=;
        b=Dq9sAdw+vIfIjCTDzxuCLzXOHIyZteTrSXgT42m+lG2/JxTfemJTVIPn6vlvJF+/0k
         ZbbX500zlfik1oINhtaoVfaGD7PpmKMD7xbglWCZCkJmLkiSBdN8tXxcqRFgpCh22Omq
         sIWkMG474M2W4Ey7Il/Qb18la4NfJn/RIHBytPn9GsuLpH9WCXSin2b7rHQv4Vf3f/tu
         WMlRsZ9J1E6Ohdh+SrDARrG4Sf7S9nBRNcO+MMAH85GX1E6CQGxQgtvtDa467Cqhz/hi
         jQylVd2OrBX/CLLQ1L2KfX0SAw7T/gdOU4TZ+EGhNJsIt9/3du6LKbuhK0EnT4pkX2fq
         yCew==
X-Gm-Message-State: APjAAAXbozMGijv6g0TCWskbJZ3TxVpebTJneQY3zajxEkPu8x6fi/rw
        DgvF5EnF1rAvCebZFPkJg3aVBA==
X-Google-Smtp-Source: APXvYqzB4yFz8S9GHrqN6tQYSP0UPmZB/NTgSy3LzN9JkcH/Eac/vwCv+RlwvWV4nerw2f/zHfGdvA==
X-Received: by 2002:a19:ee17:: with SMTP id g23mr6353744lfb.121.1573729378062;
        Thu, 14 Nov 2019 03:02:58 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id x5sm2498795lfg.71.2019.11.14.03.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 03:02:57 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Marc Zyngier <maz@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ARM: dts: ls1021a: add node describing external interrupt lines
Date:   Thu, 14 Nov 2019 12:02:52 +0100
Message-Id: <20191114110254.32171-2-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
References: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a node describing the six external interrupt lines IRQ0-IRQ5
with configurable polarity.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/arm/boot/dts/ls1021a.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index 2f6977ada447..0855b1fe98e0 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -216,6 +216,25 @@
 			compatible = "fsl,ls1021a-scfg", "syscon";
 			reg = <0x0 0x1570000 0x0 0x10000>;
 			big-endian;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x0 0x0 0x1570000 0x10000>;
+
+			extirq: interrupt-controller@1ac {
+				compatible = "fsl,ls1021a-extirq";
+				#interrupt-cells = <2>;
+				#address-cells = <0>;
+				interrupt-controller;
+				reg = <0x1ac 4>;
+				interrupt-map =
+					<0 0 &gic GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
+					<1 0 &gic GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>,
+					<2 0 &gic GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>,
+					<3 0 &gic GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>,
+					<4 0 &gic GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+					<5 0 &gic GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-map-mask = <0xffffffff 0x0>;
+			};
 		};
 
 		crypto: crypto@1700000 {
-- 
2.23.0

