Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED2783A54
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfHFUda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:33:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40557 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfHFUda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:33:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so42126884pfp.7;
        Tue, 06 Aug 2019 13:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/hl3E6xWSgLOYfC8vQfPuiPfVoRw6t9KqdsSlnrZOY=;
        b=Z5R+Ui20vWbz3pMtD8McxT1ePXqXSB0K/nOqoMdMCmQ54UG2cbXg0U2lg3pA41ZebR
         AWP4t0iEnQHvj+V/sU2PxHCB1JkqD5nBObV4zaJ3p9exwVBeu/4LLhKjE0eRA0/ESoYx
         Lg92tiFsdOBVW2vzv1I6MWUgnwHvo1EAHa+Te0ARTKC4tIYigDDYm84NOJGx+dnaW+BD
         GK306WLqw5xIU3JkrCmpkC7bS0Fn/AKMmrmteRAIJ4h9dE18XoppYipulUZhCqWalbGh
         PDe0mETwoudiO+wQO9BtTKFmZavBvyd33Oec6Gpllw0x3VqMgFQCmJ58noLJUWaynmjY
         9UCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/hl3E6xWSgLOYfC8vQfPuiPfVoRw6t9KqdsSlnrZOY=;
        b=bCQP5FE95DXMiNOOKN6Q3fVzplnju2pItBwXQiahl6Tuq61CODaFBt1XS0luQyvg/D
         UAPmZKjpUNqt6enFF9QXdKzVI5uBC/q5bnvSKagONSaSP+1bIK6+FlQtMH+wzuqGedXK
         p6IKdF0wLkxaHns9VeohVKVha0dQ/uxUwP14YRZ6fSAQjbV96aXqW1cYc2bzB7J9qkS0
         NliofdcoOTjI0xht5IxVArLBDwj1wN2ikHQDTx10AaOJ9d8xm7jtAKACHUeCNL5UbjZm
         viIgr+mMetCoxFZCCMl4VjANturPhmuLqvmEzmQ4WKGbtd3N/UDS7VkyOFmm6FwUlhqW
         fpyw==
X-Gm-Message-State: APjAAAUHbxAsO+Ko2QBHtc1Huit4pFoTpvDHB2Ed85Lo5ecunCoJ5gS5
        kMhu5AhRqzcgOle6s5aI9h4=
X-Google-Smtp-Source: APXvYqydVmi8Htm7y9SQXaN5mFjwL7oDna3ZTCjzJMqqWRRTTBYIPYefxSK8iUvA8rJh0bYbcIpRcg==
X-Received: by 2002:a17:90a:fa18:: with SMTP id cm24mr4837085pjb.120.1565123609378;
        Tue, 06 Aug 2019 13:33:29 -0700 (PDT)
Received: from localhost.localdomain ([27.7.7.163])
        by smtp.gmail.com with ESMTPSA id x9sm62823174pgp.75.2019.08.06.13.33.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 13:33:28 -0700 (PDT)
From:   Giridhar Prasath R <cristianoprasath@gmail.com>
To:     isdn@linux-pingi.de
Cc:     gregkh@linuxfoundation.org, arnd@arndb.de,
        cristianoprasath@gmail.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: isdn: hysdn_procconf_init() remove parantheses from return value
Date:   Wed,  7 Aug 2019 07:33:31 +0530
Message-Id: <20190807020331.19729-1-cristianoprasath@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ERROR: return is not a function, parentheses are not required
FILE: git/kernels/staging/drivers/staging/isdn/hysdn/hysdn_procconf.c:385
+       return (0);

Signed-off-by: Giridhar Prasath R <cristianoprasath@gmail.com>
---
 drivers/staging/isdn/hysdn/hysdn_procconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/isdn/hysdn/hysdn_procconf.c b/drivers/staging/isdn/hysdn/hysdn_procconf.c
index 73079213ec94..48afd9f5316e 100644
--- a/drivers/staging/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/staging/isdn/hysdn/hysdn_procconf.c
@@ -382,7 +382,7 @@ hysdn_procconf_init(void)
 	}
 
 	printk(KERN_NOTICE "HYSDN: procfs initialised\n");
-	return (0);
+	return 0;
 }				/* hysdn_procconf_init */
 
 /*************************************************************************************/
-- 
2.22.0

