Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAA1107ADA
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:51:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:61839 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfKVWvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:51:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="232805997"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2019 14:51:12 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYHlf-0009ih-V7; Sat, 23 Nov 2019 06:51:11 +0800
Date:   Sat, 23 Nov 2019 06:50:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     kbuild-all@lists.01.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [linux-next:master 13276/13503]
 drivers/net/dsa/ocelot/felix.c:351:6: sparse: sparse: symbol
 'felix_txtstamp' was not declared. Should it be static?
Message-ID: <201911230623.rJBgtgcn%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   b9d3d01405061bb42358fe53f824e894a1922ced
commit: c0bcf537667cf88bbcbb377d01d2b79c45265741 [13276/13503] net: dsa: ocelot: add hardware timestamping support for Felix
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-32-g233d4e1-dirty
        git checkout c0bcf537667cf88bbcbb377d01d2b79c45265741
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/dsa/ocelot/felix.c:351:6: sparse: sparse: symbol 'felix_txtstamp' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
