Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD481BB152
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgD0WFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgD0WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:58 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E02E21D7D;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=Ez5DysS12alFSCGzxD+JpDgKPRZigXc7wY6pgLEfTlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPnP3dWy1rVmzBOc+lQzDyQS50F7Kr8HaGt1qx6TPlk40VJUMvaDucCAkdt7IhepB
         H0BBr9on6dGvbh1b6FWqIJX5tq0gg1JC7le8QYprw5abQjy5npiQWG1VfaLjcdRKRA
         QZsYsIrY2ZSw25mA/AbBkPjjF2dP0z5hWGkyl76Q=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Iog-Rj; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 13/38] docs: networking: convert dccp.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:28 +0200
Message-Id: <0dc5f31ae8ddf18a57d9f9d2922af3a09e0f357b.1588024424.git.mchehab+huawei@kernel.org>
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
- comment out text-only TOC from html/pdf output;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{dccp.txt => dccp.rst}         | 39 ++++++++++++-------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 25 insertions(+), 15 deletions(-)
 rename Documentation/networking/{dccp.txt => dccp.rst} (94%)

diff --git a/Documentation/networking/dccp.txt b/Documentation/networking/dccp.rst
similarity index 94%
rename from Documentation/networking/dccp.txt
rename to Documentation/networking/dccp.rst
index 55c575fcaf17..dde16be04456 100644
--- a/Documentation/networking/dccp.txt
+++ b/Documentation/networking/dccp.rst
@@ -1,16 +1,18 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
 DCCP protocol
 =============
 
 
-Contents
-========
-- Introduction
-- Missing features
-- Socket options
-- Sysctl variables
-- IOCTLs
-- Other tunables
-- Notes
+.. Contents
+   - Introduction
+   - Missing features
+   - Socket options
+   - Sysctl variables
+   - IOCTLs
+   - Other tunables
+   - Notes
 
 
 Introduction
@@ -38,6 +40,7 @@ The Linux DCCP implementation does not currently support all the features that a
 specified in RFCs 4340...42.
 
 The known bugs are at:
+
 	http://www.linuxfoundation.org/collaborate/workgroups/networking/todo#DCCP
 
 For more up-to-date versions of the DCCP implementation, please consider using
@@ -54,7 +57,8 @@ defined: the "simple" policy (DCCPQ_POLICY_SIMPLE), which does nothing special,
 and a priority-based variant (DCCPQ_POLICY_PRIO). The latter allows to pass an
 u32 priority value as ancillary data to sendmsg(), where higher numbers indicate
 a higher packet priority (similar to SO_PRIORITY). This ancillary data needs to
-be formatted using a cmsg(3) message header filled in as follows:
+be formatted using a cmsg(3) message header filled in as follows::
+
 	cmsg->cmsg_level = SOL_DCCP;
 	cmsg->cmsg_type	 = DCCP_SCM_PRIORITY;
 	cmsg->cmsg_len	 = CMSG_LEN(sizeof(uint32_t));	/* or CMSG_LEN(4) */
@@ -94,7 +98,7 @@ must be registered on the socket before calling connect() or listen().
 
 DCCP_SOCKOPT_TX_CCID is read/write. It returns the current CCID (if set) or sets
 the preference list for the TX CCID, using the same format as DCCP_SOCKOPT_CCID.
-Please note that the getsockopt argument type here is `int', not uint8_t.
+Please note that the getsockopt argument type here is ``int``, not uint8_t.
 
 DCCP_SOCKOPT_RX_CCID is analogous to DCCP_SOCKOPT_TX_CCID, but for the RX CCID.
 
@@ -113,6 +117,7 @@ be enabled at the receiver, too with suitable choice of CsCov.
 DCCP_SOCKOPT_SEND_CSCOV sets the sender checksum coverage. Values in the
 	range 0..15 are acceptable. The default setting is 0 (full coverage),
 	values between 1..15 indicate partial coverage.
+
 DCCP_SOCKOPT_RECV_CSCOV is for the receiver and has a different meaning: it
 	sets a threshold, where again values 0..15 are acceptable. The default
 	of 0 means that all packets with a partial coverage will be discarded.
@@ -123,11 +128,13 @@ DCCP_SOCKOPT_RECV_CSCOV is for the receiver and has a different meaning: it
 
 The following two options apply to CCID 3 exclusively and are getsockopt()-only.
 In either case, a TFRC info struct (defined in <linux/tfrc.h>) is returned.
+
 DCCP_SOCKOPT_CCID_RX_INFO
-	Returns a `struct tfrc_rx_info' in optval; the buffer for optval and
+	Returns a ``struct tfrc_rx_info`` in optval; the buffer for optval and
 	optlen must be set to at least sizeof(struct tfrc_rx_info).
+
 DCCP_SOCKOPT_CCID_TX_INFO
-	Returns a `struct tfrc_tx_info' in optval; the buffer for optval and
+	Returns a ``struct tfrc_tx_info`` in optval; the buffer for optval and
 	optlen must be set to at least sizeof(struct tfrc_tx_info).
 
 On unidirectional connections it is useful to close the unused half-connection
@@ -182,7 +189,7 @@ sync_ratelimit = 125 ms
 IOCTLS
 ======
 FIONREAD
-	Works as in udp(7): returns in the `int' argument pointer the size of
+	Works as in udp(7): returns in the ``int`` argument pointer the size of
 	the next pending datagram in bytes, or 0 when no datagram is pending.
 
 
@@ -191,10 +198,12 @@ Other tunables
 Per-route rto_min support
 	CCID-2 supports the RTAX_RTO_MIN per-route setting for the minimum value
 	of the RTO timer. This setting can be modified via the 'rto_min' option
-	of iproute2; for example:
+	of iproute2; for example::
+
 		> ip route change 10.0.0.0/24   rto_min 250j dev wlan0
 		> ip route add    10.0.0.254/32 rto_min 800j dev wlan0
 		> ip route show dev wlan0
+
 	CCID-3 also supports the rto_min setting: it is used to define the lower
 	bound for the expiry of the nofeedback timer. This can be useful on LANs
 	with very low RTTs (e.g., loopback, Gbit ethernet).
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4c8e896490e0..3894043332de 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -48,6 +48,7 @@ Contents:
    cdc_mbim
    cops
    cxacru
+   dccp
 
 .. only::  subproject and html
 
-- 
2.25.4

