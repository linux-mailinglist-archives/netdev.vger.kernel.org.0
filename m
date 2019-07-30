Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9E7A5C7
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732381AbfG3KPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:15:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36359 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3KPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:15:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so51996569wme.1;
        Tue, 30 Jul 2019 03:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVU7dcKnZxmoH+SxOZdfSqf5xlgkIFadIRCSelRa9JA=;
        b=Ysem0CmnInONBZ3LiG/kpOfOzWitwDmLkWel2j8QB50n9D1njDjIsuWmY9YDFTCda4
         sF1R1zjRzlgPiWs7zR8NGar9TIAanGNGQ8JKwgpGHCF2AsZf1FsQMb12GrRF0FXCS5Un
         NDsktmbyS5AdFMAKUSf/+y/UO3wtH7u2uvfnIYV64vzZZKoMPjcmuJAHaf0xh4+HjR5J
         WvtvGshdGDJVrxiSpAd5oWDkJb9ydmq2lzQ0S47gRojJezEfPm5n4CPtb7E+fruxEic4
         WUj8AKALgH12dVaLWMGx4x+WY86LXXOZ2iNi7yU9X0rLtx5qr7yMhRL9urn34iIv5Dj4
         SqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVU7dcKnZxmoH+SxOZdfSqf5xlgkIFadIRCSelRa9JA=;
        b=ZX5ckupzcMZCaTcdfMY3DCHqZwmN/Fqf+NG470EJ+KrogIi1s7nT7ybrGLAHZjRVt+
         r28y1FsR+k1Q2m34ma6xKtL5RG1uVWaxs3LOcEAGoPgzZZNxb/G52FSEa2KBLMnw259W
         kqUK6yKFpUMyWqKkSjQBdXYwD0sTGTJFxSQvyHLr2g0gfGBnNpvBprHDokrz2888c4uW
         +G4FHXGvhS3M3DAXrDfoQ02CeFWMocZEwCEsscmpQ/ggDPEISr0gH6GViQC70F12+1dM
         6GClZb+ias+8ZAzI0lXPCa/tu4UU6aKcjJhY5EUu8Mth3CnrWZEwQh1cT8CwbOK2a2s2
         cClg==
X-Gm-Message-State: APjAAAVUP+FbnKJsVAhn3g0TJp6n91iyZKFesbGPUkr7u5scnAWicWQS
        3VyBtwrdj9uwtr+vwX7hPpbEcn0d
X-Google-Smtp-Source: APXvYqwbMRvlQeMddYpL9X8JWlwIjhI8TQON2haCjyRhiEogm4wS7uDZG3dXGkMdNtgansppxW/BaA==
X-Received: by 2002:a05:600c:24a:: with SMTP id 10mr25179505wmj.7.1564481700248;
        Tue, 30 Jul 2019 03:15:00 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id w14sm50923832wrk.44.2019.07.30.03.14.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:14:59 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/2] dt-bindings: net: dsa: marvell: add property "marvell,led-control"
Date:   Tue, 30 Jul 2019 12:14:51 +0200
Message-Id: <20190730101451.845-2-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190730101451.845-1-h.feurstein@gmail.com>
References: <20190730101451.845-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this property it is possible to change the default behaviour of
the switch LEDs.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/marvell.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 30c11fea491b..5e094e37c76d 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -46,6 +46,16 @@ Optional properties:
 - mdio?		: Container of PHYs and devices on the external MDIO
 			  bus. The node must contains a compatible string of
 			  "marvell,mv88e6xxx-mdio-external"
+- marvell,led-control   : The register value for the LED control register (
+                          Control for LED 0 & 1). This property can be defined
+                          per port. Example:
+                            ports {
+                                  port@0 {
+                                          [...]
+                                          marvell,led-control = <0x11>
+                                  };
+                                  [...]
+                            }
 
 Example:
 
-- 
2.22.0

