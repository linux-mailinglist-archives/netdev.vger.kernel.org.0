Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51362C3800
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgKYEUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80132C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=bAIGpjvwGWvQDCx9r8KNDXCRwmdxNJWDZkoQbcMo0Xo=; b=B6fPSK5BwkO6OFGFfOgOlypBZC
        8J6YeaZUws9UiMAnVCuqcMj4xLMnbHvYVxMmpXPxHqVDESoRqgZMB+9xqfviVWoex+Onzr0DCQ8sY
        iSUbuxiQTL2Nid+J5y5gQYmGWMWPj52ZsijqofJKwwa5kaeqDnRQqGvfpIXB0RGlEM48FqOM6SXS3
        luA+O6RXnxHwF9E0bJa+IPVPMLk+iT6uGZRecROzMsF8qCMWYgvloSNW6BrDYTLRcSljJ907TPwkS
        eVTIVKHVJUAgsWKyqUxuUrh6Jdc/eOz2yYrX7lOUiSB87wRFCLnjSgfSryCMFEem+JjfGHjLE/fsg
        uQSa/Stw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmID-0000SB-3C; Wed, 25 Nov 2020 04:20:33 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 10/10 net-next] net/tipc: add TIPC chapter to networking Documentation
Date:   Tue, 24 Nov 2020 20:20:17 -0800
Message-Id: <20201125042026.25374-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a TIPC chapter to the networking docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/index.rst |    1 
 Documentation/networking/tipc.rst  |  101 +++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

--- linux-next-20201124.orig/Documentation/networking/index.rst
+++ linux-next-20201124/Documentation/networking/index.rst
@@ -101,6 +101,7 @@ Contents:
    tcp-thin
    team
    timestamping
+   tipc
    tproxy
    tuntap
    udplite
--- /dev/null
+++ linux-next-20201124/Documentation/networking/tipc.rst
@@ -0,0 +1,101 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
+Linux Kernel TIPC
+=================
+
+TIPC (Transparent Inter Process Communication) is a protocol that is
+specially designed for intra-cluster communication.
+
+For more information about TIPC, see http://tipc.sourceforge.net.
+
+TIPC Base Types
+---------------
+
+.. kernel-doc:: net/tipc/subscr.h
+   :internal:
+
+.. kernel-doc:: net/tipc/bearer.h
+   :internal:
+
+.. kernel-doc:: net/tipc/name_table.h
+   :internal:
+
+.. kernel-doc:: net/tipc/name_distr.h
+   :internal:
+
+.. kernel-doc:: net/tipc/bcast.c
+   :internal:
+
+TIPC Bearer Interfaces
+----------------------
+
+.. kernel-doc:: net/tipc/bearer.c
+   :internal:
+
+.. kernel-doc:: net/tipc/udp_media.c
+   :internal:
+
+TIPC Crypto Interfaces
+----------------------
+
+.. kernel-doc:: net/tipc/crypto.c
+   :internal:
+
+TIPC Discoverer Interfaces
+--------------------------
+
+.. kernel-doc:: net/tipc/discover.c
+   :internal:
+
+TIPC Link Interfaces
+--------------------
+
+.. kernel-doc:: net/tipc/link.c
+   :internal:
+
+TIPC msg Interfaces
+-------------------
+
+.. kernel-doc:: net/tipc/msg.c
+   :internal:
+
+TIPC Name Interfaces
+--------------------
+
+.. kernel-doc:: net/tipc/name_table.c
+   :internal:
+
+.. kernel-doc:: net/tipc/name_distr.c
+   :internal:
+
+TIPC Node Management Interfaces
+-------------------------------
+
+.. kernel-doc:: net/tipc/node.c
+   :internal:
+
+TIPC Socket Interfaces
+----------------------
+
+.. kernel-doc:: net/tipc/socket.c
+   :internal:
+
+TIPC Network Topology Interfaces
+--------------------------------
+
+.. kernel-doc:: net/tipc/subscr.c
+   :internal:
+
+TIPC Server Interfaces
+----------------------
+
+.. kernel-doc:: net/tipc/topsrv.c
+   :internal:
+
+TIPC Trace Interfaces
+---------------------
+
+.. kernel-doc:: net/tipc/trace.c
+   :internal:
+
