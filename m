Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC668470846
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241961AbhLJSSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:18:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:33871 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241528AbhLJSSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 13:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639160089; x=1670696089;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vmpQh9ClAs0N1BFmhaM0KGq2ssljRnw0FnY+my++upU=;
  b=DLqVnwOUcmoOJrq6ztFz8f5viUF1lcTCvrsjMaV4l3fuxYAarxlpJnbR
   xqx41WCfesomZQUFifEJwau7YmHH7hjkjH3jCUOOZnVyv8lLjaivn0TKH
   TgwASl0kYIl4J/ZKIwkUn7Q7nHecJ8UcGe0hb+VJuMy1/I/AZo/jOd1Jy
   Rsi4n3kspkg5A0mUCBp539XDeY45WluWSbXz7lns1N9FwrsibgJOegLHL
   rsT42+TWMI6WaZ6t2MXqBVaLCyE4hPDG8PaBFg70qeSwr3cq1fx1i5wfc
   kxdWTsOSWSy4GwTuUZkNvjxV59DywT0mFg7vd2UQ5kPwJHK0d5go93FzA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="237142813"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="237142813"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 10:14:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="565316282"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 10 Dec 2021 10:14:14 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mvkPO-0003W1-6c; Fri, 10 Dec 2021 18:14:14 +0000
Date:   Sat, 11 Dec 2021 02:13:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
Subject: Re: [PATCH V2] net: bonding: Add support for IPV6 ns/na
Message-ID: <202112110234.hkzxELcK-lkp@intel.com>
References: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
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

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-ns-na/20211210-210940
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git c741e49150dbb0c0aebe234389f4aa8b47958fa8
config: hexagon-randconfig-r006-20211210 (https://download.01.org/0day-ci/archive/20211211/202112110234.hkzxELcK-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 097a1cb1d5ebb3a0ec4bcaed8ba3ff6a8e33c00a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/f86d634c3ced7ec9b5af72e4b92bca681be033f7
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-ns-na/20211210-210940
        git checkout f86d634c3ced7ec9b5af72e4b92bca681be033f7
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/bonding/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/bonding/bond_alb.c:1318:26: error: implicit declaration of function 'csum_ipv6_magic' [-Werror,-Wimplicit-function-declaration]
                           icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
                                                 ^
   drivers/net/bonding/bond_alb.c:1318:26: note: did you mean 'csum_tcpudp_magic'?
   arch/hexagon/include/asm/checksum.h:21:9: note: 'csum_tcpudp_magic' declared here
   __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
           ^
   arch/hexagon/include/asm/checksum.h:20:27: note: expanded from macro 'csum_tcpudp_magic'
   #define csum_tcpudp_magic csum_tcpudp_magic
                             ^
   1 error generated.


vim +/csum_ipv6_magic +1318 drivers/net/bonding/bond_alb.c

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
