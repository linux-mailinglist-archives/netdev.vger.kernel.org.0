Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CB54284BC
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhJKBdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhJKBdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:33:04 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4D0C0613E9;
        Sun, 10 Oct 2021 18:30:57 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a25so45264479edx.8;
        Sun, 10 Oct 2021 18:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q+gt+Asy9EIixi5Pp3kauqDHjtitdqAqEC91C3WQnsw=;
        b=hayBAxlziJa0Rt1peTo5xq7ogkEKGScKuj4SnJnMPSH33dyxE0Bh1MIp/i1E8S5Edj
         RZjel0MSFobq4phCvig1Boz3ZLTfbNPAADOYqGFG6YpLtOP8JNz0De26ECs7TaJ0BdIN
         7cyHM36hCk1H28O21aqhE8q4j8IAvKEeYsGM8w5Rox8s7YPWquOiS/uIENBf89mnv6+p
         0N0+P553XMutl+ag9JnUWWPx4fCIVlg9Ldu5Jh4sq4xsF2nAaWMcJ2R27thUA2V9PRyO
         Sg/VFgpd4yUolPO/p3enPH8j4oCiB3a2IRN3xOC+n7m9TMd13PERyVbvlhw0FtfIb2h2
         fL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q+gt+Asy9EIixi5Pp3kauqDHjtitdqAqEC91C3WQnsw=;
        b=auECjpyWm2H9mCNm2qsTxO6j48RaZDt+S/VGZph03F/nId1fVpAnO93FQxgBu+/Rxa
         gS/bWkmwGhzbwumWiL/0zU45T4IH2ULZZeOf49mx2Sd0cCJg6Z0ObIjU0iTVlNiJtxO8
         OujwIJQXUCCVv6uvH9KCgynF+aoegLh/TnWTMM94xKkLdhJuxRf4IiPb1lAPGseeI5dq
         Cfls+Qg4kyOou78PfrECO4zHS0EAFJ1CKpa9hE8SGKGHNpS9ThSrWJWiApxH76o3BidF
         CrcA5OozHQYMslc9INLif0hfvccNRwLbLywFcWg6tpdNJwSvVyxdXQ1Mca3xDdpSUzb2
         eMOg==
X-Gm-Message-State: AOAM531WZjSOg4ZfaEadKTpIXngLKM4Txv3n3JyYUe/twtTvRb82gHPH
        vLQbc0yspvzcWPpGPunhAAk=
X-Google-Smtp-Source: ABdhPJwNSeASrH4SyWRBUE0OpH91C2U4Z/HnLwaDRx+CSRkCq/xGsGCRm4d4zd0DT3GTvgViKXiWDQ==
X-Received: by 2002:a05:6402:7:: with SMTP id d7mr37925885edu.265.1633915855711;
        Sun, 10 Oct 2021 18:30:55 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:55 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 11/14] dt-bindings: net: dsa: qca8k: document support for qca8328
Date:   Mon, 11 Oct 2021 03:30:21 +0200
Message-Id: <20211011013024.569-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8328 is the bigger brother of qca8327. Document the new compatible
binding and add some information to understand the various switch
compatible.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 9e6748ec13da..f057117764af 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,9 +3,10 @@
 Required properties:
 
 - compatible: should be one of:
-    "qca,qca8327"
-    "qca,qca8334"
-    "qca,qca8337"
+    "qca,qca8328": referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
+    "qca,qca8327": referenced as AR8327(N)-AL1A DR-QFN 148 pin package
+    "qca,qca8334": referenced as QCA8334-AL3C QFN 88 pin package
+    "qca,qca8337": referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
 
 - #size-cells: must be 0
 - #address-cells: must be 1
-- 
2.32.0

