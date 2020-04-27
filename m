Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D141BB153
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgD0WB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgD0WB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:57 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E9E21775;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=GqOuFvFsrhwUuh9OILZl1cEYiyZjmsKx6MeD6v1pjdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nd3bwBs7GWFU4fKZ7AlHUtqTbZaNWuQ1wNViBhrCsO7f3YMvJ47/Z3zLIVQxWqLnf
         IJLEqOXZn1GAmEnmlgIz/XKi686FZa3WGDLcCgo5KPIYtS7NPOQibvesYVeUuCbeKs
         11YWn3ADtsvA2CtsufBtxLFLYiOZsPxvdsWJncuQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Io4-Ke; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 06/38] docs: networking: convert atm.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:21 +0200
Message-Id: <5a76e92ee27fa3912c8cf6d61ad7ba65f42f799d.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There isn't much to be done here. Just:

- add SPDX header;
- add a document title.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{atm.txt => atm.rst} | 6 ++++++
 Documentation/networking/index.rst            | 1 +
 net/atm/Kconfig                               | 2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)
 rename Documentation/networking/{atm.txt => atm.rst} (89%)

diff --git a/Documentation/networking/atm.txt b/Documentation/networking/atm.rst
similarity index 89%
rename from Documentation/networking/atm.txt
rename to Documentation/networking/atm.rst
index 82921cee77fe..c1df8c038525 100644
--- a/Documentation/networking/atm.txt
+++ b/Documentation/networking/atm.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===
+ATM
+===
+
 In order to use anything but the most primitive functions of ATM,
 several user-mode programs are required to assist the kernel. These
 programs and related material can be found via the ATM on Linux Web
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 3e0a4bb23ef9..841f3c3905d5 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -41,6 +41,7 @@ Contents:
    altera_tse
    arcnet-hardware
    arcnet
+   atm
 
 .. only::  subproject and html
 
diff --git a/net/atm/Kconfig b/net/atm/Kconfig
index 271f682e8438..e61dcc9f85b2 100644
--- a/net/atm/Kconfig
+++ b/net/atm/Kconfig
@@ -16,7 +16,7 @@ config ATM
 	  of your ATM card below.
 
 	  Note that you need a set of user-space programs to actually make use
-	  of ATM.  See the file <file:Documentation/networking/atm.txt> for
+	  of ATM.  See the file <file:Documentation/networking/atm.rst> for
 	  further details.
 
 config ATM_CLIP
-- 
2.25.4

