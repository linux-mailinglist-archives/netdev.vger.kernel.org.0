Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907E2470809
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245084AbhLJSHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:07:33 -0500
Received: from mga18.intel.com ([134.134.136.126]:58763 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245071AbhLJSHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 13:07:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639159437; x=1670695437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uMyQInOj8YUPZ21Wh05YFvullHSh8WcPDYUoGE+VHO4=;
  b=HNVJ45UkvuLQy6yuyKKRRDmEmHO3zNv8QUzPXldV93Y1LM2acXS0bQss
   8kWGeefU9CXyTqKQ9HawYg/FOWd9eYmcZ/o3VI4RL3Bq79oqc6W/sSR2x
   FLPRpvWG4Zcd0o+biHV8vhmvx9tcQZ/7bE1jRb2T6XWBdiElwpZm8WA4r
   pR+wguA3GLEO2kLLA+4Ty1fgxD91rDBXiiul2UQEc71brQaV9sDGiV6gp
   mo2iD1ncV0H3smRacp3dppOLFl22s4PoyNFHfC1uhr3xOU90f3CuHR1Kb
   VwmkFf+VmERN/fpeQqIx0RAvNX39220PY2mBnRZtZFBu936A7gEhi7KQz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="225271122"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="225271122"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 10:03:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="659710547"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 10 Dec 2021 10:03:14 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mvkEj-0003Uk-DA; Fri, 10 Dec 2021 18:03:13 +0000
Date:   Sat, 11 Dec 2021 02:03:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH V2] net: bonding: Add support for IPV6 ns/na
Message-ID: <202112110146.ZZvFe0rG-lkp@intel.com>
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
config: nios2-randconfig-r026-20211210 (https://download.01.org/0day-ci/archive/20211211/202112110146.ZZvFe0rG-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/f86d634c3ced7ec9b5af72e4b92bca681be033f7
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-ns-na/20211210-210940
        git checkout f86d634c3ced7ec9b5af72e4b92bca681be033f7
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash drivers/net/bonding/

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
