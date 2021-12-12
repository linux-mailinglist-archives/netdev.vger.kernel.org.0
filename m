Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6193471AF7
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 15:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhLLOvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 09:51:11 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:51491 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhLLOvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 09:51:10 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1N8GhM-1mRsiq1NVQ-014Ejq; Sun, 12 Dec 2021 15:50:52 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH V3 net-next 1/3] dt-bindings: add vendor Vertexcom
Date:   Sun, 12 Dec 2021 15:50:25 +0100
Message-Id: <1639320627-8827-2-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639320627-8827-1-git-send-email-stefan.wahren@i2se.com>
References: <1639320627-8827-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:bGM+akImUbUuH0wK7AjcJi62/klv4j3a5IXQv+vN0ZOMabhrLKk
 TO4CBtdWL3A2Rs6cgZm7KpxYykj+tH7b94G97Qdfb/jaSUFS9tVb4AS/HI0V087kmT22JSz
 vhCUBUUgyUf5Vp1/RDEY6D58nCpsqNitJXE2DKyC0mLv6rSAiPH+BajlEAzgqKw3u4KSBm4
 WieVnTzqL011rPKGiBERQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CeUaUEyX+ic=:KLO/OFRfFJ+pzKzovht1C4
 eTAxGpNXKoKHFVOyGS2hPZKC+AzYmyTsOh7PhGWiNJ4zkNEfngV7d+C4H/oxiP0fOeEEbKr/Q
 IFTJpmV1doKZprXT4KBIWd/JrF2HpgWaqw8GWjRxnwwBR9zhGBU1uOd8aNZbbeHZSLk+ibyJN
 ZQ8NxhgpwGe4YbHEfswRbicSG5Mmbg/YY82qYB8/F+BnG3vZwnjd/762U+IgTx9aZ/GHDNnWE
 k2ff64iUY4gemLKL5mn4kUfYSo/rHvS6GC0htvLSGCFib6vO6aTgsHViTVcBw5QPt0hJhIl3x
 H3cubtr09CHch3Lyxa/qEJjdC6AdUTZgoq/jvcOJt9Jm1t1mjg0dysYKAkD9mV9UerhR3hpE2
 eacFqGk67eIq9bDVJ/7i8Rp14tfD8yphMoyRwtibr9fKiiAJubQbzCPwb+pUQuj8yhoMs305A
 g1z7EMCrwfFqESXM1XurGg+nN4twGwu/G+jQan5oN83TNKfSgCfSlHN9O9O3Wj/Px7PJWbxmG
 VgXcbmXy8SVjQ6wpH4Q81JUrMROsVftySjrHkoeA9/h5HYxOQX/rrvcCNp6y4ZlkrqWeABhQX
 lfIGGCZh6SUUKd7vn0cBk0zyJJPxKb7esaSmpVlqRQECfYYhCZ/O9WrA7mkPYqLFJVPyUtVzH
 qHiulYRWvuBz5kronsPqv8+VpcWI1nS/NTQBQRtDlJ7ggXjRnJ8IPa/Swuumyqsatf/sjNkya
 60gFHAi7OxWMD+cb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add vendor prefix for Vertexcom Technologies, Inc [1].

[1] - http://www.vertexcom.com/

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index ed76d77..932c5de 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1278,6 +1278,8 @@ patternProperties:
     description: Variscite Ltd.
   "^vdl,.*":
     description: Van der Laan b.v.
+  "^vertexcom,.*":
+    description: Vertexcom Technologies, Inc.
   "^via,.*":
     description: VIA Technologies, Inc.
   "^videostrong,.*":
-- 
2.7.4

