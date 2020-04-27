Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5BF1BB12D
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgD0WEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5AEB22208;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=4y9N2ffjRHysyknY2f1m+SHaukE/xmyKiBGBDNEE6SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wn87D6fCWbfzrVg9D0xbpyQX7xkSStoVgTVKQGgQ9GgF0DyTvA2U1MydVEv6dPSrL
         GjPZcVO4QUK/ic7Mqn66zOEdmb74bu864dbKPou3kqSgYY1hXAiyliIcs+HeA/zNl8
         fQQ5Tn4m+eJLDEhCad3eJ1GX3g0DmZYK/7HITlaU=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000IpP-2i; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chas Williams <3chas3@gmail.com>, netdev@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net
Subject: [PATCH 22/38] docs: networking: convert fore200e.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:37 +0200
Message-Id: <b11b9ca61595f88231972a19c5a2edead9c195ea.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{fore200e.txt => fore200e.rst} | 8 +++++---
 Documentation/networking/index.rst                      | 1 +
 drivers/atm/Kconfig                                     | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)
 rename Documentation/networking/{fore200e.txt => fore200e.rst} (94%)

diff --git a/Documentation/networking/fore200e.txt b/Documentation/networking/fore200e.rst
similarity index 94%
rename from Documentation/networking/fore200e.txt
rename to Documentation/networking/fore200e.rst
index 1f98f62b4370..55df9ec09ac8 100644
--- a/Documentation/networking/fore200e.txt
+++ b/Documentation/networking/fore200e.rst
@@ -1,6 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
 
+=============================================
 FORE Systems PCA-200E/SBA-200E ATM NIC driver
----------------------------------------------
+=============================================
 
 This driver adds support for the FORE Systems 200E-series ATM adapters
 to the Linux operating system. It is based on the earlier PCA-200E driver
@@ -27,8 +29,8 @@ in the linux/drivers/atm directory for details and restrictions.
 Firmware Updates
 ----------------
 
-The FORE Systems 200E-series driver is shipped with firmware data being 
-uploaded to the ATM adapters at system boot time or at module loading time. 
+The FORE Systems 200E-series driver is shipped with firmware data being
+uploaded to the ATM adapters at system boot time or at module loading time.
 The supplied firmware images should work with all adapters.
 
 However, if you encounter problems (the firmware doesn't start or the driver
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 144ed838c1a9..b2fb8b907d68 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -57,6 +57,7 @@ Contents:
    eql
    fib_trie
    filter
+   fore200e
 
 .. only::  subproject and html
 
diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index 8c37294f1d1e..4af7cbdcc349 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -336,7 +336,7 @@ config ATM_FORE200E
 	  on PCI and SBUS hosts. Say Y (or M to compile as a module
 	  named fore_200e) here if you have one of these ATM adapters.
 
-	  See the file <file:Documentation/networking/fore200e.txt> for
+	  See the file <file:Documentation/networking/fore200e.rst> for
 	  further details.
 
 config ATM_FORE200E_USE_TASKLET
-- 
2.25.4

