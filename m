Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06BF202B49
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgFUPMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:12:15 -0400
Received: from p54ae948c.dip0.t-ipconnect.de ([84.174.148.140]:59858 "EHLO
        maeck.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730255AbgFUPMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 11:12:15 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2020 11:12:14 EDT
Received: by maeck.local (Postfix, from userid 501)
        id EA1CE8EBFAEC; Sun, 21 Jun 2020 17:06:30 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update email address for Felix Fietkau
Date:   Sun, 21 Jun 2020 17:06:30 +0200
Message-Id: <20200621150630.11816-1-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old address has been bouncing for a while now

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 68f21d46614c..fc0c1bc24ba0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10808,7 +10808,7 @@ F:	Documentation/devicetree/bindings/dma/mtk-*
 F:	drivers/dma/mediatek/
 
 MEDIATEK ETHERNET DRIVER
-M:	Felix Fietkau <nbd@openwrt.org>
+M:	Felix Fietkau <nbd@nbd.name>
 M:	John Crispin <john@phrozen.org>
 M:	Sean Wang <sean.wang@mediatek.com>
 M:	Mark Lee <Mark-MC.Lee@mediatek.com>
-- 
2.24.0

