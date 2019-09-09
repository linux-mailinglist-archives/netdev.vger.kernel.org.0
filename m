Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71349AD78D
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 13:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390964AbfIILDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 07:03:10 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:53089 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbfIILDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 07:03:09 -0400
Received: from mxback24j.mail.yandex.net (mxback24j.mail.yandex.net [IPv6:2a02:6b8:0:1619::224])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id 4BB9F4D40ED7;
        Mon,  9 Sep 2019 14:03:06 +0300 (MSK)
Received: from smtp3o.mail.yandex.net (smtp3o.mail.yandex.net [2a02:6b8:0:1a2d::27])
        by mxback24j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id QDPNu0tFIQ-352OPLFW;
        Mon, 09 Sep 2019 14:03:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudbear.ru; s=mail; t=1568026986;
        bh=65f8MmdlUBhEU7OrrZty5b1a6itd6iKs4phLGiRWv2k=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=qfzoA03QuUNd9wTQau8FJ2cOhcq7sJvKF/KwTJCGWguaivJ9ftfhPDgp/EeITcMV2
         QWgtph2Sld7QgfXy1wUsvyBeqHYw4d1PWpnwbHRpLe4RyDYIGZo5mE/639STJ1WebI
         35f+b8FkjbSXBgMv6fpQDLTc8cUAfZT/lHvcMM14=
Authentication-Results: mxback24j.mail.yandex.net; dkim=pass header.i=@cloudbear.ru
Received: by smtp3o.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id O2jPUuSQ2C-34FKGuhk;
        Mon, 09 Sep 2019 14:03:04 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
To:     davem@davemloft.net, robh+dt@kernel.org, f.fainelli@gmail.com
Cc:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Trent Piepho <tpiepho@impinj.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] net: phy: dp83867: Add documentation for SGMII mode type
Date:   Mon,  9 Sep 2019 14:02:23 +0300
Message-Id: <1568026945-3857-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568026945-3857-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
References: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1568026945-3857-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of ti,sgmii-ref-clock-output-enable
which can be used to select SGMII mode type (4 or 6-wire).

Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
---
Changes in v2:
- renamed ti,sgmii-type to ti,sgmii-ref-clock-output-enable
  and extended description

 Documentation/devicetree/bindings/net/ti,dp83867.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.txt b/Documentation/devicetree/bindings/net/ti,dp83867.txt
index db6aa3f..c98c682 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.txt
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.txt
@@ -37,6 +37,10 @@ Optional property:
 			      for applicable values.  The CLK_OUT pin can also
 			      be disabled by this property.  When omitted, the
 			      PHY's default will be left as is.
+	- ti,sgmii-ref-clock-output-enable - This denotes the fact which
+				    SGMII configuration is used (4 or 6-wire modes).
+				    Some MACs work with differential SGMII clock.
+				    See data manual for details.

 Note: ti,min-output-impedance and ti,max-output-impedance are mutually
       exclusive. When both properties are present ti,max-output-impedance
--
2.7.4

