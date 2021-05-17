Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B978338260A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhEQIAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3776 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235461AbhEQIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:13 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkBJH6spRzmj3m;
        Mon, 17 May 2021 15:55:27 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH v2 17/24] net: netronome: nfp: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:28 +0800
Message-ID: <20210517044535.21473-18-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
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
index f0783aa9e66e..4247bca09807 100644
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
index d19c02e99114..ab70179728f6 100644
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
index d4e02542e2e9..e2e5fd003ad6 100644
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
2.17.1

