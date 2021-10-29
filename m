Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5033A4403D5
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJ2UKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhJ2UKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 16:10:52 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF16C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 13:08:23 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d27so308992wrb.6
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 13:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hvbaBFRLOcGzlzRnhv3kRS5hK1Z5apnNGO+8bJf/bpU=;
        b=RmbQ0JhoTt49b/AFcftd+1CiFg8qe7FD6ujsHJv8dV8XBp93xAHn6GHJ4KI+Ndu2Cs
         T41PdsQzXpdLMKRGsKVNYPoREjJwgb54Nln03NG0hKebTiYISpyRTelLFt1VHDQyhF/W
         1S6IS6+9mjnqj+y0sOS1zqZm36OhSH4vEGUs8mX9OEyepds5xbwIjKf1nBxwH1FJkjtK
         Io2L2+HrkMBYyUlQcZPQBxfkOLXRNiVPfjScV5/t6BFDXslIagJ/UILPlYFXWip05nSO
         G4Drh9NWmc9TWVtLdYDB/QYL0lNbUEXHSJ2vp+aut0H3+q6uUuDNmHV8ay0UjJ3K0fD+
         6H+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hvbaBFRLOcGzlzRnhv3kRS5hK1Z5apnNGO+8bJf/bpU=;
        b=IQL4ySZj1W2saXb+OUBlcl2VN1+wZDGTRstOMXfnOjvfUf7hVCb3YGFYwcQXSexKCw
         kAHO7DrXWbXUAFC4IMMvrfJ952NwnEHgJ/Zuj/S7qyGO3gcvj+7bKto099+8l3mnM9Ni
         lqiOD+aI1cGDIVZT1yNYlJ2cJz7+5VyPYUsVqcRt/MF+wvvrC0l3WlnX06o+kFyLROXG
         pMFea7VnMcOL5E3gZfNBId8auk4koFPdN+FMcQaiMumj/5VZ5UtQjD0Z4CP+zBVsL/9c
         KAf/Ouu1YU29aQTTd3blSK3L1xQum/DWP8uEptP4CaPRZT2BAbs2PoRA+8H5fAA6rVyp
         9YuA==
X-Gm-Message-State: AOAM531sxuHS6nFj31uE9x9kiF77bomFS5Z67GdeZ96KyNf7FS67OOM6
        9g8YH8hRxXfgs7Jon0EZmgEpVw==
X-Google-Smtp-Source: ABdhPJxcttpj1o1s86hdohQlNabS+b8JpciljUnSKh+Gt7zKLTaqEWqIDx2N1NEyyflRVHK05Ex4Gg==
X-Received: by 2002:a5d:6d81:: with SMTP id l1mr16749039wrs.110.1635538101668;
        Fri, 29 Oct 2021 13:08:21 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id v3sm6818324wrg.23.2021.10.29.13.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:08:21 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 1/3] dt-bindings: Add vendor prefix for Engleder
Date:   Fri, 29 Oct 2021 22:07:40 +0200
Message-Id: <20211029200742.19605-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211029200742.19605-1-gerhard@engleder-embedded.com>
References: <20211029200742.19605-1-gerhard@engleder-embedded.com>
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
index e2eb0c738f3a..2c0d8b0b4f93 100644
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

