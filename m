Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A996727A
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfGLPdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:33:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40804 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfGLPdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:33:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so10399301wrl.7
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 08:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+zCxSS7+ishHnJZhTwY1CRrkcoUTE8dRuvy1RT3gCHY=;
        b=riejbCdzIhhZlev/Vy1pqoeaAG1/fA7vzNjq3HkXCTkzy1buQpVv3xSMIoi9sE7zuy
         E+C1rqkJ5GWo6Ue9zRzIAHUOEHistSs8G5eeg+QrkOFIuH90+xfgeFc/hVedvsKov/7v
         0/6zAYZlZ9tD7b1nuf6tx0AR4mVygd8hlBE/uIJwvHX+A3q0LElu6AgGJShXW3W0QxQo
         JDUfUiB+0FTC6yLMM7sfad2W/mjR/B5vDcWRUUuBsmvZl9+T7mgiSUsHQTSGamw97WtB
         nsOSPt3d7ZqlvXTkSOht9t10JQd8w5Mp2IPGqRkdXfqF/WZIEITGxxZgVAH3k65dAmww
         ygcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+zCxSS7+ishHnJZhTwY1CRrkcoUTE8dRuvy1RT3gCHY=;
        b=iUoXnwVxeJ/htfDEXOLy/WqsIFIjp+6s2IPiX5GYCRQ6QbnS/L3OLhwTnrE5ywkcrY
         6iXBR2fVNMLvKR68qQkTRwUBkdLFnziZSFMauDrbiBlkZI2bBxZIcNSAQeLC+UWco28N
         vVymyx01vpLsRFwiBZlQxpxqHcAz2lLiZlukfrGmH3P2spvYSwdmhgq4n5bcggcKw9uV
         McjqTL8e8zN4K+zOX6TQdCYSprD3xdqKwDF13nQh0tDR1h9Jr7IPJ5+PEoJ/jcoFD1To
         zo0bhI8GEVf4WpKo+32ETGA6r8W0YoFo4G3kVhqnJGNBtZA6aFA3Efl/O4Aq7IgIPeqK
         pOxg==
X-Gm-Message-State: APjAAAWy3MgCBHimietC1Le5IwGmqd6t8P/1zVYv+7DHeOvJ9kYVlYEq
        PGdUTLiVnayKe0ckz5aQGnqSen7N
X-Google-Smtp-Source: APXvYqzOqRd7HtNcVjwNYvDeR8RO/P7a4qE82iTlNu/R4wIu6dBs9Gu6JLy3q5GM/2CYDlp/0URaBA==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr12167291wrv.247.1562945618187;
        Fri, 12 Jul 2019 08:33:38 -0700 (PDT)
Received: from debian64.daheim (p5B0D7F9B.dip0.t-ipconnect.de. [91.13.127.155])
        by smtp.gmail.com with ESMTPSA id c78sm11098825wmd.16.2019.07.12.08.33.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 08:33:37 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hlxYG-0001KA-0t; Fri, 12 Jul 2019 17:33:36 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, kbuild test robot <lkp@intel.com>
Subject: [PATCH] net: dsa: qca8k: replace legacy gpio include
Date:   Fri, 12 Jul 2019 17:33:36 +0200
Message-Id: <20190712153336.5018-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the legacy bulk gpio.h include
with the proper gpio/consumer.h variant. This was
caught by the kbuild test robot that was running
into an error because of this.

For more information why linux/gpio.h is bad can be found in:
commit 56a46b6144e7 ("gpio: Clarify that <linux/gpio.h> is legacy")

Reported-by: kbuild test robot <lkp@intel.com>
Link: https://www.spinics.net/lists/netdev/msg584447.html
Fixes: a653f2f538f9 ("net: dsa: qca8k: introduce reset via gpio feature")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 27709f866c23..232e8cc96f6d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -14,7 +14,7 @@
 #include <linux/of_platform.h>
 #include <linux/if_bridge.h>
 #include <linux/mdio.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
 
 #include "qca8k.h"
-- 
2.20.1

