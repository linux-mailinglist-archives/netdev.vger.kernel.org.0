Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4498D5649DC
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 23:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiGCVGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 17:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGCVGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 17:06:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710FA5F87
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 14:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656882379; x=1688418379;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=NH8cI/Zm5qMcgTVQupQoQnKuklUkuEPSipu9aJPYwAw=;
  b=OgLNwGBQ8+7xjJm2hRbgxzcQzrJkDhwnlSr+Az7Lvil+pG2o7leh/aE3
   p0y4OxLQM+xpjtz5wC6fgkneLRMAGopA8uhpVFVPRLgQ9CcZAjZzTbmkJ
   zo+f3AC5fi63MDmHYmw0gZEq4g74RhtZllOzgSBk6RznGxY5k35Zu4kKG
   ICUk2TmQWHzb5XqvWt46uJnwDoDX5fBaZemBWHB25M9xAGtd+pmEuq3bZ
   XEaNJEk1ZKAgWuM9P6HzsD5D0nrZyute6oPZh0NBehN/UWRAiVRzBQ6dZ
   jI0d7WCcESovSaPnXHPuZYOWqfiB5fEYxtwSTvzSSzIkIoeTY/CLydzS1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="346964429"
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="346964429"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 14:06:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="596801407"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 03 Jul 2022 14:06:17 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o86nI-000Gxy-ND;
        Sun, 03 Jul 2022 21:06:16 +0000
Date:   Mon, 4 Jul 2022 05:05:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next:master 681/702] ERROR: modpost: "__divdi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <202207040532.wb2lPP2k-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   d0bf1fe6454e976e39bc1524b9159fa2c0fcf321
commit: 6ddac26cf7633766e4e59d513d81f6fd5afa6fcd [681/702] net/mlx5e: Add support to modify hardware flow meter parameters
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220704/202207040532.wb2lPP2k-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=6ddac26cf7633766e4e59d513d81f6fd5afa6fcd
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 6ddac26cf7633766e4e59d513d81f6fd5afa6fcd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__divdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
>> ERROR: modpost: "__udivdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
