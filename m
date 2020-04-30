Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED1E1C0176
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgD3QGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7267824985;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=B3ezwvg2knS6uHnv/WO13S9rLymkt8WrzNj9AI610QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRDdD0eiyHCV5Jl0zgghDNKs9SFJAQPmGZLUk+txXHb9yRGvPyK3yk3z1Mjr6+4nP
         bnei9NbbUpXG/kJYokBJ+1io6to81MN3VZ8WM/sNsjrUQ6cVW88HimhaXQr7eU36cb
         zfOGk/w/FN+uZ6UcMxDNVlTYa9tTCF+jPSMjZZ5c=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGG-N5; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: [PATCH 27/37] docs: networking: convert sctp.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:22 +0200
Message-Id: <5bbbf00c3aba45253e9d6ba0efeaf34bf2a8450f.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/{sctp.txt => sctp.rst}         | 37 +++++++++++--------
 MAINTAINERS                                   |  2 +-
 3 files changed, 24 insertions(+), 16 deletions(-)
 rename Documentation/networking/{sctp.txt => sctp.rst} (64%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index cd307b9601fa..1761eb715061 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -100,6 +100,7 @@ Contents:
    rds
    regulatory
    rxrpc
+   sctp
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/sctp.txt b/Documentation/networking/sctp.rst
similarity index 64%
rename from Documentation/networking/sctp.txt
rename to Documentation/networking/sctp.rst
index 97b810ca9082..9f4d9c8a925b 100644
--- a/Documentation/networking/sctp.txt
+++ b/Documentation/networking/sctp.rst
@@ -1,35 +1,42 @@
-Linux Kernel SCTP 
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
+Linux Kernel SCTP
+=================
 
 This is the current BETA release of the Linux Kernel SCTP reference
-implementation.  
+implementation.
 
 SCTP (Stream Control Transmission Protocol) is a IP based, message oriented,
 reliable transport protocol, with congestion control, support for
 transparent multi-homing, and multiple ordered streams of messages.
 RFC2960 defines the core protocol.  The IETF SIGTRAN working group originally
-developed the SCTP protocol and later handed the protocol over to the 
-Transport Area (TSVWG) working group for the continued evolvement of SCTP as a 
-general purpose transport.  
+developed the SCTP protocol and later handed the protocol over to the
+Transport Area (TSVWG) working group for the continued evolvement of SCTP as a
+general purpose transport.
 
-See the IETF website (http://www.ietf.org) for further documents on SCTP. 
-See http://www.ietf.org/rfc/rfc2960.txt 
+See the IETF website (http://www.ietf.org) for further documents on SCTP.
+See http://www.ietf.org/rfc/rfc2960.txt
 
 The initial project goal is to create an Linux kernel reference implementation
-of SCTP that is RFC 2960 compliant and provides an programming interface 
-referred to as the  UDP-style API of the Sockets Extensions for SCTP, as 
-proposed in IETF Internet-Drafts.    
+of SCTP that is RFC 2960 compliant and provides an programming interface
+referred to as the  UDP-style API of the Sockets Extensions for SCTP, as
+proposed in IETF Internet-Drafts.
 
-Caveats:  
+Caveats
+=======
 
--lksctp can be built as statically or as a module.  However, be aware that 
-module removal of lksctp is not yet a safe activity.   
+- lksctp can be built as statically or as a module.  However, be aware that
+  module removal of lksctp is not yet a safe activity.
 
--There is tentative support for IPv6, but most work has gone towards 
-implementation and testing lksctp on IPv4.   
+- There is tentative support for IPv6, but most work has gone towards
+  implementation and testing lksctp on IPv4.
 
 
 For more information, please visit the lksctp project website:
+
    http://www.sf.net/projects/lksctp
 
 Or contact the lksctp developers through the mailing list:
+
    <linux-sctp@vger.kernel.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index 93e1b253ae51..64789b29c085 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15044,7 +15044,7 @@ M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
 L:	linux-sctp@vger.kernel.org
 S:	Maintained
 W:	http://lksctp.sourceforge.net
-F:	Documentation/networking/sctp.txt
+F:	Documentation/networking/sctp.rst
 F:	include/linux/sctp.h
 F:	include/net/sctp/
 F:	include/uapi/linux/sctp.h
-- 
2.25.4

