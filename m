Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCEF26536F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgIJVew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbgIJNtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:49:45 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90918C061798;
        Thu, 10 Sep 2020 06:49:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o5so6737546wrn.13;
        Thu, 10 Sep 2020 06:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wSq34HEf31gn6oOAhzZl6n09VNcY+CG3VybV5LfKyMk=;
        b=BnP67ComNn7+2jrjEyAsNZC0bFk4NfGVAlM5NjtnawbBwhF8SH0nrIa19Cri50upk3
         gsmCMhGEVNKwoY4rdOmwP5UP+x+2VGvDugxwUWs5OCrCOcPQxjJ9sn9JvslfpbFtOm+V
         CDmGvkPjLkec59tXMvoCdLcX4YloHoA4rowdVJcwdyMG4jOvTa63wRn1gK1PDT1Vi/R6
         CBd9Q5Hk1Pdc+dwTNjhZlM3mb/erRagn4ZVlwOp1quZQtzJUwnGSyY1jc96wtqC7BMkp
         A5setIodvCVh2ihyuFBh9FoGLDJU3imj8R6/eqIMBNS3t+OgzvkZz8bBJM1fZVBLNboz
         Y0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wSq34HEf31gn6oOAhzZl6n09VNcY+CG3VybV5LfKyMk=;
        b=Up8kvUruNaJ6pTqOa8AgCLSUFcoTIWlZUwINb2G/SencWgt5hWNMqUDM50me03HovO
         Q5TVZ/vp0R+YTbAV7aU/YBef68O/7n54dNjfUK/GmZ06v2gemlAJFI2IM1y2y313k0rh
         CtiAH3yl7WmyQo7A88RshCHLMKRufNWXtn0Yl5fGmJbCoy6qDJ85Ivi7TsK0WrlddFh7
         o/K1RyrKKMoQklG5fFnc+/T1vETQ4PuDZEosVTLqYS6m9h4HsmgmROQub43HAYLt+SeF
         3yXoD0y3x2D8Ka2VEXHf0U8LStuA1sBmjf5C/T8ZeGjaYdw4csylkIPyHnOLtEbwUQKh
         Vl5Q==
X-Gm-Message-State: AOAM5311iGcsDzzioeWZyJZgEZ4q2+yBkeqk6Wxn9e6LXDoWImHTbX4J
        uTT7E5yXo4aLZ7b621tsMio=
X-Google-Smtp-Source: ABdhPJxIeD3Vk09q1A1rQBEDM4BhhcgUZNt2p/vmLNH2IhWM7sDMSb0ymFROoZN3qEu1SSzrUiNqhA==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr9012940wrl.401.1599745759936;
        Thu, 10 Sep 2020 06:49:19 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id s124sm3786613wme.29.2020.09.10.06.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 06:49:19 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Matteo Croce <mcroce@microsoft.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mvpp2: ptp: Fix unused variables
Date:   Thu, 10 Sep 2020 14:49:10 +0100
Message-Id: <20200910134915.46660-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the functions mvpp2_isr_handle_xlg() and
mvpp2_isr_handle_gmac_internal(), the bool variable link is assigned a
true value in the case that a given bit of val is set. However, if the
bit is unset, no value is assigned to link and it is then passed to
mvpp2_isr_handle_link() without being initialised. Fix by assigning to
link the value of the bit test.

Build-tested on x86.

Fixes: 36cfd3a6e52b ("net: mvpp2: restructure "link status" interrupt handling")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 7d86940747d1..87b1c9cfdc77 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3070,8 +3070,7 @@ static void mvpp2_isr_handle_xlg(struct mvpp2_port *port)
 	val = readl(port->base + MVPP22_XLG_INT_STAT);
 	if (val & MVPP22_XLG_INT_STAT_LINK) {
 		val = readl(port->base + MVPP22_XLG_STATUS);
-		if (val & MVPP22_XLG_STATUS_LINK_UP)
-			link = true;
+		link = (val & MVPP22_XLG_STATUS_LINK_UP);
 		mvpp2_isr_handle_link(port, link);
 	}
 }
@@ -3087,8 +3086,7 @@ static void mvpp2_isr_handle_gmac_internal(struct mvpp2_port *port)
 		val = readl(port->base + MVPP22_GMAC_INT_STAT);
 		if (val & MVPP22_GMAC_INT_STAT_LINK) {
 			val = readl(port->base + MVPP2_GMAC_STATUS0);
-			if (val & MVPP2_GMAC_STATUS0_LINK_UP)
-				link = true;
+			link = (val & MVPP2_GMAC_STATUS0_LINK_UP);
 			mvpp2_isr_handle_link(port, link);
 		}
 	}
-- 
2.28.0

