Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E6063BF4
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfGITce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:32:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:41957 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727248AbfGITc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 15:32:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 12:32:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,471,1557212400"; 
   d="scan'208";a="317124773"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 09 Jul 2019 12:32:27 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hkvqk-0003hv-Dy; Wed, 10 Jul 2019 03:32:26 +0800
Date:   Wed, 10 Jul 2019 03:32:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     kbuild-all@01.org, Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [linux-next:master 13028/13492]
 drivers/net/ethernet/ti/davinci_cpdma.c:725:5: sparse: sparse: symbol
 'cpdma_chan_split_pool' was not declared. Should it be static?
Message-ID: <201907100329.bQl3UgMB%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git master
head:   4608a726c66807c27bc7d91bdf8a288254e29985
commit: 962fb618909ef64e0c89af5b79ba0fed910b78e3 [13028/13492] net: ethernet: ti: davinci_cpdma: allow desc split while down
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout 962fb618909ef64e0c89af5b79ba0fed910b78e3
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/ti/davinci_cpdma.c:725:5: sparse: sparse: symbol 'cpdma_chan_split_pool' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
