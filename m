Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E106309A3
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiKSCP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbiKSCNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:13:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300597FC35;
        Fri, 18 Nov 2022 18:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACCED62836;
        Sat, 19 Nov 2022 02:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7606C433C1;
        Sat, 19 Nov 2022 02:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823952;
        bh=3zNwnR+6qwxjKhSPOed61h4gjhKgLCovu/E6R7K48/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWGmcMg4Ss30evh79nYfXAKWhxh9rruXw+GWSWnI/m7jIKKE+YLsLHD1BTvc4GPrU
         Banw65HpTn4pk8dC5sfPhaIU6euUNdBMOKQchFFa48JxbFhMQeWnvSGw7IFomJZxE4
         Xyg1hYofiADCrSJvD8eTMakBZbhRuNghoU3J5b0AXDNFP3+aFLPJh62dXn8YtevPuP
         BhXwlqPbsdpwE79VwRhSlKQD+KKsu5yH6HdhoeiWjr/a2qrlgIs5X4IQuZEYnQiG2w
         11KWPsFtaU6ILda37x2mlukZ/wfVxcewgZ8QB7nNZCGsrqmaLqj1m8DSd7N7+EDKjH
         yEMTRqr64O1bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 33/44] net: wwan: iosm: fix kernel test robot reported errors
Date:   Fri, 18 Nov 2022 21:11:13 -0500
Message-Id: <20221119021124.1773699-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 980ec04a88c9f0046c1da65833fb77b2ffa34b04 ]

Include linux/vmalloc.h in iosm_ipc_coredump.c &
iosm_ipc_devlink.c to resolve kernel test robot errors.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1

