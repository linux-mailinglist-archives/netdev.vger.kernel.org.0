Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4330DE3
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfEaMMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:12:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfEaMMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:12:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 086F13154860;
        Fri, 31 May 2019 12:12:33 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB31C5DA34;
        Fri, 31 May 2019 12:12:31 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     aclaudi@redhat.com, Qiaobin Fu <qiaobinf@bu.edu>
Subject: [PATCH iproute2] man: tc-skbedit.8: document 'inheritdsfield'
Date:   Fri, 31 May 2019 14:12:15 +0200
Message-Id: <7d450cb1d7bc1cde70b530930e0a5d73e39f4fdf.1559304622.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 31 May 2019 12:12:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

while at it, fix missing square bracket near 'ptype' and a typo in the
action description (it's -> its).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 man/man8/tc-skbedit.8 | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-skbedit.8 b/man/man8/tc-skbedit.8
index 003f05c93f7c..2459198261e6 100644
--- a/man/man8/tc-skbedit.8
+++ b/man/man8/tc-skbedit.8
@@ -10,9 +10,10 @@ skbedit - SKB editing action
 .B priority
 .IR PRIORITY " ] ["
 .B mark
-.IR MARK " ]"
+.IR MARK " ] ["
 .B ptype
-.IR PTYPE " ]"
+.IR PTYPE " ] ["
+.BR inheritdsfield " ]"
 .SH DESCRIPTION
 The
 .B skbedit
@@ -22,7 +23,7 @@ action, which in turn allows to change parts of the packet data itself.
 
 The most unique feature of
 .B skbedit
-is it's ability to decide over which queue of an interface with multiple
+is its ability to decide over which queue of an interface with multiple
 transmit queues the packet is to be sent out. The number of available transmit
 queues is reflected by sysfs entries within
 .I /sys/class/net/<interface>/queues
@@ -61,6 +62,12 @@ needing to allow ingressing packets with the wrong MAC address but
 correct IP address.
 .I PTYPE
 is one of: host, otherhost, broadcast, multicast
+.TP
+.BI inheritdsfield
+Override the packet classification decision, and any value specified with
+.BR priority ", "
+using the information stored in the Differentiated Services Field of the
+IPv6/IPv4 header (RFC2474).
 .SH SEE ALSO
 .BR tc (8),
 .BR tc-pedit (8)
-- 
2.20.1

