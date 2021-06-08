Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5AC39EB58
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 03:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFHB2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 21:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhFHB2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 21:28:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6807860FF2;
        Tue,  8 Jun 2021 01:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623115613;
        bh=ndudkoyTbBOOp17ct+IRNrlJUHbCAv9mMg8HiRe2SOI=;
        h=From:To:Cc:Subject:Date:From;
        b=o/41wEck1F+BfP7w06d7Ny6LPldo72/lULrqRvYsxVSE46+eBTun0lx7TRvhcTbiQ
         SEYFUVhEWu/dcrS+usmVcmchgROTTH1PsDDk/eJ+CSPqbxHqE7o8IJ2GtocpAvIZRP
         opLGYnJw9im1Ro0uelz1VF2my0mdJbwoVmMQhoN0BDlMASfzkW2rayN+fGsGnAkXWu
         4CIpAEso7QQHTPCph3owN1pMQbkVETjYQ3pep82zESsh5YqQfQszfkO9U9b9XHlecg
         RgpBbcXOHBn/J+6XxYfbApyWXLRTfE2OrO2Jv0y4pXmcG98kiGY6zpt8F7bxFwHTz+
         F9y19+vRP9pAA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next] net: Kconfig: indent with tabs instead of spaces
Date:   Tue,  8 Jun 2021 03:26:48 +0200
Message-Id: <20210608012648.17177-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BAREUDP config option uses spaces instead of tabs for indentation.
The rest of this file uses tabs. Fix this.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/Kconfig | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 74dc8e249faa..4da68ba8448f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -262,17 +262,17 @@ config GENEVE
 	  will be called geneve.
 
 config BAREUDP
-       tristate "Bare UDP Encapsulation"
-       depends on INET
-       depends on IPV6 || !IPV6
-       select NET_UDP_TUNNEL
-       select GRO_CELLS
-       help
-          This adds a bare UDP tunnel module for tunnelling different
-          kinds of traffic like MPLS, IP, etc. inside a UDP tunnel.
-
-          To compile this driver as a module, choose M here: the module
-          will be called bareudp.
+	tristate "Bare UDP Encapsulation"
+	depends on INET
+	depends on IPV6 || !IPV6
+	select NET_UDP_TUNNEL
+	select GRO_CELLS
+	help
+	  This adds a bare UDP tunnel module for tunnelling different
+	  kinds of traffic like MPLS, IP, etc. inside a UDP tunnel.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called bareudp.
 
 config GTP
 	tristate "GPRS Tunneling Protocol datapath (GTP-U)"
-- 
2.31.1

