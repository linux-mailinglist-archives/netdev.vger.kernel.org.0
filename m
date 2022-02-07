Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EE74ACD07
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiBHBFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343819AbiBGX7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:59:36 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF1C061A73;
        Mon,  7 Feb 2022 15:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644278376; x=1675814376;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z9uDw2JHmx5nPF6KoQtzLMWciYMCHc7D3nh5wmRQJg8=;
  b=Hz75hFc+hqzfqkjql8UWR9Fi6SwXyhLbl3mk30nWyq8HNoMmVw8FLaz3
   1qZkbE9TbPpf/65JjllsPr3gvyOHdIYhJ3pMd2ebQ4NevWsqoALGoP5Hf
   L1D4LTzpggwGvHRFu5RAbhCN27+WQmHS6Pmj0k5LAilYV8lSPxasyBXKF
   o4uVK3+nsOlh3tuGWHC7edJMyr+Xgsr+a8oQdNQiasCmk+PaXV55Xx8OC
   ej3+tW+PiEtCJZglD/avJimimxjI+yJvYXirqjL88MzYNlC64fXkkYPeR
   q5h8xG/vUcOsorOnfLpS9s/MyMj3JfGyu4ZGpQ7E55WY5BLbdgjQkfmAJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="248782181"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="248782181"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:59:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="621728144"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2022 15:59:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, jgg@nvidia.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        david.m.ertman@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN Driver Updates 2022-02-07
Date:   Mon,  7 Feb 2022 15:59:20 -0800
Message-Id: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
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

This pull request is targeting net-next and rdma-next branches. RDMA
patches will be sent to RDMA tree following acceptance of this shared
pull request. These patches have been reviewed by netdev and RDMA
mailing lists[1].

Dave adds support for ice driver to provide DSCP QoS mappings to irdma
driver.

[1] https://lore.kernel.org/netdev/20220202191921.1638-1-shiraz.saleem@intel.com/
---
The following are changes since commit e783362eb54cd99b2cac8b3a9aeac942e6f6ac07:
  Linux 5.17-rc1
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next

Dave Ertman (1):
  ice: add support for DSCP QoS for IDC

 drivers/net/ethernet/intel/ice/ice_idc.c | 5 +++++
 include/linux/net/intel/iidc.h           | 4 ++++
 2 files changed, 9 insertions(+)

-- 
2.31.1

