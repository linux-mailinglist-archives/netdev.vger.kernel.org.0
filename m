Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDE18FE1D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgCWTwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:52:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:37597 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgCWTwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 15:52:51 -0400
IronPort-SDR: j0SczEG1UGB8j1a2u04kE6vU++P6Mxd68TvhxFZQ4aVlKJF2+2EFyhHF//iyX6FScCGrJoV7rZ
 TPpj3N6g3K7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 12:52:39 -0700
IronPort-SDR: /IKRFckug6Av15usv1zOKNZDkdqcPtGKWCpxVsBS4BLk/Q5yIG26wuax1TNE38RB2IWiJcbgDx
 HsBSRrrch0tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="246302916"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2020 12:52:36 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jGT7k-000I2V-7X; Tue, 24 Mar 2020 03:52:36 +0800
Date:   Tue, 24 Mar 2020 03:51:39 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 54/321] drivers/net/phy/dp83867.c:363:2-3: Unneeded
 semicolon
Message-ID: <202003240333.9w4m8TaM%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   09984483db080b541c8242d846c30bc1e6a194e1
commit: cd26d72d4d43175cec8c10bed4df7f21ac5316b3 [54/321] net: phy: dp83867: Add speed optimization feature

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/phy/dp83867.c:363:2-3: Unneeded semicolon
   drivers/net/phy/dp83867.c:398:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
