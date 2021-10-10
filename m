Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701A9427E5F
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJJB7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhJJB6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:24 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C209C061777;
        Sat,  9 Oct 2021 18:56:23 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g8so52055801edt.7;
        Sat, 09 Oct 2021 18:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0aDD0ZRLezKNP93hdNBNXpgtETt+h6AkeOIcfTrSqio=;
        b=koCaojpHgAJfjGz2i2z2pt67cD+gREhciubz6P962AB1GeBz3YJDcpgLfME4Flr07Z
         k5c9JUxULPg+uQbKAsnh7uTcmfF2Lqa7v8j/EmLA4BJn4SKuZzYJa2/Kou1pecs4+sKA
         HqhhVvK0FEftIcTJSApKPOmzfJTeUqM50j/rt3BJcoK0SrtJ2MZipdrwtrMfD8O5sdLX
         8Zv8dvZcMBJeTfrruj43Q2xbXpsfdIW1e7P7DJXaBqB35XjtJ9IXKDLxzeNs5LjpCbRA
         qAWdJYBMWzjX7JOTt/Ln3QKiwaQNUvCYGDzQ/HYxjwlPOg8lnQc3ONA/H+8RIimP54UJ
         Yq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0aDD0ZRLezKNP93hdNBNXpgtETt+h6AkeOIcfTrSqio=;
        b=3VyTqGbqZ8YbkJ7tHDPFG5LHdOiJLjEysGtge1RadcbtnnTvaTg0rMzCLlTdm165QG
         ZLn086scgLqbUgqMPFunQX5+BJKvxm8qyoEU2WqG1GDrg0rJeBFMDZopQmB8nFRGthPq
         rbxiXiJG4qecGY0DLbtZiKSOaqCWyValpJZ1Xcc16LHklaOJU8IJWsiCvKkWX7/Vf+h6
         ReYkXCMbpk5iWoFLBQMQuvqe1EuytguutE8BcMyAFohIF3o9meEX4mzw7DksWxAgJ3qW
         7d1h2Vf5mwWzzyN78qF8N24OF6eovIj3V33QLCAksdCYOhKCK+EvOOCHyo7mZQ9c4pfA
         nhwg==
X-Gm-Message-State: AOAM532aCFTaTD/XPQiZKt8oGGkPR9vi8p6NV+YQ+j3TVQ1/Q2u+ISYY
        NQNILZp5iZQXx3BQcfcWq1DJg21yKSg=
X-Google-Smtp-Source: ABdhPJzVDnuJv33Qmd9lsrqBsM7r+eAKHsD8JIxGOpfzqxs7cLmY95k/nYriTc6QtG2UTzYlR8HsjA==
X-Received: by 2002:a17:906:a044:: with SMTP id bg4mr15019090ejb.312.1633830982264;
        Sat, 09 Oct 2021 18:56:22 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:21 -0700 (PDT)
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
Subject: [net-next PATCH v3 12/13] dt-bindings: net: dsa: qca8k: document support for qca8328
Date:   Sun, 10 Oct 2021 03:56:02 +0200
Message-Id: <20211010015603.24483-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
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
index 71cd45818430..e6b580d815c2 100644
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

