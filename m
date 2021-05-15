Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3791E381802
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhEOK6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3553 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbhEOKz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:57 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn49z8zsRDl;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:26 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH 17/34] net: netronome: nfp: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:42 +0800
Message-ID: <1621076039-53986-18-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/netronome/nfp/ccm_mbox.c:52: warning: expecting prototype for struct nfp_ccm_mbox_skb_cb. Prototype was for struct nfp_ccm_mbox_cmsg_cb instead
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c:35: warning: expecting prototype for struct nfp_tun_pre_run_rule. Prototype was for struct nfp_tun_pre_tun_rule instead
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c:38: warning: expecting prototype for NFFW_INFO_VERSION history(). Prototype was for NFFW_INFO_VERSION_CURRENT() instead

Cc: Simon Horman <simon.horman@netronome.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c           | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
index f0783aa..4247bca 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
+++ b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
@@ -36,7 +36,7 @@ enum nfp_net_mbox_cmsg_state {
 };
 
 /**
- * struct nfp_ccm_mbox_skb_cb - CCM mailbox specific info
+ * struct nfp_ccm_mbox_cmsg_cb - CCM mailbox specific info
  * @state:	processing state (/stage) of the message
  * @err:	error encountered during processing if any
  * @max_len:	max(request_len, reply_len)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index d19c02e..ab70179 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -21,7 +21,7 @@
 #define NFP_TUN_PRE_TUN_IPV6_BIT	BIT(7)
 
 /**
- * struct nfp_tun_pre_run_rule - rule matched before decap
+ * struct nfp_tun_pre_tun_rule - rule matched before decap
  * @flags:		options for the rule offset
  * @port_idx:		index of destination MAC address for the rule
  * @vlan_tci:		VLAN info associated with MAC
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c
index d4e0254..e2e5fd0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c
@@ -24,7 +24,7 @@
 
 #define NFFW_FWID_ALL   255
 
-/**
+/*
  * NFFW_INFO_VERSION history:
  * 0: This was never actually used (before versioning), but it refers to
  *    the previous struct which had FWINFO_CNT = MEINFO_CNT = 120 that later
-- 
2.7.4

