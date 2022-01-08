Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4371488415
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 15:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiAHOs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 09:48:59 -0500
Received: from mga05.intel.com ([192.55.52.43]:8129 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbiAHOs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jan 2022 09:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641653338; x=1673189338;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=TFVWrDgtMq+YeURetbGEuSRZEx7yY4E++7ehJueAejg=;
  b=PmJtcy1D6NonBw3eLUlk6DQkvckK2L/jOTacqH9DYnz/9+lfHhSE/d1k
   SbglnUj4MC7SsXfeqfGUjpf/0/WeZMkLs7VJu5I6TYE8MYNEWa5VrSBYW
   Lm0KRb51g5kJM3x3kS5lR5UqzytcAFv5OJBi7GlunGyH+D//DZglnfjSk
   PtU8W1pab1om4qVqzahI61gswwB0odVgA8CDRGABM4DlbSKiYfVG16Opl
   SZ3hLRhgYO1Iw5fShiaEqdgLCeS0pX+Cma2UYfX0okEYtOaDZnNQ4MNcs
   NrDsD2LUnZHKCZrMYGZ/D32/Qzbg5Pg1YMy7E/nUBWL8jzv7SEYuI5Qlo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="329359967"
X-IronPort-AV: E=Sophos;i="5.88,272,1635231600"; 
   d="scan'208";a="329359967"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2022 06:48:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,272,1635231600"; 
   d="scan'208";a="575394266"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jan 2022 06:48:56 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n6D1c-0000hl-8j; Sat, 08 Jan 2022 14:48:56 +0000
Date:   Sat, 8 Jan 2022 22:48:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [mst-vhost:vhost 30/44] drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23:
 sparse: sparse: cast to restricted __le16
Message-ID: <202201082258.aKRHnaJX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   008842b2060c14544ff452483ffd2241d145c7b2
commit: 7620d51af29aa1c5d32150db2ac4b6187ef8af3a [30/44] vdpa/mlx5: Support configuring max data virtqueue
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220108/202201082258.aKRHnaJX-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=7620d51af29aa1c5d32150db2ac4b6187ef8af3a
        git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
        git fetch --no-tags mst-vhost vhost
        git checkout 7620d51af29aa1c5d32150db2ac4b6187ef8af3a
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/vdpa/mlx5/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast to restricted __le16
>> drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast from restricted __virtio16

vim +1247 drivers/vdpa/mlx5/net/mlx5_vnet.c

  1232	
  1233	static int create_rqt(struct mlx5_vdpa_net *ndev)
  1234	{
  1235		__be32 *list;
  1236		int max_rqt;
  1237		void *rqtc;
  1238		int inlen;
  1239		void *in;
  1240		int i, j;
  1241		int err;
  1242		int num;
  1243	
  1244		if (!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_MQ)))
  1245			num = 1;
  1246		else
> 1247			num = le16_to_cpu(ndev->config.max_virtqueue_pairs);
  1248	
  1249		max_rqt = min_t(int, roundup_pow_of_two(num),
  1250				1 << MLX5_CAP_GEN(ndev->mvdev.mdev, log_max_rqt_size));
  1251		if (max_rqt < 1)
  1252			return -EOPNOTSUPP;
  1253	
  1254		inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + max_rqt * MLX5_ST_SZ_BYTES(rq_num);
  1255		in = kzalloc(inlen, GFP_KERNEL);
  1256		if (!in)
  1257			return -ENOMEM;
  1258	
  1259		MLX5_SET(create_rqt_in, in, uid, ndev->mvdev.res.uid);
  1260		rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
  1261	
  1262		MLX5_SET(rqtc, rqtc, list_q_type, MLX5_RQTC_LIST_Q_TYPE_VIRTIO_NET_Q);
  1263		MLX5_SET(rqtc, rqtc, rqt_max_size, max_rqt);
  1264		list = MLX5_ADDR_OF(rqtc, rqtc, rq_num[0]);
  1265		for (i = 0, j = 0; i < max_rqt; i++, j += 2)
  1266			list[i] = cpu_to_be32(ndev->vqs[j % (2 * num)].virtq_id);
  1267	
  1268		MLX5_SET(rqtc, rqtc, rqt_actual_size, max_rqt);
  1269		err = mlx5_vdpa_create_rqt(&ndev->mvdev, in, inlen, &ndev->res.rqtn);
  1270		kfree(in);
  1271		if (err)
  1272			return err;
  1273	
  1274		return 0;
  1275	}
  1276	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
