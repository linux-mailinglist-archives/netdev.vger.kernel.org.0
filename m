Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF71634307
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiKVRyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiKVRyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:54:25 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285249FD3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669139482; x=1700675482;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bBp268VRHvkROejp0f1YcgkNF5DcG8MfG+XZ4PBNAk8=;
  b=fN43cv9K7IoFQpH+t/1uds23RkaRUvouR8d3I0+hEjVhbBFJmsMwm85t
   dI3spl4/L0ZwmoDRWkNX4+Fux18nwYl60PhmkJPICBq+V2477fphEeHYh
   S39j1TivoJxqgPSSjRzmpvelNDUebHre0s4Mx4iRRbSMiB4AF96CEfpa9
   xmDR+POpS2Zelrq9ESKA2yTIi9Mz1orkFERgjcIdhkberJPJshxFpBPOE
   4p4nBUGc75HFl+eMk8fzSa629SA0IELYPST8behJeq7H+JMDT1JrD+C/l
   UuROga88TGb5rFK8uEPz8zEGqMuX6x04vkexwK9YqVH3NckVFFklUKAst
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315695633"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="315695633"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 09:46:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="886621064"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="886621064"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2022 09:46:04 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com,
        edumazet@google.com, pabeni@redhat.com
Subject: [PATCH net 0/4] net: wwan: iosm: build error & bug fixes
Date:   Tue, 22 Nov 2022 23:15:49 +0530
Message-Id: <20221122174549.3496791-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

This patch series fixes iosm driver bugs & build errors.

PATCH1: Fix kernel build robot reported error.
PATCH2: Fix build error reported on armhf while preparing
        6.1-rc5 for Debian.
PATCH3: Fix UL throughput crash.
PATCH4: Fix incorrect skb length.

Refer to commit message for details.

M Chetan Kumar (4):
  net: wwan: iosm: fix kernel test robot reported error
  net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
  net: wwan: iosm: fix crash during peek throughput test
  net: wwan: iosm: fix incorrect skb length

 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 21 +++++++++++----------
 drivers/net/wwan/iosm/iosm_ipc_protocol.h  |  2 +-
 2 files changed, 12 insertions(+), 11 deletions(-)

--
2.34.1

