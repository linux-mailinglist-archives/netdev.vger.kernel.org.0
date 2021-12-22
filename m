Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9534047D4B5
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343857AbhLVP6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:55 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43303 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344041AbhLVP6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:22 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 0C501E000A;
        Wed, 22 Dec 2021 15:58:19 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools 2/7] iwpan: Export iwpan_debug
Date:   Wed, 22 Dec 2021 16:58:11 +0100
Message-Id: <20211222155816.256405-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155816.256405-1-miquel.raynal@bootlin.com>
References: <20211222155816.256405-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

This debug flag will be used later on in different files.

Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 src/iwpan.c | 2 +-
 src/iwpan.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/iwpan.c b/src/iwpan.c
index fb7bef1..3cf5fe2 100644
--- a/src/iwpan.c
+++ b/src/iwpan.c
@@ -21,7 +21,7 @@
 
 /* TODO libnl 1.x compatibility code */
 
-static int iwpan_debug = 0;
+int iwpan_debug = 0;
 
 static int nl802154_init(struct nl802154_state *state)
 {
diff --git a/src/iwpan.h b/src/iwpan.h
index 48c4f03..860dd37 100644
--- a/src/iwpan.h
+++ b/src/iwpan.h
@@ -120,4 +120,6 @@ DECLARE_SECTION(get);
 
 const char *iftype_name(enum nl802154_iftype iftype);
 
+extern int iwpan_debug;
+
 #endif /* __IWPAN_H */
-- 
2.27.0

