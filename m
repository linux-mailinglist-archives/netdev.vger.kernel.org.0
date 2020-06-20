Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3F5202337
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 12:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgFTKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 06:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgFTKbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 06:31:25 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4407C0613EE;
        Sat, 20 Jun 2020 03:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ztiwetw7eKXNs0F74hbVQ8BqYeBIh6jHl13AjDA4zpk=; b=P0J+Qip6z4TqlDPigKUkiVnpXy
        LUZN4memm6z016shCysc0H1o0Azx9qB6CyRMqg6GMNU30BaxNcOHbyZc8TVhnQP7/8iLwFtVcDCUx
        M4sdXIvLSPdmQec4KWpJ8wZ4ASxhyTjM8t/gnZU9Yx6znhB30xPaaoSFNGnTW5rBMqzT7sE7If1iG
        GIan6pipvhr7OFWxV7QQmtJCQTPUOd+jkfOOBHdAG16KCuc4lhK0Ao8GTYmCTEbWEFuLHEL3du2/P
        hSULyejO+3sxSyAMNbrj6mR1LS6xvK+GhIEe435hxOMjAR9SLl7Y0Nk1cM5nS04hF+LHxiuH/lvr7
        qwvuvu6g==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jmamK-0004Ch-Bm; Sat, 20 Jun 2020 11:31:16 +0100
Date:   Sat, 20 Jun 2020 11:31:16 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 3/3] net: dsa: qca8k: Minor comment spelling fix
Message-ID: <527b9615d95ecd6875c06f5f4b67150d8bb6a1d5.1592648711.git.noodles@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
 <cover.1592648711.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1592648711.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 11d1c290d90f..4acad5fa0c84 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -647,7 +647,7 @@ qca8k_setup(struct dsa_switch *ds)
 				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 		}
 
-		/* Invividual user ports get connected to CPU port only */
+		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
 			int shift = 16 * (i % 2);
 
-- 
2.20.1

