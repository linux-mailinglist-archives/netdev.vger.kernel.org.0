Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09ED1BB14E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD0WFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgD0WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:58 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F93021D7E;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=m+3uhfU30k0g3RHQf5Wy2GgWHe8onVT3u8WYPIr3ei4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jnno8vmdrg/60Q5DGedy1+GY/huVq7ZmBAt/vxbStUrpIhOTgpA5FIM5pN0HlB6Ru
         fLVhUF70oJlkgwuwt1GQwY7sNmNUY1BJKRHdThhppVxK8z2IRpttE/eU2I11sOO06C
         9/b4hCDD2vARIZSdof91UyMvBtZvDKMzJ8hz1UME=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Iok-ST; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 14/38] docs: networking: convert dctcp.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:29 +0200
Message-Id: <94cf64eaf46b157d9a14aaf68733a3c65f034f1e.1588024424.git.mchehab+huawei@kernel.org>
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
 Documentation/networking/{dctcp.txt => dctcp.rst} | 14 +++++++++++---
 Documentation/networking/index.rst                |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)
 rename Documentation/networking/{dctcp.txt => dctcp.rst} (89%)

diff --git a/Documentation/networking/dctcp.txt b/Documentation/networking/dctcp.rst
similarity index 89%
rename from Documentation/networking/dctcp.txt
rename to Documentation/networking/dctcp.rst
index 13a857753208..4cc8bb2dad50 100644
--- a/Documentation/networking/dctcp.txt
+++ b/Documentation/networking/dctcp.rst
@@ -1,11 +1,14 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
 DCTCP (DataCenter TCP)
-----------------------
+======================
 
 DCTCP is an enhancement to the TCP congestion control algorithm for data
 center networks and leverages Explicit Congestion Notification (ECN) in
 the data center network to provide multi-bit feedback to the end hosts.
 
-To enable it on end hosts:
+To enable it on end hosts::
 
   sysctl -w net.ipv4.tcp_congestion_control=dctcp
   sysctl -w net.ipv4.tcp_ecn_fallback=0 (optional)
@@ -25,14 +28,19 @@ SIGCOMM/SIGMETRICS papers:
 
  i) Mohammad Alizadeh, Albert Greenberg, David A. Maltz, Jitendra Padhye,
     Parveen Patel, Balaji Prabhakar, Sudipta Sengupta, and Murari Sridharan:
-      "Data Center TCP (DCTCP)", Data Center Networks session
+
+      "Data Center TCP (DCTCP)", Data Center Networks session"
+
       Proc. ACM SIGCOMM, New Delhi, 2010.
+
     http://simula.stanford.edu/~alizade/Site/DCTCP_files/dctcp-final.pdf
     http://www.sigcomm.org/ccr/papers/2010/October/1851275.1851192
 
 ii) Mohammad Alizadeh, Adel Javanmard, and Balaji Prabhakar:
+
       "Analysis of DCTCP: Stability, Convergence, and Fairness"
       Proc. ACM SIGMETRICS, San Jose, 2011.
+
     http://simula.stanford.edu/~alizade/Site/DCTCP_files/dctcp_analysis-full.pdf
 
 IETF informational draft:
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 3894043332de..9e83d3bda4e0 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -49,6 +49,7 @@ Contents:
    cops
    cxacru
    dccp
+   dctcp
 
 .. only::  subproject and html
 
-- 
2.25.4

