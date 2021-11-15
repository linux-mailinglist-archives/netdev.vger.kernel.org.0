Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A817B45164B
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348270AbhKOVSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244862AbhKOU4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:56:45 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B47C04319C
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:25 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r8so33104892wra.7
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K4rmocm7jWn1VtXA8XT0CWYEOpPI2dq9vIflSLFCPqA=;
        b=m16ytqS2NoENhmvLr53w5PYu/c6E6Hr6zjbIfgCDT/LxxWybi3klC9rJFztHmuR4aT
         3Wn5tDHj5wG96QHakqpJ8HayP203BGb+KxNH2C033+joIl/2o8yvbHYfaw5AFmBJfuXH
         Y35M4Yd79VSvVtEgPkwy6Yx7qDkITm10zZWBVpmzCr1xPeckCMokqESIFQLlnOD0Crm9
         442vBDYHwXRuYMb4KoRM8UKFSS9ZC+6t6j2XgyjTdDYBk3OTIUVi6FrD8oTD3JOjJEzI
         SvmHbOHCLbGj48gPfpWKTrID19wf8gBmJwCTU8BDgRUceIQyqyfvxYD5I2rmVPLdfBFd
         3HLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K4rmocm7jWn1VtXA8XT0CWYEOpPI2dq9vIflSLFCPqA=;
        b=s+iBxJr9+3SET+ruCrZ3eajjWkwn+9WOjqxk+IZN45p1oz/napm6zr0ns20T4+c7NG
         eEuh8lco9x/ziiiuyVtYSBoJ15wn92wMNch7EhACFg92b9HznR2+775Elfb7zzE6nydy
         MO/b4lkdt/GNhGfSuw9vnNtG4SmkulUgDy+JvEZJ2gBi2VLFzYdR/gHdPZs1z7J48xju
         oitmu9tRxIeCk5abAAzA9swwgrcyGg4HdamM3GBPC5u65oH8T2E6y9ulmoM4QgBZ3f2l
         IZBwKFYaPvbNuDi/lmbAPxnUNf3hNujE/iG34k1mvldmgFlBsM/Tn+NSdN5G3pNO0uOR
         3VSQ==
X-Gm-Message-State: AOAM530azH4/LrNz5wXrW92NbcDHSFatM63div0mKA5djCDu37dCzS9V
        PAFMMlx1iEEdqjV3LfGf8eqGCQ==
X-Google-Smtp-Source: ABdhPJwyRpLqYg+r66qxlQXYaPI9JKEk3px+jV8+NxYjAjHZ7bICrnND6vImsS+0AcSr7FKs3T8ZeQ==
X-Received: by 2002:a5d:424c:: with SMTP id s12mr2368220wrr.370.1637009424066;
        Mon, 15 Nov 2021 12:50:24 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z6sm15763704wrm.93.2021.11.15.12.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 12:50:23 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v5 1/3] dt-bindings: Add vendor prefix for Engleder
Date:   Mon, 15 Nov 2021 21:50:03 +0100
Message-Id: <20211115205005.6132-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211115205005.6132-1-gerhard@engleder-embedded.com>
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Engleder develops FPGA based controllers for real-time communication.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 66d6432fd781..5f4ca46bfb13 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -379,6 +379,8 @@ patternProperties:
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

