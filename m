Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8837B34D400
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhC2PeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhC2Pdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:33:39 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B67EC061574;
        Mon, 29 Mar 2021 08:33:39 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id y1so16385063ljm.10;
        Mon, 29 Mar 2021 08:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ktl91u+6i2FDi36gd93XSP7u6zX63G4S8FcsPppuBok=;
        b=E1EG6YLTQO+IqCI8yF3MTXrIJZdBuCBudX2yspne0z/Bdt2dsObL+Hp9r7w9z8qj+3
         nG9EtW2JeSx2RQMA0aPidmSMnizGNujUrF/N6zSOz2CLBnJ76llY8+NIjUoUYXJXkeLn
         AP+qRK7HWZyeAZNEQpVq0g/O4ZjqXvA83zTOfVnF3yJmJbfyNH/HPt78A0JebI2PJuHB
         ym1ob8pHMwk/5p1q/NrHAmkf294n3KsvAPdINEc47IuCu/nKmC7PvaBl3mtNUzahUebl
         4MxoDyAkU8nSZ3jW6FmkINngohcKYXchjIgwPyx+B0hSA6jgGSLtCsYilVn4k82ZPg5B
         dNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ktl91u+6i2FDi36gd93XSP7u6zX63G4S8FcsPppuBok=;
        b=YB//52PhAAV7kig4oTL4WgwwTk//LNXlxIpIeTyq4uS8SRyf76iJ/GvToCES27PudN
         Ej2Mhn50mnhjr9JpPig5xRS8omBtFLw6hMYykdxhnh+oMXJfIjvAV15ke6Ro9RyMpyhD
         5H4Ychd2355vWjkXbYlSUdVTwGsKgnVFRUiADPkc1cf8drK+07Rqkp9IVEk3XdFHYkoc
         DiOg6ufsCuXt3iHlhh7qCZnijdNECULjg0uTFl07DtdpQREQzrpj5OsZzk1kRmLSZY7o
         6ytMTF6l8bE49/4uoJ7S3cUJXds4RQnnskcmfxonHc8egJIhxgkG0xYHOizfnTgrljGX
         /T0A==
X-Gm-Message-State: AOAM531bwx9HG3SscOYFOYgcj1la8snCrMozubQsCAL/I+g5AY4eYWIV
        IKpsN8UIAu79WFUx4JJSp2U=
X-Google-Smtp-Source: ABdhPJzIaDmWQh93tZglZ8hQeDfOUoOxtCTkFaimpYMGp2SLDDP+2uPglT4qug8m9WlF1WRF0ctB7A==
X-Received: by 2002:a2e:8616:: with SMTP id a22mr18140346lji.509.1617032017798;
        Mon, 29 Mar 2021 08:33:37 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id c9sm1112144lfv.10.2021.03.29.08.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 08:33:37 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net] dt-bindings: net: bcm4908-enet: fix Ethernet generic properties
Date:   Mon, 29 Mar 2021 17:33:28 +0200
Message-Id: <20210329153328.28493-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This binding file uses $ref: ethernet-controller.yaml# so it's required
to use "unevaluatedProperties" (instead of "additionalProperties") to
make Ethernet properties validate.

Fixes: f08b5cf1eb1f ("dt-bindings: net: bcm4908-enet: include ethernet-controller.yaml")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
index 79c38ea14237..13c26f23a820 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -32,7 +32,7 @@ required:
   - interrupts
   - interrupt-names
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.26.2

