Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB8CADD86
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 18:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389573AbfIIQwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 12:52:34 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:58375 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727080AbfIIQwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 12:52:33 -0400
Received: from mxback4g.mail.yandex.net (mxback4g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:165])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 1C5174B015F8;
        Mon,  9 Sep 2019 19:52:31 +0300 (MSK)
Received: from smtp2o.mail.yandex.net (smtp2o.mail.yandex.net [2a02:6b8:0:1a2d::26])
        by mxback4g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id oM1oYNrmyg-qU5u3J0b;
        Mon, 09 Sep 2019 19:52:31 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudbear.ru; s=mail; t=1568047951;
        bh=KyooAfPzqTmxKJgNA2NBDyBr061KuY9gP3JsRYaq9xw=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=bcUcTNhLskbI+fEHw7gZP/ZYznY2pRgrR8Z8AsHlCDPMDb8R7b13Ih/ls0AAz9g2h
         ukZfh64a6bbaXPSRyrmk6AKjVFYwm5Cc5xCnby5vY1f08HB6JAZ1XtH1i+ItMe1/ln
         Cq264VZUo7QHz3HtvXvmqyd/UpP2xjv5M3Yx7h4s=
Authentication-Results: mxback4g.mail.yandex.net; dkim=pass header.i=@cloudbear.ru
Received: by smtp2o.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id aUn2Pn2Gxb-qTtCYulI;
        Mon, 09 Sep 2019 19:52:29 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
To:     davem@davemloft.net, robh+dt@kernel.org, f.fainelli@gmail.com
Cc:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>,
        Mark Rutland <mark.rutland@arm.com>,
        Trent Piepho <tpiepho@impinj.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] net: phy: dp83867: Add documentation for SGMII mode type
Date:   Mon,  9 Sep 2019 19:52:19 +0300
Message-Id: <1568047940-14490-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568047940-14490-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
References: <1568026945-3857-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1568047940-14490-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of ti,sgmii-ref-clock-output-enable
which can be used to select SGMII mode type (4 or 6-wire).

Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
---
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

