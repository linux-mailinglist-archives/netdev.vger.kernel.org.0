Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10800258EB2
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgIAMyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:54:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40188 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgIAMuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:50:39 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598964634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXzLlkZeBJwPbRey6cA9ZGk3BHqbfpKavXh18Vgz7Ls=;
        b=k0bsQBLrhXOoQrgz148QKpPp4AVPjwePblpgLwiBplkqgsjUbV+7ssUeIWHH/MlzLpU+AG
        BOaCcfamKrgaYK47s3braLBz4Y85QVe1m+TYoj83mkj3TzRNLt/XmClp0rxF3tV/xv/MDw
        nGI4L4gXxx8DUypD0nLA2G7coYTXi4iWHjnSrZK1FHb84ycqxtBR9xBmJ5B0pZxveNTCJC
        hXQU8tiXBxD6xXDBv+yKW3CkBoShHDwvQj3PPigFiDll0pA1Zl1myJK34r9AxfpkgFI5zJ
        xW5N6bzX0Tzx59OE+zogpCzc3ERFDsH+76YBSKOtUh1eYUGLxfY8zqg43Tkylw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598964634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXzLlkZeBJwPbRey6cA9ZGk3BHqbfpKavXh18Vgz7Ls=;
        b=3KJxfcnR9c4JcwGRv5hrP0HN4NkqvWDLy6xqZQnqf631y+F4Wyh9qplQIzwhz4nbtMjGmg
        tO/m3j9f8LvBQNCg==
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
Subject: [PATCH v4 6/7] dt-bindings: Add vendor prefix for Hirschmann
Date:   Tue,  1 Sep 2020 14:50:13 +0200
Message-Id: <20200901125014.17801-7-kurt@linutronix.de>
In-Reply-To: <20200901125014.17801-1-kurt@linutronix.de>
References: <20200901125014.17801-1-kurt@linutronix.de>
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

