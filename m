Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8EF4722A8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389548AbfGWWzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:55:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:47515 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730837AbfGWWzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 18:55:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 15:55:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="scan'208";a="193228953"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jul 2019 15:55:22 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hq3gn-000AyY-Lb; Wed, 24 Jul 2019 06:55:21 +0800
Date:   Wed, 24 Jul 2019 06:54:57 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     kbuild-all@01.org, Martin Weinelt <martin@linuxlounge.net>,
        bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH TEST] net: bridge: mcast: fix possible uses of stale
 pointers
Message-ID: <201907240639.emhJo5xu%lkp@intel.com>
References: <908e9e90-70cc-7bbe-f83f-0810c9ef3925@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <908e9e90-70cc-7bbe-f83f-0810c9ef3925@cumulusnetworks.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[cannot apply to v5.3-rc1 next-20190723]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Nikolay-Aleksandrov/net-bridge-mcast-fix-possible-uses-of-stale-pointers/20190702-083354

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> net/bridge/br_multicast.c:999:8-14: ERROR: application of sizeof to pointer

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
