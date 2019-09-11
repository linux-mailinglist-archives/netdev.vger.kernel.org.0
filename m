Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAFCAFA2E
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfIKKS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:18:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfIKKSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 06:18:55 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C168C30BE7D9;
        Wed, 11 Sep 2019 10:18:55 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED69E5D9E2;
        Wed, 11 Sep 2019 10:18:54 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next] man: ss.8: add documentation for drop counter
Date:   Wed, 11 Sep 2019 12:19:29 +0200
Message-Id: <359345039df32ceea0b4ad859a09c1bc5da15c14.1568197130.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 11 Sep 2019 10:18:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 6df9c7a06a845 ("ss: add SK_MEMINFO_DROPS display") ss -m
displays also a drop counter for each socket.

This commit properly document it into the man page.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/ss.8 | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index f428e60cc1949..023d771b17878 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -99,13 +99,13 @@ skmem:(r<rmem_alloc>,rb<rcv_buf>,t<wmem_alloc>,tb<snd_buf>,
 .br
 .RS
 .RS
-f<fwd_alloc>,w<wmem_queued>,
+f<fwd_alloc>,w<wmem_queued>,o<opt_mem>,
 .RE
 .RE
 .br
 .RS
 .RS
-o<opt_mem>,bl<back_log>)
+bl<back_log>,d<sock_drop>)
 .RE
 .RE
 .P
@@ -146,6 +146,10 @@ The memory used for the sk backlog queue. On a process context, if the
 process is receiving packet, and a new packet is received, it will be
 put into the sk backlog queue, so it can be received by the process
 immediately
+.P
+.TP
+.B <sock_drop>
+the number of packets dropped before they are de-multiplexed into the socket
 .RE
 .TP
 .B \-p, \-\-processes
-- 
2.21.0

