Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B752821DEA6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgGMRYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMRYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:24:48 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C73EC061755;
        Mon, 13 Jul 2020 10:24:48 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 47989BC0CA;
        Mon, 13 Jul 2020 17:24:45 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     cooldavid@cooldavid.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] net: jme: Replace HTTP links with HTTPS ones
Date:   Mon, 13 Jul 2020 19:24:39 +0200
Message-Id: <20200713172439.36436-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not just HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 drivers/net/ethernet/jme.c | 2 +-
 drivers/net/ethernet/jme.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index c97c74164c73..ddc757680089 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -3,7 +3,7 @@
  * JMicron JMC2x0 series PCIe Ethernet Linux Device Driver
  *
  * Copyright 2008 JMicron Technology Corporation
- * http://www.jmicron.com/
+ * https://www.jmicron.com/
  * Copyright (c) 2009 - 2010 Guo-Fu Tseng <cooldavid@cooldavid.org>
  *
  * Author: Guo-Fu Tseng <cooldavid@cooldavid.org>
diff --git a/drivers/net/ethernet/jme.h b/drivers/net/ethernet/jme.h
index 2bba5ce20289..a2c3b00d939d 100644
--- a/drivers/net/ethernet/jme.h
+++ b/drivers/net/ethernet/jme.h
@@ -3,7 +3,7 @@
  * JMicron JMC2x0 series PCIe Ethernet Linux Device Driver
  *
  * Copyright 2008 JMicron Technology Corporation
- * http://www.jmicron.com/
+ * https://www.jmicron.com/
  * Copyright (c) 2009 - 2010 Guo-Fu Tseng <cooldavid@cooldavid.org>
  *
  * Author: Guo-Fu Tseng <cooldavid@cooldavid.org>
-- 
2.27.0

