Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C026B82D4
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCMUgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCMUgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:36:19 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0CD6287B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678739778; x=1710275778;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yiPGkCuFWRqq/+zZ5dNxbmWknE3r/SafDd8SL+ywou8=;
  b=FWektVv9dwzFdcupb9z5etJVQvIkr6kjwOM+TLxY0jYvMR4L6u9yObf9
   fDZUTIjEB7yHv34cwd/v4PJ+NIWtS2N2JIEo+cVYsyzw4LBWkv8pwEDZ3
   dmmT3t4BIcu4PVJDfeTav1g2V7nEVLIvv6/F7UC7X3NWa5iTvZwvXPWPQ
   FQ3jE2qaN50mUiyOF6Mwwq8a0nEU1wlyXkoppprPdwFAANAvEBTdofvxc
   ros2dgCLBV6YTrs6FEqHBrSYztHhkGkpULtqu7nXvaUiil8yqUgWlSI52
   drKVB7q8PlA3Xgz79v4n9CN46kEfP2+c1EaHpgBukSABsaB/cbIGTGJuc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364913216"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="364913216"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 13:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747732593"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="747732593"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.102])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 13:36:17 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net v1 0/2] ice_switch fixes series
Date:   Mon, 13 Mar 2023 13:36:06 -0700
Message-Id: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a couple of small issues, with a small refactor to correctly handle
a possible misconfiguration of RDMA filters, and some trivial function
headers that didn't match their function.

Brett Creeley (1):
  ice: Fix ice_cfg_rdma_fltr() to only update relevant fields

Jesse Brandeburg (1):
  ice: fix W=1 headers mismatch

 drivers/net/ethernet/intel/ice/ice_switch.c   | 26 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  1 +
 3 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.39.2

