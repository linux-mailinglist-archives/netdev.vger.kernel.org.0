Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF25488582
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 20:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiAHTFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 14:05:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:8918 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbiAHTFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jan 2022 14:05:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641668708; x=1673204708;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0yAsn9u9bUQy8Qo3IM2yDVZWyJ9L/2if2l87CMMGs2w=;
  b=Z1i5TFxAPZuWGFioF3AzkGrdT6sAt2T/cZXHAWFrgaM1xmjT3VEP/xgd
   1VRW88J52VCegQPxqmb2n3xHlSG7tAAM4tMuAycWZHyBAoyUfffEBxghq
   acnq2AUreGunAwGEzt3xphLGeIIwJ7XI8VNZYLTXX+/y0LONocgpOXn9E
   OzSbKVAbG25oGuX2RRAJ4AsQ6ILnAwNpWmKFKMbkZrcGIrNZtcBG6FVV0
   KqNdZ5AsPO94uYRFj38CIhXFpCoo2T7LRhKsKKqRfNrqwu5tQOJ4SX5TT
   uiSWUtZSOrzvEF8O7Fkj9Wey+L3arz9XQbWols2+sVo2lrmVW4aX4kUFw
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10221"; a="303776691"
X-IronPort-AV: E=Sophos;i="5.88,273,1635231600"; 
   d="scan'208";a="303776691"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2022 11:05:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,273,1635231600"; 
   d="scan'208";a="514210926"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2022 11:05:06 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n6H1V-0000wa-PU; Sat, 08 Jan 2022 19:05:05 +0000
Date:   Sun, 9 Jan 2022 03:04:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lama Kayal <lkayal@nvidia.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next:master 59/127]
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl'
 undeclared; did you mean 'out'?
Message-ID: <202201090211.3kpW0hGj-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   82192cb497f9eca6c0d44dbc173e68d59ea2f3c9
commit: 0a1498ebfa55b860e8ec929d73585bcd3fd81a4e [59/127] net/mlx5e: Expose FEC counters via ethtool
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20220109/202201090211.3kpW0hGj-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=0a1498ebfa55b860e8ec929d73585bcd3fd81a4e
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 0a1498ebfa55b860e8ec929d73585bcd3fd81a4e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'fec_set_block_stats':
>> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl' undeclared (first use in this function); did you mean 'out'?
    1235 |         if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
         |                                                ^~~~
         |                                                out
   drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: note: each undeclared identifier is reported only once for each function it appears in


vim +1235 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c

  1220	
  1221	static void fec_set_block_stats(struct mlx5e_priv *priv,
  1222					struct ethtool_fec_stats *fec_stats)
  1223	{
  1224		struct mlx5_core_dev *mdev = priv->mdev;
  1225		u32 out[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
  1226		u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
  1227		int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
  1228		int mode = fec_active_mode(mdev);
  1229	
  1230		if (mode == MLX5E_FEC_NOFEC)
  1231			return;
  1232	
  1233		MLX5_SET(ppcnt_reg, in, local_port, 1);
  1234		MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
> 1235		if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
  1236			return;
  1237	
  1238		switch (mode) {
  1239		case MLX5E_FEC_RS_528_514:
  1240		case MLX5E_FEC_RS_544_514:
  1241		case MLX5E_FEC_LLRS_272_257_1:
  1242			fec_set_rs_stats(fec_stats, out);
  1243			return;
  1244		case MLX5E_FEC_FIRECODE:
  1245			fec_set_fc_stats(fec_stats, out, fec_num_lanes(mdev));
  1246		}
  1247	}
  1248	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
