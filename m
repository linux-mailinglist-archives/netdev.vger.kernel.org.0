Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0B01BB11E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgD0WED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECBFD22246;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=AXxzudrQ8joOJ3IaNJ8EUyfvFRGsvX8spIhMJYS6UuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyz0xETNgliNmpnKto6H6q0GfsCIoYWj8k5YXDhjTYiGjCqlVVSh2wlWwen0lp7hj
         BBMFqq8/NGPi4BkimkjrC3eGHkQr0qYpxTVodVRRITE9QcvbVfcQdKOWWe732ClNZA
         HXk57B3MaHXlctT5INbFa4eFFLHk4NZ/BqN/baJ4=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Ips-7R; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 28/38] docs: networking: convert hinic.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:43 +0200
Message-Id: <10e6cd1bd08bd40c2ae0d63f7a0ccca8c9f3b12f.1588024424.git.mchehab+huawei@kernel.org>
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
- adjust titles and chapters, adding proper markups;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{hinic.txt => hinic.rst} | 5 ++++-
 Documentation/networking/index.rst                | 1 +
 MAINTAINERS                                       | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)
 rename Documentation/networking/{hinic.txt => hinic.rst} (97%)

diff --git a/Documentation/networking/hinic.txt b/Documentation/networking/hinic.rst
similarity index 97%
rename from Documentation/networking/hinic.txt
rename to Documentation/networking/hinic.rst
index 989366a4039c..867ac8f4e04a 100644
--- a/Documentation/networking/hinic.txt
+++ b/Documentation/networking/hinic.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============================================================
 Linux Kernel Driver for Huawei Intelligent NIC(HiNIC) family
 ============================================================
 
@@ -110,7 +113,7 @@ hinic_dev - de/constructs the Logical Tx and Rx Queues.
 (hinic_main.c, hinic_dev.h)
 
 
-Miscellaneous:
+Miscellaneous
 =============
 
 Common functions that are used by HW and Logical Device.
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index b29a08d1f941..5a7889df1375 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -63,6 +63,7 @@ Contents:
    generic_netlink
    gen_stats
    gtp
+   hinic
 
 .. only::  subproject and html
 
diff --git a/MAINTAINERS b/MAINTAINERS
index a14a2d9bb968..3764697a6002 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7837,7 +7837,7 @@ HUAWEI ETHERNET DRIVER
 M:	Aviad Krawczyk <aviad.krawczyk@huawei.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/networking/hinic.txt
+F:	Documentation/networking/hinic.rst
 F:	drivers/net/ethernet/huawei/hinic/
 
 HUGETLB FILESYSTEM
-- 
2.25.4

