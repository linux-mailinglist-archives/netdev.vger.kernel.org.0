Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9111FEB90
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFRGkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgFRGks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:40:48 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A3C061755;
        Wed, 17 Jun 2020 23:40:48 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=localhost.localdomain)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jloE8-0000xD-Jh; Thu, 18 Jun 2020 08:40:44 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 8/9] dt-bindings: Add vendor prefix for Hirschmann
Date:   Thu, 18 Jun 2020 08:40:28 +0200
Message-Id: <20200618064029.32168-9-kurt@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200618064029.32168-1-kurt@linutronix.de>
References: <20200618064029.32168-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hirschmann is building devices for automation and networking. Add them to the
vendor prefixes.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 9aeab66be85f..279a10418ce8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -429,6 +429,8 @@ patternProperties:
     description: HiDeep Inc.
   "^himax,.*":
     description: Himax Technologies, Inc.
+  "^hirschmann,.*":
+    description: Hirschmann Automation and Control GmbH
   "^hisilicon,.*":
     description: Hisilicon Limited.
   "^hit,.*":
-- 
2.20.1

