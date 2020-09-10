Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249EE264F53
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgIJTkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731378AbgIJPlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 11:41:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416E6C06138F
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 08:41:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D50411299B859;
        Thu, 10 Sep 2020 08:24:06 -0700 (PDT)
Date:   Thu, 10 Sep 2020 08:40:52 -0700 (PDT)
Message-Id: <20200910.084052.1935762481503560279.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     zbr@ioremap.net
Subject: [PATCH] connector: Move maintainence under networking drivers
 umbrella.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 08:24:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Evgeniy does not have the time nor capacity to maintain the
connector subsystem any longer, so just move it under networking
as that is effectively what has been happening lately.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 MAINTAINERS | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 12be7ae4d989..2783a5f68d2c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4407,12 +4407,6 @@ T:	git git://git.infradead.org/users/hch/configfs.git
 F:	fs/configfs/
 F:	include/linux/configfs.h
 
-CONNECTOR
-M:	Evgeniy Polyakov <zbr@ioremap.net>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/connector/
-
 CONSOLE SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Supported
@@ -12046,6 +12040,7 @@ Q:	http://patchwork.ozlabs.org/project/netdev/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 F:	Documentation/devicetree/bindings/net/
+F:	drivers/connector/
 F:	drivers/net/
 F:	include/linux/etherdevice.h
 F:	include/linux/fcdevice.h
-- 
2.26.2

