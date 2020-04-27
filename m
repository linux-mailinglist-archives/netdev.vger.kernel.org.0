Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228C61BB124
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgD0WEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99282223C;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=xBkzNBy2YhJi/8RK1Om5eioEswOWWQFUH8yKwJvvfgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfwAVJgU5xU8hFba4Fet0WG5uwzHpKjNy+G/Q25LQwj2hZUVA+6KsS/oqUZIck34i
         NDF9MuK088cyhYRJHoOPU8d2T4m9FB63KZjzgS+t+MbQntQGI7tUIZwKXgo3G4qZ+w
         1gKY389t7znH0SKWVaiRj758Lc0d/ILVCIOErS48=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Ipd-52; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 25/38] docs: networking: convert generic_netlink.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:40 +0200
Message-Id: <8ed7ad58fc10c5343722f7bcda07e712e41f7d0e.1588024424.git.mchehab+huawei@kernel.org>
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
- add a document title;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{generic_netlink.txt => generic_netlink.rst} | 6 ++++++
 Documentation/networking/index.rst                          | 1 +
 2 files changed, 7 insertions(+)
 rename Documentation/networking/{generic_netlink.txt => generic_netlink.rst} (64%)

diff --git a/Documentation/networking/generic_netlink.txt b/Documentation/networking/generic_netlink.rst
similarity index 64%
rename from Documentation/networking/generic_netlink.txt
rename to Documentation/networking/generic_netlink.rst
index 3e071115ca90..59e04ccf80c1 100644
--- a/Documentation/networking/generic_netlink.txt
+++ b/Documentation/networking/generic_netlink.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============
+Generic Netlink
+===============
+
 A wiki document on how to use Generic Netlink can be found here:
 
  * http://www.linuxfoundation.org/collaborate/workgroups/networking/generic_netlink_howto
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index d34824b27264..42e556509e22 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -60,6 +60,7 @@ Contents:
    fore200e
    framerelay
    generic-hdlc
+   generic_netlink
 
 .. only::  subproject and html
 
-- 
2.25.4

