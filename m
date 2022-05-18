Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A038252C461
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbiERUbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242454AbiERUbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:31:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1932EAD3F;
        Wed, 18 May 2022 13:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652905904; x=1684441904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xBq3Cf7/l7VVICiNn+fUDIB0+RGgo7IdT8rhgcpuJqw=;
  b=JirvlCP7ZRnWVPEMJH4djoPWcWY2M15Oo/askDPHX6p2e1s2ZqzA3vpU
   DgaF0sO/X5Pz7FXWdO7QFAYJR8VUvZV5/2J0TGWgrunlxa77DPOWKUmM+
   g3BhF1J3MOrag4t5b0jIHRPL+hibOBfDkHTXmL/+04amSPNkIXhd+0pdy
   PHS8TE8nnANQp2gYPyvVPWFKxh1uRGY1xvwozEnyqmlMQA84sT+7EZlBO
   lEfOWaJpyNJ9nwPnd7XmGEFR4jKpgK0hXuwsS4WQd7B9SUUAkbxtqsjmK
   sWsiKFKd9OnptBF3hFV7sjpf36Jht6YdOFUKjdblBeT7O+uHyfhIf4okC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="297179098"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="297179098"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 13:31:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="569725348"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2022 13:31:40 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrQKZ-0002bd-Fi;
        Wed, 18 May 2022 20:31:39 +0000
Date:   Thu, 19 May 2022 04:31:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: ifdefy the wireless pointers in struct
 net_device
Message-ID: <202205190456.MohbzV8M-lkp@intel.com>
References: <20220518181807.2030747-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518181807.2030747-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-ifdefy-the-wireless-pointers-in-struct-net_device/20220519-022305
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git a3641ca416a3da7cbeae5bcf1fc26ba9797a1438
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220519/202205190456.MohbzV8M-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c6413242ee18dfc005d7ed7ccc4db9cf7883b872
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/net-ifdefy-the-wireless-pointers-in-struct-net_device/20220519-022305
        git checkout c6413242ee18dfc005d7ed7ccc4db9cf7883b872
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/net-sysfs.c: In function 'netdev_register_kobject':
>> net/core/net-sysfs.c:2013:30: error: 'wireless_group' undeclared (first use in this function); did you mean 'wireless_dev'?
    2013 |                 *groups++ = &wireless_group;
         |                              ^~~~~~~~~~~~~~
         |                              wireless_dev
   net/core/net-sysfs.c:2013:30: note: each undeclared identifier is reported only once for each function it appears in


vim +2013 net/core/net-sysfs.c

^1da177e4c3f41 Linus Torvalds     2005-04-16  1990  
^1da177e4c3f41 Linus Torvalds     2005-04-16  1991  /* Create sysfs entries for network device. */
6b53dafe23fd1f WANG Cong          2014-07-23  1992  int netdev_register_kobject(struct net_device *ndev)
^1da177e4c3f41 Linus Torvalds     2005-04-16  1993  {
6648c65e7ea72c stephen hemminger  2017-08-18  1994  	struct device *dev = &ndev->dev;
6b53dafe23fd1f WANG Cong          2014-07-23  1995  	const struct attribute_group **groups = ndev->sysfs_groups;
0a9627f2649a02 Tom Herbert        2010-03-16  1996  	int error = 0;
^1da177e4c3f41 Linus Torvalds     2005-04-16  1997  
a1b3f594dc5faa Eric W. Biederman  2010-05-04  1998  	device_initialize(dev);
43cb76d91ee85f Greg Kroah-Hartman 2002-04-09  1999  	dev->class = &net_class;
6b53dafe23fd1f WANG Cong          2014-07-23  2000  	dev->platform_data = ndev;
43cb76d91ee85f Greg Kroah-Hartman 2002-04-09  2001  	dev->groups = groups;
^1da177e4c3f41 Linus Torvalds     2005-04-16  2002  
6b53dafe23fd1f WANG Cong          2014-07-23  2003  	dev_set_name(dev, "%s", ndev->name);
^1da177e4c3f41 Linus Torvalds     2005-04-16  2004  
8b41d1887db718 Eric W. Biederman  2007-09-26  2005  #ifdef CONFIG_SYSFS
0c509a6c9393b2 Eric W. Biederman  2009-10-29  2006  	/* Allow for a device specific group */
0c509a6c9393b2 Eric W. Biederman  2009-10-29  2007  	if (*groups)
0c509a6c9393b2 Eric W. Biederman  2009-10-29  2008  		groups++;
^1da177e4c3f41 Linus Torvalds     2005-04-16  2009  
0c509a6c9393b2 Eric W. Biederman  2009-10-29  2010  	*groups++ = &netstat_group;
38c1a01cf10c6e Johannes Berg      2012-11-16  2011  
c6413242ee18df Jakub Kicinski     2022-05-18  2012  	if (wireless_group_needed(ndev))
38c1a01cf10c6e Johannes Berg      2012-11-16 @2013  		*groups++ = &wireless_group;
8b41d1887db718 Eric W. Biederman  2007-09-26  2014  #endif /* CONFIG_SYSFS */
^1da177e4c3f41 Linus Torvalds     2005-04-16  2015  
0a9627f2649a02 Tom Herbert        2010-03-16  2016  	error = device_add(dev);
0a9627f2649a02 Tom Herbert        2010-03-16  2017  	if (error)
8ed633b9baf9ec Wang Hai           2019-04-12  2018  		return error;
0a9627f2649a02 Tom Herbert        2010-03-16  2019  
6b53dafe23fd1f WANG Cong          2014-07-23  2020  	error = register_queue_kobjects(ndev);
8ed633b9baf9ec Wang Hai           2019-04-12  2021  	if (error) {
8ed633b9baf9ec Wang Hai           2019-04-12  2022  		device_del(dev);
8ed633b9baf9ec Wang Hai           2019-04-12  2023  		return error;
8ed633b9baf9ec Wang Hai           2019-04-12  2024  	}
0a9627f2649a02 Tom Herbert        2010-03-16  2025  
9802c8e22f6efd Ming Lei           2013-02-22  2026  	pm_runtime_set_memalloc_noio(dev, true);
9802c8e22f6efd Ming Lei           2013-02-22  2027  
0a9627f2649a02 Tom Herbert        2010-03-16  2028  	return error;
^1da177e4c3f41 Linus Torvalds     2005-04-16  2029  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  2030  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
