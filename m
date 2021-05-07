Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9776337668C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbhEGOCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 10:02:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25738 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbhEGOCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 10:02:16 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210507140114euoutp022b7e65dada78c92a276ba77b47f4a927~8zaUL5QSX1827318273euoutp028
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 14:01:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210507140114euoutp022b7e65dada78c92a276ba77b47f4a927~8zaUL5QSX1827318273euoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620396074;
        bh=w5Gqb7BvvRqY4m23FGJR7afb4SpYR8lKibM76Y7ezp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aw5vk52c7z9pLQiiTQ4mlRKEekhUsmGTRgzQpkBInDIpWIpM9xGLNOYPaDxuiL++o
         92nzi4/HwuPu5yhHNUsAxuGGjmIPAye5R63UWCL7hdV9LoyO2Fwfm8qQEkwOftp0ct
         9fctFMFihZLDyqArzUesbHCKokXtbuNzA/YSNSRU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210507140114eucas1p285a6ad2380d7418ba21a1c21a8f68ca4~8zaTs3TaP2197721977eucas1p2i;
        Fri,  7 May 2021 14:01:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D0.8B.09439.A2845906; Fri,  7
        May 2021 15:01:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210507140113eucas1p13dc9798741a7ecad721f07efe543b56d~8zaTKkjs31878618786eucas1p1u;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210507140113eusmtrp13055df521d5f448f9c44ea1cdae0b74b~8zaTJlxRk3079830798eusmtrp1a;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
X-AuditID: cbfec7f5-c03ff700000024df-20-6095482a822a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 52.49.08696.92845906; Fri,  7
        May 2021 15:01:13 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210507140113eusmtip1276118451be30072731a98b2f327ad83~8zaS5v88o3070530705eusmtip1H;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v12 1/3] dt-bindings: vendor-prefixes: Add asix
 prefix
Date:   Fri,  7 May 2021 16:01:08 +0200
Message-Id: <20210507140110.6323-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210507140110.6323-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTdxTH/d1He8usuxQzT3DBrMFMWaROjftNiEJmlpssPrYsm4+oVHpH
        dYCmlcl8BASljvCYPGLXNoEq8pIJthRrg3PpirhUW17WR+SRlEECM8B4BDChs71d5n/ne87n
        +zvfk/wYUtZLRzPHMk/xmkxlulwUQbU9WPBsiOMqUza2TFHY2+8k8W19M41N3osUrnJ5aHxt
        Qk9j36uXNC71j5PY620R4662Eho/d9YjbPH7aNzrMImw3vsbgZ2V9xD+1dUvxg+q38OX7rnE
        ONBuFyfJuF5fN8m1NjwnuLuGfjFnafxJxFlrcri79mmCK2ltRNy0JWYvcyAiUcWnH/uB1yi2
        p0Son5jyiZMLouy/Z2uIXLRAFyKGAXYL9D6OKkQRjIytR5A/00EIYgZB4JY1LKYRWOf6xIVI
        EnLYKszhQR2CYYeRFsQoAmNtbogSsclQeuNhaLCSHSChWTeEgoJkBxEMjN4kg1QU+yXkuRdD
        DopdC0UvdKJgKim7DQL2b4V1a0BXd0cUrCVsAgz90x/CpWwk/PnLMBWs32XjoCnvaagm3/D5
        NiMpeD0ScLkThEN3Qk33GaEdBWOdreFr3gd3eRElIDlQXrY1mBLYIgRtpnlKYBLgpWcxlIxk
        10OzQyG0k6FnwEoK1hXw7FWkEGAFlLVdDbelcLlAJtCxcKu0PfxgNBSP1aOfkdzw1imGt+Ib
        /t9VjchGtIrP0mak8drNmfzpeK0yQ5uVmRafeiLDgt78O/dS56wd1Y9NxTsRwSAnAoaUr5S6
        r5WnyKQq5Y9neM2JI5qsdF7rRKsZSr5K6rA1HZGxacpT/Pc8f5LX/DclGEl0LoEGU8926kRH
        z37+6MN9I68n7hdUH/4ryXwuupLTDi9vSqq4GLt04T6wxzfZaMXh6x8U537qN+YE9t/+TLWG
        Y+zE8iR1QuwOxdNDQw3S/eRXfv5h+uZDRDX3otVsmi9zFrvaF1/LPjo33rH9a7v55o3s7+ZK
        LlypargTUE04RnYrVDNVHXu7Y3yfjHyz6zQ6r6+Y7dFbkeXKzrmpAs3S5Hz7MMru+2KPkVud
        cbDndwXsMvtdqCVxIPJ88iWWrrU1PKotmBpctizHFGNfO351fnSyx3Ncui7xYFfqdftinXXQ
        4dvwx+6j6r7USFeVQf2E2vKObpskr2xp8nKRaodmY5ec0qqVH8eRGq3yX64rVODmAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7qaHlMTDL7PkbU4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZV+c0MxX8ZKt483UJUwPjT9YuRk4OCQETia1TFjJ1MXJxCAks
        ZZRYd3MtkMMBlJCSWDk3HaJGWOLPtS42iJqnjBLbpxxhBkmwCThK9C89wQqSEBF4wyzRdO8t
        O4jDLHCfUeLXpxeMIFXCAv4Sb+5OYAGxWQRUJXputbOBbOAVsJL4vyMcYoO8RPvy7WwgNqeA
        tcSDT3fZQWwhoJKJmzqZQGxeAUGJkzOfsIC0MguoS6yfJwQS5hfQkljTdB1sOjPQmOats5kn
        MArNQtIxC6FjFpKqBYzMqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQIjfNuxn1t2MK589VHv
        ECMTB+MhRgkOZiUR3tOLJicI8aYkVlalFuXHF5XmpBYfYjQFemwis5Rocj4wxeSVxBuaGZga
        mphZGphamhkrifOaHFkTLySQnliSmp2aWpBaBNPHxMEp1cAkwCG445pTp1K2j0LZnok3FqTF
        njBee3O2C+O33/WNezc2XNLeeMl83Y2ZLy8XTtp+5WXxjjd5c9tOnuKf+WPby41XXkhN7u/9
        PblbcvIlkZXp4Q/OzbPcuvOd28+EB33xb8Q/mizpfDWv5glrit3JbQcn7P928tH6Y6pRfzsv
        Gx/clh1vePnDqpA7M00fOS5nWDUvedmjvW7HxDTFNF9675l5nD//Qqrz3u3f5yw40cb2mpU/
        SftUlOvR631alz9UrheX2/Bsqif31YWGh/U3PPLUZc4+qPwza98zaafFU5+WrBLj25O8+OXC
        i4JsXOpaTJK5zxXDr375elzCxZO/t0xC/IJsT6lOukrG/4MZ1leVWIozEg21mIuKEwEwghdX
        eQMAAA==
X-CMS-MailID: 20210507140113eucas1p13dc9798741a7ecad721f07efe543b56d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210507140113eucas1p13dc9798741a7ecad721f07efe543b56d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210507140113eucas1p13dc9798741a7ecad721f07efe543b56d
References: <20210507140110.6323-1-l.stelmach@samsung.com>
        <CGME20210507140113eucas1p13dc9798741a7ecad721f07efe543b56d@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the prefix for ASIX Electronics Corporation.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 99a72a480d32..06c32644a9c8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -131,6 +131,8 @@ patternProperties:
     description: Asahi Kasei Corp.
   "^asc,.*":
     description: All Sensors Corporation
+  "^asix,.*":
+    description: ASIX Electronics Corporation
   "^aspeed,.*":
     description: ASPEED Technology Inc.
   "^asus,.*":
-- 
2.26.2

