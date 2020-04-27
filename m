Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70801BB0FF
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD0WDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0166522253;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=jPw2vwOYLdQLlLNVqlyNjqvBBy54L5FWmYUuoJDEcdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Keof8qQ3MTvMj1l8+wyESbXuOCtK6WoBzNsDYSQkI0jeIy4vskn79UzBWzdxclcvu
         9rC+i5FGabMvAJtS20uC47sgvOLNBSJ4Eij6bA4V6YgTKz9aB6pbqzaKTw26EURT2q
         Zp0LowYr3N4QBS/n75HPkr5y5jGMtJzLYWL4aVSQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Iq2-97; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 30/38] docs: networking: convert ipddp.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:45 +0200
Message-Id: <8c3349990d7236f49b668588e40d6a14f6a81077.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not much to be done here:

- add SPDX header;
- use a document title from existing text;
- adjust a chapter markup;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst                |  1 +
 Documentation/networking/{ipddp.txt => ipddp.rst} | 13 +++++++++----
 Documentation/networking/ltpc.txt                 |  2 +-
 drivers/net/appletalk/Kconfig                     |  4 ++--
 4 files changed, 13 insertions(+), 7 deletions(-)
 rename Documentation/networking/{ipddp.txt => ipddp.rst} (89%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 488971f6b650..cf85d0a73144 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -65,6 +65,7 @@ Contents:
    gtp
    hinic
    ila
+   ipddp
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ipddp.txt b/Documentation/networking/ipddp.rst
similarity index 89%
rename from Documentation/networking/ipddp.txt
rename to Documentation/networking/ipddp.rst
index ba5c217fffe0..be7091b77927 100644
--- a/Documentation/networking/ipddp.txt
+++ b/Documentation/networking/ipddp.rst
@@ -1,7 +1,12 @@
-Text file for ipddp.c:
-	AppleTalk-IP Decapsulation and AppleTalk-IP Encapsulation
+.. SPDX-License-Identifier: GPL-2.0
 
-This text file is written by Jay Schulist <jschlst@samba.org>
+=========================================================
+AppleTalk-IP Decapsulation and AppleTalk-IP Encapsulation
+=========================================================
+
+Documentation ipddp.c
+
+This file is written by Jay Schulist <jschlst@samba.org>
 
 Introduction
 ------------
@@ -21,7 +26,7 @@ kernel AppleTalk layer and drivers are available.
 Each mode requires its own user space software.
 
 Compiling AppleTalk-IP Decapsulation/Encapsulation
-=================================================
+==================================================
 
 AppleTalk-IP decapsulation needs to be compiled into your kernel. You
 will need to turn on AppleTalk-IP driver support. Then you will need to
diff --git a/Documentation/networking/ltpc.txt b/Documentation/networking/ltpc.txt
index 0bf3220c715b..a005a73b76d0 100644
--- a/Documentation/networking/ltpc.txt
+++ b/Documentation/networking/ltpc.txt
@@ -99,7 +99,7 @@ treat the LocalTalk device like an ordinary Ethernet device, even if
 that's what it looks like to Netatalk.
 
 Instead, you follow the same procedure as for doing IP in EtherTalk.
-See Documentation/networking/ipddp.txt for more information about the
+See Documentation/networking/ipddp.rst for more information about the
 kernel driver and userspace tools needed.
 
 --------------------------------------
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index d4e51c048f62..ccde6479050c 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -86,7 +86,7 @@ config IPDDP
 	  box is stuck on an AppleTalk only network) or decapsulate (e.g. if
 	  you want your Linux box to act as an Internet gateway for a zoo of
 	  AppleTalk connected Macs). Please see the file
-	  <file:Documentation/networking/ipddp.txt> for more information.
+	  <file:Documentation/networking/ipddp.rst> for more information.
 
 	  If you say Y here, the AppleTalk-IP support will be compiled into
 	  the kernel. In this case, you can either use encapsulation or
@@ -107,4 +107,4 @@ config IPDDP_ENCAP
 	  IP packets inside AppleTalk frames; this is useful if your Linux box
 	  is stuck on an AppleTalk network (which hopefully contains a
 	  decapsulator somewhere). Please see
-	  <file:Documentation/networking/ipddp.txt> for more information.
+	  <file:Documentation/networking/ipddp.rst> for more information.
-- 
2.25.4

