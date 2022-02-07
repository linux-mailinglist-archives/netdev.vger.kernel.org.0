Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A454ACDC3
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245478AbiBHBGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239718AbiBGXc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:32:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A89AC061355;
        Mon,  7 Feb 2022 15:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644276775; x=1675812775;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=roNur7xt9W/+tkOmxvKe2APccW8Ci8hXBtHvfXkGCk8=;
  b=fw06696w9AKDMzVD/+Gv4Q8UkNfhvk+Jp/l8jehKWPWq2DbCyWSYsNuP
   GtgCLHHRBWKCG3yhVTBzApmJxq5h/6oxLfs+nZXDWfAHvl0lbNJkPOHB1
   629DVXFanHJOan7EnDhaPNpRF3cOiJIoUmPPzJHzgHQATmi281W9nOlpu
   XeoXA+ZMPxjCA+psRdAZRLEVU0F8rXt2iIit8bpYDZRMEg+bhH2e8gS2k
   3ChY++xm2lBlUOiF4PoO7F2R/aCJFqpb2+PxCt1McbzWRyZywvFVZeX+3
   0TzH8wdp+rL7AY1D3fonKHVnMeRk3fJmY4YkvZaiKoONqIU3UTZ72xpDF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="335232071"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="335232071"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:32:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="772948619"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2022 15:32:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        vinschen@redhat.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver Updates 2022-02-07
Date:   Mon,  7 Feb 2022 15:32:44 -0800
Message-Id: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
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

Corinna Vinschen says:

Fix the kernel warning "Missing unregister, handled but fix driver"
when running, e.g.,

  $ ethtool -G eth0 rx 1024

on igc.  Remove memset hack from igb and align igb code to igc.

The following are changes since commit ff62433883b3ab753a78954ecf46e2c514f5c407:
  net: dsa: mv88e6xxx: Unlock on error in mv88e6xxx_port_bridge_join()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Corinna Vinschen (2):
  igc: avoid kernel warning when changing RX ring parameters
  igb: refactor XDP registration

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 19 +++++++++++++------
 drivers/net/ethernet/intel/igc/igc_main.c    |  3 +++
 3 files changed, 16 insertions(+), 10 deletions(-)

-- 
2.31.1

