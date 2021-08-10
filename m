Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2723E7D5B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhHJQU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhHJQU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 12:20:58 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBD5C0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 09:20:36 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id m13so32887817iol.7
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 09:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3Wk2pDyXbmU+r0AsnVTvYVgVzJbiqOOteA35AVH/wQ=;
        b=hprt/XB7CmBJP+eKFgA9sQuCJZrqn0qwTrgKhwazayta8qPLfTwKMVf9HNNmqzlgin
         SOKNQiMlNrfI1NbrMxEtm4iyegkbOsAHBXY6+fGvYQwMtZKtJDihnlzBZTufFtt7MJ61
         p3V9vR2GV5X/H4mwksUW3huUM/haXeZrPfZQdYs7HjclwN6KulS0tNUL6x7lFSV3pWf/
         ceTdoxYF92UxVkbCq/2h31nEZ6WhNq1zx6PsANE8fSZyC6ZBkdpq0ZSY0F0zx4OeraDr
         7WadLSHEtpM0nCFEi5TZGkxNWk8IJrfqYAaiCFSdzOLFewUJVelKF/mUSjHp6O6uh2Ok
         Eo3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3Wk2pDyXbmU+r0AsnVTvYVgVzJbiqOOteA35AVH/wQ=;
        b=WaU3Cv5USRFvozw4FPZFu8Qtkndmo0BKy8HbJgR8cfwY26g97sUoO4Dc8FHQ5/Z/lR
         wZUuL6VlxNQ4g4nzUMvyGr61GPlZKwzWj8oRdMO4fC82vjnHaNa5ZWVOr/ReEAEGaG0i
         WIlOVigZNe714uPRrAQSD+V4Upq7swTYuSjyUSASiLS7D5xmg0BljzUITH+GSf0+ti/s
         4dVXScqjR3SyrqjG4lHNUq+XwNzwOo+Hu8V0rEa201adYeYVFjP6z0FiHuxeP150oiek
         JyyNK57jez+ZqCnAQDXQ7ByHJB5/AZMhNr4UrkpGYl01ylUqUxG1MhRJLc2PbaDl5k1o
         EzEA==
X-Gm-Message-State: AOAM532AoQ3ZLDWhUDXif+UON8HDwFSZ+DRrrFNr6ZxR6nqq34UXB8F+
        ug7jBDAUQAp7GUmyrDmoU//big==
X-Google-Smtp-Source: ABdhPJwRwEtZHSrnnARdft1xFnlfdBLTgiPEJwE4cmqZQ57BLYyVov0vj13z+J27bFF1sDO46MQslw==
X-Received: by 2002:a05:6638:24c7:: with SMTP id y7mr7077324jat.64.1628612435584;
        Tue, 10 Aug 2021 09:20:35 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h26sm11898210ior.7.2021.08.10.09.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:20:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/1] dt-bindings: net: qcom,ipa: make imem interconnect optional
Date:   Tue, 10 Aug 2021 11:20:33 -0500
Message-Id: <20210810162033.2258604-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some newer SoCs, the interconnect between IPA and SoC internal
memory (imem) is not used.  Update the binding to indicate that
having just the memory and config interconnects is another allowed
configuration.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v3:  Based on net-next/master; sending for inclusion there.
v2:  Based on linux-next/master, to be taken via Qualcomm repository.

I sent version 2 of this only to linux-arm-msm, but Bjorn reminded
me this binding update ought to go through the net-next repository.

					-Alex

 .../devicetree/bindings/net/qcom,ipa.yaml     | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index ed88ba4b94df5..b8a0b392b24ea 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -87,16 +87,24 @@ properties:
       - const: ipa-setup-ready
 
   interconnects:
-    items:
-      - description: Interconnect path between IPA and main memory
-      - description: Interconnect path between IPA and internal memory
-      - description: Interconnect path between IPA and the AP subsystem
+    oneOf:
+      - items:
+          - description: Path leading to system memory
+          - description: Path between the AP and IPA config space
+      - items:
+          - description: Path leading to system memory
+          - description: Path leading to internal memory
+          - description: Path between the AP and IPA config space
 
   interconnect-names:
-    items:
-      - const: memory
-      - const: imem
-      - const: config
+    oneOf:
+      - items:
+          - const: memory
+          - const: config
+      - items:
+          - const: memory
+          - const: imem
+          - const: config
 
   qcom,smem-states:
     $ref: /schemas/types.yaml#/definitions/phandle-array
-- 
2.27.0

