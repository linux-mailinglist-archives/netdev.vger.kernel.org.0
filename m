Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6EC3D67A4
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhGZTGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZTGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:06:01 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917E6C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:29 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n11so6046447wmd.2
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wPMcfnu1/V9i1bWK5jGDJZND/uKTtuskHaknN893sm8=;
        b=Nu+VC9z66sSuIcjoI0+UDVbTzzgCJ8o60z4QWRfUGkRH3qLflomwK2WtK4BwXXJXrt
         bbSB0CSEgPDDIOFXN0Gp/1LMgiYcr/9KdBYGXn0FWRbG4V7DbU7LTPEED52BXVKlrlvr
         Q4opwo3Fz3VbPDuKstbhG17b0uIgkyl5ekaLqdf8FoFS6O4u2+EoATkf3BYDDhVzp0lb
         Vai5LiAOH83lLwdsgd8VKyBztvjQniu4AMSrcHJ2RvsIGksENVAGes+xeAJYV3/wpeXf
         OBJ7iNmtX3XA6yX7LPXySRWGzZ8a/tMvlnjxEFCfAfBn+qTJ7f5TcZkikXFePMpp/+xW
         hKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wPMcfnu1/V9i1bWK5jGDJZND/uKTtuskHaknN893sm8=;
        b=i70j6rxo8zN8e/6gE8e2NbaK992MAYgQ5WSFkSmvdFLEgvf4YoUrO76Hx43mSs9fIa
         jlVFAZ9f2I172R25+kiQE3um7ZgCROvgJJwciQt4x2uDPAYJHx6xsD1Y5arlVe+1W2Mu
         t3O4UGMvOOB1mgvOn69jdkpNrSUs50ZLcANMHhn93Aj8SHxKOMVXvo9yyAkA2amgCegG
         Z4HwPI17ODqgkJbMezbir/rNGfHrOQ6xDdKVBrU1aB4dZB3UvdxuPym+c2+lFrltTjz/
         9CIrgHDmI/AOOeiNk1KEpXmXW3Wrkc22t1uuDvw9Atk/w/kgrsmmXsSAG1byGHfdzHkn
         fJ/g==
X-Gm-Message-State: AOAM530i4rps847TdaBv+6DN0B/smDdP5igmTy3Kq5MCRJbjZOdZCu6/
        uRxyQwj2dRtddMlwejU5jISy4Q==
X-Google-Smtp-Source: ABdhPJx8mIelICAg1kam3EbMJ5llH/JEdOxK90RoKw3b+KqtXnWTMy96cPzDQs0ShBl1VeICW+UK3A==
X-Received: by 2002:a7b:cf12:: with SMTP id l18mr547382wmg.130.1627328788238;
        Mon, 26 Jul 2021 12:46:28 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2f5ziwnqeg6t9oqqip-pd01.res.v6.highway.a1.net. [2001:871:23d:d66a:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id r4sm741528wre.84.2021.07.26.12.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:46:27 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/5] dt-bindings: Add vendor prefix for Engleder
Date:   Mon, 26 Jul 2021 21:45:59 +0200
Message-Id: <20210726194603.14671-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210726194603.14671-1-gerhard@engleder-embedded.com>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
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

