Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2EC14524F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 05:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfFNDC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 23:02:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:22702 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfFNDC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 23:02:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 20:02:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,371,1557212400"; 
   d="scan'208";a="184828939"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jun 2019 20:02:55 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hbcUQ-0001e5-Le; Fri, 14 Jun 2019 11:02:54 +0800
Date:   Fri, 14 Jun 2019 11:02:08 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sameeh Jubran <sameehj@amazon.com>
Cc:     kbuild-all@01.org, Netanel Belgazal <netanel@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [linux-next:master 5930/6350]
 drivers/net/ethernet/amazon/ena/ena_netdev.c:1158:6: sparse: sparse: symbol
 'ena_adjust_intr_moderation' was not declared. Should it be static?
Message-ID: <201906141113.NUYnC1ZG%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   da151e650328dcd37176cf49fc626a7f42bfbe17
commit: c2b542044761965db0e4cc400ab6abf670fc25b7 [5930/6350] net: ena: remove inline keyword from functions in *.c
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout c2b542044761965db0e4cc400ab6abf670fc25b7
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/amazon/ena/ena_netdev.c:1158:6: sparse: sparse: symbol 'ena_adjust_intr_moderation' was not declared. Should it be static?
   drivers/net/ethernet/amazon/ena/ena_netdev.c:3428:59: sparse: sparse: Using plain integer as NULL pointer

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
