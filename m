Return-Path: <netdev+bounces-11057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC98731614
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB6941C20DE9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5366AAC;
	Thu, 15 Jun 2023 11:05:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB071FA6
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:05:54 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ED42955
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686827145; x=1718363145;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TbvtmmlzfMGEx3J7Y1xjQZk0k2tOmu5YA2biTGqy+88=;
  b=akut8I4SfeZnGsT6A7MRXErFDqyGlNp+itsf48ysRveC179gt7pBX/DB
   9Oa38SQJhM4cW7eaBAs4PlwaR6sKgCcRO/DFMJXzJmRJYStKNaEYN8ehq
   8KFDW2ODu2KH4KOe+LTNxQlktQ0+gljNycR9kRgRR2yTcl/UXyHNJBJBs
   4bwWOqzfIXDjI6of55F0yL6XZgExrWpxmhUdg5yDSawBSphe4Jb9l4+Xu
   2NSoeamCrXsXP4U0ZBFwm4clULoDHX97HXFk9aIyNTVK2zDmqR+KyuMj4
   j3s7sVHTJ/rZ/zkHMR5shULlLqj59lZOKfScrx2HFnJ3KHofIVzsrmpCN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387329813"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="387329813"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 04:05:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="1042624082"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="1042624082"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2023 04:05:32 -0700
Received: from pelor.igk.intel.com (pelor.igk.intel.com [10.123.220.13])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 6287F33BE4;
	Thu, 15 Jun 2023 12:05:31 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH iwl-next v2 0/2] iavf: make some functions static
Date: Thu, 15 Jun 2023 07:03:07 -0400
Message-Id: <20230615110309.14698-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Turn functions that are used in just one translation unit to be static.
Remove all unused functions (but keep exported ones for now).

This series depends on three patches that are in Tony's queue, see [1],
[2], [3] - dependencies are just about avoiding trivial git conflicts.

[1] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230502152908.701880-1-ahmed.zaki@intel.com/
("iavf: remove mask from iavf_irq_enable_queues()")

[2] https://lore.kernel.org/intel-wired-lan/20230509111148.4608-3-dinghui@sangfor.com.cn/
("iavf: Fix out-of-bounds when setting channels on remove")

[3] https://lore.kernel.org/intel-wired-lan/20230605145226.1222225-2-mateusz.palczewski@intel.com/
("iavf: Wait for reset in callbacks which trigger it")

For third of those patches, I'm suspicious of git-format-patch generating
"bad" prerequisite-patch-id, it's stable across the runs and rebases,
but it's different than the one reported by git-patch-id
(= ea8d85f15350eff7a2aa4fdb0e2653d856b42184).
I don't know if anybody cares about those anyway.

v2 - typo fixed, links to prereqs for second patch.

Przemek Kitszel (2):
  iavf: remove some unused functions and pointless wrappers
  iavf: make functions static where possible

 drivers/net/ethernet/intel/iavf/iavf.h        | 10 -----
 drivers/net/ethernet/intel/iavf/iavf_alloc.h  |  3 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c | 45 -------------------
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 34 ++++++--------
 drivers/net/ethernet/intel/iavf/iavf_osdep.h  |  9 ----
 .../net/ethernet/intel/iavf/iavf_prototype.h  |  5 ---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   | 43 +++++++++---------
 drivers/net/ethernet/intel/iavf/iavf_txrx.h   |  4 --
 8 files changed, 35 insertions(+), 118 deletions(-)


base-commit: fa0e21fa44438a0e856d42224bfa24641d37b979
prerequisite-patch-id: 141de8c9f97d59aa7df2481120f1d666f90420cb
prerequisite-patch-id: 6eb49686279d9b2046d6fe5c78a882025c87f3ff
prerequisite-patch-id: 2b1499c46b646b5402867deee8d40b73d752599a
-- 
2.40.1


