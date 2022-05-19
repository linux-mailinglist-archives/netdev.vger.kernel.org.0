Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD252DF7F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241573AbiESVnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245295AbiESVmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:42:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A9710276A;
        Thu, 19 May 2022 14:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652996562; x=1684532562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/3alaUrGhPB4+i0xaXTLU1am7m7HDP8q4zTotaqRuP8=;
  b=UA4aL0rDL/GOhxU3SDWcRPKx2m4TRnR1zHiSSq2vyTQ5T2V6hfKAwgQo
   pR+CN7gLtKDPbRD3AbhKWYq9Y289yhp8TrnoFXdpfP8nj91onGj5dLC7Y
   JrqfGCgOM04K9Eo4mxgpQmq4iJdzTeSoI7SVEKsu+U1icUQNcCYAxoP7F
   4YjMvNg2a3cdXeqxmhoB21t1N8MpGcGxthvvbQjVe//snryNG9m6yOO9E
   Jg3j2RfBB0I2Ba0BoyrkSpyldAozBFD01izAW5aWyEu91C0tIfhv3lHns
   0OD8Y8IT9nz9o5XwHm7mnkVJ+j70fZalgMvirwDNMfvz8EUCpdxXPqrC1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="335438455"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="335438455"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 14:42:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="546331372"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 19 May 2022 14:42:36 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrnum-0003yC-86;
        Thu, 19 May 2022 21:42:36 +0000
Date:   Fri, 20 May 2022 05:42:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     longli@linuxonhyperv.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: Re: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <202205200542.sMPnHzQW-lkp@intel.com>
References: <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 42226c989789d8da4af1de0c31070c96726d990c
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220520/202205200542.sMPnHzQW-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f082dc68ab65c498c978d574e62413d50286b4f9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
        git checkout f082dc68ab65c498c978d574e62413d50286b4f9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/infiniband/hw/mana/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/infiniband/hw/mana/main.c:544:5: warning: no previous prototype for 'mana_ib_query_port' [-Wmissing-prototypes]
     544 | int mana_ib_query_port(struct ib_device *ibdev, u32 port,
         |     ^~~~~~~~~~~~~~~~~~
--
>> drivers/infiniband/hw/mana/qp.c:8:5: warning: no previous prototype for 'mana_ib_cfg_vport_steering' [-Wmissing-prototypes]
       8 | int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev, struct net_device *ndev,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/mana/qp.c:227:5: warning: no previous prototype for 'mana_ib_create_qp_raw' [-Wmissing-prototypes]
     227 | int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
         |     ^~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/mana/qp.c:421:5: warning: no previous prototype for 'mana_ib_destroy_qp_raw' [-Wmissing-prototypes]
     421 | int mana_ib_destroy_qp_raw(struct mana_ib_qp *qp, struct ib_udata *udata)
         |     ^~~~~~~~~~~~~~~~~~~~~~


vim +/mana_ib_query_port +544 drivers/infiniband/hw/mana/main.c

   543	
 > 544	int mana_ib_query_port(struct ib_device *ibdev, u32 port,
   545			       struct ib_port_attr *props)
   546	{
   547		/* This version doesn't return port properties */
   548		return 0;
   549	}
   550	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
