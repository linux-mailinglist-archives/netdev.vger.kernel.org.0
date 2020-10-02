Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939F1281EB6
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJBW5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBW5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 18:57:10 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4806A206FA;
        Fri,  2 Oct 2020 22:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601679430;
        bh=/Oj33ksLjN7CSaFUBUKRdpZK0B+i2D6ynyxN7YgfEgM=;
        h=Date:From:To:Cc:Subject:From;
        b=G96CXfHtTVmWi28TF9A+J4BBrsIObDs/3fv5u6GrMB1WjeAttG0FidwhR6L1fvV6r
         e7nXr4MjZ/nEIPOhZRIL8LCf/g3LlN4F98uZcLy554MP5lni7Ee0/Uy1DYzBWCImfl
         aVDulFBpx3T27AUkv1YIWgwyCOdLTNb+7nf1JVzI=
Date:   Fri, 2 Oct 2020 18:02:59 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: ksz884x: Use fallthrough pseudo-keyword
Message-ID: <20201002230259.GA5952@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace /* Fallthrough... */ comment with the new pseudo-keyword macro
fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/micrel/ksz884x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index cefbb2298004..9ed264ed7070 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5833,8 +5833,7 @@ static int netdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	/* Get address of MII PHY in use. */
 	case SIOCGMIIPHY:
 		data->phy_id = priv->id;
-
-		/* Fallthrough... */
+		fallthrough;
 
 	/* Read MII PHY register. */
 	case SIOCGMIIREG:
-- 
2.27.0

