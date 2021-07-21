Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE683D19C6
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 00:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhGUVxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 17:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhGUVxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 17:53:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABB4C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 15:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=PgQ0UMXIrilcN6AjFZx+rellnyaKNWeOnFVJR6L3OPs=; b=4kC8FQ2sxlL8M9S19M9VBGkHLO
        rG2iZPblRaEYS+Jn7mhh8nm76m3osnIgf4wCzf+Pd+MjgXX6+vRAjQJNOQ+Lpc8L5ifYE4aJJH/mx
        Ry0SbkeJiD64vsN6BjMawMFzP9Op6uN+jpXwVuvtsileyT2beMPXPq6l9VAJrHVcepcu3WIl5kaoz
        uckYZyOGiwmetqNFxjYE1WhFpVlcD5jRIFzRhkyqjnzMXb6sisPa+zpR/bPZKyPg5YhS1MC985MG9
        bPdAilL0im6QZr/8Atuw5IQTJ/lY1i2JT4by01s4jpS/E4VJTsCpaUBe51aAuxecsGmxO0wPfLu6O
        7hH9rc7g==;
Received: from [2601:1c0:6280:3f0:7629:afff:fe72:e49d] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6KmX-00HNyG-T8; Wed, 21 Jul 2021 22:33:38 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: sparx5: fix unmet dependencies warning
Date:   Wed, 21 Jul 2021 15:33:36 -0700
Message-Id: <20210721223337.25722-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WARNING: unmet direct dependencies detected for PHY_SPARX5_SERDES
  Depends on [n]: (ARCH_SPARX5 || COMPILE_TEST [=n]) && OF [=y] && HAS_IOMEM [=y]
  Selected by [y]:
  - SPARX5_SWITCH [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICROCHIP [=y] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y] && OF [=y]


Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-514-rc2.orig/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ lnx-514-rc2/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -3,6 +3,7 @@ config SPARX5_SWITCH
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
 	depends on OF
+	depends on ARCH_SPARX5 || COMPILE_TEST
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER
