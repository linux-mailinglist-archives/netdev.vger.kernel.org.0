Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B179324B0D9
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgHTIPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:15:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45370 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgHTILo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 04:11:44 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597911102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrpOUDL8p2h587aT5pRggjpfAapiWVtaXRmeOe7Oj/M=;
        b=KFzmlhAiyaQWEFTcQmjZqhJdGtHKnD5lQVtIhaYPfRz26yjD4D/XMoeskXFs+hrlI78SIe
        AMRBq61ukYw8Q9AzlS+flpDPVfcnFz4qUeiPm31TyLYLMjhNtAb5BogFnUAaI5OAo1Qj1N
        2ba2dTvdk4pImxDBSP7JKCXCd2ppOMjfBT/dZeszciYNZ0MQKOsbpSIXYnUeNyc/VORz6F
        JVHxaWnj+Wpk1Zlp+c/iNJhiGHFyuaNTNoesjd9FeJj23358mLusa1fuA09Q91dlwV7S+7
        v2yaTB+TN9hpRudJ1HB1sZx17M+4cE67ARWdQy7oozmN+4304KjafdTkNqBCBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597911102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrpOUDL8p2h587aT5pRggjpfAapiWVtaXRmeOe7Oj/M=;
        b=uRW5sXGQAVaEPmaS0LOL2NIksld9Ezc5Ayycv/Nw7xceWCZL7r6Qv0/di3ZGvD/UE2hPOY
        crFS3fA82VYNT9Ag==
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
Subject: [PATCH v3 7/8] dt-bindings: Add vendor prefix for Hirschmann
Date:   Thu, 20 Aug 2020 10:11:17 +0200
Message-Id: <20200820081118.10105-8-kurt@linutronix.de>
In-Reply-To: <20200820081118.10105-1-kurt@linutronix.de>
References: <20200820081118.10105-1-kurt@linutronix.de>
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
index 2baee2c817c1..3ab8162d80c5 100644
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

