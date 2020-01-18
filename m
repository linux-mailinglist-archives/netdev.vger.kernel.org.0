Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B51416E1
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 10:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgARJky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 04:40:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:41818 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgARJkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 04:40:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 01:40:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,333,1574150400"; 
   d="scan'208";a="227581232"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 18 Jan 2020 01:40:48 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iskb2-0005KM-58; Sat, 18 Jan 2020 17:40:48 +0800
Date:   Sat, 18 Jan 2020 17:40:18 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
Message-ID: <202001181705.lWyUk1gz%lkp@intel.com>
References: <20200116145522.28803-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116145522.28803-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master linus/master ipvs/master v5.5-rc6 next-20200117]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netlink-make-getters-tolerate-NULL-nla-arg/20200117-200009
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6bc8038035267d12df2bf78a8e1a5f07069fabb8
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-131-g22978b6b-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
--
   net/decnet/dn_route.c:309:43: sparse: sparse: restricted __le16 degrades to integer
   net/decnet/dn_route.c:1288:37: sparse: sparse: incorrect type in argument 1 (different address spaces)
   net/decnet/dn_route.c:1288:37: sparse:    expected struct dst_entry **pprt
   net/decnet/dn_route.c:1288:37: sparse:    got struct dst_entry [noderef] <asn:4> **pprt
   net/decnet/dn_route.c:1290:48: sparse: sparse: incorrect type in argument 2 (different address spaces)
   net/decnet/dn_route.c:1290:48: sparse:    expected struct dst_entry *dst_orig
   net/decnet/dn_route.c:1290:48: sparse:    got struct dst_entry [noderef] <asn:4> *
   net/decnet/dn_route.c:1290:23: sparse: sparse: incorrect type in assignment (different address spaces)
   net/decnet/dn_route.c:1290:23: sparse:    expected struct dst_entry [noderef] <asn:4> *
   net/decnet/dn_route.c:1290:23: sparse:    got struct dst_entry *
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
   net/decnet/dn_route.c:1787:9: sparse: sparse: context imbalance in 'dn_rt_cache_get_first' - wrong count at exit
   include/linux/rcupdate.h:213:27: sparse: sparse: context imbalance in 'dn_rt_cache_get_next' - unexpected unlock
   include/linux/rcupdate.h:213:27: sparse: sparse: context imbalance in 'dn_rt_cache_seq_stop' - unexpected unlock
--
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
--
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
--
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
--
   net/decnet/dn_table.c:120:17: sparse: sparse: restricted __le16 degrades to integer
   net/decnet/dn_table.c:120:28: sparse: sparse: restricted __le16 degrades to integer
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
   net/decnet/dn_table.c:120:17: sparse: sparse: restricted __le16 degrades to integer
   net/decnet/dn_table.c:120:28: sparse: sparse: restricted __le16 degrades to integer
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
   net/decnet/dn_table.c:120:17: sparse: sparse: restricted __le16 degrades to integer
   net/decnet/dn_table.c:120:28: sparse: sparse: restricted __le16 degrades to integer
   net/decnet/dn_table.c:120:17: sparse: sparse: restricted __le16 degrades to integer
   net/decnet/dn_table.c:120:28: sparse: sparse: restricted __le16 degrades to integer
--
>> include/net/netlink.h:1560:17: sparse: sparse: cast to restricted __le64
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1560:17: sparse: sparse: cast to restricted __le64
>> include/net/netlink.h:1492:17: sparse: sparse: cast to restricted __le32
>> include/net/netlink.h:1560:17: sparse: sparse: cast to restricted __le64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1519:17: sparse: sparse: cast to restricted __le16
>> include/net/netlink.h:1560:17: sparse: sparse: cast to restricted __le64
>> include/net/netlink.h:1560:17: sparse: sparse: cast to restricted __le64
>> include/net/netlink.h:1560:17: sparse: sparse: cast to restricted __le64
>> include/net/netlink.h:1560:17: sparse: sparse: cast to restricted __le64
--
   include/net/route.h:366:48: sparse: sparse: incorrect type in argument 2 (different base types)
   include/net/route.h:366:48: sparse:    expected unsigned int [usertype] key
   include/net/route.h:366:48: sparse:    got restricted __be32 [usertype] daddr
   include/net/route.h:366:48: sparse: sparse: incorrect type in argument 2 (different base types)
   include/net/route.h:366:48: sparse:    expected unsigned int [usertype] key
   include/net/route.h:366:48: sparse:    got restricted __be32 [usertype] daddr
   net/ipv4/route.c:782:46: sparse: sparse: incorrect type in argument 2 (different base types)
   net/ipv4/route.c:782:46: sparse:    expected unsigned int [usertype] key
   net/ipv4/route.c:782:46: sparse:    got restricted __be32 [usertype] new_gw
   net/ipv4/route.c:3019:27: sparse: sparse: incorrect type in assignment (different base types)
   net/ipv4/route.c:3019:27: sparse:    expected restricted __be16 [usertype] len
   net/ipv4/route.c:3019:27: sparse:    got unsigned long
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/ipv4/ip_tunnel_core.c:384:45: sparse: sparse: restricted __be16 degrades to integer
   net/ipv4/ip_tunnel_core.c:393:30: sparse: sparse: incorrect type in assignment (different base types)
   net/ipv4/ip_tunnel_core.c:393:30: sparse:    expected int type
   net/ipv4/ip_tunnel_core.c:393:30: sparse:    got restricted __be16 [usertype]
   net/ipv4/ip_tunnel_core.c:403:30: sparse: sparse: incorrect type in assignment (different base types)
   net/ipv4/ip_tunnel_core.c:403:30: sparse:    expected int type
   net/ipv4/ip_tunnel_core.c:403:30: sparse:    got restricted __be16 [usertype]
   net/ipv4/ip_tunnel_core.c:413:30: sparse: sparse: incorrect type in assignment (different base types)
   net/ipv4/ip_tunnel_core.c:413:30: sparse:    expected int type
   net/ipv4/ip_tunnel_core.c:413:30: sparse:    got restricted __be16 [usertype]
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
   net/ipv4/nexthop.c:257:59: sparse: sparse: incorrect type in argument 3 (different base types)
   net/ipv4/nexthop.c:257:59: sparse:    expected unsigned int [usertype] value
   net/ipv4/nexthop.c:257:59: sparse:    got restricted __be32 [usertype] ipv4
   net/ipv4/nexthop.c:1005:24: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/ipv4/nexthop.c:1005:24: sparse:    struct rb_node [noderef] <asn:4> *
   net/ipv4/nexthop.c:1005:24: sparse:    struct rb_node *
   include/linux/rbtree.h:84:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   include/linux/rbtree.h:84:9: sparse:    struct rb_node [noderef] <asn:4> *
   include/linux/rbtree.h:84:9: sparse:    struct rb_node *
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/ipv4/ipmr.c:2918:13: sparse: sparse: context imbalance in 'ipmr_vif_seq_start' - different lock contexts for basic block
   include/linux/mroute_base.h:427:31: sparse: sparse: context imbalance in 'mr_mfc_seq_stop' - unexpected unlock
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
   net/ipv4/fou.c:250:18: sparse: sparse: incorrect type in assignment (different address spaces)
   net/ipv4/fou.c:250:18: sparse:    expected struct net_offload const **offloads
   net/ipv4/fou.c:250:18: sparse:    got struct net_offload const [noderef] <asn:4> **
   net/ipv4/fou.c:251:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/ipv4/fou.c:251:15: sparse:    struct net_offload const [noderef] <asn:4> *
   net/ipv4/fou.c:251:15: sparse:    struct net_offload const *
   net/ipv4/fou.c:272:18: sparse: sparse: incorrect type in assignment (different address spaces)
   net/ipv4/fou.c:272:18: sparse:    expected struct net_offload const **offloads
   net/ipv4/fou.c:272:18: sparse:    got struct net_offload const [noderef] <asn:4> **
   net/ipv4/fou.c:273:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/ipv4/fou.c:273:15: sparse:    struct net_offload const [noderef] <asn:4> *
   net/ipv4/fou.c:273:15: sparse:    struct net_offload const *
   net/ipv4/fou.c:442:18: sparse: sparse: incorrect type in assignment (different address spaces)
   net/ipv4/fou.c:442:18: sparse:    expected struct net_offload const **offloads
   net/ipv4/fou.c:442:18: sparse:    got struct net_offload const [noderef] <asn:4> **
   net/ipv4/fou.c:443:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/ipv4/fou.c:443:15: sparse:    struct net_offload const [noderef] <asn:4> *
   net/ipv4/fou.c:443:15: sparse:    struct net_offload const *
   net/ipv4/fou.c:489:18: sparse: sparse: incorrect type in assignment (different address spaces)
   net/ipv4/fou.c:489:18: sparse:    expected struct net_offload const **offloads
   net/ipv4/fou.c:489:18: sparse:    got struct net_offload const [noderef] <asn:4> **
   net/ipv4/fou.c:490:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/ipv4/fou.c:490:15: sparse:    struct net_offload const [noderef] <asn:4> *
   net/ipv4/fou.c:490:15: sparse:    struct net_offload const *
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
   net/ipv6/route.c:2320:39: sparse: sparse: incorrect type in assignment (different base types)
   net/ipv6/route.c:2320:39: sparse:    expected unsigned int [usertype] flow_label
   net/ipv6/route.c:2320:39: sparse:    got restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
--
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/netfilter/nfnetlink.c:538:21: sparse: sparse: restricted __be16 degrades to integer
   net/netfilter/nfnetlink.c:601:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nfnetlink.c:601:9: sparse:    struct sock [noderef] <asn:4> *
   net/netfilter/nfnetlink.c:601:9: sparse:    struct sock *
   net/netfilter/nfnetlink.c:610:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nfnetlink.c:610:17: sparse:    struct sock [noderef] <asn:4> *
   net/netfilter/nfnetlink.c:610:17: sparse:    struct sock *
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
   net/netfilter/nf_conntrack_core.c:2174:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_conntrack_core.c:2174:9: sparse:    void ( [noderef] <asn:4> * )( ... )
   net/netfilter/nf_conntrack_core.c:2174:9: sparse:    void ( * )( ... )
   net/netfilter/nf_conntrack_core.c:2492:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_conntrack_core.c:2492:9: sparse:    void ( [noderef] <asn:4> * )( ... )
   net/netfilter/nf_conntrack_core.c:2492:9: sparse:    void ( * )( ... )
   net/netfilter/nf_conntrack_core.c:113:13: sparse: sparse: context imbalance in 'nf_conntrack_double_unlock' - unexpected unlock
   net/netfilter/nf_conntrack_core.c:123:13: sparse: sparse: context imbalance in 'nf_conntrack_double_lock' - wrong count at exit
   net/netfilter/nf_conntrack_core.c:153:9: sparse: sparse: context imbalance in 'nf_conntrack_all_lock' - wrong count at exit
   net/netfilter/nf_conntrack_core.c:164:13: sparse: sparse: context imbalance in 'nf_conntrack_all_unlock' - unexpected unlock
   net/netfilter/nf_conntrack_core.c:2011:28: sparse: sparse: context imbalance in 'get_next_corpse' - unexpected unlock
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/netfilter/nf_conntrack_netlink.c:1693:34: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_conntrack_netlink.c:1693:34: sparse:    struct nf_conntrack_helper [noderef] <asn:4> *
   net/netfilter/nf_conntrack_netlink.c:1693:34: sparse:    struct nf_conntrack_helper *
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: too many warnings
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
   net/netfilter/nfnetlink_cttimeout.c:615:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nfnetlink_cttimeout.c:615:9: sparse:    struct nf_ct_timeout *( [noderef] <asn:4> * )( ... )
   net/netfilter/nfnetlink_cttimeout.c:615:9: sparse:    struct nf_ct_timeout *( * )( ... )
   net/netfilter/nfnetlink_cttimeout.c:616:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nfnetlink_cttimeout.c:616:9: sparse:    void ( [noderef] <asn:4> * )( ... )
   net/netfilter/nfnetlink_cttimeout.c:616:9: sparse:    void ( * )( ... )
   net/netfilter/nfnetlink_cttimeout.c:629:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nfnetlink_cttimeout.c:629:9: sparse:    struct nf_ct_timeout *( [noderef] <asn:4> * )( ... )
   net/netfilter/nfnetlink_cttimeout.c:629:9: sparse:    struct nf_ct_timeout *( * )( ... )
   net/netfilter/nfnetlink_cttimeout.c:630:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nfnetlink_cttimeout.c:630:9: sparse:    void ( [noderef] <asn:4> * )( ... )
   net/netfilter/nfnetlink_cttimeout.c:630:9: sparse:    void ( * )( ... )
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/netfilter/nfnetlink_cthelper.c:103:17: sparse: sparse: dereference of noderef expression
   net/netfilter/nfnetlink_cthelper.c:115:17: sparse: sparse: dereference of noderef expression
   net/netfilter/nfnetlink_cthelper.c:116:45: sparse: sparse: dereference of noderef expression
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/netfilter/nf_tables_api.c:1375:25: sparse: sparse: cast between address spaces (<asn:3> -> <asn:4>)
   net/netfilter/nf_tables_api.c:1375:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:1375:25: sparse:    struct nft_stats [noderef] <asn:4> *
   net/netfilter/nf_tables_api.c:1375:25: sparse:    struct nft_stats [noderef] <asn:3> *
   net/netfilter/nf_tables_api.c:1532:31: sparse: sparse: incorrect type in return expression (different address spaces)
   net/netfilter/nf_tables_api.c:1535:31: sparse: sparse: incorrect type in return expression (different address spaces)
   net/netfilter/nf_tables_api.c:1539:31: sparse: sparse: incorrect type in return expression (different address spaces)
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
   net/netfilter/nf_tables_api.c:1561:17: sparse: sparse: cast between address spaces (<asn:3> -> <asn:4>)
   net/netfilter/nf_tables_api.c:1561:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:1561:17: sparse:    struct nft_stats [noderef] <asn:4> *
   net/netfilter/nf_tables_api.c:1561:17: sparse:    struct nft_stats [noderef] <asn:3> *
   net/netfilter/nf_tables_api.c:1561:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:1561:17: sparse:    struct nft_stats [noderef] <asn:4> *
   net/netfilter/nf_tables_api.c:1561:17: sparse:    struct nft_stats [noderef] <asn:3> *
   net/netfilter/nf_tables_api.c:1604:21: sparse: sparse: cast between address spaces (<asn:3> -> <asn:4>)
   net/netfilter/nf_tables_api.c:1604:21: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:1604:21: sparse:    struct nft_stats [noderef] <asn:4> *
   net/netfilter/nf_tables_api.c:1604:21: sparse:    struct nft_stats [noderef] <asn:3> *
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/netfilter/nf_tables_api.c:1906:25: sparse: sparse: cast between address spaces (<asn:3> -> <asn:4>)
   net/netfilter/nf_tables_api.c:1906:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:1906:25: sparse:    struct nft_stats [noderef] <asn:4> *
   net/netfilter/nf_tables_api.c:1906:25: sparse:    struct nft_stats [noderef] <asn:3> *
   net/netfilter/nf_tables_api.c:2056:23: sparse: sparse: incorrect type in assignment (different address spaces)
   net/netfilter/nf_tables_api.c:2056:23: sparse:    expected struct nft_stats *stats
   net/netfilter/nf_tables_api.c:2056:23: sparse:    got struct nft_stats [noderef] <asn:3> *
   net/netfilter/nf_tables_api.c:2067:38: sparse: sparse: incorrect type in assignment (different address spaces)
   net/netfilter/nf_tables_api.c:2067:38: sparse:    expected struct nft_stats [noderef] <asn:3> *stats
   net/netfilter/nf_tables_api.c:2067:38: sparse:    got struct nft_stats *stats
   net/netfilter/nf_tables_api.c:2103:21: sparse: sparse: incorrect type in argument 1 (different address spaces)
   net/netfilter/nf_tables_api.c:2103:21: sparse:    expected void [noderef] <asn:3> *__pdata
   net/netfilter/nf_tables_api.c:2103:21: sparse:    got struct nft_stats *stats
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
   include/net/netlink.h:1551:17: sparse: sparse: too many warnings
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   include/net/netfilter/nf_tables_core.h:44:16: sparse: sparse: incorrect type in return expression (different base types)
   include/net/netfilter/nf_tables_core.h:44:16: sparse:    expected unsigned int
   include/net/netfilter/nf_tables_core.h:44:16: sparse:    got restricted __le32 [usertype]
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
   net/netfilter/nft_byteorder.c:47:58: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
--
   net/netfilter/nft_exthdr.c:267:33: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_exthdr.c:267:33: sparse:    expected restricted __be16 [usertype] v16
   net/netfilter/nft_exthdr.c:267:33: sparse:    got unsigned short
   net/netfilter/nft_exthdr.c:268:33: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_exthdr.c:268:33: sparse:    expected restricted __be16 [usertype] v16
   net/netfilter/nft_exthdr.c:268:33: sparse:    got unsigned int [assigned] [usertype] src
   net/netfilter/nft_exthdr.c:286:33: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_exthdr.c:286:33: sparse:    expected restricted __be32 [usertype] v32
   net/netfilter/nft_exthdr.c:286:33: sparse:    got unsigned int [assigned] [usertype] src
   net/netfilter/nft_exthdr.c:287:33: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_exthdr.c:287:33: sparse:    expected restricted __be32 [usertype] v32
   net/netfilter/nft_exthdr.c:287:33: sparse:    got unsigned int
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   include/linux/rcupdate.h:669:9: sparse: sparse: context imbalance in 'nfnl_compat_get_rcu' - unexpected unlock
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
   net/netfilter/nft_ct.c:207:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_ct.c:207:23: sparse:    expected unsigned int [usertype]
   net/netfilter/nft_ct.c:207:23: sparse:    got restricted __be32 const [usertype] ip
   net/netfilter/nft_ct.c:212:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_ct.c:212:23: sparse:    expected unsigned int [usertype]
   net/netfilter/nft_ct.c:212:23: sparse:    got restricted __be32 const [usertype] ip
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_osf.c:94:47: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_osf.c:94:47: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_osf.c:94:47: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_osf.c:94:47: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_osf.c:94:47: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_osf.c:94:47: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_osf.c:94:47: sparse: sparse: incorrect type in argument 3 (different base types)
   net/netfilter/nft_osf.c:94:47: sparse:    expected restricted __be32 [usertype] value
   net/netfilter/nft_osf.c:94:47: sparse:    got unsigned int
--
   net/netfilter/nft_tproxy.c:49:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_tproxy.c:49:23: sparse:    expected restricted __be32 [usertype] taddr
   net/netfilter/nft_tproxy.c:49:23: sparse:    got unsigned int
   net/netfilter/nft_tproxy.c:53:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_tproxy.c:53:23: sparse:    expected restricted __be16 [usertype] tport
   net/netfilter/nft_tproxy.c:53:23: sparse:    got unsigned short
   net/netfilter/nft_tproxy.c:120:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_tproxy.c:120:23: sparse:    expected restricted __be16 [usertype] tport
   net/netfilter/nft_tproxy.c:120:23: sparse:    got unsigned short
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
   net/netfilter/nft_xfrm.c:53:21: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_xfrm.c:53:21: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_xfrm.c:53:21: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_xfrm.c:53:21: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_xfrm.c:53:21: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_xfrm.c:53:21: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_xfrm.c:136:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_xfrm.c:136:23: sparse:    expected unsigned int [usertype]
   net/netfilter/nft_xfrm.c:136:23: sparse:    got restricted __be32 const [usertype] a4
   net/netfilter/nft_xfrm.c:142:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_xfrm.c:142:23: sparse:    expected unsigned int [usertype]
   net/netfilter/nft_xfrm.c:142:23: sparse:    got restricted __be32 const [usertype] a4
   net/netfilter/nft_xfrm.c:151:23: sparse: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_xfrm.c:151:23: sparse:    expected unsigned int [usertype]
   net/netfilter/nft_xfrm.c:151:23: sparse:    got restricted __be32 const [usertype] spi
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
   net/netfilter/ipvs/ip_vs_ctl.c:1369:27: sparse: sparse: dereference of noderef expression
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1551:17: sparse: sparse: cast to restricted __be64
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
   net/bridge/netfilter/nft_meta_bridge.c:56:39: sparse: sparse: incorrect type in argument 2 (different base types)
   net/bridge/netfilter/nft_meta_bridge.c:56:39: sparse:    expected unsigned short [usertype] val
   net/bridge/netfilter/nft_meta_bridge.c:56:39: sparse:    got restricted __be16 [usertype]
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
   net/sched/act_tunnel_key.c:231:45: sparse: sparse: restricted __be16 degrades to integer
   net/sched/act_tunnel_key.c:248:30: sparse: sparse: incorrect type in assignment (different base types)
   net/sched/act_tunnel_key.c:248:30: sparse:    expected int type
   net/sched/act_tunnel_key.c:248:30: sparse:    got restricted __be16 [usertype]
   net/sched/act_tunnel_key.c:260:30: sparse: sparse: incorrect type in assignment (different base types)
   net/sched/act_tunnel_key.c:260:30: sparse:    expected int type
   net/sched/act_tunnel_key.c:260:30: sparse:    got restricted __be16 [usertype]
   net/sched/act_tunnel_key.c:272:30: sparse: sparse: incorrect type in assignment (different base types)
   net/sched/act_tunnel_key.c:272:30: sparse:    expected int type
   net/sched/act_tunnel_key.c:272:30: sparse:    got restricted __be16 [usertype]
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
--
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1636:33: sparse: sparse: missing braces around initializer
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
--
   net/sched/cls_flower.c:211:19: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:211:19: sparse:    got restricted __be16 [usertype] dst
   net/sched/cls_flower.c:211:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:211:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:214:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:214:21: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:214:21: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:214:21: sparse:    got restricted __be16 [usertype] dst
   net/sched/cls_flower.c:214:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:214:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:214:21: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:214:51: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:215:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:215:21: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:215:21: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:215:21: sparse:    got restricted __be16 [usertype] dst
   net/sched/cls_flower.c:215:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:215:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:215:21: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:215:51: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:231:20: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:231:20: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:231:20: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:231:20: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:231:20: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:231:20: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:232:20: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:232:20: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:232:20: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:232:20: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:232:20: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:232:20: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:233:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:233:19: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:233:19: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:233:19: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:233:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:233:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:234:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:234:19: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:234:19: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:234:19: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:234:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:234:19: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:237:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:237:21: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:237:21: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:237:21: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:237:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:237:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:237:21: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:237:51: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:238:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:238:21: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:238:21: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:238:21: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:238:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:238:21: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:238:21: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:238:51: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:756:14: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:756:14: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:756:14: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:756:14: sparse:    got restricted __be16 [usertype] dst
   net/sched/cls_flower.c:756:14: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:756:14: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:757:18: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:757:18: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:757:18: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:757:18: sparse:    got restricted __be16 [usertype] dst
   net/sched/cls_flower.c:757:18: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:757:18: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:756:14: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:757:18: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:759:14: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:759:14: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:759:14: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:759:14: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:759:14: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:759:14: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:760:18: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:760:18: sparse: sparse: incorrect type in argument 1 (different base types)
   net/sched/cls_flower.c:760:18: sparse:    expected unsigned short [usertype] val
   net/sched/cls_flower.c:760:18: sparse:    got restricted __be16 [usertype] src
   net/sched/cls_flower.c:760:18: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:760:18: sparse: sparse: cast from restricted __be16
   net/sched/cls_flower.c:759:14: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:760:18: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_flower.c:844:15: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:844:15: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:844:15: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:844:15: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:844:15: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:844:15: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:845:16: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:845:16: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:845:16: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:845:16: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:845:16: sparse: sparse: cast to restricted __be32
   net/sched/cls_flower.c:845:16: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1483:17: sparse: sparse: cast to restricted __be32
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16
>> include/net/netlink.h:1510:17: sparse: sparse: cast to restricted __be16

vim +1510 include/net/netlink.h

  1476	
  1477	/**
  1478	 * nla_get_be32 - return payload of __be32 attribute
  1479	 * @nla: __be32 netlink attribute
  1480	 */
  1481	static inline __be32 nla_get_be32(const struct nlattr *nla)
  1482	{
> 1483		return (__be32)nla_get_u32(nla);
  1484	}
  1485	
  1486	/**
  1487	 * nla_get_le32 - return payload of __le32 attribute
  1488	 * @nla: __le32 netlink attribute
  1489	 */
  1490	static inline __le32 nla_get_le32(const struct nlattr *nla)
  1491	{
> 1492		return (__le32)nla_get_u32(nla);
  1493	}
  1494	
  1495	/**
  1496	 * nla_get_u16 - return payload of u16 attribute
  1497	 * @nla: u16 netlink attribute
  1498	 */
  1499	static inline u16 nla_get_u16(const struct nlattr *nla)
  1500	{
  1501		return nla ? *(u16 *) nla_data(nla) : 0u;
  1502	}
  1503	
  1504	/**
  1505	 * nla_get_be16 - return payload of __be16 attribute
  1506	 * @nla: __be16 netlink attribute
  1507	 */
  1508	static inline __be16 nla_get_be16(const struct nlattr *nla)
  1509	{
> 1510		return (__be16)nla_get_u16(nla);
  1511	}
  1512	
  1513	/**
  1514	 * nla_get_le16 - return payload of __le16 attribute
  1515	 * @nla: __le16 netlink attribute
  1516	 */
  1517	static inline __le16 nla_get_le16(const struct nlattr *nla)
  1518	{
> 1519		return (__le16)nla_get_u16(nla);
  1520	}
  1521	
  1522	/**
  1523	 * nla_get_u8 - return payload of u8 attribute
  1524	 * @nla: u8 netlink attribute
  1525	 */
  1526	static inline u8 nla_get_u8(const struct nlattr *nla)
  1527	{
  1528		return nla ? *(u8 *) nla_data(nla) : 0u;
  1529	}
  1530	
  1531	/**
  1532	 * nla_get_u64 - return payload of u64 attribute
  1533	 * @nla: u64 netlink attribute
  1534	 */
  1535	static inline u64 nla_get_u64(const struct nlattr *nla)
  1536	{
  1537		u64 tmp = 0;
  1538	
  1539		if (nla)
  1540			nla_memcpy(&tmp, nla, sizeof(tmp));
  1541	
  1542		return tmp;
  1543	}
  1544	
  1545	/**
  1546	 * nla_get_be64 - return payload of __be64 attribute
  1547	 * @nla: __be64 netlink attribute
  1548	 */
  1549	static inline __be64 nla_get_be64(const struct nlattr *nla)
  1550	{
> 1551		return (__be64)nla_get_u64(nla);
  1552	}
  1553	
  1554	/**
  1555	 * nla_get_le64 - return payload of __le64 attribute
  1556	 * @nla: __le64 netlink attribute
  1557	 */
  1558	static inline __le64 nla_get_le64(const struct nlattr *nla)
  1559	{
> 1560		return (__le64)nla_get_u64(nla);
  1561	}
  1562	
  1563	/**
  1564	 * nla_get_s32 - return payload of s32 attribute
  1565	 * @nla: s32 netlink attribute
  1566	 */
  1567	static inline s32 nla_get_s32(const struct nlattr *nla)
  1568	{
  1569		return (s32)nla_get_u32(nla);
  1570	}
  1571	
  1572	/**
  1573	 * nla_get_s16 - return payload of s16 attribute
  1574	 * @nla: s16 netlink attribute
  1575	 */
  1576	static inline s16 nla_get_s16(const struct nlattr *nla)
  1577	{
  1578		return (s16)nla_get_u16(nla);
  1579	}
  1580	
  1581	/**
  1582	 * nla_get_s8 - return payload of s8 attribute
  1583	 * @nla: s8 netlink attribute
  1584	 */
  1585	static inline s8 nla_get_s8(const struct nlattr *nla)
  1586	{
  1587		return (s8)nla_get_u8(nla);
  1588	}
  1589	
  1590	/**
  1591	 * nla_get_s64 - return payload of s64 attribute
  1592	 * @nla: s64 netlink attribute
  1593	 */
  1594	static inline s64 nla_get_s64(const struct nlattr *nla)
  1595	{
  1596		return (s64)nla_get_u64(nla);
  1597	}
  1598	
  1599	/**
  1600	 * nla_get_flag - return payload of flag attribute
  1601	 * @nla: flag netlink attribute
  1602	 */
  1603	static inline int nla_get_flag(const struct nlattr *nla)
  1604	{
  1605		return !!nla;
  1606	}
  1607	
  1608	/**
  1609	 * nla_get_msecs - return payload of msecs attribute
  1610	 * @nla: msecs netlink attribute
  1611	 *
  1612	 * Returns the number of milliseconds in jiffies.
  1613	 */
  1614	static inline unsigned long nla_get_msecs(const struct nlattr *nla)
  1615	{
  1616		u64 msecs = nla_get_u64(nla);
  1617	
  1618		return msecs_to_jiffies((unsigned long) msecs);
  1619	}
  1620	
  1621	/**
  1622	 * nla_get_in_addr - return payload of IPv4 address attribute
  1623	 * @nla: IPv4 address netlink attribute
  1624	 */
  1625	static inline __be32 nla_get_in_addr(const struct nlattr *nla)
  1626	{
  1627		return nla_get_be32(nla);
  1628	}
  1629	
  1630	/**
  1631	 * nla_get_in6_addr - return payload of IPv6 address attribute
  1632	 * @nla: IPv6 address netlink attribute
  1633	 */
  1634	static inline struct in6_addr nla_get_in6_addr(const struct nlattr *nla)
  1635	{
> 1636		struct in6_addr tmp = { 0 };
  1637	
  1638		if (nla)
  1639			nla_memcpy(&tmp, nla, sizeof(tmp));
  1640	
  1641		return tmp;
  1642	}
  1643	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
