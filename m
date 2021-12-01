Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D664650EA
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhLAPJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:09:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:31466 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235152AbhLAPJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 10:09:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="223704308"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="223704308"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 07:06:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="677287331"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 01 Dec 2021 07:06:35 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1msRBq-000F3A-GW; Wed, 01 Dec 2021 15:06:34 +0000
Date:   Wed, 1 Dec 2021 23:06:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 02/15] Bluetooth: HCI: Use skb_pull_data to parse BR/EDR
 events
Message-ID: <202112012251.iGUVb22U-lkp@intel.com>
References: <20211201000215.1134831-3-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201000215.1134831-3-luiz.dentz@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

I love your patch! Yet something to improve:

[auto build test ERROR on bluetooth-next/master]
[also build test ERROR on net-next/master net/master linus/master bluetooth/master v5.16-rc3 next-20211201]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Luiz-Augusto-von-Dentz/Rework-parsing-of-HCI-events/20211201-080632
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: nios2-randconfig-r004-20211201 (https://download.01.org/0day-ci/archive/20211201/202112012251.iGUVb22U-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/ccec11fda2c9e92440427cb397e3fdd8e46b2827
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Luiz-Augusto-von-Dentz/Rework-parsing-of-HCI-events/20211201-080632
        git checkout ccec11fda2c9e92440427cb397e3fdd8e46b2827
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "__mulsi3" [net/vmw_vsock/vsock.ko] undefined!
ERROR: modpost: "__mulsi3" [net/mac802154/mac802154.ko] undefined!
ERROR: modpost: "__mulsi3" [net/ieee802154/ieee802154.ko] undefined!
ERROR: modpost: "__mulsi3" [net/atm/lec.ko] undefined!
ERROR: modpost: "__mulsi3" [net/atm/atm.ko] undefined!
>> ERROR: modpost: "skb_pull_data" [net/bluetooth/bluetooth.ko] undefined!
ERROR: modpost: "__mulsi3" [net/bluetooth/bluetooth.ko] undefined!
ERROR: modpost: "__mulsi3" [net/lapb/lapb.ko] undefined!
ERROR: modpost: "__mulsi3" [sound/virtio/virtio_snd.ko] undefined!
ERROR: modpost: "__mulsi3" [sound/hda/snd-hda-core.ko] undefined!
WARNING: modpost: suppressed 804 unresolved symbol warnings because there were too many)

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
