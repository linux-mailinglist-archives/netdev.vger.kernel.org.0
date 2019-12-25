Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF68112A548
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfLYA55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:57:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51832 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfLYA55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:57:57 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so3406223wmd.1;
        Tue, 24 Dec 2019 16:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7xaUferG7HAWecpJcxnOnz4oYDhKhjdfLvmFfZUZQK4=;
        b=L9vNQNnFaEGspbC0QRsDefYP16CFmPV+JMq+na4k4pspEeksqZ23LFmXN8OMUcLHQf
         4V2zoD0aHmMa5Fxyq+l20LTxCyj7UQrngOEpBQOGjF+Ju/BDuC2+brkHGTFLdZLWg+sc
         84YoXz2IPAuNIfwTiYf5jRBC67lV3HhdA1fNVptfaLPj0pnIbzQO1+Y3gwUDUUj2WFam
         yKXJD62lgd+ZwOLkz/zprhAzMXH6wg76NK9adOEENRUQ61w/i2K9uhUBc0EP0t9dA+gt
         DdnyKCsutNax4YBT5nGJc7hxLh1Oc8iwHVz3RDYOH+tdSa3ZAPB98RXT8I+M6pbWdM3v
         Bt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7xaUferG7HAWecpJcxnOnz4oYDhKhjdfLvmFfZUZQK4=;
        b=M8SCXEHdGk06dHv7PnjImitwMPPfRL0/iOZF9OxWWXi/IOCLMu0FhDYq8+pD4Lpey7
         5ArNNaJOIqzB4JXcT1+7P3U06mzOrsoCr3k5iyfRiXzTulcy3EahflL7YSVBRkJed89r
         96IyezR71JGSfftArmBHa3n28hrPJjtl4OiNQZPvEQDV6QGzDWkP9XdQnnp4P8G4vyWO
         AqbbrvzN/FULYR96Fo3wzRhugxL43nvEflBC6+lFjz9QXyiPAxrxFrA0mof4vWd7dqTg
         qwTzEH9ivClmDBRgFQvcfuy+pnCZ+ZkL27uqMrBYQx4TKdV2+s2OQHpEy29M0CtWws48
         csNg==
X-Gm-Message-State: APjAAAU54DxG5R4XQQcGboBQmrYTCejRvgNgUpvj8KyvxRAxlqXxZjB6
        ydfjj0kQLrUzqI73+Mpuhjw=
X-Google-Smtp-Source: APXvYqzE+4J+EBv4z0CzgDiPxQWZzZ7eL1fSoI4TT/crUG7n8l3YetIiwu2KCeBd2ZY+CHgYsCrjUA==
X-Received: by 2002:a1c:f003:: with SMTP id a3mr5946155wmb.41.1577235475292;
        Tue, 24 Dec 2019 16:57:55 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id e18sm26034448wrw.70.2019.12.24.16.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 16:57:54 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbes-150@yandex.ru, ingrassia@epigenesys.com,
        jbrunet@baylibre.com, linus.luessing@c0d3.blue,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/3] ARM: dts: meson8b: odroidc1: use the same RGMII TX delay as u-boot
Date:   Wed, 25 Dec 2019 01:56:54 +0100
Message-Id: <20191225005655.1502037-3-martin.blumenstingl@googlemail.com>
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

Fixes: 9c15795a4f96cb ("ARM: dts: meson8b-odroidc1: ethernet support")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm/boot/dts/meson8b-odroidc1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index a2a47804fc4a..e2ba2d66d8d9 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -204,7 +204,7 @@ &ethmac {
 
 	phy-mode = "rgmii";
 	phy-handle = <&eth_phy>;
-	amlogic,tx-delay-ns = <4>;
+	amlogic,tx-delay-ns = <2>;
 
 	nvmem-cells = <&ethernet_mac_address>;
 	nvmem-cell-names = "mac-address";
-- 
2.24.1

