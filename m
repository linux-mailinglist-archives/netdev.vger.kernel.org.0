Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CBD4A53B7
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiBAAFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:05:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:65448 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbiBAAFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 19:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643673938; x=1675209938;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z2e34IdtP3ilqVMnhJ9DtvzLBRuJQn6wjL7kQzYRKcc=;
  b=eOaF17NRrpwbaSGrdY/ijDi++T52bBf3Wb2h/wLJk0GTWYaEv31sXhGY
   wjJyd+xXdTLY8V32UEBkesdYzyRwYL8aHhgiWrvvnBhi3qlXxUBs0iwZh
   2RbS0XJQbbTy/LEUHLj+udccRk57JAxK0+Y1KYkfTRz979vUhH5TLYyIj
   TcWmmkicxC43UZH5sSKpzThyCkwWeSXepzHhiY8UmcXubmVWX48dqptT6
   cjuto1H6282cF0pH2wwQ3i6Y3qMAxyZ73F0yZQCkQbev36oEIR+YjTc1l
   AYvL0D00IjrKpjLJLSuINYnPkZ7KG1/d94tIKf5Ygdw/prP+TsrKYMVBu
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="246417047"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="246417047"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 16:05:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="698209555"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 31 Jan 2022 16:05:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-01-31
Date:   Mon, 31 Jan 2022 16:05:20 -0800
Message-Id: <20220201000522.505909-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Jedrzej fixes a condition check which would cause an error when
resetting bandwidth when DCB is active with one TC.

Karen resolves a null pointer dereference that could occur when removing
the driver while VSI rings are being disabled.

The following are changes since commit 341adeec9adad0874f29a0a1af35638207352a39:
  net/smc: Forward wakeup to smc socket waitqueue after fallback
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Jedrzej Jagielski (1):
  i40e: Fix reset bw limit when DCB enabled with 1 TC

Karen Sornek (1):
  i40e: Fix reset path while removing the driver

 drivers/net/ethernet/intel/i40e/i40e.h      |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 31 +++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.31.1

