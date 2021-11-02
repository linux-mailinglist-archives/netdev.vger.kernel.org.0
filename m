Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4841C443751
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 21:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhKBUcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 16:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhKBUcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 16:32:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626C4C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 13:29:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d24so440317wra.0
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 13:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mMup43irZcxtDfw5pFZxg59maBqRAZ8MC3OJGORQopU=;
        b=jfFJp2igsmhzmAjbUZucV5+gX6oMgNIKR4dWd/cTis9GCBiDaJ184GQO28GveUzUjz
         cpt5NBTUV0fCdaUG2reVgkHkFIlO5azrxvLg377Rb+GjP6+vdCrMNWJnu741u/MuZmcg
         tX5scMhK63U2SoX29tKZz8C1zrnU8ZUk4ztILoIrMnOrj3KRP5cBAapyWThyCBTgfB1w
         ewgVZMkbRtpTGCEi2uRhqk1AVHdDhTT2bbjcO7/+nuFwd4USwLOaeYSlXeW5DvSp0ttb
         +P6IQOORQZorgUUKGs72hpLQ9GwennIC10S+Jzzr1bYEsglqeYDj9wzuy7ZT2gHGKMMP
         VYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mMup43irZcxtDfw5pFZxg59maBqRAZ8MC3OJGORQopU=;
        b=5S99qBmIxIivet4RhOpIHkYAk1pql1Vgqjas/yEJBu9nv//Sq/8YQ659vbGP/uLRPx
         ELVIh4OEKq+m1HTfWdKcDbcEQYKyEoFt4SXw5LDLBjHK1S9tSzqUL+d+5yah6B7E6oBk
         eov6IDVYOS1DapgdyvAvqulzHl76AimEFQDij5XNhvMEui0Z0SdfkbVDO+F/MUN+aDk2
         Atgo0lWh+YXqoURGRV4SRCMgq63zungOmGyBrr62zu1x+TbatG7yE/3e+wKQDgllge7c
         CUpM/yoPkeUlzG8PiGMPJVdednlIY9WAhxP/jJFtHCkQEYI2TUAkcvP7ajM4qzGGHdgH
         2ylg==
X-Gm-Message-State: AOAM531zgWo3w4JweZOfmDCRPOTDnZ7oXsmTsppZ+520jLiY1l8YCSDT
        5XOLMhoqrrx31rgQVfrh1TfBCA==
X-Google-Smtp-Source: ABdhPJxCtONqTnFF9NHYOK+2YAccCWVoG7bWwVp9tTtdERcncP6zywBWhwLsMzlWCZV2jlX3begytQ==
X-Received: by 2002:a5d:6085:: with SMTP id w5mr42394230wrt.122.1635884965676;
        Tue, 02 Nov 2021 13:29:25 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id 6sm31914wma.48.2021.11.02.13.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 13:29:25 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v4 1/3] dt-bindings: Add vendor prefix for Engleder
Date:   Tue,  2 Nov 2021 21:28:45 +0100
Message-Id: <20211102202847.6380-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211102202847.6380-1-gerhard@engleder-embedded.com>
References: <20211102202847.6380-1-gerhard@engleder-embedded.com>
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
index 0aa9e7676fcf..5bdba41bd389 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -373,6 +373,8 @@ patternProperties:
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

