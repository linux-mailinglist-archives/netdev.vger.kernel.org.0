Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E25B4CCF
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 11:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiIKJCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 05:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIKJCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 05:02:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C53399E4;
        Sun, 11 Sep 2022 02:02:45 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MQNx80db2zHnm7;
        Sun, 11 Sep 2022 17:00:44 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 11 Sep 2022 17:02:42 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <gregory.greenman@intel.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <luciano.coelho@intel.com>,
        <johannes.berg@intel.com>, <cuigaosheng1@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 1/2] iwlwifi: remove killer1650w_2ax_cfg and killer1650x_2ax_cfg declarations
Date:   Sun, 11 Sep 2022 17:02:40 +0800
Message-ID: <20220911090241.3207201-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911090241.3207201-1-cuigaosheng1@huawei.com>
References: <20220911090241.3207201-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

killer1650w_2ax_cfg and killer1650x_2ax_cfg have been removed since
commit 5e003982b07a ("iwlwifi: move AX200 devices to the new table"),
so remove them.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f5b556a103e8..dd30a997c172 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -620,8 +620,6 @@ extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650s_2ax_cfg_qu_c0_hr_b0;
 extern const struct iwl_cfg killer1650i_2ax_cfg_qu_c0_hr_b0;
-extern const struct iwl_cfg killer1650x_2ax_cfg;
-extern const struct iwl_cfg killer1650w_2ax_cfg;
 extern const struct iwl_cfg iwl_qnj_b0_hr_b0_cfg;
 extern const struct iwl_cfg iwlax210_2ax_cfg_so_jf_b0;
 extern const struct iwl_cfg iwlax211_2ax_cfg_so_gf_a0;
-- 
2.25.1

