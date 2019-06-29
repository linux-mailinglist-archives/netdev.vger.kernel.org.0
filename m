Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5EA5A946
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 08:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfF2Gki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 02:40:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:3810 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfF2Gki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 02:40:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 23:40:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,430,1557212400"; 
   d="scan'208";a="170948957"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jun 2019 23:40:36 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hh72J-0004PB-RF; Sat, 29 Jun 2019 14:40:35 +0800
Date:   Sat, 29 Jun 2019 14:40:03 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 4/4] gve: Add ethtool support
Message-ID: <201906291448.1i4e8XiQ%lkp@intel.com>
References: <20190626185251.205687-5-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-5-csully@google.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Catherine,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Catherine-Sullivan/Add-gve-driver/20190629-070444
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/google/gve/gve_ethtool.c:147:6: sparse: sparse: symbol 'gve_get_channels' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_ethtool.c:161:5: sparse: sparse: symbol 'gve_set_channels' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_ethtool.c:191:6: sparse: sparse: symbol 'gve_get_ringparam' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_ethtool.c:202:5: sparse: sparse: symbol 'gve_user_reset' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
