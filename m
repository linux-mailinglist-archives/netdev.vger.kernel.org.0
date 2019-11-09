Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA79F5E02
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 09:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfKIIJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 03:09:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:10148 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfKIIJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 03:09:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Nov 2019 00:09:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="193411225"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2019 00:09:17 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iTLo5-000Ikj-3S; Sat, 09 Nov 2019 16:09:17 +0800
Date:   Sat, 9 Nov 2019 16:08:58 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Tristram.Ha@microchip.com, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de
Subject: Re: [PATCH v1 3/4] ksz: Add Microchip KSZ8863 SMI-DSA driver
Message-ID: <201911091627.4jlynWYJ%lkp@intel.com>
References: <20191107110030.25199-4-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107110030.25199-4-m.grzeschik@pengutronix.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on v5.4-rc6 next-20191108]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Michael-Grzeschik/microchip-add-support-for-ksz88x3-driver-family/20191109-122140
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git a2582cdc32f071422e0197a6c59bd1235b426ce2
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-21-gb31adac-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:184:17: sparse: sparse: cast to restricted __be64
>> drivers/net/dsa/microchip/ksz8863.c:193:14: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned long long [usertype] data @@    got nsigned long long [usertype] data @@
>> drivers/net/dsa/microchip/ksz8863.c:193:14: sparse:    expected unsigned long long [usertype] data
>> drivers/net/dsa/microchip/ksz8863.c:193:14: sparse:    got restricted __be64 [usertype]
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64
   drivers/net/dsa/microchip/ksz8863.c:252:23: sparse: sparse: cast to restricted __be64

vim +184 drivers/net/dsa/microchip/ksz8863.c

   172	
   173	static void ksz8863_r_table(struct ksz_device *dev, int table, u16 addr,
   174				    u64 *data)
   175	{
   176		u16 ctrl_addr;
   177	
   178		ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
   179	
   180		mutex_lock(&dev->alu_mutex);
   181		ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
   182		ksz_read64(dev, REG_IND_DATA_HI, data);
   183		mutex_unlock(&dev->alu_mutex);
 > 184		*data = be64_to_cpu(*data);
   185	}
   186	
   187	static void ksz8863_w_table(struct ksz_device *dev, int table, u16 addr,
   188				    u64 data)
   189	{
   190		u16 ctrl_addr;
   191	
   192		ctrl_addr = IND_ACC_TABLE(table) | addr;
 > 193		data = cpu_to_be64(data);
   194	
   195		mutex_lock(&dev->alu_mutex);
   196		ksz_write64(dev, REG_IND_DATA_HI, data);
   197		ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
   198		mutex_unlock(&dev->alu_mutex);
   199	}
   200	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
