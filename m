Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B23E6C7292
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCWVuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjCWVuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:50:01 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E20B198B
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679608200; x=1711144200;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fNaLWXwBB1Qiw2oM0o5jUpTHKR6YtK+qcGXk7SgRkTU=;
  b=dMeuND0900l5JbhUoqKP0QolEHzX++YxYyP1R9cHv2XPqpRthC9n9c0a
   q7kEz7LMTMYW8Fbo/r0vyUXHudjvCqN5+QMPD9Mn/Y2AU+Bid5ub8+v0q
   nDkkNvbh9WVfEQuH82UCFDONrFIX4gZvHpqhOHcm5XwdAfDWFQuaDFQM4
   5OFXZQr9hs9ty+Jezw/NzUASOUnKusO4YRnyhe4XByrYkzJYna7LKN0nu
   5Nrg5C5kEcvRtMHQ41Zc+qQXzc1oIEDva5fcuugvwO18L+APg83pmGKqr
   elnKStT14N6DjvXjJbIHO+KXRpmIiH7GH21nWX8V/yEDorwUrkd+VXjqo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="323496831"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="323496831"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 14:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="928394410"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="928394410"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 23 Mar 2023 14:49:45 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pfSob-000EjF-01;
        Thu, 23 Mar 2023 21:49:45 +0000
Date:   Fri, 24 Mar 2023 05:49:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dima Chumak <dchumak@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Dima Chumak <dchumak@nvidia.com>
Subject: Re: [PATCH net-next 2/4] net/mlx5: Implement devlink port function
 cmds to control ipsec_crypto
Message-ID: <202303240548.WDzL68Ny-lkp@intel.com>
References: <20230323111059.210634-3-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323111059.210634-3-dchumak@nvidia.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dima,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20230323]
[cannot apply to net-next/main net/main horms-ipvs/master linus/master v6.3-rc3 v6.3-rc2 v6.3-rc1 v6.3-rc3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dima-Chumak/devlink-Expose-port-function-commands-to-control-IPsec-crypto-offloads/20230323-191353
patch link:    https://lore.kernel.org/r/20230323111059.210634-3-dchumak%40nvidia.com
patch subject: [PATCH net-next 2/4] net/mlx5: Implement devlink port function cmds to control ipsec_crypto
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20230324/202303240548.WDzL68Ny-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ca580efef4996834c003bf5e8d6d244fe0550415
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dima-Chumak/devlink-Expose-port-function-commands-to-control-IPsec-crypto-offloads/20230323-191353
        git checkout ca580efef4996834c003bf5e8d6d244fe0550415
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/ethernet/mellanox/mlx5/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303240548.WDzL68Ny-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c: In function 'mlx5_devlink_port_fn_ipsec_crypto_set':
>> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:4203:24: error: 'struct net' has no member named 'xfrm'
    4203 |         mutex_lock(&net->xfrm.xfrm_cfg_mutex);
         |                        ^~
   drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:4239:26: error: 'struct net' has no member named 'xfrm'
    4239 |         mutex_unlock(&net->xfrm.xfrm_cfg_mutex);
         |                          ^~


vim +4203 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c

  4173	
  4174	int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable,
  4175						  struct netlink_ext_ack *extack)
  4176	{
  4177		struct mlx5_eswitch *esw;
  4178		struct mlx5_vport *vport;
  4179		int err = -EOPNOTSUPP;
  4180		struct net *net;
  4181	
  4182		esw = mlx5_devlink_eswitch_get(port->devlink);
  4183		if (IS_ERR(esw))
  4184			return PTR_ERR(esw);
  4185	
  4186		if (!mlx5_esw_ipsec_vf_offload_supported(esw->dev)) {
  4187			NL_SET_ERR_MSG_MOD(extack, "Device doesn't support ipsec_crypto");
  4188			return err;
  4189		}
  4190	
  4191		vport = mlx5_devlink_port_fn_get_vport(port, esw);
  4192		if (IS_ERR(vport)) {
  4193			NL_SET_ERR_MSG_MOD(extack, "Invalid port");
  4194			return PTR_ERR(vport);
  4195		}
  4196	
  4197		/* xfrm_cfg lock is needed to avoid races with XFRM state being added to
  4198		 * the PF net device. Netlink stack takes this lock for `ip xfrm` user
  4199		 * commands, so here we need to take it before esw->state_lock to
  4200		 * preserve the order.
  4201		 */
  4202		net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
> 4203		mutex_lock(&net->xfrm.xfrm_cfg_mutex);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
