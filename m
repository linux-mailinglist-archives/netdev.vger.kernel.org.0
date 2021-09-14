Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1C40B2E2
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhINPUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:20:21 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56241 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbhINPTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 11:19:13 -0400
Received: from stefan-VirtualBox.in-tech.global ([37.4.249.93]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MOzfO-1mGIqB1v24-00PIhc; Tue, 14 Sep 2021 17:17:43 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC 1/3] dt-bindings: add vendor Vertexcom
Date:   Tue, 14 Sep 2021 17:17:15 +0200
Message-Id: <20210914151717.12232-2-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210914151717.12232-1-stefan.wahren@i2se.com>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:b5Mff13jkDoHvc3OdwxjtStzJ1O9a5xQlsAiO8TVx4ZV6IRnY1G
 IJWGMpbAL2jEd1Rm5Bw6vxf6YzvV1f6xbDKCz5DCfzi17MrYLNymaw5TYjO/EdxCuAzxJvP
 SplXaaCHj7/luw4oB3Pi0Fbg1HVO/95lTHyJ+cc8RJT/6oZYgOekMb0fxMdxYwrZWha7ddX
 LTqBnYeR8t8GRCKlRNuWg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ed0nwGuGhXU=:R1eO/m4Cfn44U3u03BU49d
 pxbD+xuVKN0E9XQm6fZp8j4uzUsYhffCjU/Zcdh0rRhQZMdpCl+rDTnkByzR6hsIXIFbQQh6q
 a6P6O9jC7e9BeUlik/LBLwEsmC074UzY9s0jvvQhx1iM4PD+YwtHFaWOdUqg/5R/a0VKOzptL
 46VC+7fPJ34cG0PpibMlCDE4SE1KHNg+Z45gA3JBJi2togXbnoNb3kMTJu1EZLOU7VhIvD8H+
 HQYANvwUlD7zbxZO6nOosjUZmbKU6DWX72ZIp9geu4XoXCV9f9PxEa2HJql+hx33U0s+b4e6t
 trw1pSy4+u6BJf8cBNr2a9x9wLT9x+YNpC1pSE5v5YAPq4MLCbr4S/yTdOOAqYgFEjZA/xGVj
 lHsmgkbHiXGw3uzP/AcdFXCAwqF7GjNRLHt27k3MKLM3CJpE3cNBVz+IlmsIZa/p9n7MOT7H6
 rzXygkVnqKBpq/kXjM6Ew9XqcincWeqTlxbb2JWb13IFk5EmV/IDuoL6p7TN0U9nms6Lp8MnX
 bzpbKlZboWj5iLyo+hWxk1Nd3EORxnPJ1rjsJ0ORgTgxpm54GEfAd7gTsC/NgrLla7d4Mq7ZA
 YGl4W+D4t8UobhOrZaYV7gGoFJ8akQdCi+k2Eauby7t1rFFheng63TtmWNjmr3PvW7pkRjb0O
 BOzGzYtiC49L8u8uOolwmMq6i7FtWv/OsAN+Ul3nNjICW3dsYpe88lfw4lpIF/QQWuePyq817
 E/0AMDLZJwiTbDVnb08EkEK2hvZ5JEs73ydMGCAJQS06qu22P6gOv2r2sio=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add vendor prefix for Vertexcom Technologies, Inc [1].

[1] - http://www.vertexcom.com/

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index a867f7102c35..0610e4323724 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1250,6 +1250,8 @@ patternProperties:
     description: Variscite Ltd.
   "^vdl,.*":
     description: Van der Laan b.v.
+  "^vertexcom,.*":
+    description: Vertexcom Technologies, Inc.
   "^via,.*":
     description: VIA Technologies, Inc.
   "^videostrong,.*":
-- 
2.17.1

