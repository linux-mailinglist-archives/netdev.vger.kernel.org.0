Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A113C47BAA4
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhLUHU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:20:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:55171 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234985AbhLUHUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 02:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640071252; x=1671607252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+6AmUwf5o2vPDLfoDS0KzJ2/XVV60iEXJ+kGl5C7Ayk=;
  b=PLK2xJjzUTB4JoqbL5EpNhn7iZeJSW5AbdM1WLwyBmYXi9C4hf8CKiSQ
   0wGL+PMa3FjrhX70DPY1fWtNnGo34ZgmgSY4zIZR0XcuUvGvgyXGg6nKg
   RNlceDDftruZr0I1kRHoX5sIO04nbepk+X01XLoPiYm+Tg3THYRCs8Bfw
   1BwxMBiQAXeNyfnsJDu6zt7OmxLB/9tWgk6tsEhTzi7fvWJqgNJ8TBhMJ
   8ElUYCa7mcA1oXOx1ia0oST3ZcW2YEQfJCvXzz3SUrg0WD6729viU0NkG
   Jd1PmVBBSALOohXljWA+NM70ECpy+OnnDGifiZiAB/fk/uWOm4dyNZn3/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="220354489"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="220354489"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 23:20:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="616678124"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 20 Dec 2021 23:20:48 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mzZS3-0008oK-IN; Tue, 21 Dec 2021 07:20:47 +0000
Date:   Tue, 21 Dec 2021 15:19:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v3] net: bonding: Add support for IPV6 ns/na
Message-ID: <202112211539.hiXV7ML0-lkp@intel.com>
References: <20211217164829.31388-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217164829.31388-1-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 6441998e2e37131b0a4c310af9156d79d3351c16]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-ns-na/20211218-005147
base:   6441998e2e37131b0a4c310af9156d79d3351c16
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20211221/202112211539.hiXV7ML0-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/ba063ac377ce5e5000b84a7f9bc127e4f72d0b00
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-ns-na/20211218-005147
        git checkout ba063ac377ce5e5000b84a7f9bc127e4f72d0b00
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/bonding/bond_alb.c: In function 'alb_change_nd_option':
>> drivers/net/bonding/bond_alb.c:1318:47: error: implicit declaration of function 'csum_ipv6_magic'; did you mean 'csum_tcpudp_magic'? [-Werror=implicit-function-declaration]
    1318 |                         icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
         |                                               ^~~~~~~~~~~~~~~
         |                                               csum_tcpudp_magic
   cc1: some warnings being treated as errors


vim +1318 drivers/net/bonding/bond_alb.c

  1283	
  1284	static void alb_change_nd_option(struct sk_buff *skb, void *data)
  1285	{
  1286		struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
  1287		struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
  1288		struct net_device *dev = skb->dev;
  1289		struct icmp6hdr *icmp6h = icmp6_hdr(skb);
  1290		struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
  1291		u8 *lladdr = NULL;
  1292		u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
  1293					offsetof(struct nd_msg, opt));
  1294	
  1295		while (ndoptlen) {
  1296			int l;
  1297	
  1298			switch (nd_opt->nd_opt_type) {
  1299			case ND_OPT_SOURCE_LL_ADDR:
  1300			case ND_OPT_TARGET_LL_ADDR:
  1301			lladdr = ndisc_opt_addr_data(nd_opt, dev);
  1302			break;
  1303	
  1304			default:
  1305			lladdr = NULL;
  1306			break;
  1307			}
  1308	
  1309			l = nd_opt->nd_opt_len << 3;
  1310	
  1311			if (ndoptlen < l || l == 0)
  1312				return;
  1313	
  1314			if (lladdr) {
  1315				memcpy(lladdr, data, dev->addr_len);
  1316				icmp6h->icmp6_cksum = 0;
  1317	
> 1318				icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
  1319								      &ip6hdr->daddr,
  1320							ntohs(ip6hdr->payload_len),
  1321							IPPROTO_ICMPV6,
  1322							csum_partial(icmp6h,
  1323								     ntohs(ip6hdr->payload_len), 0));
  1324			}
  1325			ndoptlen -= l;
  1326			nd_opt = ((void *)nd_opt) + l;
  1327		}
  1328	}
  1329	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
