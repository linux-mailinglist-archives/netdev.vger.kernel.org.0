Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D219B3BB9AE
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhGEI7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:59:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:25461 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230246AbhGEI7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 04:59:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10035"; a="270070239"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="270070239"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 01:57:05 -0700
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="485432083"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 01:57:04 -0700
Date:   Mon, 5 Jul 2021 16:57:02 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net:master 45/81] drivers/ptp/ptp_sysfs.c:182:9: warning: %d in
 format string (no. 1) requires 'int' but the argument type is 'unsigned
 int'. [invalidPrintfArgType_sint]
Message-ID: <20210705085702.GC2022171@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
head:   b43c8909be52f2baca8884f967b418a88424494a
commit: 73f37068d540eba5f93ba3a0019bf479d35ebd76 [45/81] ptp: support ptp physical/virtual clocks conversion
compiler: h8300-linux-gcc (GCC) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

cppcheck warnings: (new ones prefixed by >>)

>> drivers/ptp/ptp_sysfs.c:182:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]

vim +182 drivers/ptp/ptp_sysfs.c

73f37068d540eb Yangbo Lu 2021-06-30  172  
73f37068d540eb Yangbo Lu 2021-06-30  173  static ssize_t n_vclocks_show(struct device *dev,
73f37068d540eb Yangbo Lu 2021-06-30  174  			      struct device_attribute *attr, char *page)
73f37068d540eb Yangbo Lu 2021-06-30  175  {
73f37068d540eb Yangbo Lu 2021-06-30  176  	struct ptp_clock *ptp = dev_get_drvdata(dev);
73f37068d540eb Yangbo Lu 2021-06-30  177  	ssize_t size;
73f37068d540eb Yangbo Lu 2021-06-30  178  
73f37068d540eb Yangbo Lu 2021-06-30  179  	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
73f37068d540eb Yangbo Lu 2021-06-30  180  		return -ERESTARTSYS;
73f37068d540eb Yangbo Lu 2021-06-30  181  
73f37068d540eb Yangbo Lu 2021-06-30 @182  	size = snprintf(page, PAGE_SIZE - 1, "%d\n", ptp->n_vclocks);
73f37068d540eb Yangbo Lu 2021-06-30  183  
73f37068d540eb Yangbo Lu 2021-06-30  184  	mutex_unlock(&ptp->n_vclocks_mux);
73f37068d540eb Yangbo Lu 2021-06-30  185  
73f37068d540eb Yangbo Lu 2021-06-30  186  	return size;
73f37068d540eb Yangbo Lu 2021-06-30  187  }
73f37068d540eb Yangbo Lu 2021-06-30  188  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
