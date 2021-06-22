Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4123F3B05F0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhFVNlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhFVNlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:41:18 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8063DC061574;
        Tue, 22 Jun 2021 06:39:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h17so13796907edw.11;
        Tue, 22 Jun 2021 06:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9J4wVE+UNYQUWg2UAo+BHnsFSkaqU67PH4QUyTYeAE4=;
        b=cgz7YsG6v2uq1W4MDwor4qW6rExpu3LojY5JFoBSP0KVARw38NMPa+9rQ9qbWHLdfB
         xtCovSXnaec3oJNNhGLVB69DOCfyeEKJjqg4N0IRb1vRI4kVuMpOLeuKyipf9mnxAgQS
         lnlnaP5ERZeiDbD/ieJtOUV49ihP5Da6spb2vyTK03QGj/x0qz1ANfwEUCCMdND8zueV
         B4jebQhqi53bMTKd/XFd1CoWhT8ZvbI1cehNyuC7Bw4FC4T1ncesRI4hCEKc3bBss2UO
         BKRnRXiFGihFTQmOo+uBbor6SQid4SSy8hJrotx87Is+fJ4l/hwrVXVL0K/o8WuuMbe/
         1B2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9J4wVE+UNYQUWg2UAo+BHnsFSkaqU67PH4QUyTYeAE4=;
        b=K/CPi3HQKfGdagg+ON4W8KqVsxd3M6ks8reyQDrRjzoGcw8y7ISBb0ErpqHTXthkhx
         4sZ69NcUZf6/5QWCFURXLc/kW7yfF+weTvNZ/Dg5a71Udp94ez0d4rlFZPs3WrzRZyc8
         Nhn+Kr3r/sndNYRgSP59AQ4+dSj8rKor/Y66S9mbiQOpJgATLthFE1b7k0g/wMut2Rzs
         kROwkBrLn7bZciHyDewW5bfPRqXLHiWeQmpvab6UliabAV7fFjKcN8/1yTkh7sDG8eNY
         Aj2kxsygGje6jBZbzte4OVlHmlYI9QP+6weQoVZSHZzbxYnOGjdCz9i+5akjr15nU6RE
         tDyA==
X-Gm-Message-State: AOAM5311xTrfmXw3arU4WNb/9y9EccbGloc8QgYg5UBKOYLkOUgXhZ8P
        fWiJweJ1G6GHtKAT4NyZBk0=
X-Google-Smtp-Source: ABdhPJzyZtEOcR17LO1E+9KxfNFNMoNJH2KATvcvOPlgT5FyF0NNSLORQG/zF0Q1xAKBEE40W8xQPQ==
X-Received: by 2002:a05:6402:d0a:: with SMTP id eb10mr5191520edb.139.1624369140608;
        Tue, 22 Jun 2021 06:39:00 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id o5sm12055010edq.8.2021.06.22.06.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 06:38:59 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     zhouyanjie@wanyeetech.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: net: dwmac: ingenic: Drop snps,dwmac compatible
Date:   Tue, 22 Jun 2021 15:40:55 +0200
Message-Id: <20210622134055.3861582-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The DT binding doesn't specify snps,dwmac as a valid compatible string,
so remove it from the example to avoid validation failures.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/devicetree/bindings/net/ingenic,mac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
index 5e93d4f9a080..d08a88125a5c 100644
--- a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
+++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
@@ -61,7 +61,7 @@ examples:
     #include <dt-bindings/clock/x1000-cgu.h>
 
     mac: ethernet@134b0000 {
-        compatible = "ingenic,x1000-mac", "snps,dwmac";
+        compatible = "ingenic,x1000-mac";
         reg = <0x134b0000 0x2000>;
 
         interrupt-parent = <&intc>;
-- 
2.32.0

