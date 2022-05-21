Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AEF52FAF3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbiEULMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242252AbiEULMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:01 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8232980F;
        Sat, 21 May 2022 04:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MCZ1LCdE6QhPwxjygy1p2ljSuHfNgp/DKpBEOPMbvV0=;
  b=ffmrXDYAz3kOVNqXz9/9nIxUQ/C6AXMRbToffjoQD6I5ppRSuzOfPKVC
   NzE/bec03vUP78UnwXuCro4p9pptxfUofA8xj1FuIF/pjZ96fSGu4flrY
   eTKnmLQUqeKh63zFnERYeO8NHNAxg2SLKQ1HRY/gdkphnWuEDsNuTdl08
   o=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727906"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:53 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Gregory Greenman <gregory.greenman@intel.com>
Cc:     kernel-janitors@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix typos in comment
Date:   Sat, 21 May 2022 13:10:21 +0200
Message-Id: <20220521111145.81697-11-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling mistakes (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/wireless/intel/iwlwifi/fw/img.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index f878ac508801..f5c4d93d1033 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -182,10 +182,10 @@ struct iwl_dump_exclude {
  * @enhance_sensitivity_table: device can do enhanced sensitivity.
  * @init_evtlog_ptr: event log offset for init ucode.
  * @init_evtlog_size: event log size for init ucode.
- * @init_errlog_ptr: error log offfset for init ucode.
+ * @init_errlog_ptr: error log offset for init ucode.
  * @inst_evtlog_ptr: event log offset for runtime ucode.
  * @inst_evtlog_size: event log size for runtime ucode.
- * @inst_errlog_ptr: error log offfset for runtime ucode.
+ * @inst_errlog_ptr: error log offset for runtime ucode.
  * @type: firmware type (&enum iwl_fw_type)
  * @human_readable: human readable version
  *	we get the ALIVE from the uCode

