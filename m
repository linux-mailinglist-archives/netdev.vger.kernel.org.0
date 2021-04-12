Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9786B35C784
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 15:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhDLN1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 09:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237277AbhDLN1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 09:27:02 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C14BC061574;
        Mon, 12 Apr 2021 06:26:44 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id l19so7095981ilk.13;
        Mon, 12 Apr 2021 06:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1aO1TpF9MgF5lN0TP7fat48f1wzPDiMoVBU35EFvOUY=;
        b=hZbmHOUsxJrApOYlVpHX0NnNIambFgFj57y1C7dMuRwaYhLGhUFJrD1N2JT/A1zCyQ
         +1zrmVcfQTHu+vU2mW3T7e+sgsjRaVyZURQQF17VB6PmM8kfKumR+2djTtJ6eaWvAZkC
         K47XC1xFM6kpL/QaiE3Mg0vLA0Uw4ea3h+Whxb19W0tkAhmRYwO+FmKdAgaRXA3ikCZV
         HpisGjxH5ctqg2YswzNkfktESX8DKW1B8D7fWl+DiH1O4veAYcA5P3z1A3bjDfDc9Ou2
         cEdS5s9koHb3VJFvvPMMtf0mjVpAJOcm0CZNYco+j1FkFDl4yt2MC9eYnliKH5JgIR+5
         T4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1aO1TpF9MgF5lN0TP7fat48f1wzPDiMoVBU35EFvOUY=;
        b=LTZqmEBAXODxOMoxN9ZujR925DuXVg1MvtZRn7cGebLtG16+D2voBf77zoCPU2BxJx
         dVFwsdaHsP0ZbBQ/PQeJhUbR/q7iSw7J2CN4AhIAFU3yTMv+TlaSlXvEPbxI/EIOBf2V
         b1NucNt4KYf4POczdwK3ULUqasSBm5DRQ8KGxTsjXolNaNr6jqsJU6JhK4C9Jf6HeeQR
         k5gWdWbq7Lnlj0wSNadJXfikiL+1xnONIQ2bsOLnrTv/7I3LXKhIb2zWt1MSeO4crTol
         35hQzHMIxadljQpiDQak/wAlKzYFfFoVwrTFgY63rzvUQhN36hPakvnDkDsdFf/OowZy
         8WyA==
X-Gm-Message-State: AOAM532xHFTsAPeWJDGrZBNy/ZUaxLu0b//xCeN+TTq9A4WzGAOxWPm6
        QvRpk3tSjzVS8zyIWOUPhkAxbTJTL5lcEQ==
X-Google-Smtp-Source: ABdhPJzWPKU50yhJTHZ80V98+NgHmzDKfCtomnXKv0s9HfBWRnZ/62rg7zaVAozcOhTgmrq2vr+z1Q==
X-Received: by 2002:a92:5204:: with SMTP id g4mr23487727ilb.84.1618234003269;
        Mon, 12 Apr 2021 06:26:43 -0700 (PDT)
Received: from aford-OptiPlex-7050.logicpd.com ([174.46.170.158])
        by smtp.gmail.com with ESMTPSA id x8sm5261118iov.7.2021.04.12.06.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 06:26:42 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 1/2] dt-bindings: net: renesas,etheravb: Add additional clocks
Date:   Mon, 12 Apr 2021 08:26:18 -0500
Message-Id: <20210412132619.7896-1-aford173@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AVB driver assumes there is an external crystal, but it could
be clocked by other means.  In order to enable a programmable
clock, it needs to be added to the clocks list and enabled in the
driver.  Since there currently only one clock, there is no
clock-names list either.

Update bindings to add the additional optional clock, and explicitly
name both of them.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
---
V4:  No Change
V3:  No Change
V2:  No Change

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 91ba96d43c6c..fe72a5598add 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -50,7 +50,16 @@ properties:
   interrupt-names: true
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: AVB functional clock
+      - description: Optional TXC reference clock
+
+  clock-names:
+    items:
+      - const: fck
+      - const: refclk
 
   iommus:
     maxItems: 1
-- 
2.17.1

