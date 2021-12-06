Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FCE46A333
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243912AbhLFRpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:45:11 -0500
Received: from mail-oo1-f53.google.com ([209.85.161.53]:36837 "EHLO
        mail-oo1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244426AbhLFRpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:45:10 -0500
Received: by mail-oo1-f53.google.com with SMTP id g11-20020a4a754b000000b002c679a02b18so4594345oof.3;
        Mon, 06 Dec 2021 09:41:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OAS85gDzY5DPs6SebpkI9j9HhLZ+Q0xF/5yXOUmrPP4=;
        b=k3gssCv5t9o69HhSfIoyW1Wf4BAysPxul0qw+fV3VwsfuuIkaPc8Ylj/ZsPbHMN/iQ
         pDd4FebMnNbKvm/gvo1Mhvz3BIszjJ4E+E8c7ekRNWevHYN350NRSXcnzR9NnWqwg2fl
         nZ7YpCSSmKLwp7Byvc+IUDMxVdr+0DXDFoOFn0K/KWFL3Fg5u/SoihsnlNwSKdxlsrL+
         hCcSrsX0OjlQTVrzplzU06SYjk/2qssOEjnYxh/DSyYjN7yjaDiX9fhY98AfHxqerTMf
         i5wVpHHoG647uWJxTByFLAVnMS6I/jjuyG34UnHnJOdzgxi+Rt1o/iL7WLuF8pMxGWG3
         tUpw==
X-Gm-Message-State: AOAM533MSwQyj77Ow8Jeym15iJLEfcx0VXpHV4GGwdRLfCaZXwlnf/om
        DVqsBMT55Gh/3DOpkjQQNw==
X-Google-Smtp-Source: ABdhPJxLHb/xmMRoYN37eGy1rkWi5Z91nI0AFyPUeq/T0IQJY5qv1HSyAzI6uudfZGALzQWsGy/UzQ==
X-Received: by 2002:a4a:af46:: with SMTP id x6mr23038904oon.48.1638812501360;
        Mon, 06 Dec 2021 09:41:41 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id bk41sm2864402oib.31.2021.12.06.09.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:41:40 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: mdio: Allow any child node name
Date:   Mon,  6 Dec 2021 11:41:39 -0600
Message-Id: <20211206174139.2296497-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An MDIO bus can have devices other than ethernet PHYs on it, so it
should allow for any node name rather than just 'ethernet-phy'.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index 08e15fb1584f..53206e4a7a14 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -59,7 +59,7 @@ properties:
     type: boolean
 
 patternProperties:
-  "^ethernet-phy@[0-9a-f]+$":
+  '@[0-9a-f]+$':
     type: object
 
     properties:
-- 
2.32.0

