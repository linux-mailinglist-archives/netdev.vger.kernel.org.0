Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547A95B24AA
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiIHReF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiIHReC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:34:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07095A50E0
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662658442; x=1694194442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5JDJcWMo08yVL2ETAdqLZjIQUBUJ11ugQMz/X4YOU/E=;
  b=B2N2O0RWsyoDIMVZ+ojWAXvb8sPwfrLBV/fssnhdM1n2P5VGskvj1oL5
   hQsGbQ82Q/CEjSoLn7duEUGrn07bhTeMkS2Jul/qGoiXpsIQJCQELryM6
   HS9Rt3yFTF9ksCghl8CCStVYHoBxlgKeKrwFgdB7vvDm/bWZ4PxUxGbFn
   Gv2sfdiWwHMJVKoxM1U4Dmk8P8K9oeCEotV2YNYTyCFJcLfOeaaEe58s0
   lzVp+Iz9pMSW6ZBQ/zQvHxVwmYOMYDMIuvCYS1fQDEXxMo1Zw1Vu9ZpQV
   cyUrDlhB25zFMtdjkjInREXVs57cXBcCivB8Chx8crDdTfgfZrrJk3oKo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298611158"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298611158"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:33:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="790525760"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 08 Sep 2022 10:33:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 2/2] igc: Remove IGC_MDIC_INT_EN definition
Date:   Thu,  8 Sep 2022 10:33:44 -0700
Message-Id: <20220908173344.1282736-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908173344.1282736-1-anthony.l.nguyen@intel.com>
References: <20220908173344.1282736-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

IGC_MDIC_INT_EN definition is not used. This patch comes to tidy up the
driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 5c66b97c0cfa..4f9d7f013a95 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -610,7 +610,6 @@
 #define IGC_MDIC_OP_WRITE	0x04000000
 #define IGC_MDIC_OP_READ	0x08000000
 #define IGC_MDIC_READY		0x10000000
-#define IGC_MDIC_INT_EN		0x20000000
 #define IGC_MDIC_ERROR		0x40000000
 
 #define IGC_N0_QUEUE		-1
-- 
2.35.1

