Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1046E7E1
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhLIMCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:02:08 -0500
Received: from mga12.intel.com ([192.55.52.136]:29870 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234781AbhLIMCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 07:02:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639051108; x=1670587108;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tIAdvPUy74MigiMAu4GN9bW2fukCDWHRWjRFKJ34MoQ=;
  b=Ni4c4AiVbQH8TPGClN53A+gZF1XOlZBecJJllFhneP2W20ZwRJFnt0c+
   53acHa6gkP1Csgo8Gkp5v7sP9QKWnBtYQx1zS6b1ywGMtGv4TmMmRdaSL
   zcUo2LJt6VyMgrt8A/ntlwOsMg+2YjhvIge0hipYdBYrgIprFJPJtNUAV
   HyZ78BdegIv3doEWowSBxopy+i8Jv5mU3XueuYJahnYfoa46K6rmYbh1r
   2jI/ANG+bE8GWmsNHVHOxre+b4JTBUwOyj6wOIW88g+f258jlh7U97a3r
   sFQSSjda+4j7fn+f2jjGe9QrEmVhFRJD4v/fVwHfWCgwrQbosZZNhlOZQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="218105450"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="218105450"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 03:58:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="543571739"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2021 03:58:24 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mvI47-0001rm-Un; Thu, 09 Dec 2021 11:58:23 +0000
Date:   Thu, 9 Dec 2021 19:57:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
Subject: Re: [PATCH] net: bonding: Add support for IPV6 ns/na
Message-ID: <202112091907.6iLel0c9-lkp@intel.com>
References: <1639032622-28098-1-git-send-email-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639032622-28098-1-git-send-email-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.16-rc4 next-20211208]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-ns-na/20211209-150108
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 2a987e65025e2b79c6d453b78cb5985ac6e5eb26
config: riscv-randconfig-c006-20211209 (https://download.01.org/0day-ci/archive/20211209/202112091907.6iLel0c9-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 097a1cb1d5ebb3a0ec4bcaed8ba3ff6a8e33c00a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/ab724c314fcdcaa60e70c590850b2ce57430d7fa
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-ns-na/20211209-150108
        git checkout ab724c314fcdcaa60e70c590850b2ce57430d7fa
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/bonding/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/bonding/bond_alb.c:1307:26: error: implicit declaration of function 'csum_ipv6_magic' [-Werror,-Wimplicit-function-declaration]
                           icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
                                                 ^
   drivers/net/bonding/bond_alb.c:1307:26: note: did you mean 'csum_tcpudp_magic'?
   include/asm-generic/checksum.h:52:1: note: 'csum_tcpudp_magic' declared here
   csum_tcpudp_magic(__be32 saddr, __be32 daddr, __u32 len,
   ^
   1 error generated.


vim +/csum_ipv6_magic +1307 drivers/net/bonding/bond_alb.c

  1272	
  1273	static void alb_change_nd_option(struct sk_buff *skb, void *data)
  1274	{
  1275		struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
  1276		struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
  1277		struct net_device *dev = skb->dev;
  1278		struct icmp6hdr *icmp6h = icmp6_hdr(skb);
  1279		struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
  1280		u8 *lladdr = NULL;
  1281		u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
  1282					offsetof(struct nd_msg, opt));
  1283	
  1284		while (ndoptlen) {
  1285			int l;
  1286	
  1287			switch (nd_opt->nd_opt_type) {
  1288			case ND_OPT_SOURCE_LL_ADDR:
  1289			case ND_OPT_TARGET_LL_ADDR:
  1290			lladdr = ndisc_opt_addr_data(nd_opt, dev);
  1291			break;
  1292	
  1293			default:
  1294			break;
  1295			}
  1296	
  1297			l = nd_opt->nd_opt_len << 3;
  1298	
  1299			if (ndoptlen < l || l == 0)
  1300				return;
  1301	
  1302			if (lladdr) {
  1303				memcpy(lladdr, data, dev->addr_len);
  1304				lladdr = NULL;
  1305				icmp6h->icmp6_cksum = 0;
  1306	
> 1307				icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
  1308								      &ip6hdr->daddr,
  1309							ntohs(ip6hdr->payload_len),
  1310							IPPROTO_ICMPV6,
  1311							csum_partial(icmp6h,
  1312								     ntohs(ip6hdr->payload_len), 0));
  1313				lladdr = NULL;
  1314			}
  1315			ndoptlen -= l;
  1316			nd_opt = ((void *)nd_opt) + l;
  1317		}
  1318	}
  1319	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
