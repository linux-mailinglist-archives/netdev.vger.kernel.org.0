Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0601A15477D
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgBFPSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yBFv8aJbI4oYb9Rrvk3UXwfv0Yl1ScqGFr86JBwxikg=; b=r//LqI/jTIcnkcqMErLYF/XgNe
        7dpcfp/3tAButvC4bpQhM0Rp1dSCOy7sSf3lfFRwqUFsA0jRecVnJSxQF3N14Fz7cosZR9XZoPBG0
        CA2+81ODotuoxGLIxa57td1x8x0+B+c5TdDRY94zCY9r6swNOY4FeehE1k3QoaPUsqPjiFnI6imcm
        WNFy4PGTBkvun9GnMqpBT/CZ7f7JomImND0Nye7G7z48GJ4ND8roKFu+Wf6krOKdP/nbuJsKFCVNJ
        HkyVt/AnOnssJCp3g7LCNDtm/GVlN83IvB+Xhr3ZDZS+QIf9vNc+CN6+80zp68wT7BTT3o2RjIrVS
        2CjCrs2Q==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziuk-0005j7-W0; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oWE-Rp; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 23/28] docs: networking: convert fore200e.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:43 +0100
Message-Id: <1e98e9d69a5f7e19086a536b806d8b39a7b4c37c.1581002063.git.mchehab+huawei@kernel.org>
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
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.


Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{fore200e.txt => fore200e.rst} | 8 +++++---
 Documentation/networking/index.rst                      | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)
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
index 73b573739f67..022e0e895156 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -55,6 +55,7 @@ Contents:
    eql
    fib_trie
    filter
+   fore200e
 
 .. only::  subproject and html
 
-- 
2.24.1

