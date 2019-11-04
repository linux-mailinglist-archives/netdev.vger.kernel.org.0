Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB3EEF00C
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbfKDWZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:25:20 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36274 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730618AbfKDVvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 16:51:50 -0500
Received: by mail-wm1-f65.google.com with SMTP id c22so17734031wmd.1
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 13:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UWfA6bGex3Brxa2lEkphz+ofM2AgJ8qq9hbdspm9o3I=;
        b=mKKSSZhzUcnl4r/MVmTINOmt+A5XoDQjC6113VPa6QbaEGAylj5IlV8AZF1uK9x16T
         AMeaBYdzCYOuQlsm9pWkBL5S0KAiLmSiodqUw2eklKGVnR2NRETqvCx7rJuJOhn63xfY
         FBqLqAj655ZwUaf5amnCxgQ2puz3hsJclrcA0WAwgax4GtZ7c5vCB5pKyOBPaj86Su7B
         RRFn1rpUuztjSY6x9AB1Y2dL5IojyBCVHwkK2uIM3Sfl+lVu0ZIsUumG35wm7mPgQ+2q
         2bjsxRuDtRTlDggJdHtws9WFAQnx98aOslglx/C1lfH/WN+gdmcsMiFG3/LBV6vgbTBh
         9Fvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UWfA6bGex3Brxa2lEkphz+ofM2AgJ8qq9hbdspm9o3I=;
        b=mk0bsLlh2kUu0/D0GXNe0jWsI6gaf3P+QvcebZhXH/HOE//AOgEZAMtkUX/9RIaXbA
         +DPoSQj5lLCSmY10VUxbasrgCuEH7nMiY+UGnA/PEiSd62C1uhaUIvg8MSLXZcYusPKL
         IH3pHz7xndT3ufcTt8FX9/BVqnhL9itiNc22CBJx3vo/S/e3xxL2QRg3PyFTxr0r627y
         nw6/F6NHeanow6W+14KlPqnff8syD9FB8quUXdf4YbdToei051YN1XKcnjOPgO9dKLM4
         nfAZeSf4I44eLqLbFyYdSqDXTn0UpmQs6w1/QBqZPdyO1kEPIawDn+AAInrbKTPkVENM
         VReQ==
X-Gm-Message-State: APjAAAVaoH9zZdWbeTe/5MHLQt9MGPIg8uzHeCxivnIzwiCPpqP0r2C9
        16Mp3QHFoYnKnoKDyE9A5i7mpGIG
X-Google-Smtp-Source: APXvYqzHWv854V/ZTpIcpXbCahhMgJfwM9MwVuhJ51kQ5yPof3yDghLdi7cI37k1FdGrh/7fMy5RQQ==
X-Received: by 2002:a1c:3c42:: with SMTP id j63mr867245wma.90.1572904307473;
        Mon, 04 Nov 2019 13:51:47 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t133sm21439302wmb.1.2019.11.04.13.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 13:51:46 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v2 1/2] dt-bindings: net: Describe BCM7445 switch reset property
Date:   Mon,  4 Nov 2019 13:51:38 -0800
Message-Id: <20191104215139.17047-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191104215139.17047-1-f.fainelli@gmail.com>
References: <20191104215139.17047-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM7445/BCM7278 built-in Ethernet switch have an optional reset line
to the SoC's reset controller, describe the 'resets' and 'reset-names'
properties as optional.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt    | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
index b7336b9d6a3c..48a7f916c5e4 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
+++ b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
@@ -44,6 +44,12 @@ Optional properties:
   Admission Control Block supports reporting the number of packets in-flight in a
   switch queue
 
+- resets: a single phandle and reset identifier pair. See
+  Documentation/devicetree/binding/reset/reset.txt for details.
+
+- reset-names: If the "reset" property is specified, this property should have
+  the value "switch" to denote the switch reset line.
+
 Port subnodes:
 
 Optional properties:
-- 
2.17.1

