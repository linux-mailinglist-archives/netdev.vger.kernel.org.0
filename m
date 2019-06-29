Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE685A855
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 04:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF2CV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 22:21:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:49746 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfF2CV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 22:21:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 19:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="167932036"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2019 19:21:25 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hh2zV-000GDb-8R; Sat, 29 Jun 2019 10:21:25 +0800
Date:   Sat, 29 Jun 2019 10:21:15 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute
 Engine Virtual NIC
Message-ID: <201906291033.gGpBQ9F9%lkp@intel.com>
References: <20190626185251.205687-2-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-2-csully@google.com>
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

   drivers/net/ethernet/google/gve/gve_main.c:23:12: sparse: sparse: symbol 'gve_version_str' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_main.c:24:12: sparse: sparse: symbol 'gve_version_prefix' was not declared. Should it be static?
>> drivers/net/ethernet/google/gve/gve_main.c:352:25: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_main.c:352:25: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_main.c:352:25: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_main.c:352:25: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_main.c:352:25: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_main.c:352:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:353:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:353:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:353:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:353:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:353:25: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/google/gve/gve_main.c:353:25: sparse: sparse: cast to restricted __be32
--
>> drivers/net/ethernet/google/gve/gve_adminq.c:28:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
>> drivers/net/ethernet/google/gve/gve_adminq.c:28:16: sparse:    expected unsigned int val
>> drivers/net/ethernet/google/gve/gve_adminq.c:28:16: sparse:    got restricted __be32 [usertype]
   drivers/net/ethernet/google/gve/gve_adminq.c:68:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
   drivers/net/ethernet/google/gve/gve_adminq.c:68:16: sparse:    expected unsigned int val
   drivers/net/ethernet/google/gve/gve_adminq.c:68:16: sparse:    got restricted __be32 [usertype]
>> drivers/net/ethernet/google/gve/gve_adminq.c:77:21: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_adminq.c:77:21: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_adminq.c:77:21: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_adminq.c:77:21: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_adminq.c:77:21: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/google/gve/gve_adminq.c:77:21: sparse: sparse: cast to restricted __be32

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
