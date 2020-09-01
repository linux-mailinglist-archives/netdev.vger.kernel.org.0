Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9934825A1BF
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgIAW70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIAW7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:59:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C69AC061245;
        Tue,  1 Sep 2020 15:59:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 67so1494643pgd.12;
        Tue, 01 Sep 2020 15:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0M9UetfAtyeMCeUqpiMFChaJf92K3z/aC4o6AhbLFnE=;
        b=sKm24Z7IFygpgjxRouogu4sZYcKtxkim1KdB8NbJ0WWJst/+CYXJ7lmwXEt77AlT/z
         fzcmRR5XKX4MbSfYNYEpPWqNg73qtwP/AYSGWf7GS3Z+s55u1UacAzAbT1JTWW4uprsq
         QT0GhV5bNr2estu2NqsJK6IufnvjXEi2azzFVPgLAOtN+zTsgoxRu/zV9SQcWohN8L25
         DXZdcSWSWfNvK4xGiwxope8zT5HEgb9gNPrb3suhY0xFIxXzUuCTFahJGYtbEoFGQQBp
         71O9Cu34EaNWK8pED9ou2A8xr6f6d0yw9PIkov95oFJvZwjip9HJ23RUtGxYL25yailx
         mlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0M9UetfAtyeMCeUqpiMFChaJf92K3z/aC4o6AhbLFnE=;
        b=NkTQAwQIH3oyZDBQaw0MaQUApYqLcYYMBJls5FE2Cmt+ad2Pa7/8TyveeiIxxMc3L2
         hlLJjX9t5S5b1kBvKGfb42vOMr1vLOOnK9jgPnYiqrYyI/kGsRzd9GnO2huTxNncLn6a
         3LCwFQ0BSG+BhMp1bpNcMkNDeo54UdH5apiIwkC1Hubcq9aT1H1RT5e0BJLp1nulOwCa
         ygDDbLcvImXgtbMQGXCtkqryP9sq8e8XSMlQv4lVZzjHykKrTnWu0S8dyfq3Ku9MP0Xm
         wt1Q46W+YKoWkuYHpaS5KfqT0Em1nT5sEDb6Et9tijVR0BkzZ62HM5le3V0Cd4D2okC0
         pcww==
X-Gm-Message-State: AOAM531caR1b80V4JXpKCEa22d3brse7ULcK4FRLkiFmUbnCS/k3YHNO
        0yTuc9w7SKQCtwU/o2xUUyr2R4aWfW4=
X-Google-Smtp-Source: ABdhPJwsdOkCCs5Ww0v7HbLXOi9oSfmTT05zYk0y70mmVjVGED2748BA6ZvTTJc7J7BCWLmNYSXSoA==
X-Received: by 2002:a63:354:: with SMTP id 81mr3535145pgd.216.1599001159128;
        Tue, 01 Sep 2020 15:59:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m188sm2952750pfm.220.2020.09.01.15.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:59:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/3] dt-bindings: net: Document Broadcom SF2 switch clocks
Date:   Tue,  1 Sep 2020 15:59:11 -0700
Message-Id: <20200901225913.1587628-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200901225913.1587628-1-f.fainelli@gmail.com>
References: <20200901225913.1587628-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the two possible clocks feeding into the Broadcom SF2
integrated Ethernet switch. BCM7445 systems have two clocks, one for the
main switch core clock, and another for controlling the switch clock
divider whereas BCM7278 systems only have the first kind.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt   | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
index 88b57b0ca1f4..97ca62b0e14d 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
+++ b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
@@ -50,6 +50,13 @@ Optional properties:
 - reset-names: If the "reset" property is specified, this property should have
   the value "switch" to denote the switch reset line.
 
+- clocks: when provided, the first phandle is to the switch's main clock and
+  is valid for both BCM7445 and BCM7278. The second phandle is only applicable
+  to BCM7445 and is to support dividing the switch core clock.
+
+- clock-names: when provided, the first phandle must be "sw_switch", and the
+  second must be named "sw_switch_mdiv".
+
 Port subnodes:
 
 Optional properties:
-- 
2.25.1

