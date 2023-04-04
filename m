Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048156D6A90
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbjDDR2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbjDDR2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:28:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2743372AA
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680629191; x=1712165191;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z/Mw0l+ClZSLA/z8g8WFrNNPDyz2sEXnkH3iP+NhOyo=;
  b=J0IuGm+Py/+Xs3z0IP4AiKZM+w5tniYyMtT2/lXgYgPkYiCBah4dXzt2
   OJJVcqidRVgvPEdvEZsqBH2PtC9udS6MBuzcHHMf7UdqQaENVmbdC8ziv
   LcnM5TO1yt+7auAH1oheb+YvOOimFsmi1P4ruRRUHbjAxI1KF5Zf+BYfk
   3T/NWYIFyxhwmTzIRFZnKVVfy2XFRsqCbszw+RD/TrNqvPFE9Z6nCNfK8
   9q/vyA67Y8VCL2lFAcdvFsQ5TTymZm6uJXBEtPEWzJ72X6Pzfpr1kL0z8
   1QQzutzHzOaadk89C1I7OwZPibO6+IrvI3QdXlJZWVJVQx2Fj4IoBsqo/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="370072099"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="370072099"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719022180"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="719022180"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 04 Apr 2023 10:25:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2023-04-04 (ice)
Date:   Tue,  4 Apr 2023 10:23:04 -0700
Message-Id: <20230404172306.450880-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Simei adjusts error path on adding VF Flow Director filters that were
not releasing all resources.

Lingyu adds setting/resetting of VF Flow Director filters counters
during initialization.

The following are changes since commit 218c597325f4faf7b7a6049233a30d7842b5b2dc:
  net: stmmac: fix up RX flow hash indirection table when setting channels
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Lingyu Liu (1):
  ice: Reset FDIR counter in FDIR init stage

Simei Su (1):
  ice: fix wrong fallback logic for FDIR

 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

-- 
2.38.1

