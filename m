Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF8A8AFBE
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfHMGOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:14:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35923 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfHMGOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:14:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so12881794wrt.3;
        Mon, 12 Aug 2019 23:14:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fOymHFFg/Qx1w7bntMrnDlbWlBs3n8KAqHgdURM4Ltc=;
        b=dbzA0RPpB90WO9U4XXVDIE4fOqe78WOM/Umq/pRjaT3IcKx25UUsh/8YYWmy7+1lTH
         qmGU+XckfI1fzIfXmpyVVrQejgV74/tKxbv8QuGW2mC42mRFiFhyMTmcEPR7M9e7Jb1W
         AB/zYFiJftkgnEZwjoD7p90tUswbje1KEXJULR9PaK/FO0jBxSiNvXQ9xANjlfr7um8j
         xNq7LHOzEYomEj/JKM8VncalmDHirwGLo6ZWsU+17/nNeetdQ+CNy5ypKD8w1Tmljr0B
         TKsYjj7LmrhmPgoD/KQG3Ebk7UmuMtTPS8sxN0K57jGDO9JJUPHJAagwNEn+RDb70NbI
         EOIw==
X-Gm-Message-State: APjAAAXggEe3KOXtZgBwVrB/HIlJCNNTkRS/x/wFYHoVbsxAq3qPHXYT
        j3Iz6TPDaeWjBi0oAITN+1JMgKle9zA=
X-Google-Smtp-Source: APXvYqymp3uVKPuQ8o0VJI/eQpac92CVm88YLhik5MEZRtL1n660rv7DAXBxBLyE/M7CILXNGgQy0Q==
X-Received: by 2002:adf:f286:: with SMTP id k6mr45478806wro.320.1565676887975;
        Mon, 12 Aug 2019 23:14:47 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id o126sm676773wmo.1.2019.08.12.23.14.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 23:14:47 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: PHY LIBRARY: Remove sysfs-bus-mdio record
Date:   Tue, 13 Aug 2019 09:14:39 +0300
Message-Id: <20190813061439.17529-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update MAINTAINERS to reflect that sysfs-bus-mdio documentation
was removed.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Fixes: a6cd0d2d493a ("Documentation: net-sysfs: Remove duplicate PHY device documentation")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2776e0797ae3..ab870920ea82 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6065,7 +6065,6 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Heiner Kallweit <hkallweit1@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/ABI/testing/sysfs-bus-mdio
 F:	Documentation/devicetree/bindings/net/ethernet-phy.yaml
 F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/networking/phy.rst
-- 
2.21.0

