Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3506612A545
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLYA57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:57:59 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37139 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfLYA56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:57:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so8283942wru.4;
        Tue, 24 Dec 2019 16:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PFmQ90ZYw4YHFMWAxeUA4KZ+OR6FSTaAbjo/3KRmum4=;
        b=GlptQvw+dENRbqNV/ZmYyeMc5Iulp2sTSNKMBKg5vCMLRijEI9Hx3VEPXiFos2QoaM
         qGGlUu6cka/RPmy43aWC/KO2BUyr6IVmb71uP+FS/BlJENgpEVw2bRW8ERlUHsPOhPq6
         1FL/jRTLeIDjfgkSdwv+b3IwbhE7XNOo7ENrwB+ytOP8t2aByTrcLeDhjS61iXJoPo/2
         ltA1Pfr8zQsYRObjB5Gq2glDrrGmaJNg4dHHyJtZ/dG7wDQVsCgcja2RlaCwN+9UNEER
         pUpOoSHw3xsn8oebebqtZljVxeKLTlHXZ7dyOa6ixLsSuoBrq3aajnuQR1iHKWAAqRJ6
         6BdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PFmQ90ZYw4YHFMWAxeUA4KZ+OR6FSTaAbjo/3KRmum4=;
        b=NZaSHMFO0ctdNBM/fKE8WfWM/RpJJjsZb2wX2RuSAOtKKUFfFIa+CTgV/160YQeO7d
         M+icVLfDKBVPcXpdq2yeiGpwegEeEg93ILqjSh3De9Wvi3jezBnluSCy8ZxAN2O9SNdh
         q+7m2R9dnjCHY1BPOEqkFA2I6eefIQrOIaHUomMAuM3N/jK4LYyuKSe8z8O2CT2ltnj8
         OGLzaexozrrcEW6U2FkZWGoOHpJG2Scbw463/mOOUo0uXIXLgM2gw8kaG6aXA1QJ5YSD
         v7/1enDflhWOvk20xWcT3T3jAstlnOFvNYzdXp6yYu1Ljq/ko7JvyirJlu9p2UmhAk+i
         sHDA==
X-Gm-Message-State: APjAAAVe7Hr/gVf5vIBlOYWC140AEA31K9FZNg6OfUIxF9A+QUtqpqjQ
        oZVCeANL4cay1ad9FSw5A5M=
X-Google-Smtp-Source: APXvYqzMRfyD3lyEw+Zb4gNepoyAdwAUCWFEyKKCzMwOT61ncy02kog+p+b5jrt9BJEzS0NQro+IIQ==
X-Received: by 2002:a5d:6390:: with SMTP id p16mr38153955wru.170.1577235476171;
        Tue, 24 Dec 2019 16:57:56 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id e18sm26034448wrw.70.2019.12.24.16.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 16:57:55 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbes-150@yandex.ru, ingrassia@epigenesys.com,
        jbrunet@baylibre.com, linus.luessing@c0d3.blue,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/3] ARM: dts: meson8m2: mxiii-plus: use the same RGMII TX delay as u-boot
Date:   Wed, 25 Dec 2019 01:56:55 +0100
Message-Id: <20191225005655.1502037-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to a bug in the MPLL2 clock setup (which is used as input for the
RGMII TX clock) a TX delay of 2ns did not work previously. With a TX
delay of 4ns Ethernet worked enough to get an IP via DHCP but there was
still high packet loss when transmitting data.

Update the TX delay to 2ns - which is the same value that u-boot and the
vendor kernel use - to fix the packet loss when transmitting data.

Fixes: 35ee52bea66c74 ("ARM: dts: meson8m2: add support for the Tronsmart MXIII Plus")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
index d54477b1001c..fd94b5cbd845 100644
--- a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
+++ b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
@@ -71,7 +71,7 @@ &ethmac {
 	phy-handle = <&eth_phy0>;
 	phy-mode = "rgmii";
 
-	amlogic,tx-delay-ns = <4>;
+	amlogic,tx-delay-ns = <2>;
 
 	mdio {
 		compatible = "snps,dwmac-mdio";
-- 
2.24.1

