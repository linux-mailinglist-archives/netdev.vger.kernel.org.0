Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B71D3EC6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgENUOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENUOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:14:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813D9C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 13:14:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5012A128D72E9
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 13:14:04 -0700 (PDT)
Date:   Thu, 14 May 2020 13:14:03 -0700 (PDT)
Message-Id: <20200514.131403.168568797789507233.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add Jakub to networking drivers.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:14:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---

Honestly this is just a formality as NETWORKING general is
a superset of this.

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 391e7eea6a3e..4b270dbdf09b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11718,6 +11718,7 @@ F:	net/core/drop_monitor.c
 
 NETWORKING DRIVERS
 M:	"David S. Miller" <davem@davemloft.net>
+M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Odd Fixes
 W:	http://www.linuxfoundation.org/en/Net
-- 
2.26.2

