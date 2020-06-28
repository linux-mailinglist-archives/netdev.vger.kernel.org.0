Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF220C903
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 18:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgF1Qe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 12:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgF1Qe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 12:34:28 -0400
X-Greylist: delayed 487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Jun 2020 09:34:27 PDT
Received: from outpost.hi.is (outpost.hi.is [IPv6:2a00:c88:4000:1650::165:166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67C1C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 09:34:27 -0700 (PDT)
Received: from inpost.hi.is (inpost.hi.is [IPv6:2a00:c88:4000:1650::165:62])
        by outpost.hi.is (8.14.7/8.14.7) with ESMTP id 05SGQKRs032100
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 16:26:20 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 outpost.hi.is 05SGQKRs032100
Received: from hekla.rhi.hi.is (hekla.rhi.hi.is [IPv6:2a00:c88:4000:1650::165:2])
        by inpost.hi.is (8.14.7/8.14.7) with ESMTP id 05SGQFhN016446
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 16:26:15 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 inpost.hi.is 05SGQFhN016446
Received: from hekla.rhi.hi.is (localhost [127.0.0.1])
        by hekla.rhi.hi.is (8.14.4/8.14.4) with ESMTP id 05SGQFGe027607
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 16:26:15 GMT
Received: (from bjarniig@localhost)
        by hekla.rhi.hi.is (8.14.4/8.14.4/Submit) id 05SGQFCd027606
        for netdev@vger.kernel.org; Sun, 28 Jun 2020 16:26:15 GMT
Date:   Sun, 28 Jun 2020 16:26:15 +0000
From:   Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To:     netdev@vger.kernel.org
Subject: [PATCH] libnetlink.3: display section numbers in roman font, not
 boldface
Message-ID: <20200628162615.GA27573@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Typeset section numbers in roman font, see man-pages(7).

###

  Details:

Output is from: test-groff -b -mandoc -T utf8 -rF0 -t -w w -z

  [ "test-groff" is a developmental version of "groff" ]

<./man/man3/libnetlink.3>:53 (macro BR): only 1 argument, but more are expected
<./man/man3/libnetlink.3>:132 (macro BR): only 1 argument, but more are expected
<./man/man3/libnetlink.3>:134 (macro BR): only 1 argument, but more are expected
<./man/man3/libnetlink.3>:197 (macro BR): only 1 argument, but more are expected
<./man/man3/libnetlink.3>:198 (macro BR): only 1 argument, but more are expected

Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
---
 man/man3/libnetlink.3 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/man/man3/libnetlink.3 b/man/man3/libnetlink.3
index 8e3dc620..9a2c801c 100644
--- a/man/man3/libnetlink.3
+++ b/man/man3/libnetlink.3
@@ -50,7 +50,7 @@ int rta_addattr32(struct rtattr *rta, int maxlen, int type, __u32 data)
 int rta_addattr_l(struct rtattr *rta, int maxlen, int type, void *data, int alen)
 .SH DESCRIPTION
 libnetlink provides a higher level interface to
-.BR rtnetlink(7).
+.BR rtnetlink (7).
 The read functions return 0 on success and a negative errno on failure.
 The send functions return the amount of data sent, or -1 on error.
 .TP
@@ -129,9 +129,9 @@ for parsing. The file should contain raw data as received from a rtnetlink socke
 The following functions are useful to construct custom rtnetlink messages. For
 simple database dumping with filtering it is better to use the higher level
 functions above. See
-.BR rtnetlink(3)
+.BR rtnetlink (3)
 and
-.BR netlink(3)
+.BR netlink (3)
 on how to generate a rtnetlink message. The following utility functions
 require a continuous buffer that already contains a netlink message header
 and a rtnetlink request.
@@ -194,7 +194,7 @@ netlink/rtnetlink was designed and written by Alexey Kuznetsov.
 Andi Kleen wrote the man page.
 
 .SH SEE ALSO
-.BR netlink(7),
-.BR rtnetlink(7)
+.BR netlink (7),
+.BR rtnetlink (7)
 .br
 /usr/include/linux/rtnetlink.h
-- 
2.27.0
