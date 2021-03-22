Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E785345374
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhCVX5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhCVX4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BB46C061756;
        Mon, 22 Mar 2021 16:56:40 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BAAAD6312B;
        Tue, 23 Mar 2021 00:56:32 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/10] netfilter: conntrack: Remove unused variable declaration
Date:   Tue, 23 Mar 2021 00:56:21 +0100
Message-Id: <20210322235628.2204-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit e97c3e278e95 ("tproxy: split off ipv6 defragmentation to a separate
module") left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index 7b3c873f8839..e95483192d1b 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -4,7 +4,4 @@
 
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
-#include <linux/sysctl.h>
-extern struct ctl_table nf_ct_ipv6_sysctl_table[];
-
 #endif /* _NF_CONNTRACK_IPV6_H*/
-- 
2.20.1

