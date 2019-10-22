Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE8DE06A9
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfJVOpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:45:34 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:59354 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfJVOpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:45:33 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iMvOs-0005FE-Q8; Tue, 22 Oct 2019 15:44:42 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iMvOs-00061A-Ak; Tue, 22 Oct 2019 15:44:42 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: include <net/addrconf.h> for missing declarations
Date:   Tue, 22 Oct 2019 15:44:40 +0100
Message-Id: <20191022144440.23086-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include <net/addrconf.h> for the missing declarations of
various functions. Fixes the following sparse warnings:

net/ipv6/addrconf_core.c:94:5: warning: symbol 'register_inet6addr_notifier' was not declared. Should it be static?
net/ipv6/addrconf_core.c:100:5: warning: symbol 'unregister_inet6addr_notifier' was not declared. Should it be static?
net/ipv6/addrconf_core.c:106:5: warning: symbol 'inet6addr_notifier_call_chain' was not declared. Should it be static?
net/ipv6/addrconf_core.c:112:5: warning: symbol 'register_inet6addr_validator_notifier' was not declared. Should it be static?
net/ipv6/addrconf_core.c:118:5: warning: symbol 'unregister_inet6addr_validator_notifier' was not declared. Should it be static?
net/ipv6/addrconf_core.c:125:5: warning: symbol 'inet6addr_validator_notifier_call_chain' was not declared. Should it be static?
net/ipv6/addrconf_core.c:237:6: warning: symbol 'in6_dev_finish_destroy' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/ipv6/addrconf_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 783f3c1466da..2fc079284ca4 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -7,6 +7,7 @@
 #include <linux/export.h>
 #include <net/ipv6.h>
 #include <net/ipv6_stubs.h>
+#include <net/addrconf.h>
 #include <net/ip.h>
 
 /* if ipv6 module registers this function is used by xfrm to force all
-- 
2.23.0

