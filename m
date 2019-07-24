Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7F726BD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfGXEhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:37:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:4962 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfGXEhj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 00:37:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 21:37:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="scan'208";a="189007068"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jul 2019 21:37:37 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hq921-000FYF-H2; Wed, 24 Jul 2019 12:37:37 +0800
Date:   Wed, 24 Jul 2019 12:37:14 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org
Subject: [net-next:master 7/33]
 drivers/target/iscsi/cxgbit/cxgbit_target.c:1451:47-48: Unneeded semicolon
Message-ID: <201907241208.upolDRPG%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/davem/net-next.git master
head:   3e3bb69589e482e0783f28d4cd1d8e56fda0bcbb
commit: d7840976e3915669382c62ddd1700960f348328e [7/33] net: Use skb accessors in network drivers

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/target/iscsi/cxgbit/cxgbit_target.c:1451:47-48: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
