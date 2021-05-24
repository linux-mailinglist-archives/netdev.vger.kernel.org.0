Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F0D38F632
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhEXXYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhEXXYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B22DC06138F
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:37 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id jt22so92580ejb.7
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9DYafoQZ8sjJo3dQP1Ut0hCHEoaGM2CgvVGWol/pIgA=;
        b=mLIQtgdI1/8YSqBCbvNehsGBo+z+9G/8w/6UR3+7nS7NJg8H68mEkKAwYTSfPbmLyr
         tzJO+8CkgG1mcZMLaU/dWsaJNrWhRgsmjjgO2szNgs7MxM8flHScxgQrF7GVsZwwdjZT
         ECyVkc/EwK4u5UgnMPOb1gxguswo0NsqKhgGhxDqY7mXughzr/+8DdmpPT8jSMPaqxcc
         j4jN4aggBvceWhptHphed5M7noZHvK3gPqFaY7Lv2EJZlQhN03i5eeJ1HmicvKi+NRor
         e0/t9nI+22AHtpdFq5WHaeHeLAoeW9KnXV5GvJyiZ9uBzDAVIkPHBUoxr2w+Fp4P+qM+
         RxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9DYafoQZ8sjJo3dQP1Ut0hCHEoaGM2CgvVGWol/pIgA=;
        b=hric9RQ2aVOCduBemkIz1DoS01x6C/5WM7llcCouSCkACt9+ysXhqaKvH3RZgQBmP+
         i8WUG6NZ+aYe5VB9OJ2sk2DfK3phyvAGp79F5nHbf1U6jlw97G1ISZmGFISNTaZ14bJJ
         xKN323OOPG0hvtKwgfvEukk6+QCBF+Ct7YUVLksxvufJcph0V+KhaLuWq+Z+jI5JWXpd
         JQpcLtKTcRF94lz82xy3tCl27p6QXPlzbWg1JPuPJx5euUasb+vmOIaDZzz+lXG6b2TN
         4APBF+FpiPX/XkNuHxk7+qhdYJCCCHNirYSDmDeLXBtIoMcAooKd+qlwuKLOgPA8K02O
         OGKA==
X-Gm-Message-State: AOAM532L/J13njkPWWd2l0ZtS6jCRUpZ5FQiUtlojMXirsitm3UodVB9
        KcJVlzAOJSajhcWYKYa7jxg=
X-Google-Smtp-Source: ABdhPJyHgHw0TD2L8PLRIyuqW5l8vqkAxeQcIsP1fbVro0ayBdKv3oL5uN5etQVa4zy12dSKp0DB8Q==
X-Received: by 2002:a17:907:1002:: with SMTP id ox2mr25087144ejb.337.1621898556164;
        Mon, 24 May 2021 16:22:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 09/13] dt-bindings: net: dsa: sja1105: add compatible strings for SJA1110
Date:   Tue, 25 May 2021 02:22:10 +0300
Message-Id: <20210524232214.1378937-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are 4 variations of the SJA1110 switch which have a different set
of MII protocols supported per port. Document the compatible strings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/sja1105.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/sja1105.txt b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
index 13fd21074d48..7029ae92daef 100644
--- a/Documentation/devicetree/bindings/net/dsa/sja1105.txt
+++ b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
@@ -11,6 +11,10 @@ Required properties:
 	- "nxp,sja1105q"
 	- "nxp,sja1105r"
 	- "nxp,sja1105s"
+	- "nxp,sja1110a"
+	- "nxp,sja1110b"
+	- "nxp,sja1110c"
+	- "nxp,sja1110d"
 
 	Although the device ID could be detected at runtime, explicit bindings
 	are required in order to be able to statically check their validity.
-- 
2.25.1

