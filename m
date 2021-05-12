Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C680D37BD27
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhELMxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231500AbhELMxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 059DE6142F;
        Wed, 12 May 2021 12:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823903;
        bh=Siu+BFq1+PyRburw9qoE86u5X6rSLCp6lJqQVcNDPqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwaeoVY+8c3y1kzeLBO4Ullt7X+BfZVfIZ8R/Ytv+tp/zFFVf5VdsmkIgMJBFMYmN
         I8bQxQyjGKnUlxwFtVn+9Hb8+QXIh8FAS/P7cFKpbVlXbMNoD5ZVCZWMHkmtcVhfY3
         gcXvwD0t211vjoNggLs+KokFNvDgZQ9XsL7Bf00po1hUA5Oie92PvAqRfAN670pD9A
         Xk+LaOqcJETunVoppc8a1LndC394p9I0lTPwxpBgHhzvynsC/hbg7FFGBbwaqoMHWW
         ZZzok/8MKL5dBQnQq0nWDJeU9Izv/I0J6E3ofpBq2rs6UJawXb2hX8h3ggiz1lBJon
         9ShYhrGdxBWCA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgoKz-0018iM-4T; Wed, 12 May 2021 14:51:41 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 24/40] docs: networking: scaling.rst: Use ASCII subset instead of UTF-8 alternate symbols
Date:   Wed, 12 May 2021 14:50:28 +0200
Message-Id: <f785e05c62330a95ac1a6ba369e8669c9486f29a.1620823573.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620823573.git.mchehab+huawei@kernel.org>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion tools used during DocBook/LaTeX/Markdown->ReST conversion
and some automatic rules which exists on certain text editors like
LibreOffice turned ASCII characters into some UTF-8 alternatives that
are better displayed on html and PDF.

While it is OK to use UTF-8 characters in Linux, it is better to
use the ASCII subset instead of using an UTF-8 equivalent character
as it makes life easier for tools like grep, and are easier to edit
with the some commonly used text/source code editors.

Also, Sphinx already do such conversion automatically outside literal blocks:
   https://docutils.sourceforge.io/docs/user/smartquotes.html

So, replace the occurences of the following UTF-8 characters:

	- U+2019 ('’'): RIGHT SINGLE QUOTATION MARK
	- U+201c ('“'): LEFT DOUBLE QUOTATION MARK
	- U+201d ('”'): RIGHT DOUBLE QUOTATION MARK

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/scaling.rst | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index 3d435caa3ef2..e1a0c88193fa 100644
--- a/Documentation/networking/scaling.rst
+++ b/Documentation/networking/scaling.rst
@@ -30,7 +30,7 @@ queues to distribute processing among CPUs. The NIC distributes packets by
 applying a filter to each packet that assigns it to one of a small number
 of logical flows. Packets for each flow are steered to a separate receive
 queue, which in turn can be processed by separate CPUs. This mechanism is
-generally known as “Receive-side Scaling” (RSS). The goal of RSS and
+generally known as "Receive-side Scaling" (RSS). The goal of RSS and
 the other scaling techniques is to increase performance uniformly.
 Multi-queue distribution can also be used for traffic prioritization, but
 that is not the focus of these techniques.
@@ -46,7 +46,7 @@ indirection table and reading the corresponding value.
 
 Some advanced NICs allow steering packets to queues based on
 programmable filters. For example, webserver bound TCP port 80 packets
-can be directed to their own receive queue. Such “n-tuple” filters can
+can be directed to their own receive queue. Such "n-tuple" filters can
 be configured from ethtool (--config-ntuple).
 
 
@@ -114,7 +114,7 @@ RSS. Being in software, it is necessarily called later in the datapath.
 Whereas RSS selects the queue and hence CPU that will run the hardware
 interrupt handler, RPS selects the CPU to perform protocol processing
 above the interrupt handler. This is accomplished by placing the packet
-on the desired CPU’s backlog queue and waking up the CPU for processing.
+on the desired CPU's backlog queue and waking up the CPU for processing.
 RPS has some advantages over RSS:
 
 1) it can be used with any NIC
@@ -128,20 +128,20 @@ netif_receive_skb(). These call the get_rps_cpu() function, which
 selects the queue that should process a packet.
 
 The first step in determining the target CPU for RPS is to calculate a
-flow hash over the packet’s addresses or ports (2-tuple or 4-tuple hash
+flow hash over the packet's addresses or ports (2-tuple or 4-tuple hash
 depending on the protocol). This serves as a consistent hash of the
 associated flow of the packet. The hash is either provided by hardware
 or will be computed in the stack. Capable hardware can pass the hash in
 the receive descriptor for the packet; this would usually be the same
 hash used for RSS (e.g. computed Toeplitz hash). The hash is saved in
 skb->hash and can be used elsewhere in the stack as a hash of the
-packet’s flow.
+packet's flow.
 
 Each receive hardware queue has an associated list of CPUs to which
 RPS may enqueue packets for processing. For each received packet,
 an index into the list is computed from the flow hash modulo the size
 of the list. The indexed CPU is the target for processing the packet,
-and the packet is queued to the tail of that CPU’s backlog queue. At
+and the packet is queued to the tail of that CPU's backlog queue. At
 the end of the bottom half routine, IPIs are sent to any CPUs for which
 packets have been queued to their backlog queue. The IPI wakes backlog
 processing on the remote CPU, and any queued packets are then processed
@@ -298,7 +298,7 @@ CPU for packet processing (from get_rps_cpu()) the rps_sock_flow table
 and the rps_dev_flow table of the queue that the packet was received on
 are compared. If the desired CPU for the flow (found in the
 rps_sock_flow table) matches the current CPU (found in the rps_dev_flow
-table), the packet is enqueued onto that CPU’s backlog. If they differ,
+table), the packet is enqueued onto that CPU's backlog. If they differ,
 the current CPU is updated to match the desired CPU if one of the
 following is true:
 
@@ -356,7 +356,7 @@ the application thread consuming the packets of each flow is running.
 Accelerated RFS should perform better than RFS since packets are sent
 directly to a CPU local to the thread consuming the data. The target CPU
 will either be the same CPU where the application runs, or at least a CPU
-which is local to the application thread’s CPU in the cache hierarchy.
+which is local to the application thread's CPU in the cache hierarchy.
 
 To enable accelerated RFS, the networking stack calls the
 ndo_rx_flow_steer driver function to communicate the desired hardware
@@ -369,7 +369,7 @@ The hardware queue for a flow is derived from the CPU recorded in
 rps_dev_flow_table. The stack consults a CPU to hardware queue map which
 is maintained by the NIC driver. This is an auto-generated reverse map of
 the IRQ affinity table shown by /proc/interrupts. Drivers can use
-functions in the cpu_rmap (“CPU affinity reverse map”) kernel library
+functions in the cpu_rmap ("CPU affinity reverse map") kernel library
 to populate the map. For each CPU, the corresponding queue in the map is
 set to be one whose processing CPU is closest in cache locality.
 
-- 
2.30.2

