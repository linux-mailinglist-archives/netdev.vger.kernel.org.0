Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47C61C1863
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgEAOpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbgEAOpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:06 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD10208D6;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=IOVRqp8dN/LRKfokaK8zYd4K1YaI4tINbkY6jxbkZ/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJuoGW1bEJYpq0KlcwjYh4gCtqZfktqTkNFCzjvgy140WddSeVbzKmL1HrgMhCtgz
         6DyH0yZEyaqy8nRwfeg5OAZxj/rZbXr8uNUnVeXR9N4ems2epvPx7dALCxLQbi3DiU
         G45fMhdA4MPq7sggHTq1PplWOH8uqGDQsTqtJil0=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCcs-CH; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        netdev@vger.kernel.org, linux-x25@vger.kernel.org
Subject: [PATCH 06/37] docs: networking: convert x25.txt to ReST
Date:   Fri,  1 May 2020 16:44:28 +0200
Message-Id: <577bc9abec90b75e85e2df602ee5d918345183eb.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not much to be done here:
- add SPDX header;
- add a document title;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            | 1 +
 Documentation/networking/{x25.txt => x25.rst} | 4 ++++
 net/x25/Kconfig                               | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)
 rename Documentation/networking/{x25.txt => x25.rst} (96%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 7a4bdbc111b0..75521e6c473b 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -116,6 +116,7 @@ Contents:
    vrf
    vxlan
    x25-iface
+   x25
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/x25.txt b/Documentation/networking/x25.rst
similarity index 96%
rename from Documentation/networking/x25.txt
rename to Documentation/networking/x25.rst
index c91c6d7159ff..00e45d384ba0 100644
--- a/Documentation/networking/x25.txt
+++ b/Documentation/networking/x25.rst
@@ -1,4 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================
 Linux X.25 Project
+==================
 
 As my third year dissertation at University I have taken it upon myself to
 write an X.25 implementation for Linux. My aim is to provide a complete X.25
diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index a328f79885d1..9f0d58b0b90b 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -20,7 +20,7 @@ config X25
 	  You can read more about X.25 at <http://www.sangoma.com/tutorials/x25/> and
 	  <http://docwiki.cisco.com/wiki/X.25>.
 	  Information about X.25 for Linux is contained in the files
-	  <file:Documentation/networking/x25.txt> and
+	  <file:Documentation/networking/x25.rst> and
 	  <file:Documentation/networking/x25-iface.rst>.
 
 	  One connects to an X.25 network either with a dedicated network card
-- 
2.25.4

