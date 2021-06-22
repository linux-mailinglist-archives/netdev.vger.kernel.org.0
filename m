Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7C23B02D3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFVLdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFVLdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:33:50 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A400C061574;
        Tue, 22 Jun 2021 04:31:33 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i94so23214232wri.4;
        Tue, 22 Jun 2021 04:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IQWYBDsWnVgNYb0J/ARy4jiGyFTiN2ezb1XU1B2YfnM=;
        b=ASpNCLwOhv0lmYh3wU/v7hdREVqRgRO4c/API7MZJyrQGjfZ1sHc/+9zZD4S3pxGqk
         l74j1khng1fheQbWuV93DiwhSP028ecCP39oini8gKeqQkqmd+1RuN/8IhgPDS3yi0e0
         qxJrsH3tunCDENBcdCZn2v8+tVDkqSwrgibOb23yWdy+1KAEp8Gi3hXyg3m8X7KHo6zz
         9celprROrwFeZpDVCUXdyqSZVnji0K0VsRVGBJw0S/ouwL55GSh3IyiRdjc0tDC8cMoT
         aKEKJUWg71L1uscc4oSUuek1dZmPlCPh7YVe1+SLnkFRCc9TKCyCa7Ew3sGyxMG1qtRx
         jDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IQWYBDsWnVgNYb0J/ARy4jiGyFTiN2ezb1XU1B2YfnM=;
        b=aB+6o7+vAVT6TXF6qG4Cz0Pc823u0CQK+hPma65OcXTEpeI4lHf3wVBob7HyTYs7W6
         oRzQTtOoTPnnVn7FGBVfNNadPrWIiHwo40cqo64lz30Oecl6ChKDbZMlbed8o55872gT
         xz1s3rmZiClO7fMj7hM9iMwIhGM86RTUsjxp3SnylGnsGgZp6WBd/4tGrGoih3dlJX1S
         /8CRJ/X5TvHWumOSLelobwCcwUlNx6kERZjdEEWsp+Sm8C9ykN/NCzWHMpql8zlDGAzk
         KHaJLCaQQft+A8ewRheVmlU4XYX7n3N/5RnCUz+/ZE9E5v7L/0b+9YHdX7/Tj1ZgKbJO
         QzOA==
X-Gm-Message-State: AOAM5307rYhUhpTSLk03pOpDjtdDtPV9FD7528Zivgsy9uW+6PBKDPf1
        3oOiiSFhLsbQeRDkOFdoLBc=
X-Google-Smtp-Source: ABdhPJxjuZ8dpiFSTPP7pdi029NIXE1hjGNARIe7j7ENpZCOCfB2fU1p3EqUTTDplnxf4UJe83ZBRQ==
X-Received: by 2002:adf:ff8e:: with SMTP id j14mr4089268wrr.374.1624361492103;
        Tue, 22 Jun 2021 04:31:32 -0700 (PDT)
Received: from localhost (pd9e51d70.dip0.t-ipconnect.de. [217.229.29.112])
        by smtp.gmail.com with ESMTPSA id u12sm21911104wrr.40.2021.06.22.04.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 04:31:31 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: net: dsa: sja1105: Fix indentation warnings
Date:   Tue, 22 Jun 2021 13:33:27 +0200
Message-Id: <20210622113327.3613595-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Some of the lines aren't properly indented, causing yamllint to warn
about them:

    .../nxp,sja1105.yaml:70:17: [warning] wrong indentation: expected 18 but found 16 (indentation)

Use the proper indentation to fix those warnings.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 0b8a05dd52e6..f978f8719d8e 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -67,8 +67,8 @@ properties:
           reg:
             oneOf:
               - enum:
-                - 0
-                - 1
+                  - 0
+                  - 1
 
         required:
           - compatible
-- 
2.32.0

