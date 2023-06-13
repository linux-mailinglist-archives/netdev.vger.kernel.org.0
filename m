Return-Path: <netdev+bounces-10399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A963572E554
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E395C1C20C8E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F107E370DC;
	Tue, 13 Jun 2023 14:15:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E578C522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:15:34 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57162ED
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686665733; x=1718201733;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vCq6GIGuzG53IbmhHaPzZOuPqZZIw5vadaI80J3AYSQ=;
  b=mpnxkFg2StGN9lqKLQseG8QUddJjWW5OqbcdciGUcRi4iFUJvALkPUOi
   xbSK1EOkbgixq03oUmCb5Ly2fMrW1EPf3pTinWc03XZgPX2ydQ97OASwx
   NVhHamtfFgJ77LDkZX0FnOu48eLrZUdOUz6j0bu6QyaU9N1eAq2YPGNHx
   OxM2kcpNka7kHSA1Z3Q3rGsyVbzlmSfFTrrS9kSDOb0n/LFL+ILIwSWnF
   5uLm/wWfgTat0w7HTCx78Or8AaYwSlcACTTUJSFH4ZOnG4bKDtuI+UWci
   AIywHOWVLtbRFMoKKtQMvDt1CZc877GX2g8j+fHByusOmMD9Wuy8LeXPf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="337981433"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="337981433"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:15:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="856104989"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="856104989"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2023 07:15:30 -0700
Received: from pelor.igk.intel.com (pelor.igk.intel.com [10.123.220.13])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 0AEF535429;
	Tue, 13 Jun 2023 15:15:29 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH iwl-next 0/2] iavf: make some functions static
Date: Tue, 13 Jun 2023 10:12:51 -0400
Message-Id: <20230613141253.57811-1-przemyslaw.kitszel@intel.com>
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
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make static functions that are used in just one translation unit.
Remove all unused and unexported functions.

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

-- 
2.40.1


