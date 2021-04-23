Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C80368A9B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbhDWBs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240186AbhDWBsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F2DC061344;
        Thu, 22 Apr 2021 18:48:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z5so19207359edr.11;
        Thu, 22 Apr 2021 18:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffA750f2MevOaBc6ScKeZYtWjDObG1Cn21hSXSP5XoE=;
        b=MKXzRE3T6R6O0mtSFBtQVR+FOcumeaR2W/3fKiDZGL2XBnIexNWWzBr27eh4o07eyq
         LHnGXkAvKRfwqMBx921jOquP/4HUDryRdSa8ahTFRArF/2htspnSiLBge8vI6kxVS7ND
         P/n+PfglIM3o3NmRkcwb0NV0uQAMyla7DJxt1pIVc9BY7J3U+RsJTKHzuL124iNHWAEs
         7711usXBUy56s54fo75RycVHu5SfSXdYv6SoxYREcL7oTFt+6bD9I+0nlwJke4Aef/rb
         5KLM87kE3eKlB9k9JMIVjcOguqroEsem47N0pBTkrFX7vM4my86kLy1ddFFVC/QBCTCW
         JuKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffA750f2MevOaBc6ScKeZYtWjDObG1Cn21hSXSP5XoE=;
        b=f0rY1IaMMz9fGY+9XjnuB9UurAxHNBGCc7eJANMjOlNWJaJLrBJHw8qPUpuowTY3z+
         6p6KmGO+CBHnxnI2oU0OF/xo7hhoX3LSK9UT5UJkEaN4933PlrKLyL+v/Hezf7Vp4ylk
         bq6NdMKePSpq2lLrHgD0iPQk9xC7UH2o+G3k7kSOhSqT/kBMLCdWQFG5xiEqAOP5r2bS
         wFYwU+Xwl0pIJYanDeW1HWzFu8pL2aZ6bJ3rggTrBhlWLf2KvYVuTEzDNhAYgulVAfF+
         5fvuZl6Wze/5Kn9XUY32C5aWIRYSturd2feDuQcsHeGYKTONJic41E6x0zlUBVwFzNTm
         3+ng==
X-Gm-Message-State: AOAM532z2cROXIPyfEShsIC0baxXClgK/49cS69+KIJ4shfLiRMTARM5
        o9KgvoOuS5Dk7JOUw2ag5fM=
X-Google-Smtp-Source: ABdhPJwr1D77jjbhTkmSUYNF9HmT8eez73pQfDWrua0PReuVNbuXdPP+C/oBrmhSCOv9aamsp/JYSQ==
X-Received: by 2002:aa7:c90e:: with SMTP id b14mr1572870edt.93.1619142480991;
        Thu, 22 Apr 2021 18:48:00 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:00 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] devicetree: net: dsa: qca8k: Document new compatible qca8327
Date:   Fri, 23 Apr 2021 03:47:32 +0200
Message-Id: <20210423014741.11858-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for qca8327 in the compatible list.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index ccbc6d89325d..1daf68e7ae19 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,6 +3,7 @@
 Required properties:
 
 - compatible: should be one of:
+    "qca,qca8327"
     "qca,qca8334"
     "qca,qca8337"
 
-- 
2.30.2

