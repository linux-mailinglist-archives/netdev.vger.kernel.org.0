Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AEC48887E
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 10:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiAIJfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 04:35:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57726 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiAIJfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 04:35:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 426BFB80C71
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 09:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C95C36AE3;
        Sun,  9 Jan 2022 09:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641720918;
        bh=ypHWDMx3dcTpt3oLNk/mI59gIPt4I1IoVgH6OVeGJ1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jyzZzyQnwlijez79j55dRV0QL6UkCVfpoV3QQK2yM1Tmv3aQhK+n4XnAH5FXa0AL2
         1FtDpeczsKsZjFrnbSPr7CVqPzSlT2tFIpHuEt3mqTnyxaZmt66gfMseZAWlBAjs/K
         qHXyqd+BRcWuPt+h28r4D0mEHd0Nwb4u8ZuxXP2A7kO65Z5egR+h/37X/QRayrY7fi
         QNIrZKDSRelIedjH9/YRBF2qcGE9QLMog+fOyw2UmX5KZ03HqDOtkc+SZyAoQ/W/NW
         v1EQqcC030nLZJd7FX/Fhd5MPMZEjwK5LRfmhoeKFVKgu0Mi/u9Z9U6ptJ87c9vaKN
         NmGGcoSAjuJ1w==
Date:   Sun, 9 Jan 2022 11:35:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Lama Kayal <lkayal@nvidia.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next:master 59/127]
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl'
 undeclared; did you mean 'out'?
Message-ID: <YdqsUj3UNmESqvOw@unreal>
References: <202201090211.3kpW0hGj-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202201090211.3kpW0hGj-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 09, 2022 at 03:04:48AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> head:   82192cb497f9eca6c0d44dbc173e68d59ea2f3c9
> commit: 0a1498ebfa55b860e8ec929d73585bcd3fd81a4e [59/127] net/mlx5e: Expose FEC counters via ethtool
> config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20220109/202201090211.3kpW0hGj-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=0a1498ebfa55b860e8ec929d73585bcd3fd81a4e
>         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>         git fetch --no-tags net-next master
>         git checkout 0a1498ebfa55b860e8ec929d73585bcd3fd81a4e
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'fec_set_block_stats':
> >> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl' undeclared (first use in this function); did you mean 'out'?
>     1235 |         if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
>          |                                                ^~~~
>          |                                                out
>    drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: note: each undeclared identifier is reported only once for each function it appears in
> 
> 
> vim +1235 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> 
>   1220	
>   1221	static void fec_set_block_stats(struct mlx5e_priv *priv,
>   1222					struct ethtool_fec_stats *fec_stats)
>   1223	{
>   1224		struct mlx5_core_dev *mdev = priv->mdev;
>   1225		u32 out[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
>   1226		u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
>   1227		int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
>   1228		int mode = fec_active_mode(mdev);
>   1229	
>   1230		if (mode == MLX5E_FEC_NOFEC)
>   1231			return;
>   1232	
>   1233		MLX5_SET(ppcnt_reg, in, local_port, 1);
>   1234		MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
> > 1235		if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))

Obviously, this should be "out" and not "outl".

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 7e7c0c1019f6..26e326fe503c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1232,7 +1232,7 @@ static void fec_set_block_stats(struct mlx5e_priv *priv,

        MLX5_SET(ppcnt_reg, in, local_port, 1);
        MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
-       if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
+       if (mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0))
                return;

        switch (mode) {


>   1236			return;
>   1237	
>   1238		switch (mode) {
>   1239		case MLX5E_FEC_RS_528_514:
>   1240		case MLX5E_FEC_RS_544_514:
>   1241		case MLX5E_FEC_LLRS_272_257_1:
>   1242			fec_set_rs_stats(fec_stats, out);
>   1243			return;
>   1244		case MLX5E_FEC_FIRECODE:
>   1245			fec_set_fc_stats(fec_stats, out, fec_num_lanes(mdev));
>   1246		}
>   1247	}
>   1248	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
