Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03F5670CC
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiGEORw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiGEORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:17:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C320AC2;
        Tue,  5 Jul 2022 07:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657030375; x=1688566375;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SIDIXWp+uLjdJ2JzYj8HE+pPOUBXDZ/g3Y7jU8UVF44=;
  b=M0V30Fwp7t1OANCn0dBKxvN3XbGeFu27L7dKXpn/w2/Ammc2q45Svfu9
   pmbKrpGJC3nw5Njk8qCYTuBFJ7Ufprtz41winCZY3sOe/3inmTs5gGP4B
   pOB3Y+e3QzmFZsxi47rDxn6bY0G0fyrGcao5swFItO/dluFbJRdt779Wn
   rF8Llo7fNqxPwIl6AJPU0QaxBWUv3yVdx3e2jvSlOPPX1MhfJXHKnJoxw
   NEtifm82+IfPD/HhDMebZcdMM65i/6M0NLlKr6Eqh+9Xl2zW0K1U0k1bJ
   i/OXx1cGbE4yAhCC6JIiZ2u6cOTwQ7Jni1r4h7hIdTBkS0AHqSRTqs148
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="263785883"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="263785883"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 07:12:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="592938074"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 05 Jul 2022 07:12:52 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8jIJ-000J9L-OE;
        Tue, 05 Jul 2022 14:12:51 +0000
Date:   Tue, 5 Jul 2022 22:11:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kbuild-all@lists.01.org, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V1 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <202207052209.x00Iykkp-lkp@intel.com>
References: <20220705102740.29337-7-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705102740.29337-7-yishaih@nvidia.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yishai,

I love your patch! Yet something to improve:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on next-20220705]
[cannot apply to linus/master v5.19-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
base:   https://github.com/awilliam/linux-vfio.git next
config: openrisc-randconfig-r036-20220703 (https://download.01.org/0day-ci/archive/20220705/202207052209.x00Iykkp-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
        git checkout 12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   or1k-linux-ld: certs/system_keyring.o: in function `load_system_certificate_list':
   system_keyring.c:(.init.text+0xc0): undefined reference to `x509_load_certificate_list'
   system_keyring.c:(.init.text+0xc0): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `x509_load_certificate_list'
   or1k-linux-ld: or1k-linux-ld: DWARF error: could not find abbrev number 36676422
   drivers/vfio/vfio_main.o: in function `vfio_ioctl_device_feature_logging_start':
   vfio_main.c:(.text+0x18c8): undefined reference to `interval_tree_iter_first'
   vfio_main.c:(.text+0x18c8): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `interval_tree_iter_first'
>> or1k-linux-ld: vfio_main.c:(.text+0x18e4): undefined reference to `interval_tree_insert'
   vfio_main.c:(.text+0x18e4): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `interval_tree_insert'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
