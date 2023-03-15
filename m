Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EE76BBA72
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjCORG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjCORG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:06:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B7E77E14;
        Wed, 15 Mar 2023 10:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678900016; x=1710436016;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H4UMzReeAM+PlF8XGcFbq/Zb3ED3oOaNxlibZHBIPpo=;
  b=fSLBHKn4/0XiXalWsKjkNjtK+Q8oi+V+/W+vdnvd9N/FdiuL1luhn0Xc
   lBBLn8fbmQGRT6VE0XJYXh/VwyqBpxmYKbhrOxFKxoqwNdIYDZUl0o8sN
   JIDfSZnP72Nl9JvmJVmbj61EvzmFnpZzypKC62ykBThiTn02WqP3adhIi
   SqOU7nTkQVVGaSN6DCJIgpIkBsQh61ncr1jaL/OLisJ64sEhobTjC13lp
   jujupvS0/0NW2XxeNdm73/ufPdb4cUeMqT/jqJ3loCEicENks10ia0DEl
   lA4MX2MF4q+5yjoWmMyh/nf8cipj9SdnJjducEOWvic3gNgCfrZhP3iEM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="424037863"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="424037863"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 10:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="768584485"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768584485"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Mar 2023 10:06:38 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pcUaB-003xmq-1r;
        Wed, 15 Mar 2023 19:06:35 +0200
Date:   Wed, 15 Mar 2023 19:06:35 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZBH7G+1RwX4VAKcz@smile.fi.intel.com>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
 <202303150831.vgyKe8FD-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202303150831.vgyKe8FD-lkp@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 09:05:25AM +0800, kernel test robot wrote:
> Hi Andy,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on net-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Shevchenko/net-dsa-hellcreek-Get-rid-of-custom-led_init_default_state_get/20230315-021931
> patch link:    https://lore.kernel.org/r/20230314181824.56881-1-andriy.shevchenko%40linux.intel.com
> patch subject: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
> config: i386-randconfig-a015-20230313 (https://download.01.org/0day-ci/archive/20230315/202303150831.vgyKe8FD-lkp@intel.com/config)
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/fdd54417a75386e7ad47065c21403835b7fda94a
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Andy-Shevchenko/net-dsa-hellcreek-Get-rid-of-custom-led_init_default_state_get/20230315-021931
>         git checkout fdd54417a75386e7ad47065c21403835b7fda94a
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/dsa/hirschmann/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202303150831.vgyKe8FD-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/net/dsa/hirschmann/hellcreek_ptp.c:322:10: error: implicit declaration of function 'led_init_default_state_get' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>            state = led_init_default_state_get(of_fwnode_handle(led));
>                    ^
>    1 error generated.

I can not reproduce it.

I have downloaded net-next and applied the only patch on top.
I have downloaded the above mentioned kernel configuration and
repeated the steps with `make ... oldconfig; make W=1 ...`

Can you shed a light on what's going on here?

Note, the bug is impossibly related to my patch because the new API is in the
same header as already used from the LEDS framework. If it's reproducible, it
should be also without my patch.

-- 
With Best Regards,
Andy Shevchenko


