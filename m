Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21E6487BA8
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348644AbiAGR5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:57:43 -0500
Received: from mga18.intel.com ([134.134.136.126]:47970 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240370AbiAGR5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641578263; x=1673114263;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1t4NZKaiMDVKE4nfh0iM6ujrWQ/AWtvaFdsHMpBYy1I=;
  b=fZPYgzRZZz4SBZhw+diG7lEppjoAki6qYURDTO14jELsyqRrpIl4sD2y
   tXWMDqFRYccRpMhATty1y9T+yoimSsh/ZV65Wak4ISYMoTpoJ0y0Upl9M
   7wMD67lxYXgHjF6kDg0Y7P7ZZmouR3AQEsJk4ROluSE8vPmd1BL6ZyzHP
   QfYomQRgoLr3Sv79SgKsjGc0BbSpRCbw9S3lUH0BtlcyCPuM6rSQ4jWgz
   FSE5F9RizaOpA1xlE3kBDPRNa3eSwjzx3RMYTM0zmnQBzH6gwZpRcFU+h
   6uPqb2fuVxeDkcpwqbG/Akh+wp21xNxU3qeH6oWTrQHFMKDVoC0zTZ828
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="229716401"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="229716401"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:57:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668831897"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2022 09:57:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next v2 0/6][pull request] 40GbE Intel Wired LAN Driver Updates 2022-01-07
Date:   Fri,  7 Jan 2022 09:56:58 -0800
Message-Id: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Karen limits per VF MAC filters so that one VF does not consume all
filters for i40e.

Jedrzej reduces busy wait time for admin queue calls for i40e.

Mateusz updates firmware versions to reflect new supported NVM images
and renames an error to remove non-inclusive language for i40e.

Yang Li fixes a set but not used warning for i40e.

Jason Wang removes an unneeded variable for iavf.
---
v2: Dropped patch 2

The following are changes since commit c25af830ab2608ef1dd5e4dada702ce1437ea8e7:
  sch_cake: revise Diffserv docs
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Jason Wang (1):
  iavf: remove an unneeded variable

Jedrzej Jagielski (1):
  i40e: Minimize amount of busy-waiting during AQ send

Karen Sornek (1):
  i40e: Add ensurance of MacVlan resources for every trusted VF

Mateusz Palczewski (2):
  i40e: Update FW API version
  i40e: Remove non-inclusive language

Yang Li (1):
  i40e: remove variables set but not used

 drivers/net/ethernet/intel/i40e/i40e_adminq.c | 29 ++++++++++++----
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  4 +--
 drivers/net/ethernet/intel/i40e/i40e_common.c | 15 ++++----
 .../net/ethernet/intel/i40e/i40e_prototype.h  | 14 +++++---
 drivers/net/ethernet/intel/i40e/i40e_status.h |  2 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 34 ++++++++++++++++---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c |  4 +--
 7 files changed, 70 insertions(+), 32 deletions(-)

-- 
2.31.1

