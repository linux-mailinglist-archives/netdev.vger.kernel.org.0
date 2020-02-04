Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A599151C0E
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgBDOWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 09:22:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:25324 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbgBDOWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 09:22:11 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 06:22:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="429820153"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 04 Feb 2020 06:22:10 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iyz5d-000HXc-At; Tue, 04 Feb 2020 22:22:09 +0800
Date:   Tue, 4 Feb 2020 22:21:57 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net:master 40/48] drivers/net/netdevsim/dev.c:937:1-3: WARNING:
 PTR_ERR_OR_ZERO can be used
Message-ID: <202002042248.5gLay9S1%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
head:   83b43045308ea0600099830292955f18818f8d5e
commit: 6556ff32f12d0a5380dd2fa6bbaa01373925a7d1 [40/48] netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/netdevsim/dev.c:937:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
