Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B4A21B420
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 13:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgGJLgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 07:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgGJLge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 07:36:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C564AC08E6DC;
        Fri, 10 Jul 2020 04:36:33 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594380992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6vNxszJ+QpAHIwzS32Xb3utPJ984pUYlUYs3hKg754=;
        b=cPD3yhM37oQ+oIY1/VAO6t2vS3yZF2ubOoBNZrNM/YGVwS64TGNnc8P3/7i3Lyg9AiJEfp
        dUMN3GsEj6WMezE8WNHpKOzHjlUDyBWZDO4oFV3QMbU8FZ/r1BV91VVyYcomiS2yoTWyFg
        toIP52rrzZmxNj5JIcOXllbyQUE9OIRYisW6x6ptpiyhDPqv/19/S2LBL0rM6aOP8LpcZ2
        BKhzKLS5lMDbwyqxDZLG0Q3KqcPu9NgxVMwBSp1Dpj71WAJKda7Pfrn+zLmy9a4HMrnE7p
        eGNf1msuMn5F7VD6NNMSnyxZka5ckpBj+rGtz1ar73LMuYMr9uOLRUYKgABD6Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594380992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6vNxszJ+QpAHIwzS32Xb3utPJ984pUYlUYs3hKg754=;
        b=ZYD5hezyn5HO/Vnj4gisrZ+LUxUeEyG+eka+dosoWIfu7wg+H0MlLWd/ze3E9eNZA5MQ0h
        kfsCLiN/yMi13lBQ==
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
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v1 7/8] dt-bindings: Add vendor prefix for Hirschmann
Date:   Fri, 10 Jul 2020 13:36:10 +0200
Message-Id: <20200710113611.3398-8-kurt@linutronix.de>
In-Reply-To: <20200710113611.3398-1-kurt@linutronix.de>
References: <20200710113611.3398-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

