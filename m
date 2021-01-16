Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788872F8FC1
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 23:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbhAPWmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 17:42:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:20828 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbhAPWmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 17:42:38 -0500
IronPort-SDR: QYMepD4G9vrntqRYwS2c28i46TqA/DmIM3qg0kmhQfC0IiAaSVkWQtfFKBwjwPFaXYGMrgOCts
 g7K1pWnp01xg==
X-IronPort-AV: E=McAfee;i="6000,8403,9866"; a="178774172"
X-IronPort-AV: E=Sophos;i="5.79,352,1602572400"; 
   d="gz'50?scan'50,208,50";a="178774172"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2021 14:41:56 -0800
IronPort-SDR: cu0eD6qU/SyiBss+hblFEz/7x4L3TtGg/v7aOEMMpTSMoJeubGd/qokvHvqB/DXb5jTGJAtrZH
 L0/G6v92Y/Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,352,1602572400"; 
   d="gz'50?scan'50,208,50";a="364953464"
Received: from lkp-server01.sh.intel.com (HELO 260eafd5ecd0) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 16 Jan 2021 14:41:55 -0800
Received: from kbuild by 260eafd5ecd0 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1l0uGY-0001AC-Tp; Sat, 16 Jan 2021 22:41:54 +0000
Date:   Sun, 17 Jan 2021 06:41:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pavel =?utf-8?Q?=C5=A0imerda?= <code@simerda.eu>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Pavel =?utf-8?Q?=C5=A0imerda?= <code@simerda.eu>
Subject: Re: [PATCH net-next] net: mdio: access c22 registers via debugfs
Message-ID: <202101170600.yP36sVrF-lkp@intel.com>
References: <20210116211916.8329-1-code@simerda.eu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20210116211916.8329-1-code@simerda.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi "Pavel,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Pavel-imerda/net-mdio-access-c22-registers-via-debugfs/20210117-053409
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9ab7e76aefc97a9aa664accb59d6e8dc5e52514a
config: powerpc-adder875_defconfig (attached as .config)
compiler: powerpc-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/22d74f4896850840331d36d6867f7bc5ce728bbd
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Pavel-imerda/net-mdio-access-c22-registers-via-debugfs/20210117-053409
        git checkout 22d74f4896850840331d36d6867f7bc5ce728bbd
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=powerpc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/phy/mdio-debugfs.c:170:6: warning: no previous prototype for 'mdio_debugfs_add' [-Wmissing-prototypes]
     170 | void mdio_debugfs_add(struct mii_bus *bus)
         |      ^~~~~~~~~~~~~~~~
>> drivers/net/phy/mdio-debugfs.c:177:6: warning: no previous prototype for 'mdio_debugfs_remove' [-Wmissing-prototypes]
     177 | void mdio_debugfs_remove(struct mii_bus *bus)
         |      ^~~~~~~~~~~~~~~~~~~
>> drivers/net/phy/mdio-debugfs.c:184:12: warning: no previous prototype for 'mdio_debugfs_init' [-Wmissing-prototypes]
     184 | int __init mdio_debugfs_init(void)
         |            ^~~~~~~~~~~~~~~~~
>> drivers/net/phy/mdio-debugfs.c:192:13: warning: no previous prototype for 'mdio_debugfs_exit' [-Wmissing-prototypes]
     192 | void __exit mdio_debugfs_exit(void)
         |             ^~~~~~~~~~~~~~~~~


vim +/mdio_debugfs_add +170 drivers/net/phy/mdio-debugfs.c

   169	
 > 170	void mdio_debugfs_add(struct mii_bus *bus)
   171	{
   172		bus->debugfs_dentry = debugfs_create_dir(dev_name(&bus->dev), mdio_debugfs_dentry);
   173		debugfs_create_file("control", 0600, bus->debugfs_dentry, bus, &mdio_debug_fops);
   174	}
   175	EXPORT_SYMBOL_GPL(mdio_debugfs_add);
   176	
 > 177	void mdio_debugfs_remove(struct mii_bus *bus)
   178	{
   179		debugfs_remove(bus->debugfs_dentry);
   180		bus->debugfs_dentry = NULL;
   181	}
   182	EXPORT_SYMBOL_GPL(mdio_debugfs_remove);
   183	
 > 184	int __init mdio_debugfs_init(void)
   185	{
   186		mdio_debugfs_dentry = debugfs_create_dir("mdio", NULL);
   187	
   188		return PTR_ERR_OR_ZERO(mdio_debugfs_dentry);
   189	}
   190	module_init(mdio_debugfs_init);
   191	
 > 192	void __exit mdio_debugfs_exit(void)

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--KsGdsel6WgEHnImy
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
OFSgtgAA

--KsGdsel6WgEHnImy--
