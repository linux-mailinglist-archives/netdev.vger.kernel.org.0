Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED97F550468
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 14:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiFRMRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 08:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiFRMRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 08:17:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121B015732
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 05:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655554638; x=1687090638;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=qGHNGsPBlJdkjBFYTh1tlW7NpbCv66NtHyhW1QahJIo=;
  b=EPaAYHvzC6FlvZYagFt5Dtuwoww30jpVRmqgLo6G9cSpWQLfgMCYU8Ns
   0p79ksZAp89/KA1Vta26KuWGQRwRpiZxBT6nXrK8FK3vLNp3GfvfhWQCA
   ndEmkCeDPL1xFfGLm54Cb8at5YfWnE8ZsM593L60ejE5XLjolPcH6q7p/
   qDYaeNkrEt7tXcivDrjygpg/OGLvr1SHfo+xjl01DE3vFP6fjhk9DYClt
   wFk5bghh/CzIf/tefxZBuBV0CMz/EoQfVuWAHDL/pioB+5DY6azL/Czf8
   M439qMVq1IB+3wZUfBlKf+U9clZRNO2UNn4cSYNESeUMfDexWYTGhfanx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278424689"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="278424689"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2022 05:17:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="642399432"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jun 2022 05:17:16 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2XO8-000QJ1-3X;
        Sat, 18 Jun 2022 12:17:16 +0000
Date:   Sat, 18 Jun 2022 20:16:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [net-next:master 19/27] ERROR: modpost:
 "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko]
 undefined!
Message-ID: <202206182016.Go0zVi4t-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   f0623340fd2cab724e3c54ac026d1414325f375d
commit: b47aec885bcd672ebca2108a8b7e9ce3e3982775 [19/27] net: pcs: xpcs: add CL37 1000BASE-X AN support
config: arm-randconfig-r005-20220617 (https://download.01.org/0day-ci/archive/20220618/202206182016.Go0zVi4t-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=b47aec885bcd672ebca2108a8b7e9ce3e3982775
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout b47aec885bcd672ebca2108a8b7e9ce3e3982775
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
>> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
