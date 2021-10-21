Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51DE436C0D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhJUUbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:31:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:57396 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhJUUbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:31:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="292598283"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="292598283"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:22 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625038"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:21 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH 01/14] net: wwan: Add default MTU size
Date:   Thu, 21 Oct 2021 13:27:25 -0700
Message-Id: <20211021202738.729-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a default MTU size definition that new WWAN drivers can refer to.

Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 include/linux/wwan.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 9fac819f92e3..28934b7dd0ae 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -171,4 +171,9 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 
 void wwan_unregister_ops(struct device *parent);
 
+/*
+ * Default WWAN interface MTU value
+ */
+#define WWAN_DEFAULT_MTU       1500
+
 #endif /* __WWAN_H */
-- 
2.17.1

