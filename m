Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108F138D936
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 08:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhEWGCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 02:02:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5668 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhEWGCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 02:02:40 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnqQQ3SnHz1BPmh;
        Sun, 23 May 2021 13:58:22 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 23 May 2021 14:01:11 +0800
Received: from [10.174.179.215] (10.174.179.215) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 23 May 2021 14:01:10 +0800
Subject: Re: [PATCH net-next] ehea: Use DEVICE_ATTR_*() macro
To:     kernel test robot <lkp@intel.com>, <dougmill@linux.ibm.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <kbuild-all@lists.01.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210523031504.11732-1-yuehaibing@huawei.com>
 <202105231357.TeRSEcVH-lkp@intel.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <4ba60312-b6ee-23db-bd1b-585dc5e83ae4@huawei.com>
Date:   Sun, 23 May 2021 14:01:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <202105231357.TeRSEcVH-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/23 13:14, kernel test robot wrote:
> Hi YueHaibing,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/YueHaibing/ehea-Use-DEVICE_ATTR_-macro/20210523-111702
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f5120f5998803a973b1d432ed2aa7e592527aa46
> config: powerpc-allmodconfig (attached as .config)
> compiler: powerpc64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/7402089765bd60dcd72cad433fd318058e06d514
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review YueHaibing/ehea-Use-DEVICE_ATTR_-macro/20210523-111702
>         git checkout 7402089765bd60dcd72cad433fd318058e06d514
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=powerpc 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/kobject.h:20,
>                     from include/linux/energy_model.h:7,
>                     from include/linux/device.h:16,
>                     from drivers/net/ethernet/ibm/ehea/ehea_main.c:17:
>>> drivers/net/ethernet/ibm/ehea/ehea_main.c:3206:23: error: 'probe_port_store' undeclared here (not in a function); did you mean 'probe_port_show'?

Sorry, this is the wrong version.

>     3206 | static DEVICE_ATTR_WO(probe_port);
>          |                       ^~~~~~~~~~
>    include/linux/sysfs.h:135:11: note: in definition of macro '__ATTR_WO'
>      135 |  .store = _name##_store,     \
>          |           ^~~~~
>    drivers/net/ethernet/ibm/ehea/ehea_main.c:3206:8: note: in expansion of macro 'DEVICE_ATTR_WO'
>     3206 | static DEVICE_ATTR_WO(probe_port);
>          |        ^~~~~~~~~~~~~~
>    drivers/net/ethernet/ibm/ehea/ehea_main.c:3116:16: warning: 'probe_port_show' defined but not used [-Wunused-function]
>     3116 | static ssize_t probe_port_show(struct device *dev,
>          |                ^~~~~~~~~~~~~~~
> 
> 
> vim +3206 drivers/net/ethernet/ibm/ehea/ehea_main.c
> 
>   3205	
>> 3206	static DEVICE_ATTR_WO(probe_port);
>   3207	static DEVICE_ATTR_WO(remove_port);
>   3208	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
