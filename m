Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892FC12F2C0
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 02:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgACBqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 20:46:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgACBqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 20:46:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E696115410AB9
        for <netdev@vger.kernel.org>; Thu,  2 Jan 2020 17:46:02 -0800 (PST)
Date:   Thu, 02 Jan 2020 17:46:02 -0800 (PST)
Message-Id: <20200102.174602.1527569147186535315.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: Update GIT url in maintainers.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 17:46:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 MAINTAINERS | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6b893f77078..77d4529dd2a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11460,8 +11460,8 @@ M:	"David S. Miller" <davem@davemloft.net>
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 S:	Odd Fixes
 F:	Documentation/devicetree/bindings/net/
 F:	drivers/net/
@@ -11502,8 +11502,8 @@ M:	"David S. Miller" <davem@davemloft.net>
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 B:	mailto:netdev@vger.kernel.org
 S:	Maintained
 F:	net/
@@ -11548,7 +11548,7 @@ M:	"David S. Miller" <davem@davemloft.net>
 M:	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
 M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
 L:	netdev@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 S:	Maintained
 F:	net/ipv4/
 F:	net/ipv6/
-- 
2.20.1

