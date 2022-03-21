Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E154E34A4
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiCUXql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiCUXqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:46:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D300D78FD7;
        Mon, 21 Mar 2022 16:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647906313; x=1679442313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HiGrn/wqtmjWjv0KYmxpZBLvA9yOpRMmV+uh3duvMLY=;
  b=RfHXSclMis82kMA7FpPsCO/Hh+8WmipZHoPROmwVsrOTA84mOxPyAs7z
   dQ02VwHjYknxs+RsKW9YjKScYJVdD1ak9XDsDAYuuCDMwLFgEcSlbKI0R
   zcVcOBILApkTXIBwf7pcbblHKXM3uWfRyTIMaYLivBjJ4qH0iykO5TIRY
   UkfAOCBmaqDX0JUfBluHONzozYx1Kt5sKr+SmJqOUOeytnWFln6p7pz0k
   fI622FCY22Q0alzrD5q7KYriyhpOVW3NLSCHH25fjk9ZPne0LW3HCqv1l
   BTUh5wgGgqekp7fvyCMJjN88xTxHS0ZlSSOxZd3a4SNMoWl1EvjcP7Tkb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="282506784"
X-IronPort-AV: E=Sophos;i="5.90,199,1643702400"; 
   d="scan'208";a="282506784"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 16:45:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,199,1643702400"; 
   d="scan'208";a="515116404"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 21 Mar 2022 16:45:09 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nWRi1-000IHt-1J; Mon, 21 Mar 2022 23:45:09 +0000
Date:   Tue, 22 Mar 2022 07:44:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: Re: [PATCH v5 4/4] net:bonding:Add support for IPV6 RLB to
 balance-alb mode
Message-ID: <202203220724.6dOxKPRJ-lkp@intel.com>
References: <20220321084704.36370-5-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321084704.36370-5-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 092d992b76ed9d06389af0bc5efd5279d7b1ed9f]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/Add-support-for-IPV6-RLB-to-balance-alb-mode/20220321-164934
base:   092d992b76ed9d06389af0bc5efd5279d7b1ed9f
config: s390-randconfig-r044-20220321 (https://download.01.org/0day-ci/archive/20220322/202203220724.6dOxKPRJ-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/d84e696c74aa408d01d0e142f8ec11dd5b6410a5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/Add-support-for-IPV6-RLB-to-balance-alb-mode/20220321-164934
        git checkout d84e696c74aa408d01d0e142f8ec11dd5b6410a5
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   s390-linux-ld: drivers/net/bonding/bond_alb.o: in function `rlb_nd_recv':
   bond_alb.c:(.text+0x3c92): undefined reference to `ipv6_get_ifaddr'
>> s390-linux-ld: bond_alb.c:(.text+0x3cd2): undefined reference to `inet6_ifa_finish_destroy'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
