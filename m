Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B515C7D3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 05:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfGBDdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 23:33:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:40274 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbfGBDdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 23:33:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 20:33:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,441,1557212400"; 
   d="scan'208";a="157493903"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 01 Jul 2019 20:33:12 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hi9Xb-0002MI-VF; Tue, 02 Jul 2019 11:33:11 +0800
Date:   Tue, 2 Jul 2019 11:33:05 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     kbuild-all@01.org, Martin Weinelt <martin@linuxlounge.net>,
        bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH TEST] net: bridge: mcast: fix possible uses of stale
 pointers
Message-ID: <201907021114.h1fVI3eg%lkp@intel.com>
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
[also build test WARNING on v5.2-rc6 next-20190625]
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
