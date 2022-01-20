Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDC7494CD1
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiATLWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:22:07 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:59263 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiATLVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:21:35 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A189CC0009;
        Thu, 20 Jan 2022 11:21:32 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 9/9] MAINTAINERS: Remove Harry Morris bouncing address
Date:   Thu, 20 Jan 2022 12:21:15 +0100
Message-Id: <20220120112115.448077-10-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120112115.448077-1-miquel.raynal@bootlin.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Harry's e-mail address from Cascoda bounces, I have not found any
contributions from him since 2018 so let's drop the Maintainer entry
from the CA8210 driver and mark it Orphan.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d479b554361..ab2b32080b73 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4099,9 +4099,8 @@ N:	csky
 K:	csky
 
 CA8210 IEEE-802.15.4 RADIO DRIVER
-M:	Harry Morris <h.morris@cascoda.com>
 L:	linux-wpan@vger.kernel.org
-S:	Maintained
+S:	Orphan
 W:	https://github.com/Cascoda/ca8210-linux.git
 F:	Documentation/devicetree/bindings/net/ieee802154/ca8210.txt
 F:	drivers/net/ieee802154/ca8210.c
-- 
2.27.0

