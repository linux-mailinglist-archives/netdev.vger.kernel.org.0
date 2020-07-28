Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C6723060A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgG1JCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgG1JCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 05:02:10 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51557C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 02:02:10 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q7so20304862ljm.1
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 02:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wsZOcrd8Llh8wTnJq9QorQ7DoQrqNwMZlR5ZdU21/yA=;
        b=NccA1C2GFlO4CMyWNFdWpPXu75AJo6moC3RVsMe96/7tL2xn0XqD/d/k89ttFVku02
         fIsGOB5BkNIQdSLHQkTsEjAhZtEZ2MbRgiLiIMERNVjZUcid3GZvM25ioupNML+MhIVZ
         wb0Xlxzgcxaa9YY4qmHQ7eB8rwayMYapiH/h7z/YvzLMZZM0aaE/nGwtCaij+Toe2T/T
         NU+b4QLncb84xbMkkE2swWwV6hi0VhfVsgCSpplUdAvMbBP/cLMQT1PqvAPDqwU0v2vT
         MsuIc/Kmt2uw2KnkgubjsGze5jAaYFpBArk/6bec41XHbEQfxAd79FX3SeaggXPXK+sf
         2kkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wsZOcrd8Llh8wTnJq9QorQ7DoQrqNwMZlR5ZdU21/yA=;
        b=bZyGYHXdVRPMEpWptc2mIWlZjJGYmf4+XYrrxMPl18fiS8lDPeS3L9x19JIyeQR9sg
         Hen/9XetpRWM7GR3vFTR7b754wg8ysoJdVmMnQw+DQbV/7oCQa04Hfjj5W9asvFNrjCL
         SIqa2htLBu5J9veFXkSYoX2L1ZfmhfvPfgM7tyDncN7J8LUyqaJruDfJd8vMW0OAw1Lb
         gCc+oy2LLe9GqAeYCAg/FkIF5hRnbRsgYZOx5g1Rjpi29oc+mXK1PH31tdkNYyCJivs1
         mfNgaKn0iaNWeTBK8Bo10u80qWv642PR72qHajILPIu0ukOQS8uGSEbdtAtUHo4lqoQV
         7tiw==
X-Gm-Message-State: AOAM532Pcq68+Qshbn58Wny25LqdcJ9gTBNfJDaK0DphFaCXh+QrvzIw
        aOZCkSMq8zYkSCZC9UHq8+EpLKe8E7pC9g==
X-Google-Smtp-Source: ABdhPJzFKAlx5B5XKcfhaOAPvQQe/PjPkqadMYivqkwyCxlF90GifCX7GK9Hc85yHYtUczNo/+zr/w==
X-Received: by 2002:a2e:6f19:: with SMTP id k25mr12490016ljc.443.1595926928568;
        Tue, 28 Jul 2020 02:02:08 -0700 (PDT)
Received: from xps13.kamstrup.dk ([185.181.22.4])
        by smtp.googlemail.com with ESMTPSA id h21sm2836352ljk.31.2020.07.28.02.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 02:02:08 -0700 (PDT)
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: [PATCH 2/2] dt-bindings: net: mdio: update reset-delay-us description
Date:   Tue, 28 Jul 2020 11:02:03 +0200
Message-Id: <20200728090203.17313-2-bruno.thomsen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728090203.17313-1-bruno.thomsen@gmail.com>
References: <20200728090203.17313-1-bruno.thomsen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Property is now used for both assert and deassert delay
so PHYs can be reset before type id auto detection.

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index d6a3bf8550eb..8385960e3b3e 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -38,6 +38,8 @@ properties:
       RESET pulse width in microseconds. It applies to all MDIO devices
       and must therefore be appropriately determined based on all devices
       requirements (maximum value of all per-device RESET pulse widths).
+      Additional it also provides a reset deassert delay of the same width
+      to ensure devices are ready for communication.
 
   clock-frequency:
     description:
-- 
2.26.2

