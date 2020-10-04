Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF74282A76
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 13:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgJDLa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 07:30:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52764 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgJDLaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 07:30:22 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601811020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXzLlkZeBJwPbRey6cA9ZGk3BHqbfpKavXh18Vgz7Ls=;
        b=OmqRpUpH40QqQcNtiMFWhXhh2UbRSX0WOakhn2jskSyMDr3P97G2f7p/yw3dpzJiNOf+Ey
        jyQA2XyX+78zGaZNWvMnr9h56A5/6y1fjqPEYjg04ifvs9P6w4exPM2hfRiY/EAM1nUfC7
        ebgCqhXB0IH7rr2vwpNUBFEZpI3VAWphOvmb8QMxkl1nN/eb9uNAPGt5HInkps/PfAinXH
        7jUSvGyxzXFdS0d3N8sMoFqWzK18TrUbYszaaXmnL6fnWEkbBD6T3mTrK/v9UGOo/SRDdG
        cIWznx9mpG6uvT59DQSIJj6nGsNw+bT1l6PMPc28pTxtuQ/MpE+Q6KhbrLoBJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601811020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXzLlkZeBJwPbRey6cA9ZGk3BHqbfpKavXh18Vgz7Ls=;
        b=ugHFctXJQeJaT2m8Q6NltEE3x28F3u+VU2zNHoNlrD0XDKniv9pRGG3h2VDhMXJuhTaGFU
        HFM+J/XnlMaFrcAQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v6 6/7] dt-bindings: Add vendor prefix for Hirschmann
Date:   Sun,  4 Oct 2020 13:29:10 +0200
Message-Id: <20201004112911.25085-7-kurt@linutronix.de>
In-Reply-To: <20201004112911.25085-1-kurt@linutronix.de>
References: <20201004112911.25085-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

