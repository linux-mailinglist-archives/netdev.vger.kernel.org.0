Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04252D2CB9
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgLHOLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729265AbgLHOLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:11:45 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B1FC061285;
        Tue,  8 Dec 2020 06:10:42 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c79so14005044pfc.2;
        Tue, 08 Dec 2020 06:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jAgAg0NFCQ9D2OHHyIrBitG3IV58eouboI/0tj7JbcU=;
        b=pZaR/zx95+BhtM8XrrRxKaqIYQhQow/xIHahInXMTn5NA1G4eEP8qHS8vEuxnTa9HC
         vR/ZBihatAC7Z294Pj+9g+v5k4gFO7FOnVykdo4yhRUeJ50n2AHQO59m6ihF7H/KM9wr
         ceHIoCxglmh2cAyoZcHSi76Xb0n06LdrQSIH4FGWlcVLSCSCsrc/TdPf3susjp0Iq47R
         cvI9qcoJdhj9j1+cJP8aiK70n1aKVjFh5bcOcrns05TucVJ2R9Td+Z+G4j6mb3ffDdkw
         XpBHgDGh14ljnehVPUlIsuHkmCCPreFdrPWniFFv+psi93BXPIccNFgTkdq8DEWppI3R
         +UHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jAgAg0NFCQ9D2OHHyIrBitG3IV58eouboI/0tj7JbcU=;
        b=Vwft9cHwvgICgnna3j9bG38shoLnIATxpT+TKtLM3ZJVygOC3cP8n14Hapy0fpYd10
         5r1pFxTEqF7av4QLgneDHBIZT7sw6wwdd6EmaaF8uUGNuq8Uhl9hUNxd5ZkAWSMBJC/d
         +G4PI5vOn+yYVjJBTHtcYzd5n3ViS+bAU+9h5OIVKEymGEhj0wTOeY5E3L7gOU2tmOk2
         h7o1gP5n37pNALcQw+wRYsVbgZKS0BYFZmSdS2ZNFMEHBMDulUM9N4av06oatkFQeakw
         bRym+8iSmXYtgoS+/D1k1eZAwJZfef+AagrXwGWLhte3P8p15MnnuJ43xFAp0HlEoLBu
         WZPA==
X-Gm-Message-State: AOAM532QzWEnvJq7YwkKvn/NW7Q9yBr61VXQU0giqXhvGco4Gq+aI1FR
        HOusmXln4Cr9gmAyKNXLfxw=
X-Google-Smtp-Source: ABdhPJxfDzZKHQI0QwpuTikddnptjHRXefFDE7BiEdJ5Mt3w53Z5yuH+dR92wBN6eXRHkMz43bC4yg==
X-Received: by 2002:a62:2cc3:0:b029:197:dda8:476a with SMTP id s186-20020a622cc30000b0290197dda8476amr20191749pfs.37.1607436642315;
        Tue, 08 Dec 2020 06:10:42 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id m15sm9071951pfa.72.2020.12.08.06.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 06:10:41 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 1/2] dt-bindings: net: nfc: s3fwrn5: Change I2C interrupt trigger type
Date:   Tue,  8 Dec 2020 23:10:11 +0900
Message-Id: <20201208141012.6033-2-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201208141012.6033-1-bongsu.jeon@samsung.com>
References: <20201208141012.6033-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Change interrupt trigger from IRQ_TYPE_LEVEL_HIGH to IRQ_TYPE_EDGE_RISING
 for stable NFC I2C interrupt handling.
Samsung's NFC Firmware sends an i2c frame as below.
1. NFC Firmware sets the GPIO(interrupt pin) high when there is an i2c
 frame to send.
2. If the CPU's I2C master has received the i2c frame, NFC F/W sets the
GPIO low.
NFC driver's i2c interrupt handler would be called in the abnormal case
as the NFC FW task of number 2 is delayed because of other high priority
tasks.
In that case, NFC driver will try to receive the i2c frame but there isn't
 any i2c frame to send in NFC.
It would cause an I2C communication problem. This case would hardly happen.
But, I changed the interrupt as a defense code.
If Driver uses the TRIGGER_RISING instead of the LEVEL trigger,
there would be no problem even if the NFC FW task is delayed.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index ca3904bf90e0..477066e2b821 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -76,7 +76,7 @@ examples:
             reg = <0x27>;
 
             interrupt-parent = <&gpa1>;
-            interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
+            interrupts = <3 IRQ_TYPE_EDGE_RISING>;
 
             en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
             wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
-- 
2.17.1

