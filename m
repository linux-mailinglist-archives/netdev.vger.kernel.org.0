Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24FA25D159
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgIDG3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbgIDG2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:28:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F2BC06124F;
        Thu,  3 Sep 2020 23:28:08 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599200886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXzLlkZeBJwPbRey6cA9ZGk3BHqbfpKavXh18Vgz7Ls=;
        b=CLQ2rlr2kkWgk1jRWpZZDfQr86uauJTtAJvXwyNSZ5Kbom2P5uohogANMbOLE9O/XXQo7q
        q2vh9VhUdQdjf3zYDGrRlyoh1jtg8Oww4Ty1aKoXlV1oQi2rXDKWaJFmyp57c+wLumG3tQ
        7/d/6gtG/YaXKKmUhTm0AnI21cgw0sByjx0u6yzlCWzKrbWY9KoM1O6GV19hT4IvE/9iml
        Q4x//aFBzPqDHk9bHHijNqGflN+A65OThm0OxJrz2Gu4qmFSng1ShVm3AICQGhmBHvmyO8
        ubiEr9R8S2WBGNflC63eIkRfHk4d7oWxOmxOc2YFmmy+bLxG89o2Evsk2JoPFQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599200886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXzLlkZeBJwPbRey6cA9ZGk3BHqbfpKavXh18Vgz7Ls=;
        b=s26PYP0Y7bFCUHJAU8WtUT+eaUPNAOrXHTMp3V2Fzw6cWIeL2APU/wlDZ1qITcFkerlfyX
        kMvG/46OYTWExFDQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 6/7] dt-bindings: Add vendor prefix for Hirschmann
Date:   Fri,  4 Sep 2020 08:27:38 +0200
Message-Id: <20200904062739.3540-7-kurt@linutronix.de>
In-Reply-To: <20200904062739.3540-1-kurt@linutronix.de>
References: <20200904062739.3540-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hirschmann is building devices for automation and networking. Add them to the
vendor prefixes.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 63996ab03521..6c4268b585cd 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -433,6 +433,8 @@ patternProperties:
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

