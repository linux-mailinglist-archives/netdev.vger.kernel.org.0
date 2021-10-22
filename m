Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820DB437AC4
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhJVQT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbhJVQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:19:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B121C061764;
        Fri, 22 Oct 2021 09:17:10 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m26so4085133pff.3;
        Fri, 22 Oct 2021 09:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P1aN4WsQLFI2PdfhUjfI4iLqwcc0IEhlsHJVMk9NYus=;
        b=eYC04xupUIJiOhCsDqAk8SrvFshTrvSqLu0kYc1IEVsOMaZPQweyEbP372hlRNmEEv
         wQ2aw0KGXRiahltRZCdvZlyOROJ8vdy2kqZeHPYXDWnZTTeSlHM0OimI/h+gcJ/ifv5g
         CVZ5kgm7h9SgINERP0/W0twkwWTHDx3CfeBGTihhKgjPB+NFyGLM7I5EN4FoHhzU4n5R
         T651mCS7yBy1TYLQtPTKjX/xtwLv+tkTnYqpa/AIQb/czlmklgsf0sfbm4aVySMbkv18
         9aBSmDWF100pHBjMkdf5Y23c1N0tpdPu5Jd1gIqD/aSOfOYbUK4r45i4r1UrR1vtRrgP
         Hgjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P1aN4WsQLFI2PdfhUjfI4iLqwcc0IEhlsHJVMk9NYus=;
        b=lBU2i79K1VJXckOn9/tKEBqgZ5PU/zoydRiE+vZKAdDYI6l0RI55EG6mNAcMpg4/XV
         QDmnF/5ZcbvIgUAFK2aY1u4WokcJAhcYfvEEaZxe/IqlXOsPtn6LDZSKqFk3SL4bToYi
         248u+E7PZEGPfQpGTUN3VNfGrnKO/0TugpEZAxrxM+imIJqkkdvC4DaPOQRNO6aNgh4X
         +R7DiVJ6BnsBZummVMZi6nSd9UROXCYw7Vstt7f/IcetzhMZ5AWyjDsWJHdEVWdn84LS
         btyjkCkuSGG6ujlohYvGRI49NEAx2ygNXW2hCYp1qWzBJLE2AQeS2bVRvbY/H+9m7pXt
         9DrA==
X-Gm-Message-State: AOAM531uwwvpf2e43hz7zZk4wzYSRvvKzh7+/vtPxik126y022GXn7KC
        C5dvNEW78PsW7WJHHoHzP//W2h0vEJg=
X-Google-Smtp-Source: ABdhPJySnFdCeAb+fZRgTclObyR0yKN5FDhWINSh/YWXckFEulCX/SzWrvlgPl90ei8gnq5XNv8zkQ==
X-Received: by 2002:a05:6a00:1a01:b0:44d:af99:19c9 with SMTP id g1-20020a056a001a0100b0044daf9919c9mr548023pfv.36.1634919429158;
        Fri, 22 Oct 2021 09:17:09 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id nn14sm9866556pjb.27.2021.10.22.09.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 09:17:08 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/3] dt-bindings: net: bcmgenet: Document 7712 binding
Date:   Fri, 22 Oct 2021 09:17:02 -0700
Message-Id: <20211022161703.3360330-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022161703.3360330-1-f.fainelli@gmail.com>
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7712 includes a GENETv5 adapter with an on-chip 10/100 16nm Ethernet PHY
which requires us to document that controller's integration specifically
for proper driver keying.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt b/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
index 33a0d67e4ce5..0b5994fba35f 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
+++ b/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
@@ -2,7 +2,8 @@
 
 Required properties:
 - compatible: should contain one of "brcm,genet-v1", "brcm,genet-v2",
-  "brcm,genet-v3", "brcm,genet-v4", "brcm,genet-v5", "brcm,bcm2711-genet-v5".
+  "brcm,genet-v3", "brcm,genet-v4", "brcm,genet-v5", "brcm,bcm2711-genet-v5" or
+  "brcm,bcm7712-genet-v5".
 - reg: address and length of the register set for the device
 - interrupts and/or interrupts-extended: must be two cells, the first cell
   is the general purpose interrupt line, while the second cell is the
-- 
2.25.1

