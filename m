Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774F2F6BEC
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 01:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfKKAOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 19:14:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:2113 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfKKAOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 19:14:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 16:14:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,290,1569308400"; 
   d="scan'208";a="234292203"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2019 16:14:17 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iTxLU-000EG5-Sq; Mon, 11 Nov 2019 08:14:16 +0800
Date:   Mon, 11 Nov 2019 08:13:33 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     kbuild-all@lists.01.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next v1 PATCH 2/2] page_pool: make inflight returns more
 robust via blocking alloc cache
Message-ID: <201911110812.fwsFyJyx%lkp@intel.com>
References: <157323722783.10408.5060384163093162553.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157323722783.10408.5060384163093162553.stgit@firesoul>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on v5.4-rc6 next-20191108]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Jesper-Dangaard-Brouer/Change-XDP-lifetime-guarantees-for-page_pool-objects/20191110-062429
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 92da362c07d413786ab59db1665376fb63805586
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-21-gb31adac-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/core/page_pool.c:379:6: sparse: sparse: symbol 'page_pool_empty_alloc_cache_once' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
