Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682732C7AA7
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgK2SeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgK2SeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 13:34:24 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1299C061A4C
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 10:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=k1lcdTPkYRVvrNt5oSUqA18SpI7MH6gIKHEfNnvqbXM=; b=QAM2aZyzdjWSvfnoOYU8RwtRw/
        6M1Kw5237/kR127t3OftzXY56wLRaLndJNqOrYyo3pqveGNykV/GqR5c7n/ngeaEEV1kn/x1sNgyI
        iAVi+Jqt4wGP2UD9SCxfkg/mAiWuRqxL5besAeDfpkLCPCypMqOUfqsyO/XeeL60hZEZn2wbJ5t6i
        aGtuqLz8NJaIltTwv+sHmaXCzWiqsLcqmrqBmi3X627nAFhdJVBUiLC/c2QGgfhTITBHjpv6TbsyB
        04F1JjHr8sC23tRyKxcdp/VSSYZuvXBtvMwTzML9eFxhLuDn03Yp0xDTolW30V8faFkhrOiYDODd4
        cXLlk9Mg==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRVl-00011y-8Q; Sun, 29 Nov 2020 18:33:25 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 10/10 net-next v2] net/tipc: add TIPC chapter to networking Documentation
Date:   Sun, 29 Nov 2020 10:32:51 -0800
Message-Id: <20201129183251.7049-11-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201129183251.7049-1-rdunlap@infradead.org>
References: <20201129183251.7049-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a TIPC chapter to the networking docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2: rebase to current net-next

 Documentation/networking/index.rst |    1 
 Documentation/networking/tipc.rst  |  101 +++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

--- net-next.orig/Documentation/networking/index.rst
+++ net-next/Documentation/networking/index.rst
@@ -101,6 +101,7 @@ Contents:
    tcp-thin
    team
    timestamping
+   tipc
    tproxy
    tuntap
    udplite
--- /dev/null
+++ net-next/Documentation/networking/tipc.rst
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
