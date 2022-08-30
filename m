Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9365A65C7
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiH3N5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiH3N5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:57:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A756B1037E2;
        Tue, 30 Aug 2022 06:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661867787; x=1693403787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1X6dFnwQW2ESGhqZFbnec+kA7U67zrpjGvKoEq5DS4I=;
  b=EDGZHk1RpgT4jE3YGwKIcu/G5Lg2op8Zc+QTjWMQOfNTpSpWKO9T1HZn
   qg9OaXP45r6j1092AUAKyl/w4G24zMqkpxicaKEA/nQv4Dqyv5EXZYti1
   BdD6WHb5XsojqqSBbKScrC1N7Plu/4GOj+GNNWevLSWyW29giYJqI5DxA
   WAonRJ3UvhYbs9qFK6Mg9dP67HoT1NKZ4tAHPAh0OHj9oJbWv2dmUaqcK
   QiEHzHQ7mDo0KA1KPo+c7FkX4WzJ2A8HJoXdhD6yLJ7zhB1zCD7Pk09Jp
   V907eQZH2b6mum6gJuRfuT4nUIL2K6YYcgtlGBMjrfWiU2fKx/TusZ/th
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295180387"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295180387"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:56:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="562651319"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 06:56:25 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 3/6] selftests: xsk: increase chars for interface name
Date:   Tue, 30 Aug 2022 15:56:01 +0200
Message-Id: <20220830135604.10173-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
References: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that "enp240s0f0" or such name can be used against xskxceiver.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 8d1c31f127e7..12bfa6e463d3 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -29,7 +29,7 @@
 #define TEST_FAILURE -1
 #define TEST_CONTINUE 1
 #define MAX_INTERFACES 2
-#define MAX_INTERFACE_NAME_CHARS 7
+#define MAX_INTERFACE_NAME_CHARS 10
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKETS 2
 #define MAX_TEST_NAME_SIZE 32
-- 
2.34.1

