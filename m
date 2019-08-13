Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9615E8AC64
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 03:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfHMBPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 21:15:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:28305 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfHMBPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 21:15:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 18:15:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="204919907"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 12 Aug 2019 18:15:07 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hxLP0-000IZr-JM; Tue, 13 Aug 2019 09:15:06 +0800
Date:   Tue, 13 Aug 2019 09:14:16 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] netdevsim: implement support for devlink region
 and snapshots
Message-ID: <201908130911.8CmyawQC%lkp@intel.com>
References: <20190812101620.7884-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812101620.7884-1-jiri@resnulli.us>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jiri-Pirko/netdevsim-implement-support-for-devlink-region-and-snapshots/20190813-002135

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/netdevsim/dev.c:297:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
