Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BF91BB108
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgD0WDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1415422264;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=L4jsQdJmt6d0yWzSleeuXlGAkK6kzaQF1GdzgV3kZc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYHKJJssIrgo6GJ3mv8JXe9TeUyyOGOBVLI3T9YaQJgr++IY+Nkthanpoy1XrXd+3
         CcdolwrZDN3G6upfGMBkmOi7ud0Ws/Tr9D+OMyFqW2fxhsBfjjgrJDggqds35hAv4U
         FkpS+1Zl/z4+fcYM48Xc760R+RDVVtK2tNSMNrjM=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000IqH-Bv; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 33/38] docs: networking: convert ipsec.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:48 +0200
Message-Id: <448fc25ca83dcc01bedfe36b27966b670a87a7b0.1588024424.git.mchehab+huawei@kernel.org>
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
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst                |  1 +
 Documentation/networking/{ipsec.txt => ipsec.rst} | 14 +++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)
 rename Documentation/networking/{ipsec.txt => ipsec.rst} (90%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 505eaa41ca2b..3efb4608649a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -68,6 +68,7 @@ Contents:
    ipddp
    ip_dynaddr
    iphase
+   ipsec
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ipsec.txt b/Documentation/networking/ipsec.rst
similarity index 90%
rename from Documentation/networking/ipsec.txt
rename to Documentation/networking/ipsec.rst
index ba794b7e51be..afe9d7b48be3 100644
--- a/Documentation/networking/ipsec.txt
+++ b/Documentation/networking/ipsec.rst
@@ -1,12 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====
+IPsec
+=====
+
 
 Here documents known IPsec corner cases which need to be keep in mind when
 deploy various IPsec configuration in real world production environment.
 
-1. IPcomp: Small IP packet won't get compressed at sender, and failed on
+1. IPcomp:
+	   Small IP packet won't get compressed at sender, and failed on
 	   policy check on receiver.
 
-Quote from RFC3173:
-2.2. Non-Expansion Policy
+Quote from RFC3173::
+
+  2.2. Non-Expansion Policy
 
    If the total size of a compressed payload and the IPComp header, as
    defined in section 3, is not smaller than the size of the original
-- 
2.25.4

