Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5001C018B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgD3QGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E19024972;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=hk3yJGCIoqdz1qoglNsbEPKNyxiVbJmRAddO2RhD+jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncQxzJ/1gi9OxLSNVmcXW0rNCJ1WppLY+3NVQ+kTXgOk63MLMqTDWS5NuuO+J/U+w
         SKagRP9Qrj1tz5BCA9rQF3O11dSiSt7aDLHKNO+rX0F9oo+tcih8HXwNwZgjUgTHkI
         pFxYyJWVoAl5CyY8ajusv6MkQHZ3gzXU8bqAqu0g=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFn-Ha; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 21/37] docs: networking: convert proc_net_tcp.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:16 +0200
Message-Id: <9d38ccde3b8d3de2479fcdfa8e6e0d317f72934d.1588261997.git.mchehab+huawei@kernel.org>
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
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{proc_net_tcp.txt => proc_net_tcp.rst}    | 23 +++++++++++++------
 2 files changed, 17 insertions(+), 7 deletions(-)
 rename Documentation/networking/{proc_net_tcp.txt => proc_net_tcp.rst} (83%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index f89535871481..0da7eb0ec85a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -94,6 +94,7 @@ Contents:
    pktgen
    plip
    ppp_generic
+   proc_net_tcp
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/proc_net_tcp.txt b/Documentation/networking/proc_net_tcp.rst
similarity index 83%
rename from Documentation/networking/proc_net_tcp.txt
rename to Documentation/networking/proc_net_tcp.rst
index 4a79209e77a7..7d9dfe36af45 100644
--- a/Documentation/networking/proc_net_tcp.txt
+++ b/Documentation/networking/proc_net_tcp.rst
@@ -1,15 +1,21 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============================================
+The proc/net/tcp and proc/net/tcp6 variables
+============================================
+
 This document describes the interfaces /proc/net/tcp and /proc/net/tcp6.
 Note that these interfaces are deprecated in favor of tcp_diag.
 
-These /proc interfaces provide information about currently active TCP 
+These /proc interfaces provide information about currently active TCP
 connections, and are implemented by tcp4_seq_show() in net/ipv4/tcp_ipv4.c
 and tcp6_seq_show() in net/ipv6/tcp_ipv6.c, respectively.
 
 It will first list all listening TCP sockets, and next list all established
-TCP connections. A typical entry of /proc/net/tcp would look like this (split 
-up into 3 parts because of the length of the line):
+TCP connections. A typical entry of /proc/net/tcp would look like this (split
+up into 3 parts because of the length of the line)::
 
-   46: 010310AC:9C4C 030310AC:1770 01 
+   46: 010310AC:9C4C 030310AC:1770 01
    |      |      |      |      |   |--> connection state
    |      |      |      |      |------> remote TCP port number
    |      |      |      |-------------> remote IPv4 address
@@ -17,7 +23,7 @@ up into 3 parts because of the length of the line):
    |      |---------------------------> local IPv4 address
    |----------------------------------> number of entry
 
-   00000150:00000000 01:00000019 00000000  
+   00000150:00000000 01:00000019 00000000
       |        |     |     |       |--> number of unrecovered RTO timeouts
       |        |     |     |----------> number of jiffies until timer expires
       |        |     |----------------> timer_active (see below)
@@ -25,7 +31,7 @@ up into 3 parts because of the length of the line):
       |-------------------------------> transmit-queue
 
    1000        0 54165785 4 cd1e6040 25 4 27 3 -1
-    |          |    |     |    |     |  | |  | |--> slow start size threshold, 
+    |          |    |     |    |     |  | |  | |--> slow start size threshold,
     |          |    |     |    |     |  | |  |      or -1 if the threshold
     |          |    |     |    |     |  | |  |      is >= 0xFFFF
     |          |    |     |    |     |  | |  |----> sending congestion window
@@ -40,9 +46,12 @@ up into 3 parts because of the length of the line):
     |---------------------------------------------> uid
 
 timer_active:
+
+ ==  ================================================================
   0  no timer is pending
   1  retransmit-timer is pending
   2  another timer (e.g. delayed ack or keepalive) is pending
-  3  this is a socket in TIME_WAIT state. Not all fields will contain 
+  3  this is a socket in TIME_WAIT state. Not all fields will contain
      data (or even exist)
   4  zero window probe timer is pending
+ ==  ================================================================
-- 
2.25.4

