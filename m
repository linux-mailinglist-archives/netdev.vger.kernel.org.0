Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CB83CF041
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbhGSXLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346532AbhGSWqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 18:46:15 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2202C061766;
        Mon, 19 Jul 2021 16:26:54 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 70so17477226pgh.2;
        Mon, 19 Jul 2021 16:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XJHkcr+rNFoEtXHW41Ygg434e9wX6lX+q5T+gvNKXE=;
        b=Gk8ElqWebRrlCfuWtTh5YC1pKkVX8v3x8cCTvGprFOC+kAdYO+VhlI9TTfvJ6KksHN
         2LLJotCCbEHCj6e8CrKcvTY9D4dMnJZdK1RCg48BMXARiXiSPZ6fPu5KQxCszHqfwQYQ
         xm0P1fNQMhmM+nS3GUMe1g+tlr0NLZCwfyobOs1F3II1DnSjGiZ5MKR7pxaXCExqhg0w
         Hv+A1eIKdfLbbc1bbraapp4ckoNM57erydZ4//c6qpAjnH8q3HPFD/4CiZbaqw5Abw+w
         MFXJjJAFCD1PQIXxTw1Kgv4xVvp/1qxLj0qFcKBiYYQEEVCmX5uOw6Y+JNOlrF5Twp7N
         OGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XJHkcr+rNFoEtXHW41Ygg434e9wX6lX+q5T+gvNKXE=;
        b=papAMlHHqtHNxUU+8MnAcCc7O1WX4I3qB+lLNkz9v7rLpI8ckv9CULtMzEoW4h79N4
         HLkEPZbEVcYnW6ZouJIsXqAgR7k/W/AO73vCRytsiv0XMN9y2fO9H3x/dj6UT6DjpEJd
         0yiTDUKMTkOdH6p+YtCLg08ykLdd+I94C6apWNI7mlrPPVWbBp/d2/KOVvsDMCZNBTix
         YZLj2Px0aUk3FD+95ev0LPm0BzC/9DdVhPh40vECPoZv/lcAMlDGG41JvbWSRqLRg0Mp
         /+IIeZjH0O66PtQsrC0tfRNjtbMhWYCafp2+vYGsWpCS3Y9KyDmwrOWisGWF9eaAoeX4
         y0gw==
X-Gm-Message-State: AOAM533mBCWRIYjHmMLCVcFmYJseceSbhcCPcnLxEC+jvDQFGH+/peeQ
        aGXqQKi6var7D0PkW9LfIMk=
X-Google-Smtp-Source: ABdhPJywl27Hln3EMxWKNk36+5YOQfqY+tYWe8lSq7ANEVVntXWt04GtDQ07qdbyYEGlZFr4WaJumA==
X-Received: by 2002:a05:6a00:1895:b029:32c:b091:ebc with SMTP id x21-20020a056a001895b029032cb0910ebcmr29158271pfh.4.1626737214099;
        Mon, 19 Jul 2021 16:26:54 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:504a:4236:c95f:1569:e13d])
        by smtp.gmail.com with ESMTPSA id j16sm21974127pfi.165.2021.07.19.16.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 16:26:53 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     qiangqing.zhang@nxp.com, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next] dt-bindings: net: fec: Fix indentation
Date:   Mon, 19 Jul 2021 20:26:39 -0300
Message-Id: <20210719232639.3812285-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following warning is observed when running 'make dtbs_check':
Documentation/devicetree/bindings/net/fsl,fec.yaml:85:7: [warning] wrong indentation: expected 8 but found 6 (indentation)

Fix the indentation accordingly.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index 7fa11f6622b1..0f8ca4e574c6 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -82,11 +82,11 @@ properties:
     maxItems: 5
     contains:
       enum:
-      - ipg
-      - ahb
-      - ptp
-      - enet_clk_ref
-      - enet_out
+        - ipg
+        - ahb
+        - ptp
+        - enet_clk_ref
+        - enet_out
 
   phy-mode: true
 
-- 
2.25.1

