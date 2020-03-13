Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF931845E9
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCMLZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:25:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53021 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgCMLZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 07:25:40 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jCiRb-0005Ri-4h; Fri, 13 Mar 2020 11:25:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ethtool: fix spelling mistake "exceeeds" -> "exceeds"
Date:   Fri, 13 Mar 2020 11:25:34 +0000
Message-Id: <20200313112534.76626-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of spelling mistakes in NL_SET_ERR_MSG_ATTR messages.
Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ethtool/channels.c | 2 +-
 net/ethtool/rings.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 8dc5485333a4..389924b65d05 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -189,7 +189,7 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	if (err_attr) {
 		ret = -EINVAL;
 		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
-				    "requested channel count exceeeds maximum");
+				    "requested channel count exceeds maximum");
 		goto out_ops;
 	}
 
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index c2ebf72be217..5422526f4eef 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -181,7 +181,7 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	if (err_attr) {
 		ret = -EINVAL;
 		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
-				    "requested ring size exceeeds maximum");
+				    "requested ring size exceeds maximum");
 		goto out_ops;
 	}
 
-- 
2.25.1

