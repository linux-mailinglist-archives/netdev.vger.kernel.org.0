Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6E1C017D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgD3QGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4E32499C;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=DGsx6h/Swi27aAMJQlbcrw/nxI9G75+HiBG54132wHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7bLXBIdis3/P3r5maKygrUkusCX8BbpuHEQ80yP0kt6Mj5DP4IAsVbaB7PIQOU48
         TqqlVqcoaHq0FRM2u/TojaoL+d5iYxuy82TGJjBAI97jNNIRAUAsz75kr4U4N0Y2mh
         Uf8O7oUC+yxeL+dJNyfkX4MFBgqAs3W9mw40JqpQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGu-UB; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 35/37] docs: networking: convert team.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:30 +0200
Message-Id: <970a11887c8007cc02fbb99f6890c36616be286e.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
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
 Documentation/networking/index.rst              | 1 +
 Documentation/networking/{team.txt => team.rst} | 6 ++++++
 2 files changed, 7 insertions(+)
 rename Documentation/networking/{team.txt => team.rst} (67%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 89b02fbfc2eb..be65ee509669 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -108,6 +108,7 @@ Contents:
    switchdev
    tc-actions-env-rules
    tcp-thin
+   team
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/team.txt b/Documentation/networking/team.rst
similarity index 67%
rename from Documentation/networking/team.txt
rename to Documentation/networking/team.rst
index 5a013686b9ea..0a7f3a059586 100644
--- a/Documentation/networking/team.txt
+++ b/Documentation/networking/team.rst
@@ -1,2 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====
+Team
+====
+
 Team devices are driven from userspace via libteam library which is here:
 	https://github.com/jpirko/libteam
-- 
2.25.4

