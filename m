Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94FF61EC2B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiKGHgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiKGHgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:36:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD6C5580
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667806562; x=1699342562;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0o6fW2n+JMtaYNzmTuj6whxxJNDRJAjmoyj3+vvygeA=;
  b=GF4V0RhnXqIzDXl4P5ihxJFZYXxHuDdntroMgA3f+BYnfHkcVOESluoM
   MWrA57Q1m3YSwSG6ucgyD+IuJjmN6681y8b9npMWqkLDixbFVxhZavkoQ
   M9V6XmlzHSSyYYTdvV2oEAhdFTnFfADRNdGI3Mi8za9W/evhhqyXC8g5O
   Yak3Ip8oOFf6amFZ/9HHmSMuVaGQL5pztHuu6qNycdSMYD/7dw7A4iG48
   U5ySFMKv0qZLstpe+GV7x3KDLWxm3fzIrGZBcvII6in5X7wkTbJ5wnBbV
   3v7006nMrBp/g3qjHSBWjj+CMWC4bqHkcVX1W/NIcy7VVqrB+P0kH0IWt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="307970562"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="307970562"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 23:36:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="635806399"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="635806399"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by orsmga002.jf.intel.com with ESMTP; 06 Nov 2022 23:35:58 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net V2 4/4] net: wwan: iosm: fix kernel test robot reported errors
Date:   Mon,  7 Nov 2022 13:05:24 +0530
Message-Id: <20221107073524.1978224-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Include linux/vmalloc.h in iosm_ipc_coredump.c &
iosm_ipc_devlink.c to resolve kernel test robot errors.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_coredump.c | 1 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_coredump.c b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
index 9acd87724c9d..26ca30476f40 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_coredump.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020-2021 Intel Corporation.
  */
+#include <linux/vmalloc.h>
 
 #include "iosm_ipc_coredump.h"
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 17da85a8f337..2fe724d623c0 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020-2021 Intel Corporation.
  */
+#include <linux/vmalloc.h>
 
 #include "iosm_ipc_chnl_cfg.h"
 #include "iosm_ipc_coredump.h"
-- 
2.34.1

