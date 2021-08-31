Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE2D3FCDE4
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbhHaTfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 15:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240833AbhHaTfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 15:35:45 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C563EC061760
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:34:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t15so828201wrg.7
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wPMcfnu1/V9i1bWK5jGDJZND/uKTtuskHaknN893sm8=;
        b=1j+/z7T4dYmgPNLK/eiACgvmG3WBK+c6erp1Z2zQ5xYYV+/L8XfF+jKGJu0DmvKDL/
         5NNW4i/ixL3hSA0Yf2sKUWjUj0WoATW5SnZNEoPQ4dlSTefwTSzSzzj946olFmFU7QeU
         4/hOtDaG47Or05UTlrpOTlPQ+Zm9/cKCNAmZ1mvj2Aj6MP1N2ty0ehQ/4+aEYOExykVg
         hcdAeKj0NEWAvi1QCv4731y0l+mYELRxQIGgrqYM9meVmCNmVo9ZzBiMmEEDha23oO+U
         waZuhICAUJFEMrcde+JBO1V51qRD3tFE4V21hAH1Fj8tONefinADmlrUwdEa+6neCbDd
         mc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wPMcfnu1/V9i1bWK5jGDJZND/uKTtuskHaknN893sm8=;
        b=ACJjqdtbxLNj211UYERXiceULte8g4kNrccD1Q7veyWADr3e0nD4WnCQ5rAsvqCaso
         ZfuO/xnTjhVCK95/Df/iWiJOjehH6RczwRafT2n48J4JcproeQzktbLxWMdUamHaClIk
         6ee+VfOtRYWtSgjip6obqYhGBYsDVRs0thbNIZr4JPNPw9VFVjGzvEupLKLu9ikqfSFK
         ZiemB9TsaZjhR++cLWaseSd2c63AtItfRXea8yVAlKogPLgP4XSwdQkYp6dITT9TIayt
         SINYSQxNvfeLD/kwQlxuNFwCn1auZVZthkF51Dav0N+4yYod90I4LzueFqBE0qTYdMKG
         SWxA==
X-Gm-Message-State: AOAM533iQNvdwLEhL7eIqTEcSkmdTHP5xNBMjYNO6rpGFYHgwS6+QO2E
        7MPB9ZPuuYO5Ulm/q2tfjrdvGQ==
X-Google-Smtp-Source: ABdhPJyB/WMV7x0Krm42xWbPEMd72KOKHfBUNu/bVDWAdMECv5FRLMZ36bbRNpYzPo5Sr+IXT/VqQQ==
X-Received: by 2002:adf:b745:: with SMTP id n5mr34344713wre.338.1630438488439;
        Tue, 31 Aug 2021 12:34:48 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id n4sm18708324wri.78.2021.08.31.12.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 12:34:48 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 1/3] dt-bindings: Add vendor prefix for Engleder
Date:   Tue, 31 Aug 2021 21:34:23 +0200
Message-Id: <20210831193425.26193-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210831193425.26193-1-gerhard@engleder-embedded.com>
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Engleder develops FPGA based controllers for real-time communication.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 07fb0d25fc15..d5cd33d33c73 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -367,6 +367,8 @@ patternProperties:
     description: Silicon Laboratories (formerly Energy Micro AS)
   "^engicam,.*":
     description: Engicam S.r.l.
+  "^engleder,.*":
+    description: Engleder
   "^epcos,.*":
     description: EPCOS AG
   "^epfl,.*":
-- 
2.20.1

