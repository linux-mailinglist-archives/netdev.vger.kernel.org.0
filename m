Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFC48CCD1
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350641AbiALUGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:06:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:59219 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357159AbiALUGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 15:06:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642017974; x=1673553974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jTYJ5MPdPVHmwKkOwlI7reeAFLonvjVi2dQZX/Vt8Fk=;
  b=I83KMA0TT8ChwGvGw/5++4cq5030dx0xLjMTWj5SvPEaQBNZQQpe29jW
   zAnDGHqsyW9BmIoKtl9uLkc3NSgSEDlnoZYfnxNicU/dXjOBLPoK4MDy5
   dMKArmofngnnHR0V9Y0oYg5TUJUvb9fIhj7TMjXEAawS3o7I4z3/RgsqN
   P094n8f36XKnUn+fqwDwYx2Gtr2jInV+HO3jWEy1DG7MiHZnR9u2asFFX
   posPXNY6y6Kh5NxaIa91FDU80sKEIbLrQO5Fuh/eoX544nyHUtJ+DS4Qv
   6ZB//VPyXr/J2Zm6naqpsTwFFYF0fbxIcshGX6Y/6djPJ6inNfsEjY0Gd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243640026"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="243640026"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 12:06:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="691524412"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 12 Jan 2022 12:06:11 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n7jso-0006Kk-7v; Wed, 12 Jan 2022 20:06:10 +0000
Date:   Thu, 13 Jan 2022 04:05:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>
Subject: Re: [wpan-next v2 19/27] net: ieee802154: Full PAN management
Message-ID: <202201130312.AD3Sqi9A-lkp@intel.com>
References: <20220112173312.764660-20-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112173312.764660-20-miquel.raynal@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miquel,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.16 next-20220112]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Miquel-Raynal/IEEE-802-15-4-scan-support/20220113-013731
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git daadb3bd0e8d3e317e36bc2c1542e86c528665e5
config: alpha-randconfig-r006-20220112 (https://download.01.org/0day-ci/archive/20220113/202201130312.AD3Sqi9A-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9c8fbd918a704432bbf6cdce1d111e9002c756b4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Miquel-Raynal/IEEE-802-15-4-scan-support/20220113-013731
        git checkout 9c8fbd918a704432bbf6cdce1d111e9002c756b4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash net/ieee802154/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/ieee802154/nl802154.c: In function 'nl802154_dump_pans':
>> net/ieee802154/nl802154.c:1613:15: error: implicit declaration of function 'nl802154_prepare_wpan_dev_dump' [-Werror=implicit-function-declaration]
    1613 |         err = nl802154_prepare_wpan_dev_dump(skb, cb, &rdev, &wpan_dev);
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/ieee802154/nl802154.c:1637:9: error: implicit declaration of function 'nl802154_finish_wpan_dev_dump' [-Werror=implicit-function-declaration]
    1637 |         nl802154_finish_wpan_dev_dump(rdev);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/nl802154_prepare_wpan_dev_dump +1613 net/ieee802154/nl802154.c

  1605	
  1606	static int nl802154_dump_pans(struct sk_buff *skb, struct netlink_callback *cb)
  1607	{
  1608		struct cfg802154_registered_device *rdev;
  1609		struct cfg802154_internal_pan *pan;
  1610		struct wpan_dev *wpan_dev;
  1611		int err;
  1612	
> 1613		err = nl802154_prepare_wpan_dev_dump(skb, cb, &rdev, &wpan_dev);
  1614		if (err)
  1615			return err;
  1616	
  1617		spin_lock_bh(&rdev->pan_lock);
  1618	
  1619		if (cb->args[2])
  1620			goto out;
  1621	
  1622		cb->seq = rdev->pan_generation;
  1623	
  1624		ieee802154_for_each_pan(pan, rdev) {
  1625			err = nl802154_send_pan_info(skb, cb, cb->nlh->nlmsg_seq,
  1626						     NLM_F_MULTI, rdev, wpan_dev, pan);
  1627			if (err < 0)
  1628				goto out_err;
  1629		}
  1630	
  1631		cb->args[2] = 1;
  1632	out:
  1633		err = skb->len;
  1634	out_err:
  1635		spin_unlock_bh(&rdev->pan_lock);
  1636	
> 1637		nl802154_finish_wpan_dev_dump(rdev);
  1638	
  1639		return err;
  1640	}
  1641	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
