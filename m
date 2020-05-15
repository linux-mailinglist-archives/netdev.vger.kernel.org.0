Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CA91D42AF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgEOBFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727098AbgEOBFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:05:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2D1C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 18:05:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA3C914DD3169;
        Thu, 14 May 2020 18:05:33 -0700 (PDT)
Date:   Thu, 14 May 2020 18:05:32 -0700 (PDT)
Message-Id: <20200514.180532.854900635490849048.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Jakub to networking drivers.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514212408.GC499265@lunn.ch>
References: <20200514.131403.168568797789507233.davem@davemloft.net>
        <20200514212408.GC499265@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 18:05:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 14 May 2020 23:24:08 +0200

> Now there are two of you, do you think you can do a bit better than
> Odd Fixes?

Your expectations are really high :-)

Yeah I guess we can put Maintained in there, I'll do that right now.

====================
[PATCH] MAINTAINERS: Mark networking drivers as Maintained.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4b270dbdf09b..2c59cc557f2b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11720,7 +11720,7 @@ NETWORKING DRIVERS
 M:	"David S. Miller" <davem@davemloft.net>
 M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
-S:	Odd Fixes
+S:	Maintained
 W:	http://www.linuxfoundation.org/en/Net
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
-- 
2.26.2

