Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F40DD04E
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406550AbfJRUba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:31:30 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40874 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405774AbfJRUb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XE4sg10QMH12zgcLas2RsejXrRVfzWSY20DuCJpqKIU=; b=ZIlzBaL/u/bLrLhFCATwqdIGo
        dsZiFP7d4tNPJ6Q02sberL6DrUVlV0KRZnolsflEmg5S2yKZiRj41hgUa9AKpvxntlsMreK8G6tNL
        fRdRzQ2olDLFMF9l1qVf3xmZnK/++v2Uej77Bnl3G8Ojr/ySHo6H8wBFaLA06NlnMht0OPSYXAWyH
        QA/Z6beKhOHGtPlYGiHboNkB14yDHCxnA03gmqAfpy30Bwwn0+5DnaJm6KRarQBdLABNJaQTvX19v
        5PGXMehspzQjs8T9xltLuP8Knc+v1jTtBoS0pJ+Y3qz5HqmoWOIqB6biwVLAe1ukT/UgS11es/mFV
        X742ZNWRA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55388 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iLYu7-0001Tn-Ts; Fri, 18 Oct 2019 21:31:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iLYu7-0000sw-5u; Fri, 18 Oct 2019 21:31:19 +0100
From:   Russell King <rmk@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linville@tuxdriver.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: [PATCH 2/3] ethtool: mark 10G Base-ER as SFF-8472 revision 10.4
 onwards
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iLYu7-0000sw-5u@rmk-PC.armlinux.org.uk>
Date:   Fri, 18 Oct 2019 21:31:19 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

SFF-8472 revision 11.0, 12.1 and 12.2 all have support for 10G Base-ER
so mark this as "rev 10.4 onwards" rather than "rev 10.4 only".

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 sfpid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sfpid.c b/sfpid.c
index 71f0939c6282..3c50c456f93d 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -47,7 +47,7 @@ static void sff8079_show_transceiver(const __u8 *id)
 	/* 10G Ethernet Compliance Codes */
 	if (id[3] & (1 << 7))
 		printf("%s 10G Ethernet: 10G Base-ER" \
-		       " [SFF-8472 rev10.4 only]\n", pfx);
+		       " [SFF-8472 rev10.4 onwards]\n", pfx);
 	if (id[3] & (1 << 6))
 		printf("%s 10G Ethernet: 10G Base-LRM\n", pfx);
 	if (id[3] & (1 << 5))
-- 
2.7.4

