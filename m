Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BAE64B6F5
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiLMOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbiLMOJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:09:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D79972126B;
        Tue, 13 Dec 2022 06:09:31 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/3] netfilter: conntrack: document sctp timeouts
Date:   Tue, 13 Dec 2022 15:09:23 +0100
Message-Id: <20221213140923.154594-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221213140923.154594-1-pablo@netfilter.org>
References: <20221213140923.154594-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

Exposed through sysctl, update documentation to describe sctp states and
their default timeouts.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../networking/nf_conntrack-sysctl.rst        | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 1120d71f28d7..49db1d11d7c4 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -163,6 +163,39 @@ nf_conntrack_timestamp - BOOLEAN
 
 	Enable connection tracking flow timestamping.
 
+nf_conntrack_sctp_timeout_closed - INTEGER (seconds)
+	default 10
+
+nf_conntrack_sctp_timeout_cookie_wait - INTEGER (seconds)
+	default 3
+
+nf_conntrack_sctp_timeout_cookie_echoed - INTEGER (seconds)
+	default 3
+
+nf_conntrack_sctp_timeout_established - INTEGER (seconds)
+	default 432000 (5 days)
+
+nf_conntrack_sctp_timeout_shutdown_sent - INTEGER (seconds)
+	default 0.3
+
+nf_conntrack_sctp_timeout_shutdown_recd - INTEGER (seconds)
+	default 0.3
+
+nf_conntrack_sctp_timeout_shutdown_ack_sent - INTEGER (seconds)
+	default 3
+
+nf_conntrack_sctp_timeout_heartbeat_sent - INTEGER (seconds)
+	default 30
+
+	This timeout is used to setup conntrack entry on secondary paths.
+	Default is set to hb_interval.
+
+nf_conntrack_sctp_timeout_heartbeat_acked - INTEGER (seconds)
+	default 210
+
+	This timeout is used to setup conntrack entry on secondary paths.
+	Default is set to (hb_interval * path_max_retrans + rto_max)
+
 nf_conntrack_udp_timeout - INTEGER (seconds)
 	default 30
 
-- 
2.30.2

