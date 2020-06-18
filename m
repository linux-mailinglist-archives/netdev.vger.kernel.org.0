Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07851FEFA8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 12:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFRK2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 06:28:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgFRK2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 06:28:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IAHVjf100557;
        Thu, 18 Jun 2020 10:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=ACq0d5KNuAwLcskYBnI7bI56CuXDPRElqgvu34DM21I=;
 b=S6irhQZyBad5H5fC0t+FGeDBsk18cxTBSb8YnXm2Y87nlz/UDjfuAiFjqxHlU82mSVcC
 P/J+yqwhE9GLlVJTWhKyoYl8xTS/gQXV5Y4ccea00vluNJPB1jIBaKyNZAmEk8g2MkhM
 pkh+VZLArIzSqabK/ijpKJBE5u3bhtHTnWZNmaN8AUlZZFbJEIwak+zlTTiOAuLGIvCP
 ZX2hOZj/6akcX7vhqP7mw4YbQ4F4FshftFOUebBhQAmRxhEAs+ln6axBI5xfFXU87H4I
 RFCxh6UKwX+raRqeI7p16o8JmQOE8Ofy0HbHtMngwcsrvpj/T/ASwsYuAwfG+taIPBi8 qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31qg356bup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 10:28:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IAJBtY130039;
        Thu, 18 Jun 2020 10:28:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31q66phvvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 10:28:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05IASMal002692;
        Thu, 18 Jun 2020 10:28:22 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 03:28:22 -0700
Date:   Thu, 18 Jun 2020 13:28:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, yunaixin03610@163.com, netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        yunaixin <yunaixin@huawei.com>
Subject: [kbuild] Re: [PATCH 2/5] Huawei BMA: Adding Huawei BMA driver:
 host_cdev_drv
Message-ID: <20200618102816.GS4282@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615145906.1013-3-yunaixin03610@163.com>
Message-ID-Hash: YMXJWQQLW3HOP52VA5Z5HJTQEOS7RFUF
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

url:    https://github.com/0day-ci/linux/commits/yunaixin03610-163-com/Adding-Huawei-BMA-drivers/20200616-102318
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git a5dc8300df75e8b8384b4c82225f1e4a0b4d9b55
compiler: gcc-9 (Debian 9.3.0-13) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cppcheck warnings: (new ones prefixed by >>)

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

# https://github.com/0day-ci/linux/commit/d0965c4179b69ddd204c1f795f0d6ac080c657af
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout d0965c4179b69ddd204c1f795f0d6ac080c657af
vim +122 drivers/net/ethernet/huawei/bma/cdev_drv/bma_cdev.c

d0965c4179b69d yunaixin 2020-06-15   93  static int cdev_param_get_statics(char *buf, const struct kernel_param *kp)
d0965c4179b69d yunaixin 2020-06-15   94  {
d0965c4179b69d yunaixin 2020-06-15   95  	int len = 0;
d0965c4179b69d yunaixin 2020-06-15   96  	int i = 0;
d0965c4179b69d yunaixin 2020-06-15   97  	__kernel_time_t running_time = 0;
d0965c4179b69d yunaixin 2020-06-15   98  
d0965c4179b69d yunaixin 2020-06-15   99  	if (!buf)
d0965c4179b69d yunaixin 2020-06-15  100  		return 0;

buf is a PAGE_SIZE buffer.  It can't be NULL.

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

I'm very worried that the sprintf loop can overflow the PAGE_SIZE.
Please replace all the sprintf() calls with scnprintf().

	len += scnprintf(PAGE_SIZE - len, buf + len, "blah blah");

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

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org
