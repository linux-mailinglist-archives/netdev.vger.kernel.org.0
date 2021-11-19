Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C50457937
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhKSXCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 18:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbhKSXCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 18:02:05 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA29C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:59:02 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a9so20618534wrr.8
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWBtF3VWHYNGyyiWO1xUxIIpGyLF39iHGSJzgsQAxZw=;
        b=J1cztN5yR6Jkx6Z80jISLsKwao/v97eBK66UFhE6pTdYtifGwZ+UbZRgSyRcqDo+sf
         vYNO5NpscIVrbn0Yc1b2fZD5TIiuj2i9MY7wwF8Gh+rGt1xu0x4q5YShGr+XqlRAzaMT
         jIjhY3AXYDaq5SwbiPTXuJsv/4cxhjk9kYivwchquHZiBEnteyu5Pox1xW5ybQKHPCwT
         jrJL9Sz+prwrvRvNMDPBtTxKspK6oaRertkkveyP89sBb1TNeeAWhxGHtXG+jwgQf3QU
         S+QcYHr4P74fj0c0wGAujL6+YrjCmaGLI/xcDGMpDVWq3UWDDbp9s8o6qt7gCG3jdxyi
         fQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWBtF3VWHYNGyyiWO1xUxIIpGyLF39iHGSJzgsQAxZw=;
        b=B7AYuJdlY7gNvyeLmgjzKHeC/clWOZYCUvh8HTXyimQ2A5AW7JLB+nJpTSS8/G2GjJ
         j5rMgvJqIXryqUo5/iiuPggiYO9XWbm9iW6rlkn2gY406xTXBRgWGqZzcYu7LG8XYslP
         8kTcCMDG/yB9CrHvtlsVsvoNXOsNNNFZNW9zRGEQde+nP1YFJT5EB3SPzSNhs1EtP8AU
         WZeyavUXmpzIYTsx88T4O+oh9IFQW14SZWGoxPJnE9DxLH3nzOuhjBB6/DrmmvxbCoTX
         tsBqyXvtd9DgGMFwwyRd8mK1ifL/TyhULi8c0LlaC0zRiMMz21x6B14xYB8ueUyczpE+
         RC/Q==
X-Gm-Message-State: AOAM533w89TRlTqGc8UVEh4KGkoOySLdju0L59cCB32qLeangeVl4E0u
        bFKij4L+gE74m8ADPkLROmX8oQ==
X-Google-Smtp-Source: ABdhPJzxjC0+U25LXKkmrSWtIVHdfnf0GzF9gH3c+rjxXwObnqLn+EfredvIWextNt7zfDHk+hFY1A==
X-Received: by 2002:adf:e882:: with SMTP id d2mr12173090wrm.389.1637362741454;
        Fri, 19 Nov 2021 14:59:01 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id n32sm17637377wms.1.2021.11.19.14.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 14:59:01 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v6 1/3] dt-bindings: Add vendor prefix for Engleder
Date:   Fri, 19 Nov 2021 23:58:24 +0100
Message-Id: <20211119225826.19617-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211119225826.19617-1-gerhard@engleder-embedded.com>
References: <20211119225826.19617-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Engleder develops FPGA based controllers for real-time communication.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

