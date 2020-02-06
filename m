Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E571547D3
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgBFPTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+Yop00d0Xbp0545ICHmgql9c1fRKohAG5sloDCaSutw=; b=YNyc9QGAB77qhhIXE627igBUun
        pRdC7duCqZujAd0sGW8lKr4thltvoXKguoIvi1r/usWoxBmsggH4ymckh+UBLAGt3Qg1iN5R5S810
        89tLsOt/DzTeYBzMqrHrHjxtT1VPvj1aOHv96Yw0T9N3w6Vs9G9FB9omW1PTsMzcVCil8BVXwsVQx
        7HUGrJCW2miECGfjIWUXdoEXVCQmQNWXqd3Q9mxje5lVeHAMrC9W3UhNKxPaVRFv4coTnL+5frmGv
        9wNf1F7T58QaMUNKfAnUHKMItRgjw4QCyoFk7ePaxsxJB2v1UsJvSWr6FrPmch+x07Vg4LUpRdlNc
        cykLL/eg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziuk-0005jb-VV; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVt-IW; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 18/28] docs: networking: convert dns_resolver.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:38 +0100
Message-Id: <a04a5efd9692da07fc60d407578bf97f21151dd9.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- comment out text-only TOC from html/pdf output;

- mark code blocks and literals as such;

- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.


Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{dns_resolver.txt => dns_resolver.rst}    | 52 +++++++++----------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 26 insertions(+), 27 deletions(-)
 rename Documentation/networking/{dns_resolver.txt => dns_resolver.rst} (89%)

diff --git a/Documentation/networking/dns_resolver.txt b/Documentation/networking/dns_resolver.rst
similarity index 89%
rename from Documentation/networking/dns_resolver.txt
rename to Documentation/networking/dns_resolver.rst
index eaa8f9a6fd5d..add4d59a99a5 100644
--- a/Documentation/networking/dns_resolver.txt
+++ b/Documentation/networking/dns_resolver.rst
@@ -1,8 +1,10 @@
-			     ===================
-			     DNS Resolver Module
-			     ===================
+.. SPDX-License-Identifier: GPL-2.0
 
-Contents:
+===================
+DNS Resolver Module
+===================
+
+.. Contents:
 
  - Overview.
  - Compilation.
@@ -12,8 +14,7 @@ Contents:
  - Debugging.
 
 
-========
-OVERVIEW
+Overview
 ========
 
 The DNS resolver module provides a way for kernel services to make DNS queries
@@ -33,50 +34,50 @@ It does not yet support the following AFS features:
 This code is extracted from the CIFS filesystem.
 
 
-===========
-COMPILATION
+Compilation
 ===========
 
-The module should be enabled by turning on the kernel configuration options:
+The module should be enabled by turning on the kernel configuration options::
 
 	CONFIG_DNS_RESOLVER	- tristate "DNS Resolver support"
 
 
-==========
-SETTING UP
+Setting up
 ==========
 
 To set up this facility, the /etc/request-key.conf file must be altered so that
 /sbin/request-key can appropriately direct the upcalls.  For example, to handle
 basic dname to IPv4/IPv6 address resolution, the following line should be
-added:
+added::
+
 
 	#OP	TYPE		DESC	CO-INFO	PROGRAM ARG1 ARG2 ARG3 ...
 	#======	============	=======	=======	==========================
 	create	dns_resolver  	*	*	/usr/sbin/cifs.upcall %k
 
 To direct a query for query type 'foo', a line of the following should be added
-before the more general line given above as the first match is the one taken.
+before the more general line given above as the first match is the one taken::
 
 	create	dns_resolver  	foo:*	*	/usr/sbin/dns.foo %k
 
 
-=====
-USAGE
+Usage
 =====
 
 To make use of this facility, one of the following functions that are
-implemented in the module can be called after doing:
+implemented in the module can be called after doing::
 
 	#include <linux/dns_resolver.h>
 
- (1) int dns_query(const char *type, const char *name, size_t namelen,
-		   const char *options, char **_result, time_t *_expiry);
+     ::
+
+	int dns_query(const char *type, const char *name, size_t namelen,
+		     const char *options, char **_result, time_t *_expiry);
 
      This is the basic access function.  It looks for a cached DNS query and if
      it doesn't find it, it upcalls to userspace to make a new DNS query, which
      may then be cached.  The key description is constructed as a string of the
-     form:
+     form::
 
 		[<type>:]<name>
 
@@ -107,16 +108,14 @@ This can be cleared by any process that has the CAP_SYS_ADMIN capability by
 the use of KEYCTL_KEYRING_CLEAR on the keyring ID.
 
 
-===============================
-READING DNS KEYS FROM USERSPACE
+Reading DNS Keys from Userspace
 ===============================
 
 Keys of dns_resolver type can be read from userspace using keyctl_read() or
 "keyctl read/print/pipe".
 
 
-=========
-MECHANISM
+Mechanism
 =========
 
 The dnsresolver module registers a key type called "dns_resolver".  Keys of
@@ -147,11 +146,10 @@ See <file:Documentation/security/keys/request-key.rst> for further
 information about request-key function.
 
 
-=========
-DEBUGGING
+Debugging
 =========
 
 Debugging messages can be turned on dynamically by writing a 1 into the
-following file:
+following file::
 
-        /sys/module/dnsresolver/parameters/debug
+	/sys/module/dnsresolver/parameters/debug
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 198851d45b26..68ddb023133c 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -50,6 +50,7 @@ Contents:
    dctcp
    decnet
    defza
+   dns_resolver
 
 .. only::  subproject and html
 
-- 
2.24.1

