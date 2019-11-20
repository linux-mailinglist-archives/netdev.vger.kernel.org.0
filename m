Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B4610384A
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 12:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfKTLK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 06:10:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:63466 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfKTLK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 06:10:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 03:10:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,221,1571727600"; 
   d="gz'50?scan'50,208,50";a="209710034"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 20 Nov 2019 03:10:54 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iXNss-000GRX-5E; Wed, 20 Nov 2019 19:10:54 +0800
Date:   Wed, 20 Nov 2019 19:10:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        davem@davemloft.net, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH v3 net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <201911201825.LcZpxSwq%lkp@intel.com>
References: <5acab9e9da8aa9d1e554880b1f548d3057b70b75.1573872263.git.martin.varghese@nokia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4tjsqeihcq7yfscr"
Content-Disposition: inline
In-Reply-To: <5acab9e9da8aa9d1e554880b1f548d3057b70b75.1573872263.git.martin.varghese@nokia.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4tjsqeihcq7yfscr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Martin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on v5.4-rc8 next-20191120]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Martin-Varghese/Bare-UDP-L3-Encapsulation-Module/20191116-135036
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 20021578ba226bda1f0ddf50e4d4a12ea1c6c6c1
config: powerpc-tqm8560_defconfig (attached as .config)
compiler: powerpc-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=powerpc 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/net/dst_metadata.h:6:0,
                    from net/core/dev.c:101:
   include/net/ip_tunnels.h: In function 'iptunnel_get_v4_rt':
>> include/net/ip_tunnels.h:514:39: error: 'const struct ip_tunnel_info' has no member named 'dst_cache'
     dst_cache = (struct dst_cache *)&info->dst_cache;
                                          ^~
--
   In file included from net/ipv4/ip_tunnel_core.c:26:0:
   include/net/ip_tunnels.h: In function 'iptunnel_get_v4_rt':
>> include/net/ip_tunnels.h:514:39: error: 'const struct ip_tunnel_info' has no member named 'dst_cache'
     dst_cache = (struct dst_cache *)&info->dst_cache;
                                          ^~
   In file included from net/ipv4/ip_tunnel_core.c:27:0:
   include/net/ip6_tunnel.h: In function 'ip6tunnel_get_dst':
>> include/net/ip6_tunnel.h:191:39: error: 'const struct ip_tunnel_info' has no member named 'dst_cache'
     dst_cache = (struct dst_cache *)&info->dst_cache;
                                          ^~
>> include/net/ip6_tunnel.h:193:9: error: implicit declaration of function 'dst_cache_get_ip6'; did you mean 'dst_cache_get_ip4'? [-Werror=implicit-function-declaration]
      dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
            ^~~~~~~~~~~~~~~~~
            dst_cache_get_ip4
   include/net/ip6_tunnel.h:193:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
          ^
>> include/net/ip6_tunnel.h:209:3: error: implicit declaration of function 'dst_cache_set_ip6'; did you mean 'dst_cache_set_ip4'? [-Werror=implicit-function-declaration]
      dst_cache_set_ip6(dst_cache, dst, &fl6->saddr);
      ^~~~~~~~~~~~~~~~~
      dst_cache_set_ip4
   cc1: some warnings being treated as errors

vim +514 include/net/ip_tunnels.h

   492	
   493	static inline  struct rtable *iptunnel_get_v4_rt(struct sk_buff *skb,
   494			struct net_device *dev,
   495			struct net *net,
   496			struct flowi4 *fl4,
   497			const struct ip_tunnel_info *info,
   498			bool  use_cache)
   499	{
   500		struct dst_cache *dst_cache;
   501		struct rtable *rt = NULL;
   502		__u8 tos;
   503	
   504	
   505		memset(fl4, 0, sizeof(*fl4));
   506		fl4->flowi4_mark = skb->mark;
   507		fl4->flowi4_proto = IPPROTO_UDP;
   508		fl4->daddr = info->key.u.ipv4.dst;
   509		fl4->saddr = info->key.u.ipv4.src;
   510	
   511		tos = info->key.tos;
   512		fl4->flowi4_tos = RT_TOS(tos);
   513	
 > 514		dst_cache = (struct dst_cache *)&info->dst_cache;
   515		if (use_cache) {
   516			rt = dst_cache_get_ip4(dst_cache, &fl4->saddr);
   517			if (rt)
   518				return rt;
   519		}
   520		rt = ip_route_output_key(net, fl4);
   521		if (IS_ERR(rt)) {
   522			netdev_dbg(dev, "no route to %pI4\n", &fl4->daddr);
   523			return ERR_PTR(-ENETUNREACH);
   524		}
   525		if (rt->dst.dev == dev) { /* is this necessary? */
   526			netdev_dbg(dev, "circular route to %pI4\n", &fl4->daddr);
   527			ip_rt_put(rt);
   528			return ERR_PTR(-ELOOP);
   529		}
   530		if (use_cache)
   531			dst_cache_set_ip4(dst_cache, &rt->dst, fl4->saddr);
   532		return rt;
   533	}
   534	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--4tjsqeihcq7yfscr
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AQA=

--4tjsqeihcq7yfscr--
