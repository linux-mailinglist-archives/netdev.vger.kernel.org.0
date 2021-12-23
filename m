Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6405B47E205
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347908AbhLWLIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347895AbhLWLIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:08:11 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F88C061759;
        Thu, 23 Dec 2021 03:08:10 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id a37so8430834ljq.13;
        Thu, 23 Dec 2021 03:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KnVwXtElgkqludi56UdcLE42+Lel1OeKyHXLPGAi3Yk=;
        b=QT0FMS5l06BCQPHuZqFcYx9kbLvsIlr1SPQMCgULHyubHtN8OATPOzeaRgnVc0WTMh
         sjndt3Y/7jKrRdGIdsO0TQSzZMrvWH9O0IwrZxHAF0s3GuUR8itYdLUmNkRGQoLRi70S
         UOjW0KHX579tSsfv9EayVRtKQ6+IV5qT0wy9MAlItVw+/Y0r/ZS+lRqFgEyfQDjWX1I4
         kbyI58lrm3YM606HlRrFdqRxbzq+NAJNVqJztH8EgJlG/PE/jcW6UAV1chWcy0B3EvG1
         kkl1pdrWfxJU4gDsVMtKg7x58qLiDMqFO2cXPJFq0vqunlTbBDznQ17qjayrJAwod3f7
         uwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KnVwXtElgkqludi56UdcLE42+Lel1OeKyHXLPGAi3Yk=;
        b=s+A3ALsSX8t/HgJWQeyc4Fa8ZDbjRt74XRVUiphK3WZlD9kNXSr5wj190khKYAcEOa
         GNiBLh3J5o9ctJXZ2D2lmtx7pAG4AwnEcYErAER7fFgC9pcvKG3qRcXzRxe5BYZxVdaX
         Xy1Bqbug6KZ47X4LPtX5c158ck8mc7P6sTNhSu+U2CQ2DX5ncKVEXhqkp1pEupUtav96
         luwFeaJebiEO9HmDyk1u8qM5Cwa4ctuyH8vfRyWu8hQXTLlRkUW7AGLEJIopse9C463E
         j3wcztV+xw501J/XUEf0hEqTzUr7pPx2TinGcKoXr9QTaheQd3/cAol1E0+FDA7nikwg
         yDmA==
X-Gm-Message-State: AOAM531ShibgDZlc1fH6OOh5im8x1tXf8v/PrRAQJutMZxrcpwqqhubK
        SBRi74yCcrFZEptAIlAqYJo=
X-Google-Smtp-Source: ABdhPJwbXuWbb49XNu/OZB3UxNVRNFvpamPv3uvoYM3UqOOry1TcXEdws19cYreV4umO4zkkw0cNBg==
X-Received: by 2002:a2e:aa14:: with SMTP id bf20mr1349678ljb.169.1640257688524;
        Thu, 23 Dec 2021 03:08:08 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t7sm473047lfg.115.2021.12.23.03.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 03:08:08 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4/5] dt-bindings: nvmem: brcm,nvram: add NVMEM cell to example
Date:   Thu, 23 Dec 2021 12:07:54 +0100
Message-Id: <20211223110755.22722-5-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223110755.22722-1-zajec5@gmail.com>
References: <20211223110755.22722-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

NVRAM doesn't have cells at hardcoded addresses. They are stored in
internal struct. One of cells set in almost every device is "et0macaddr"
containing MAC address. Add example that show how it can be referenced.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/nvmem/brcm,nvram.yaml | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/nvmem/brcm,nvram.yaml b/Documentation/devicetree/bindings/nvmem/brcm,nvram.yaml
index 8c3f0cd22821..840a4559b2fd 100644
--- a/Documentation/devicetree/bindings/nvmem/brcm,nvram.yaml
+++ b/Documentation/devicetree/bindings/nvmem/brcm,nvram.yaml
@@ -32,6 +32,10 @@ unevaluatedProperties: false
 examples:
   - |
     nvram@1eff0000 {
-            compatible = "brcm,nvram";
-            reg = <0x1eff0000 0x10000>;
+        compatible = "brcm,nvram";
+        reg = <0x1eff0000 0x10000>;
+
+        mac: cell-0 {
+            label = "et0macaddr";
+        };
     };
-- 
2.31.1

