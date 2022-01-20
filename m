Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23237495317
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377314AbiATRXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:23:32 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:47097 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377233AbiATRX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:23:29 -0500
Received: by mail-oi1-f178.google.com with SMTP id w188so9789743oiw.13;
        Thu, 20 Jan 2022 09:23:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAkSVry5IOKbh3mNYVa4dyjbmMK+FV1ismL7QMeIYBE=;
        b=Rptlzddy9PZ3Cr+6vypCu7VicwqrXXQ3cMCvGs31Urw8F+R404lSNVoWIYjwyesCjx
         wja1SFdrlj80ALz6NJTEhXPcSegQ3i4uOp7fY9qxroG13okfb7cVQwIk7YHeFw0n51vn
         zueHNJhZCETaxFgvW9JMK//B+rRkJEtL5P8j8t5Wd0PZWdBiuW51OkiDLmNgINuInkGX
         5uxQWVdibRo+si2n9udAdzVdETR3C0aZq/jlXXh+KFoVssbRVXxvAHPJ3rDqRFX9kvjL
         BLcJ1/Zdrnkte4zk2dFbDPi22yo6ih5FyClm2NRfG6FgnEF7p1y4+QFU5rrG86srqkf7
         8N/g==
X-Gm-Message-State: AOAM533EhRkjM2T1JjMzSW4G+46z7TK6PlGONtFrYCk9GtXz1FQ11yB9
        6uM3+B6hYk9bKLMleGhG62g64J1eLw==
X-Google-Smtp-Source: ABdhPJyYaRqYHbwwgMxnSR9Jr/rVi95SCT70cluMn3mT6CUbGRyJY7P7Clqm4Rmuay1WMOaEjLEJJA==
X-Received: by 2002:aca:1311:: with SMTP id e17mr8321961oii.119.1642699408514;
        Thu, 20 Jan 2022 09:23:28 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id i19sm1350172oou.36.2022.01.20.09.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 09:23:27 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: ti,k3-am654-cpts: Fix assigned-clock-parents
Date:   Thu, 20 Jan 2022 11:23:18 -0600
Message-Id: <20220120172319.1628500-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The schema has a typo with 'assigned-clocks-parents'. As it is not
required to list assigned clocks in bindings, just drop the assigned-clocks
property definitions to fix this

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index 1a81bf70c88c..a30419ef550a 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -103,12 +103,6 @@ properties:
       clocks:
         maxItems: 8
 
-      assigned-clocks:
-        maxItems: 1
-
-      assigned-clocks-parents:
-        maxItems: 1
-
     required:
       - clocks
 
-- 
2.32.0

