Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB660349B6E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 22:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYVLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 17:11:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37166 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhCYVK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 17:10:29 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C52FA605AA;
        Thu, 25 Mar 2021 22:10:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        sfr@canb.auug.org.au
Subject: [PATCH net-next] docs: nf_flowtable: fix compilation and warnings
Date:   Thu, 25 Mar 2021 22:10:16 +0100
Message-Id: <20210325211018.5548-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

... cannot be used in block quote, it breaks compilation, remove it.

Fix warnings due to missing blank line such as:

net-next/Documentation/networking/nf_flowtable.rst:142: WARNING: Block quote ends without a blank line; unexpected unindent.

Fixes: 143490cde566 ("docs: nf_flowtable: update documentation with enhancements")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_flowtable.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
index d87f253b9d39..d757c21c10f2 100644
--- a/Documentation/networking/nf_flowtable.rst
+++ b/Documentation/networking/nf_flowtable.rst
@@ -112,6 +112,7 @@ You can identify offloaded flows through the [OFFLOAD] tag when listing your
 connection tracking table.
 
 ::
+
 	# conntrack -L
 	tcp      6 src=10.141.10.2 dst=192.168.10.2 sport=52728 dport=5201 src=192.168.10.2 dst=192.168.10.1 sport=5201 dport=52728 [OFFLOAD] mark=0 use=2
 
@@ -138,6 +139,7 @@ allows the flowtable to define a fastpath bypass between the bridge ports
 device (represented as eth0) in your switch/router.
 
 ::
+
                       fastpath bypass
                .-------------------------.
               /                           \
@@ -168,12 +170,12 @@ connection tracking entry by specifying the counter statement in your flowtable
 definition, e.g.
 
 ::
+
 	table inet x {
 		flowtable f {
 			hook ingress priority 0; devices = { eth0, eth1 };
 			counter
 		}
-		...
 	}
 
 Counter support is available since Linux kernel 5.7.
@@ -185,12 +187,12 @@ If your network device provides hardware offload support, you can turn it on by
 means of the 'offload' flag in your flowtable definition, e.g.
 
 ::
+
 	table inet x {
 		flowtable f {
 			hook ingress priority 0; devices = { eth0, eth1 };
 			flags offload;
 		}
-		...
 	}
 
 There is a workqueue that adds the flows to the hardware. Note that a few
-- 
2.30.2

