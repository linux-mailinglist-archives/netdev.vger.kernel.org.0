Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B911FCE35
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgFQNQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 09:16:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:14612 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgFQNQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 09:16:50 -0400
IronPort-SDR: 86MdU50XUU4zS0DsTAWUKyECLZIxj7j5Ia/kboSY/ZNgM5gt3S5dIkeJE8odNNsaDhAqlJe1PF
 GBqyIAPvUkHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 06:16:39 -0700
IronPort-SDR: hjWTbMADNeyvXl88IerD0lKu82wey83F9e96kblqYl/55vhd5tqf465gTgx7haXSu/OaRP4ICU
 qYQ198y1qPOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,522,1583222400"; 
   d="scan'208";a="476845844"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jun 2020 06:16:37 -0700
Date:   Wed, 17 Jun 2020 21:28:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     yunaixin03610@163.com, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, yunaixin <yunaixin@huawei.com>
Subject: Re: [PATCH 2/5] Huawei BMA: Adding Huawei BMA driver: host_cdev_drv
Message-ID: <20200617132800.GC7376@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615145906.1013-3-yunaixin03610@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.8-rc1 next-20200616]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/yunaixin03610-163-com/Adding-Huawei-BMA-drivers/20200616-102318
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git a5dc8300df75e8b8384b4c82225f1e4a0b4d9b55
:::::: branch date: 23 hours ago
:::::: commit date: 23 hours ago
compiler: gcc-9 (Debian 9.3.0-13) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cppcheck warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c:443:2: warning: Redundant assignment of 'ent' to itself. [selfAssignment]
    UNUSED(ent);
    ^
>> drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c:492:2: warning: Redundant assignment of 'pdev' to itself. [selfAssignment]
    UNUSED(pdev);
    ^
>> drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c:493:2: warning: Redundant assignment of 'state' to itself. [selfAssignment]
    UNUSED(state);
    ^
   drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c:500:2: warning: Redundant assignment of 'pdev' to itself. [selfAssignment]
    UNUSED(pdev);
    ^
>> drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c:149:3: warning: Shifting signed 32-bit value by 31 bits is undefined behaviour [shiftTooManyBitsSigned]
     REGION_DIR_INPUT + (region & REGION_INDEX_MASK));
     ^
   drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c:158:55: warning: Shifting signed 32-bit value by 31 bits is undefined behaviour [shiftTooManyBitsSigned]
    (void)pci_write_config_dword(pdev, ATU_REGION_CTRL2, REGION_ENABLE);
                                                         ^
--
>> drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:63:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "lost_count   :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:65:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "b2h_int      :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:67:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "h2b_int      :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:69:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "dma_count    :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:71:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "recv_bytes   :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:73:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "send_bytes   :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:75:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "recv_pkgs    :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:77:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "send_pkgs    :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:79:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "drop_pkgs    :%dn",
           ^
   drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c:81:9: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
    len += sprintf(buf + len, "fail_count   :%dn",
           ^
>> drivers/net/ethernet/huawei/bma/cdev_drv/bma_cdev.c:326:21: warning: Checking if unsigned variable 'count' is less than zero. [unsignedLessThanZero]
    if (!data || count <= 0)
                       ^
   drivers/net/ethernet/huawei/bma/cdev_drv/bma_cdev.c:346:21: warning: Checking if unsigned variable 'count' is less than zero. [unsignedLessThanZero]
    if (!data || count <= 0)
                       ^

# https://github.com/0day-ci/linux/commit/d0965c4179b69ddd204c1f795f0d6ac080c657af
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout d0965c4179b69ddd204c1f795f0d6ac080c657af
vim +122 drivers/net/ethernet/huawei/bma/cdev_drv/bma_cdev.c

d0965c4179b69d yunaixin 2020-06-15   92  
d0965c4179b69d yunaixin 2020-06-15   93  static int cdev_param_get_statics(char *buf, const struct kernel_param *kp)
d0965c4179b69d yunaixin 2020-06-15   94  {
d0965c4179b69d yunaixin 2020-06-15   95  	int len = 0;
d0965c4179b69d yunaixin 2020-06-15   96  	int i = 0;
d0965c4179b69d yunaixin 2020-06-15   97  	__kernel_time_t running_time = 0;
d0965c4179b69d yunaixin 2020-06-15   98  
d0965c4179b69d yunaixin 2020-06-15   99  	if (!buf)
d0965c4179b69d yunaixin 2020-06-15  100  		return 0;
d0965c4179b69d yunaixin 2020-06-15  101  
d0965c4179b69d yunaixin 2020-06-15  102  	GET_SYS_SECONDS(running_time);
d0965c4179b69d yunaixin 2020-06-15  103  	running_time -= g_cdev_set.init_time;
d0965c4179b69d yunaixin 2020-06-15  104  	len += sprintf(buf + len,
d0965c4179b69d yunaixin 2020-06-15  105  		       "============================CDEV_DRIVER_INFO=======================\n");
d0965c4179b69d yunaixin 2020-06-15  106  	len += sprintf(buf + len, "version      :%s\n", CDEV_VERSION);
d0965c4179b69d yunaixin 2020-06-15  107  
d0965c4179b69d yunaixin 2020-06-15  108  	len += sprintf(buf + len, "running_time :%luD %02lu:%02lu:%02lu\n",
d0965c4179b69d yunaixin 2020-06-15  109  		       running_time / (SECONDS_PER_DAY),
d0965c4179b69d yunaixin 2020-06-15  110  		       running_time % (SECONDS_PER_DAY) / SECONDS_PER_HOUR,
d0965c4179b69d yunaixin 2020-06-15  111  		       running_time % SECONDS_PER_HOUR / SECONDS_PER_MINUTE,
d0965c4179b69d yunaixin 2020-06-15  112  		       running_time % SECONDS_PER_MINUTE);
d0965c4179b69d yunaixin 2020-06-15  113  
d0965c4179b69d yunaixin 2020-06-15  114  	for (i = 0; i < g_cdev_set.dev_num; i++) {
d0965c4179b69d yunaixin 2020-06-15  115  		len += sprintf(buf + len,
d0965c4179b69d yunaixin 2020-06-15  116  			       "===================================================\n");
d0965c4179b69d yunaixin 2020-06-15  117  		len += sprintf(buf + len, "name      :%s\n",
d0965c4179b69d yunaixin 2020-06-15  118  			       g_cdev_set.dev_list[i].dev_name);
d0965c4179b69d yunaixin 2020-06-15  119  		len +=
d0965c4179b69d yunaixin 2020-06-15  120  		    sprintf(buf + len, "dev_id    :%08x\n",
d0965c4179b69d yunaixin 2020-06-15  121  			    g_cdev_set.dev_list[i].dev_id);
d0965c4179b69d yunaixin 2020-06-15 @122  		len += sprintf(buf + len, "type      :%u\n",
d0965c4179b69d yunaixin 2020-06-15  123  			       g_cdev_set.dev_list[i].type);
d0965c4179b69d yunaixin 2020-06-15  124  		len += sprintf(buf + len, "status    :%s\n",
d0965c4179b69d yunaixin 2020-06-15  125  			       g_cdev_set.dev_list[i].s.open_status ==
d0965c4179b69d yunaixin 2020-06-15  126  			       1 ? "open" : "close");
d0965c4179b69d yunaixin 2020-06-15  127  		len += sprintf(buf + len, "send_pkgs :%u\n",
d0965c4179b69d yunaixin 2020-06-15  128  			       g_cdev_set.dev_list[i].s.send_pkgs);
d0965c4179b69d yunaixin 2020-06-15  129  		len +=
d0965c4179b69d yunaixin 2020-06-15  130  		    sprintf(buf + len, "send_bytes:%u\n",
d0965c4179b69d yunaixin 2020-06-15  131  			    g_cdev_set.dev_list[i].s.send_bytes);
d0965c4179b69d yunaixin 2020-06-15  132  		len += sprintf(buf + len, "send_failed_count:%u\n",
d0965c4179b69d yunaixin 2020-06-15  133  			       g_cdev_set.dev_list[i].s.send_failed_count);
d0965c4179b69d yunaixin 2020-06-15  134  		len += sprintf(buf + len, "recv_pkgs :%u\n",
d0965c4179b69d yunaixin 2020-06-15  135  			       g_cdev_set.dev_list[i].s.recv_pkgs);
d0965c4179b69d yunaixin 2020-06-15  136  		len += sprintf(buf + len, "recv_bytes:%u\n",
d0965c4179b69d yunaixin 2020-06-15  137  			       g_cdev_set.dev_list[i].s.recv_bytes);
d0965c4179b69d yunaixin 2020-06-15  138  		len += sprintf(buf + len, "recv_failed_count:%u\n",
d0965c4179b69d yunaixin 2020-06-15  139  			       g_cdev_set.dev_list[i].s.recv_failed_count);
d0965c4179b69d yunaixin 2020-06-15  140  	}
d0965c4179b69d yunaixin 2020-06-15  141  
d0965c4179b69d yunaixin 2020-06-15  142  	return len;
d0965c4179b69d yunaixin 2020-06-15  143  }
d0965c4179b69d yunaixin 2020-06-15  144  module_param_call(statistics, NULL, cdev_param_get_statics, &debug, 0444);
d0965c4179b69d yunaixin 2020-06-15  145  MODULE_PARM_DESC(statistics, "Statistics info of cdev driver,readonly");
d0965c4179b69d yunaixin 2020-06-15  146  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

