Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7FC47D4B9
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344060AbhLVP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:57 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44097 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344045AbhLVP6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:24 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 32B5EE0016;
        Wed, 22 Dec 2021 15:58:22 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools 4/7] iwpan: Remove duplicated SECTION
Date:   Wed, 22 Dec 2021 16:58:13 +0100
Message-Id: <20211222155816.256405-5-miquel.raynal@bootlin.com>
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

This section has been duplicated, drop one.

Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 src/iwpan.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/src/iwpan.h b/src/iwpan.h
index 9d265c6..406940a 100644
--- a/src/iwpan.h
+++ b/src/iwpan.h
@@ -90,12 +90,6 @@ struct cmd {
 		.handler = (_handler),					\
 		.help = (_help),					\
 	 }
-#define SECTION(_name)							\
-	struct cmd __section ## _ ## _name				\
-	__attribute__((used)) __attribute__((section("__cmd"))) = {	\
-		.name = (#_name),					\
-		.hidden = 1,						\
-	}
 
 #define SECTION(_name)							\
 	struct cmd __section ## _ ## _name				\
-- 
2.27.0

