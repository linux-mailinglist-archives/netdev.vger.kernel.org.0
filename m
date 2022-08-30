Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91C75A5912
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiH3CBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiH3CBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:01:00 -0400
X-Greylist: delayed 358 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 19:00:57 PDT
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5E416714D;
        Mon, 29 Aug 2022 19:00:57 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 5772D1E80CD3;
        Tue, 30 Aug 2022 09:51:26 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hHYKjDt8gkf0; Tue, 30 Aug 2022 09:51:23 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 506C41E80C90;
        Tue, 30 Aug 2022 09:51:22 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [PATCH] net: ipv4: Use SPDX-license-identifier and remove the License description
Date:   Tue, 30 Aug 2022 09:50:54 +0800
Message-Id: <20220830015054.3366-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the SPDX-license-identifier license agreement to more clearly
express the content of the license representative.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 net/ipv4/inetpeer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index e9fed83e9b3c..141be6d94793 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -1,8 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *		INETPEER - A storage for permanent information about peers
  *
- *  This source is covered by the GNU GPL, the same as all kernel sources.
- *
  *  Authors:	Andrey V. Savochkin <saw@msu.ru>
  */
 
-- 
2.18.2

