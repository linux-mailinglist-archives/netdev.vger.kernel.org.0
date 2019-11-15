Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111D7FE827
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKOWjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:39:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:32628 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfKOWjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 17:39:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 14:39:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,309,1569308400"; 
   d="scan'208";a="203512412"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 15 Nov 2019 14:39:22 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iVkFN-000F33-Ug; Sat, 16 Nov 2019 06:39:21 +0800
Date:   Sat, 16 Nov 2019 06:38:33 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [net-next:master 217/233] drivers/net/phy/mscc.c:1683:3-4: Unneeded
 semicolon
Message-ID: <201911160629.1h9COFsK%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   a98cdaf73e32d1538cc225464fcf61310749471e
commit: 75a1ccfe6c726ba33a2f9859d39deb2eba620583 [217/233] mscc.c: Add support for additional VSC PHYs

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/phy/mscc.c:1683:3-4: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
