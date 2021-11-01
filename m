Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4D441281
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 04:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhKAD7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 23:59:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:6371 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhKAD7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 23:59:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="229669203"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="229669203"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2021 20:57:05 -0700
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="467133020"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2021 20:57:04 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH v2 01/14] net: wwan: Add default MTU size
Date:   Sun, 31 Oct 2021 20:56:22 -0700
Message-Id: <20211101035635.26999-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a default MTU size definition that new WWAN drivers can refer to.

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

