Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A22928BF76
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 20:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbgJLSN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 14:13:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:20165 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389885AbgJLSN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 14:13:57 -0400
IronPort-SDR: JuYE+b645+E+KYCN/bc6ZRbJISyZk8eJtq5ggeNjify07IhWfWyvukwOLMfegu/OS4whHsCqD5
 vb0J+AeU3D2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="153613143"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="153613143"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 11:13:57 -0700
IronPort-SDR: GsDNJUBbw2x6EZDNW4MKGm6maDW1MwPFOnqrYEnIYTvswQR5ez0BAA9LF8YaERJ7iioDX/iXUB
 xYV6fdBYga9Q==
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="463192898"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 11:13:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/2][pull request] 40GbE Intel Wired LAN Driver Updates 2020-10-12
Date:   Mon, 12 Oct 2020 11:13:44 -0700
Message-Id: <20201012181346.3073618-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and e1000 drivers.

Jaroslaw adds support for changing FEC on i40e if the firmware supports it.

Jesse fixes a kbuild-bot warning regarding ternary operator on e1000. 

v2: Return -EOPNOTSUPP instead of -EINVAL when FEC settings are not
supported by firmware. Remove, unneeded, done label and return errors
directly in i40e_set_fec_param() for patch 1. Dropped, previous patch 2,
to send to net. 

The following are changes since commit 15f5e48f93c0e028b4d5cc0e8ede1168a2308fe6:
  cx82310_eth: use netdev_err instead of dev_err
and are available in the git repository at:
  https://github.com/anguy11/next-queue.git 40GbE

Jaroslaw Gawin (1):
  i40e: Allow changing FEC settings on X722 if supported by FW

Jesse Brandeburg (1):
  e1000: remove unused and incorrect code

 drivers/net/ethernet/intel/e1000/e1000_hw.c   | 10 +-----
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  6 ++++
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 ++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 33 ++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 19 +++++++++++
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 6 files changed, 50 insertions(+), 21 deletions(-)

-- 
2.26.2

