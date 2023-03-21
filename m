Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDFE6C3943
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCUShh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCUShg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:37:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C66B509A7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679423856; x=1710959856;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d8lDnuPEinwYyfnlqn5KHxuxvDUmd+7KklGNQa5jkHw=;
  b=AAbaiwu0VdFvtMF5ADsFnInIlfhRqCMqfoZ5kVV/Z+Ap6iK27gTwpe2v
   VyuklUYqh62E1PDBVJvcex14aRGNB0tPDiDZiy30O8fjc45S7lRDV1/mn
   QbRVOUvvRLEPyizDrolS9NUao7b20NWPg/V4MWjHT3RZS5lO9clfhdZd0
   7hZQgehZ5XR0aM68TIs3u7PvdF1RfWLz8YKrC8KTR4s0d96FiWOTCb4hS
   ofmcTl4dVBOkrLHaLnrQznOVAu7RUT/8SoIMI5oo6EDVHjoLXhxphygw5
   78pkc8yRGIwrcCFrnt0Qj27rDS2pE4Sr4q4w2GF6HA5jr6GD0kHSwqI2Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="319420483"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="319420483"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 11:37:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="711922447"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="711922447"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 21 Mar 2023 11:37:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2023-03-21 (iavf, i40e)
Date:   Tue, 21 Mar 2023 11:35:46 -0700
Message-Id: <20230321183548.2849671-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf and i40e drivers.

Stefan Assmann adds check, and return, if driver has already gone
through remove to prevent hang for iavf.

Radoslaw adds zero initialization to ensure Flow Director packets are
populated with correct values for i40e.

The following are changes since commit f038f3917baf04835ba2b7bcf2a04ac93fbf8a9c:
  octeontx2-vf: Add missing free for alloc_percpu
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Radoslaw Tyl (1):
  i40e: fix flow director packet filter programming

Stefan Assmann (1):
  iavf: fix hang on reboot with ice

 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 ++++----
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.38.1

