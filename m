Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA44541271
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357176AbiFGTqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 15:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357410AbiFGTpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 15:45:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A3964D18
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 11:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654625920; x=1686161920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+omSLsS0oer9RQ69AukBD+/mke/GrVPwa8dfpXfG6zI=;
  b=jEK63ci6hd+MS4didXnwq6AZGmN9esr1rWmxIX4lMgzuhjV7o4sOrFoB
   G86SKRBNzFswHFRy3HTqeqg8KD1zfQMQazz6z3U8D3Anx2CKFKzUZGYYm
   0ucGHCe5QJW6GsPCNH7wmGlKQ/cz7jI6Sl3tvJ7QKRP0o1bXGHHWCyd2K
   VTAfUXg5FeoTyPfClqTOTRHOQ9iNoo3EySPoP8PqADlX89FYVABfgC/XJ
   LQPeOwpJmNbz75Nil80cbgLNNiA/T9uSLGYpc5LOVZbYnCGRF8uWZlKf5
   L+DNdLaae1vcJCqk4Aw4ewJp/S5bnCxeGMA160Y+gtjuIlYc2LAAt/wBl
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302096343"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="302096343"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 11:18:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="907165813"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jun 2022 11:18:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-06-07
Date:   Tue,  7 Jun 2022 11:15:36 -0700
Message-Id: <20220607181538.748786-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe driver only.

Olivier Matz resolves an issue so that broadcast packets can still be
received when VF removes promiscuous settings and removes setting of
VLAN promiscuous, in promiscuous mode, to prevent a loop when VFs are
bridged.

The following are changes since commit cf67838c4422eab826679b076dad99f96152b4de:
  selftests net: fix bpf build error
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Olivier Matz (2):
  ixgbe: fix bcast packets Rx on VF after promisc removal
  ixgbe: fix unexpected VLAN Rx in promisc mode on VF

 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.35.1

