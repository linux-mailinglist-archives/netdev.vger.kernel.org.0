Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EDB8D3FF
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfHNM6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:58:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43826 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbfHNM63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 08:58:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so5054869wrn.10;
        Wed, 14 Aug 2019 05:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sKNecaG9uJ6OOz0KBdXfDcOGxAObXFQzYaSa9S2/+74=;
        b=P7FxR8JDgfx+GgLDPh3O/Hl411Ibb71G7/EJYj4PvZSrvxSfb7RYg3F6dfdftZLQy9
         MHFqjnhEs9rfe6oVn7FDpmVQSYnGOPFHRoKfY15Y13Oi5XqqQ0iSXCoBCy5O+BIEzyg7
         5DYAMl3GKmgxd2Zvv5YT8KdvNmYPMssbo7TVbO/Ml+ToWXWieqfw1HzsS8aULo4D2xQl
         +HiH8Q58/YN7BCPsGhWD9RaQZoNUlhnkri/bv/gDLjrbTKyZvSRvxwHd5Uwwq4oo/RMu
         IPgZgAiyZZcn30ZCp/Tg2bC5Xk1o9+6ToP5Pdixau/t6DrkNGzq0M0Ic+Zb5MDr5aS4A
         cJjw==
X-Gm-Message-State: APjAAAX+W0uMdOPD8BflMej5kAdlCIFo2wMysbo4dIMu06Bri2gYh2rs
        qLhNXtU07Uq/Sp87WLdniic=
X-Google-Smtp-Source: APXvYqxhM9476qaxGNT9qSQ8wXfkeXu1K37RaE1WScWDGKyW9FuchX8TJhOtx6AwF5sKc9TsM59trg==
X-Received: by 2002:adf:dd88:: with SMTP id x8mr45113464wrl.331.1565787507561;
        Wed, 14 Aug 2019 05:58:27 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id q20sm68659440wrc.79.2019.08.14.05.58.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 05:58:27 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: PHY LIBRARY: Update files in the record
Date:   Wed, 14 Aug 2019 15:58:00 +0300
Message-Id: <20190814125800.23729-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <039d86b5-6897-0176-bf15-6f58e9d26b89@gmail.com>
References: <039d86b5-6897-0176-bf15-6f58e9d26b89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update MAINTAINERS to reflect that sysfs-bus-mdio was removed in
commit a6cd0d2d493a ("Documentation: net-sysfs: Remove duplicate
PHY device documentation") and sysfs-class-net-phydev was added in
commit 86f22d04dfb5 ("net: sysfs: Document PHY device sysfs
attributes").

Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e944baeca75..168e5121578e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6065,7 +6065,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Heiner Kallweit <hkallweit1@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/ABI/testing/sysfs-bus-mdio
+F:	Documentation/ABI/testing/sysfs-class-net-phydev
 F:	Documentation/devicetree/bindings/net/ethernet-phy.yaml
 F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/networking/phy.rst
-- 
2.21.0

