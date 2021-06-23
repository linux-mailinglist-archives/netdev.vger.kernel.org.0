Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE8D3B1F33
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFWRFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:05:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33550 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhFWRFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:05:31 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9FE6B6427E;
        Wed, 23 Jun 2021 19:01:47 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 5/6] docs: networking: Update connection tracking offload sysctl parameters
Date:   Wed, 23 Jun 2021 19:03:00 +0200
Message-Id: <20210623170301.59973-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623170301.59973-1-pablo@netfilter.org>
References: <20210623170301.59973-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

Document the following connection offload configuration parameters:
- nf_flowtable_tcp_timeout
- nf_flowtable_tcp_pickup
- nf_flowtable_udp_timeout
- nf_flowtable_udp_pickup

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../networking/nf_conntrack-sysctl.rst        | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 11a9b76786cb..0467b30e4abe 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -177,3 +177,27 @@ nf_conntrack_gre_timeout_stream - INTEGER (seconds)
 
 	This extended timeout will be used in case there is an GRE stream
 	detected.
+
+nf_flowtable_tcp_timeout - INTEGER (seconds)
+        default 30
+
+        Control offload timeout for tcp connections.
+        TCP connections may be offloaded from nf conntrack to nf flow table.
+        Once aged, the connection is returned to nf conntrack with tcp pickup timeout.
+
+nf_flowtable_tcp_pickup - INTEGER (seconds)
+        default 120
+
+        TCP connection timeout after being aged from nf flow table offload.
+
+nf_flowtable_udp_timeout - INTEGER (seconds)
+        default 30
+
+        Control offload timeout for udp connections.
+        UDP connections may be offloaded from nf conntrack to nf flow table.
+        Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+
+nf_flowtable_udp_pickup - INTEGER (seconds)
+        default 30
+
+        UDP connection timeout after being aged from nf flow table offload.
-- 
2.30.2

