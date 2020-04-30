Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C3B1C012C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgD3QEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbgD3QEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:36 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FBA208D6;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=10NXVI6k21QO/0mR47Pop0ytwYQUr4HLp8yZ0e5xQis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcXV1IdTRBwNQSU0YNGxktEIfyGvVdz3mIZxNd6wAkwDUrPL16Sq/NmZ8iutL86KU
         5u9m5HU/aQTt96Vk41sek/rZQc45kUbJbU1wzDPChnc8DivNh6HjD/HjIDa7tfUthd
         xuAUBw3f24qh/XKYSz100fEnab9oHvKrcaUgtIc4=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxET-3p; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 05/37] docs: networking: convert mpls-sysctl.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:00 +0200
Message-Id: <26abaaa0035964683c3031a30e174ee147b87dfa.1588261997.git.mchehab+huawei@kernel.org>
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
- mark lists as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst              |  1 +
 .../{mpls-sysctl.txt => mpls-sysctl.rst}        | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)
 rename Documentation/networking/{mpls-sysctl.txt => mpls-sysctl.rst} (82%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 81c1834bfb57..a751cda83c3d 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -78,6 +78,7 @@ Contents:
    lapb-module
    ltpc
    mac80211-injection
+   mpls-sysctl
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/mpls-sysctl.txt b/Documentation/networking/mpls-sysctl.rst
similarity index 82%
rename from Documentation/networking/mpls-sysctl.txt
rename to Documentation/networking/mpls-sysctl.rst
index 025cc9b96992..0a2ac88404d7 100644
--- a/Documentation/networking/mpls-sysctl.txt
+++ b/Documentation/networking/mpls-sysctl.rst
@@ -1,4 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+MPLS Sysfs variables
+====================
+
 /proc/sys/net/mpls/* Variables:
+===============================
 
 platform_labels - INTEGER
 	Number of entries in the platform label table.  It is not
@@ -17,6 +24,7 @@ platform_labels - INTEGER
 	no longer fit in the table.
 
 	Possible values: 0 - 1048575
+
 	Default: 0
 
 ip_ttl_propagate - BOOL
@@ -27,8 +35,8 @@ ip_ttl_propagate - BOOL
 	If disabled, the MPLS transport network will appear as a
 	single hop to transit traffic.
 
-	0 - disabled / RFC 3443 [Short] Pipe Model
-	1 - enabled / RFC 3443 Uniform Model (default)
+	* 0 - disabled / RFC 3443 [Short] Pipe Model
+	* 1 - enabled / RFC 3443 Uniform Model (default)
 
 default_ttl - INTEGER
 	Default TTL value to use for MPLS packets where it cannot be
@@ -36,6 +44,7 @@ default_ttl - INTEGER
 	or ip_ttl_propagate has been disabled.
 
 	Possible values: 1 - 255
+
 	Default: 255
 
 conf/<interface>/input - BOOL
@@ -44,5 +53,5 @@ conf/<interface>/input - BOOL
 	If disabled, packets will be discarded without further
 	processing.
 
-	0 - disabled (default)
-	not 0 - enabled
+	* 0 - disabled (default)
+	* not 0 - enabled
-- 
2.25.4

