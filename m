Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB54468505
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385048AbhLDNV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:21:57 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:47257 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385041AbhLDNVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 08:21:54 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MowX2-1mEMco0370-00qOtY; Sat, 04 Dec 2021 14:18:08 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC V2 1/4] dt-bindings: add vendor Vertexcom
Date:   Sat,  4 Dec 2021 14:17:48 +0100
Message-Id: <1638623871-21805-2-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
References: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:m8jfn44LjOO8dWB6QeHDoXx05s58wCozD503M6qRBLgQl6yqUKA
 Ovb8vJwHyDNlc1ITMIL4zXeRX5I+5bmKK75YkNWF2EfqyCoHkUvSZJ9CxbUKr7+JzflGuuo
 x1TtZ6wFPXG2kG4DM7O50qjCxHJIv/uTNvm6oiQwZlAzyxBlqSCv1B5s7YkRt9zrfRrOzhv
 qIKj+IbbKFR85Cnb/6wIg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5SgUFgdllKc=:QHMb5NSrufhsC0jC5ll2Tw
 IUtyqWOO8FLx2sDVbyk8XoKtiGaR8qGOWcpniKFzVtZUuRu8/Toq5idl3ugzQFhSdY8DZzo56
 S//Ku3B5wzehk6ptTszjozDhM90PDMuxfPcsfvmOCLvDHc59Z8tIOgQlDHyNiBEqG4o8wtDxX
 ZgxiNIwq/UzWEF6iiHYdBltH/+xoLZ65ieF2wpHgV0pNRj3JPi/CcE0rEh67VyLums52CJu3Q
 IzS0shWfkE+CLKJa/oyqWScEcmJTkCEspdnTXge/FiiZiek7Fr/dlIxI6wTn9fEyqFdPgIe+B
 3IVln19KkmVUKfKlsdvcqALMA4wBsCgplz0o1p8lWXp1FMImdoWWTsGoquYAAer82OLlxg8CQ
 MVVL0d3sR+/ZsZ1e94b7iBj1rUKmlhAXW+oIX9TdzinEGrf/BJPhNMXusx5xa4HIdLidmtguN
 H+fycSW3truI6DAVFrP23bUJvPCEqFTDivmK7PVJl+5eiht+YpcYm3DDrbjywSj1pQlbKTEvr
 l46ndSO5P6ancBxhrCe/0/VxRvoek4G1YNUmP86nyB1Z5uJmBZGSIFvcUw1sZElCBzJQ6PfxR
 LGf8AG0aP0Za/0A0o5wjCm8VcHJ92qyEoAwmyk43VOsgeAyd9afW+svNpMEt9In6YB/L6E5W2
 Ylvt0mDIE3gp6hGvkX4vm7AilNNIWU/uXQ2CKRjdaLDzSknPyXqOAt3VjsLkFez9y23cgR7MP
 /WTmIOk1L/w5pf96
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
index 84cd16f..2ffea43 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1276,6 +1276,8 @@ patternProperties:
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

