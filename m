Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7308A676623
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjAUMDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUMDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:03:24 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7564859C;
        Sat, 21 Jan 2023 04:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674302603; x=1705838603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eQvXmYU1ul3ihyLWrnek5TV3lhtfpAdAscF3pcR3Ge0=;
  b=RZNTro4Zn7sNg+hKBKMJ4dhv279PqALDlKOI2zw/4Z0EeeqP/OkACQ+c
   9ZRTy8wtVtV1ScnxCaleQ2f6OjDteFFxNF1Z7w/uoMG3QOJ+mMnCTPO6f
   cJmYKrkyLXQDaOm0RcU5GC6Fhia5XosZM0hRKkRwYW5+ABylSq6svamJ9
   loUfcruka/D8Zff+8cV6QpXiGA2Ax7iec3jrow7lmmjfGkEvYwLLJBVv/
   6djszXp0zculZyL86k8PMtcVEJCX4XWcYfWvicUw7vKlXGdYD0kckUKRO
   AZw2vO5OBrf6kQaxMi54Qx6hdUmhL7NARZ293j9p1v10OJL+Galrw0NCt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="306138287"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="306138287"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2023 04:03:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="834724793"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="834724793"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 21 Jan 2023 04:03:18 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pJCab-00041m-1b;
        Sat, 21 Jan 2023 12:03:17 +0000
Date:   Sat, 21 Jan 2023 20:03:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>,
        linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        yangyingliang@huawei.com, weiyongjun1@huawei.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, lennart@lfdomain.com
Subject: Re: [net-next 1/3] net: ethernet: adi: adin1110: add PTP clock
 support
Message-ID: <202301211925.PhM4jvZS-lkp@intel.com>
References: <20230120095348.26715-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120095348.26715-2-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandru,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexandru-Tachici/net-ethernet-adi-adin1110-add-PTP-clock-support/20230120-175639
patch link:    https://lore.kernel.org/r/20230120095348.26715-2-alexandru.tachici%40analog.com
patch subject: [net-next 1/3] net: ethernet: adi: adin1110: add PTP clock support
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20230121/202301211925.PhM4jvZS-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/8acf61452607f47da6223227b32c6f1e8ec01f62
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexandru-Tachici/net-ethernet-adi-adin1110-add-PTP-clock-support/20230120-175639
        git checkout 8acf61452607f47da6223227b32c6f1e8ec01f62
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "ktime_get_fast_timestamps" [drivers/net/ethernet/adi/adin1110.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
