Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C04F4738A2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 00:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242642AbhLMXis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 18:38:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:44420 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238160AbhLMXis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 18:38:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639438728; x=1670974728;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UR+fJ4VmLFRwnP5c+7ylvVOLpiG1PSOLIz4raVsEAig=;
  b=NWeHSOcszI0Kib4QbKJlzbRCyNTnCs8yjy2xm7tDw8rmZM7HuRaW57NU
   hQ/eOYd36/rCGAFrbIXcmrEopR9OHYvAy4a6sVDisti6Pa7g/3f/TUNh3
   rFxjkWgD9TLQ7yUYYp1IJnFynqsX4OR+1S0JhNvpAs7td64TOD5wzHAAL
   uJ1g13Mhm5Y0k3tpIBcdyRQs+faT/gGc5YJAn4GgGtISaVPKpbRmkT/k6
   8WfHF/9rNZChyf44RtKlHlG1NHsM6o2i08oNJFafnMI21TKZCFr5UiiuN
   HxjyzpXFl567lDFoeYu7snhiapDyvrUk4OseNAfjduUnrT1GuocqDTcfL
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="219539644"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="219539644"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 15:38:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="661052302"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 15:38:47 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-12-13
Date:   Mon, 13 Dec 2021 15:37:48 -0800
Message-Id: <20211213233750.930233-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Dan Carpenter fixes some missing mutex unlocking.

Stefan Assmann restores stopping watchdog from overriding to reset state.

The following are changes since commit 884d2b845477cd0a18302444dc20fe2d9a01743e:
  net: stmmac: Add GFP_DMA32 for rx buffers if no 64 capability
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Dan Carpenter (1):
  iavf: missing unlocks in iavf_watchdog_task()

Stefan Assmann (1):
  iavf: do not override the adapter state in the watchdog task (again)

 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.31.1

