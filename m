Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508021547D9
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBFPTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=GMOwf0zZ5gXJqjVWRJMkdONiUojACb+2zWUNeGANiFQ=; b=cra9+54ibDNHFyg4hT6TcOSky6
        qLy+LgZq1/Aj7mFN0Vnr9WbZVqH2YS5RAdWCpJNfYZp9R5gkg69ZJfXBcwn04vt28fvRl2GUXyfZi
        qE09IFHaRrsBwqbL2bUXtBtFouu1PuhBTyzT+tQtiUGmoUkLVz8DAqPb28XXX+fy6Ad57U8ht7NIj
        ZsNMu+xpsNlgOAfc85OVWA2wN7JLfuFFYQn2VcK6//tVGZ4VFkG7IanCYbxJkrYGzRwk2fCVFPa6R
        4+uV0mj1VuF6yDYknjgVYOSXC+NN4QQBQvGg19BhYCgtKC9RhLxkV75TWj3F3jQAPRTZYE0g4Bb9C
        OS3XAdiw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jZ-39; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVh-Co; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 15/28] docs: networking: convert dctcp.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:35 +0100
Message-Id: <769cbbcdbcabb5010c4ac51cd18700d59c69a738.1581002063.git.mchehab+huawei@kernel.org>
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
index 56372aae88a3..7c815ffb1403 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -47,6 +47,7 @@ Contents:
    cops
    cxacru
    dccp
+   dctcp
 
 .. only::  subproject and html
 
-- 
2.24.1

