Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57350AA913
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbfIEQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:33:59 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:48784 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387514AbfIEQd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 12:33:59 -0400
Received: from mxback16j.mail.yandex.net (mxback16j.mail.yandex.net [IPv6:2a02:6b8:0:1619::92])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id 5F81D4D4116C;
        Thu,  5 Sep 2019 19:26:36 +0300 (MSK)
Received: from smtp1j.mail.yandex.net (smtp1j.mail.yandex.net [2a02:6b8:0:801::ab])
        by mxback16j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id ukY2D8Egdj-QZhOW1bl;
        Thu, 05 Sep 2019 19:26:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudbear.ru; s=mail; t=1567700796;
        bh=hOkCN7931vzjt0l3Tqx48TfioEIidz03weA0TYCaeLY=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=FX6x16BP0+aTF2FOvU3gWtNNrEBC+jlU0R/kyvMsmiivbOBwlI1+6oWTar3yNcDqH
         BM0AmdeTHpgRD2HdD9u6CpwUNKPpHkIaAg4fXqgWv1BhoRE3KJkpPA8zzd1iXxDMNy
         V1lQn1v7knTCbZVrq82yp67G0+hcTkDaqElaIsQs=
Authentication-Results: mxback16j.mail.yandex.net; dkim=pass header.i=@cloudbear.ru
Received: by smtp1j.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id ymy8epsrG0-QYQqHnll;
        Thu, 05 Sep 2019 19:26:35 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
To:     davem@davemloft.net, robh+dt@kernel.org, f.fainelli@gmail.com
Cc:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>,
        Mark Rutland <mark.rutland@arm.com>,
        Trent Piepho <tpiepho@impinj.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode type
Date:   Thu,  5 Sep 2019 19:26:00 +0300
Message-Id: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
References: <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of ti,sgmii-type which can be used to select
SGMII mode type (4 or 6-wire).

Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
---
 Documentation/devicetree/bindings/net/ti,dp83867.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.txt b/Documentation/devicetree/bindings/net/ti,dp83867.txt
index db6aa3f2215b..18e7fd52897f 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.txt
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.txt
@@ -37,6 +37,7 @@ Optional property:
 			      for applicable values.  The CLK_OUT pin can also
 			      be disabled by this property.  When omitted, the
 			      PHY's default will be left as is.
+	- ti,sgmii-type - This denotes the fact which SGMII mode is used (4 or 6-wire).
 
 Note: ti,min-output-impedance and ti,max-output-impedance are mutually
       exclusive. When both properties are present ti,max-output-impedance
-- 
2.16.4

