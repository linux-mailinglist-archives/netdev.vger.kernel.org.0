Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2D920FCE8
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgF3Tnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:43:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:54600 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgF3Tnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 15:43:45 -0400
IronPort-SDR: /1NRQDZq/JEmdKxKJDBmSh+rLiuy95IKkU1fsT0WmO80gYGVEGJBkYuor2XP+KNvoW/a+if2/t
 6SO8fvzLo8Vw==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="146367578"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="gz'50?scan'50,208,50";a="146367578"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 12:42:37 -0700
IronPort-SDR: RQ3P+bSXWD98+lUEExBn0uad17sNcOTseyoh5GRDaaPqB7ytbOHWBEUgawQUxIKbAK9NoxMaf8
 P21DA/Eac5zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="gz'50?scan'50,208,50";a="454724424"
Received: from lkp-server01.sh.intel.com (HELO 28879958b202) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2020 12:42:34 -0700
Received: from kbuild by 28879958b202 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jqM9J-0001tS-L9; Tue, 30 Jun 2020 19:42:33 +0000
Date:   Wed, 1 Jul 2020 03:42:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, UNGLinuxDriver@microchip.com
Cc:     kbuild-all@lists.01.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next 2/3] bridge: mrp: Add br_mrp_fill_info
Message-ID: <202007010321.yEBMvfLB%lkp@intel.com>
References: <20200630134424.4114086-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20200630134424.4114086-3-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Horatiu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Horatiu-Vultur/bridge-mrp-Add-support-for-getting-the-status/20200630-214828
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5fb62372a0207f1514fa6052c51991198c46ffe2
config: i386-randconfig-s002-20200630 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.2-3-gfa153962-dirty
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   net/smc/smc_ib.c:202:44: sparse:     got struct net_device [noderef] __rcu *const ndev
   net/sctp/sm_make_chunk.c:3060:48: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected int optname @@     got restricted __be16 @@
   net/sctp/sm_make_chunk.c:3060:48: sparse:     expected int optname
   net/sctp/sm_make_chunk.c:3060:48: sparse:     got restricted __be16
   net/sctp/sm_make_chunk.c:3132:48: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected int optname @@     got restricted __be16 @@
   net/sctp/sm_make_chunk.c:3132:48: sparse:     expected int optname
   net/sctp/sm_make_chunk.c:3132:48: sparse:     got restricted __be16
   net/ipv4/tcp_output.c:3346: warning: Function parameter or member 'sk' not described in 'tcp_make_synack'
   net/ipv4/tcp_output.c:3346: warning: Function parameter or member 'dst' not described in 'tcp_make_synack'
   net/ipv4/tcp_output.c:3346: warning: Function parameter or member 'req' not described in 'tcp_make_synack'
   net/ipv4/tcp_output.c:3346: warning: Function parameter or member 'foc' not described in 'tcp_make_synack'
   net/ipv4/tcp_output.c:3346: warning: Function parameter or member 'synack_type' not described in 'tcp_make_synack'
   net/core/filter.c:400:33: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:403:33: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:406:33: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:409:33: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:412:33: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:486:27: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:489:27: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:492:27: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:1380:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sock_filter const *filter @@     got struct sock_filter [noderef] __user *filter @@
   net/core/filter.c:1380:39: sparse:     expected struct sock_filter const *filter
   net/core/filter.c:1380:39: sparse:     got struct sock_filter [noderef] __user *filter
   net/core/filter.c:1458:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sock_filter const *filter @@     got struct sock_filter [noderef] __user *filter @@
   net/core/filter.c:1458:39: sparse:     expected struct sock_filter const *filter
   net/core/filter.c:1458:39: sparse:     got struct sock_filter [noderef] __user *filter
   net/core/filter.c:7008:27: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:7011:27: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:7014:27: sparse: sparse: subtraction of functions? Share your drugs
   net/core/filter.c:8768:31: sparse: sparse: symbol 'cg_skb_verifier_ops' was not declared. Should it be static?
   net/core/filter.c:8774:27: sparse: sparse: symbol 'cg_skb_prog_ops' was not declared. Should it be static?
   net/core/filter.c:8819:31: sparse: sparse: symbol 'cg_sock_verifier_ops' was not declared. Should it be static?
   net/core/filter.c:8825:27: sparse: sparse: symbol 'cg_sock_prog_ops' was not declared. Should it be static?
   net/core/filter.c:8828:31: sparse: sparse: symbol 'cg_sock_addr_verifier_ops' was not declared. Should it be static?
   net/core/filter.c:8834:27: sparse: sparse: symbol 'cg_sock_addr_prog_ops' was not declared. Should it be static?
   net/core/filter.c:215:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:215:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:215:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:215:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:242:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:242:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:242:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:242:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:242:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:242:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:1882:43: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __wsum [usertype] diff @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1882:43: sparse:     expected restricted __wsum [usertype] diff
   net/core/filter.c:1882:43: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1885:36: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be16 [usertype] old @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1885:36: sparse:     expected restricted __be16 [usertype] old
   net/core/filter.c:1885:36: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1885:42: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be16 [usertype] new @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1885:42: sparse:     expected restricted __be16 [usertype] new
   net/core/filter.c:1885:42: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1888:36: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1888:36: sparse:     expected restricted __be32 [usertype] from
   net/core/filter.c:1888:36: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1888:42: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1888:42: sparse:     expected restricted __be32 [usertype] to
   net/core/filter.c:1888:42: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1933:59: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] diff @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1933:59: sparse:     expected restricted __wsum [usertype] diff
   net/core/filter.c:1933:59: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1936:52: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be16 [usertype] from @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1936:52: sparse:     expected restricted __be16 [usertype] from
   net/core/filter.c:1936:52: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1936:58: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected restricted __be16 [usertype] to @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1936:58: sparse:     expected restricted __be16 [usertype] to
   net/core/filter.c:1936:58: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1939:52: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] from @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1939:52: sparse:     expected restricted __be32 [usertype] from
   net/core/filter.c:1939:52: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1939:58: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected restricted __be32 [usertype] to @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1939:58: sparse:     expected restricted __be32 [usertype] to
   net/core/filter.c:1939:58: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1985:28: sparse: sparse: incorrect type in return expression (different base types) @@     expected unsigned long long @@     got restricted __wsum @@
   net/core/filter.c:1985:28: sparse:     expected unsigned long long
   net/core/filter.c:1985:28: sparse:     got restricted __wsum
   net/core/filter.c:2007:35: sparse: sparse: incorrect type in return expression (different base types) @@     expected unsigned long long @@     got restricted __wsum [usertype] csum @@
   net/core/filter.c:2007:35: sparse:     expected unsigned long long
   net/core/filter.c:2007:35: sparse:     got restricted __wsum [usertype] csum
   net/core/filter.c:4694:17: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] spi @@     got restricted __be32 const [usertype] spi @@
   net/core/filter.c:4694:17: sparse:     expected unsigned int [usertype] spi
   net/core/filter.c:4694:17: sparse:     got restricted __be32 const [usertype] spi
   net/core/filter.c:4702:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] remote_ipv4 @@     got restricted __be32 const [usertype] a4 @@
   net/core/filter.c:4702:33: sparse:     expected unsigned int [usertype] remote_ipv4
   net/core/filter.c:4702:33: sparse:     got restricted __be32 const [usertype] a4
   net/atm/lec.c:891:39: sparse: sparse: context imbalance in 'lec_priv_walk' - unexpected unlock
   net/atm/lec.c:947:39: sparse: sparse: context imbalance in 'lec_seq_stop' - unexpected unlock
   net/9p/client.c:420: warning: Function parameter or member 'c' not described in 'p9_client_cb'
   net/9p/client.c:420: warning: Function parameter or member 'req' not described in 'p9_client_cb'
   net/9p/client.c:420: warning: Function parameter or member 'status' not described in 'p9_client_cb'
   net/9p/client.c:568: warning: Function parameter or member 'uidata' not described in 'p9_check_zc_errors'
   net/9p/client.c:824: warning: Function parameter or member 'in_hdrlen' not described in 'p9_client_zc_rpc'
   net/9p/client.c:824: warning: Excess function parameter 'hdrlen' description in 'p9_client_zc_rpc'
   net/sunrpc/svcsock.c:226:5: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined, evaluates to 0 [-Wundef]
     226 | #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/bridge/br_mrp_netlink.c:316:9: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:325:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:325:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:328:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:328:36: sparse: sparse: dereference of noderef expression
>> net/bridge/br_mrp_netlink.c:316:9: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp.c:106:18: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] @@     got restricted __be16 [usertype] @@
   net/bridge/br_mrp.c:106:18: sparse:     expected unsigned short [usertype]
   net/bridge/br_mrp.c:106:18: sparse:     got restricted __be16 [usertype]
   net/bridge/br_mrp.c:281:23: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *entry @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:281:23: sparse:     expected struct list_head *entry
   net/bridge/br_mrp.c:281:23: sparse:     got struct list_head [noderef] *
   net/bridge/br_mrp.c:332:28: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *new @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:332:28: sparse:     expected struct list_head *new
   net/bridge/br_mrp.c:332:28: sparse:     got struct list_head [noderef] *
   net/bridge/br_mrp.c:332:40: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected struct list_head *head @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:332:40: sparse:     expected struct list_head *head
   net/bridge/br_mrp.c:332:40: sparse:     got struct list_head [noderef] *
   net/bridge/br_mrp.c:682:29: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head const *head @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:682:29: sparse:     expected struct list_head const *head
   net/bridge/br_mrp.c:682:29: sparse:     got struct list_head [noderef] *
   net/tipc/bearer.c:77: warning: Function parameter or member 'name' not described in 'tipc_media_find'
   net/tipc/bearer.c:91: warning: Function parameter or member 'type' not described in 'media_find_id'
   net/tipc/bearer.c:105: warning: Function parameter or member 'buf' not described in 'tipc_media_addr_printf'
   net/tipc/bearer.c:105: warning: Function parameter or member 'len' not described in 'tipc_media_addr_printf'
   net/tipc/bearer.c:105: warning: Function parameter or member 'a' not described in 'tipc_media_addr_printf'
   net/tipc/bearer.c:174: warning: Function parameter or member 'net' not described in 'tipc_bearer_find'
   net/tipc/bearer.c:174: warning: Function parameter or member 'name' not described in 'tipc_bearer_find'
   net/tipc/bearer.c:238: warning: Function parameter or member 'net' not described in 'tipc_enable_bearer'
   net/tipc/bearer.c:238: warning: Function parameter or member 'name' not described in 'tipc_enable_bearer'
   net/tipc/bearer.c:238: warning: Function parameter or member 'disc_domain' not described in 'tipc_enable_bearer'
   net/tipc/bearer.c:238: warning: Function parameter or member 'prio' not described in 'tipc_enable_bearer'
   net/tipc/bearer.c:238: warning: Function parameter or member 'attr' not described in 'tipc_enable_bearer'
   net/tipc/bearer.c:350: warning: Function parameter or member 'net' not described in 'tipc_reset_bearer'
   net/tipc/bearer.c:350: warning: Function parameter or member 'b' not described in 'tipc_reset_bearer'
   net/tipc/bearer.c:374: warning: Function parameter or member 'net' not described in 'bearer_disable'
   net/tipc/bearer.c:374: warning: Function parameter or member 'b' not described in 'bearer_disable'
   net/tipc/bearer.c:462: warning: Function parameter or member 'net' not described in 'tipc_l2_send_msg'
   net/tipc/bearer.c:609: warning: Function parameter or member 'skb' not described in 'tipc_l2_rcv_msg'
   net/tipc/bearer.c:609: warning: Excess function parameter 'buf' description in 'tipc_l2_rcv_msg'
   net/ipv4/tcp_offload.c:129:49: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __wsum [usertype] res @@     got fouled restricted __sum16 @@
   net/ipv4/tcp_offload.c:129:49: sparse:     expected restricted __wsum [usertype] res
   net/ipv4/tcp_offload.c:129:49: sparse:     got fouled restricted __sum16
   net/ipv4/tcp_offload.c:131:60: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __wsum [usertype] res @@     got fouled restricted __sum16 @@
   net/ipv4/tcp_offload.c:131:60: sparse:     expected restricted __wsum [usertype] res
   net/ipv4/tcp_offload.c:131:60: sparse:     got fouled restricted __sum16
   net/ipv4/tcp_offload.c:173:41: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __wsum [usertype] res @@     got fouled restricted __sum16 @@
   net/ipv4/tcp_offload.c:173:41: sparse:     expected restricted __wsum [usertype] res
   net/ipv4/tcp_offload.c:173:41: sparse:     got fouled restricted __sum16
   net/ipv4/tcp_offload.c:175:52: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __wsum [usertype] res @@     got fouled restricted __sum16 @@
   net/ipv4/tcp_offload.c:175:52: sparse:     expected restricted __wsum [usertype] res
   net/ipv4/tcp_offload.c:175:52: sparse:     got fouled restricted __sum16
   net/9p/trans_fd.c:932:28: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be32 [addressable] [assigned] [usertype] s_addr @@     got unsigned long @@
   net/9p/trans_fd.c:932:28: sparse:     expected restricted __be32 [addressable] [assigned] [usertype] s_addr
   net/9p/trans_fd.c:932:28: sparse:     got unsigned long
   net/dcb/dcbnl.c:1828: warning: Function parameter or member 'dev' not described in 'dcb_getapp'
   net/dcb/dcbnl.c:1828: warning: Function parameter or member 'app' not described in 'dcb_getapp'
   net/dcb/dcbnl.c:1850: warning: Function parameter or member 'dev' not described in 'dcb_setapp'
   net/dcb/dcbnl.c:1850: warning: Function parameter or member 'new' not described in 'dcb_setapp'
   net/dcb/dcbnl.c:1891: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_mask'
   net/dcb/dcbnl.c:1891: warning: Function parameter or member 'app' not described in 'dcb_ieee_getapp_mask'
   net/dcb/dcbnl.c:1914: warning: Function parameter or member 'dev' not described in 'dcb_ieee_setapp'
   net/dcb/dcbnl.c:1914: warning: Function parameter or member 'new' not described in 'dcb_ieee_setapp'
   net/dcb/dcbnl.c:1945: warning: Function parameter or member 'dev' not described in 'dcb_ieee_delapp'
   net/dcb/dcbnl.c:1945: warning: Function parameter or member 'del' not described in 'dcb_ieee_delapp'
   net/dcb/dcbnl.c:1978: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_prio_dscp_mask_map'
   net/dcb/dcbnl.c:1978: warning: Function parameter or member 'p_map' not described in 'dcb_ieee_getapp_prio_dscp_mask_map'
   net/dcb/dcbnl.c:2008: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_dscp_prio_mask_map'
   net/dcb/dcbnl.c:2008: warning: Function parameter or member 'p_map' not described in 'dcb_ieee_getapp_dscp_prio_mask_map'
   net/dcb/dcbnl.c:2037: warning: Function parameter or member 'dev' not described in 'dcb_ieee_getapp_default_prio_mask'
   net/9p/trans_common.c:23: warning: Function parameter or member 'pages' not described in 'p9_release_pages'
   net/9p/trans_common.c:23: warning: Function parameter or member 'nr_pages' not described in 'p9_release_pages'
   net/tipc/discover.c:82: warning: Function parameter or member 'skb' not described in 'tipc_disc_init_msg'
   net/tipc/discover.c:82: warning: Function parameter or member 'mtyp' not described in 'tipc_disc_init_msg'
   net/tipc/discover.c:82: warning: Excess function parameter 'type' description in 'tipc_disc_init_msg'
   net/tipc/discover.c:348: warning: Function parameter or member 'skb' not described in 'tipc_disc_create'
   net/tipc/discover.c:348: warning: Excess function parameter 'dest_domain' description in 'tipc_disc_create'
   net/tipc/discover.c:399: warning: Excess function parameter 'dest_domain' description in 'tipc_disc_reset'
   net/tipc/msg.c:68: warning: Function parameter or member 'gfp' not described in 'tipc_buf_acquire'
   net/tipc/msg.c:214: warning: Function parameter or member '_hdr' not described in 'tipc_msg_append'
   net/tipc/msg.c:214: warning: Excess function parameter 'hdr' description in 'tipc_msg_append'
   net/tipc/msg.c:380: warning: Function parameter or member 'offset' not described in 'tipc_msg_build'
   net/tipc/msg.c:706: warning: Function parameter or member 'net' not described in 'tipc_msg_lookup_dest'
   net/tipc/monitor.c:263:35: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int @@     got restricted __be32 [usertype] @@
   net/tipc/monitor.c:263:35: sparse:     expected unsigned int
   net/tipc/monitor.c:263:35: sparse:     got restricted __be32 [usertype]
   net/tipc/monitor.c:269:20: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] len @@     got restricted __be16 [usertype] @@
   net/tipc/monitor.c:269:20: sparse:     expected unsigned short [usertype] len
   net/tipc/monitor.c:269:20: sparse:     got restricted __be16 [usertype]
   net/tipc/monitor.c:270:20: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] gen @@     got restricted __be16 [usertype] @@
   net/tipc/monitor.c:270:20: sparse:     expected unsigned short [usertype] gen
   net/tipc/monitor.c:270:20: sparse:     got restricted __be16 [usertype]
   net/tipc/monitor.c:271:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] member_cnt @@     got restricted __be16 [usertype] @@
   net/tipc/monitor.c:271:27: sparse:     expected unsigned short [usertype] member_cnt
   net/tipc/monitor.c:271:27: sparse:     got restricted __be16 [usertype]
   net/tipc/monitor.c:272:23: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] up_map @@     got restricted __be64 [usertype] @@
   net/tipc/monitor.c:272:23: sparse:     expected unsigned long long [usertype] up_map
   net/tipc/monitor.c:272:23: sparse:     got restricted __be64 [usertype]
   net/tipc/monitor.c:458:30: sparse: sparse: cast to restricted __be16
   net/tipc/monitor.c:458:30: sparse: sparse: cast to restricted __be16
   net/tipc/monitor.c:458:30: sparse: sparse: cast to restricted __be16
   net/tipc/monitor.c:458:30: sparse: sparse: cast to restricted __be16
   net/tipc/monitor.c:460:23: sparse: sparse: cast to restricted __be16
   net/tipc/monitor.c:460:23: sparse: sparse: cast to restricted __be16
   net/tipc/monitor.c:460:23: sparse: sparse: cast to restricted __be16
   net/tipc/monitor.c:460:23: sparse: sparse: cast to restricted __be16
--
   net/bridge/br_device.c:475:25: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *list @@     got struct list_head [noderef] * @@
   net/bridge/br_device.c:475:25: sparse:     expected struct list_head *list
   net/bridge/br_device.c:475:25: sparse:     got struct list_head [noderef] *
   net/bridge/br_netlink_tunnel.c:29:6: warning: no previous prototype for 'vlan_tunid_inrange' [-Wmissing-prototypes]
      29 | bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
         |      ^~~~~~~~~~~~~~~~~~
   net/bridge/br_netlink_tunnel.c:196:5: warning: no previous prototype for 'br_vlan_tunnel_info' [-Wmissing-prototypes]
     196 | int br_vlan_tunnel_info(const struct net_bridge_port *p, int cmd,
         |     ^~~~~~~~~~~~~~~~~~~
>> net/bridge/br_mrp_netlink.c:316:9: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:325:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:325:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:328:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:328:36: sparse: sparse: dereference of noderef expression
>> net/bridge/br_mrp_netlink.c:316:9: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp.c:106:18: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] @@     got restricted __be16 [usertype] @@
   net/bridge/br_mrp.c:106:18: sparse:     expected unsigned short [usertype]
   net/bridge/br_mrp.c:106:18: sparse:     got restricted __be16 [usertype]
   net/bridge/br_mrp.c:281:23: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *entry @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:281:23: sparse:     expected struct list_head *entry
   net/bridge/br_mrp.c:281:23: sparse:     got struct list_head [noderef] *
   net/bridge/br_mrp.c:332:28: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *new @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:332:28: sparse:     expected struct list_head *new
   net/bridge/br_mrp.c:332:28: sparse:     got struct list_head [noderef] *
   net/bridge/br_mrp.c:332:40: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected struct list_head *head @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:332:40: sparse:     expected struct list_head *head
   net/bridge/br_mrp.c:332:40: sparse:     got struct list_head [noderef] *
   net/bridge/br_mrp.c:682:29: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head const *head @@     got struct list_head [noderef] * @@
   net/bridge/br_mrp.c:682:29: sparse:     expected struct list_head const *head
   net/bridge/br_mrp.c:682:29: sparse:     got struct list_head [noderef] *
--
>> net/bridge/br_mrp_netlink.c:316:9: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:325:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:325:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:328:36: sparse: sparse: dereference of noderef expression
   net/bridge/br_mrp_netlink.c:328:36: sparse: sparse: dereference of noderef expression
>> net/bridge/br_mrp_netlink.c:316:9: sparse: sparse: dereference of noderef expression

vim +316 net/bridge/br_mrp_netlink.c

   306	
   307	int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
   308	{
   309		struct nlattr *tb, *mrp_tb;
   310		struct br_mrp *mrp;
   311	
   312		mrp_tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
   313		if (!mrp_tb)
   314			return -EMSGSIZE;
   315	
 > 316		list_for_each_entry(mrp, &br->mrp_list, list) {
   317			tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP_INFO);
   318			if (!tb)
   319				goto nla_info_failure;
   320	
   321			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_ID,
   322					mrp->ring_id))
   323				goto nla_put_failure;
   324			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_P_IFINDEX,
   325					mrp->p_port->dev->ifindex))
   326				goto nla_put_failure;
   327			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_S_IFINDEX,
   328					mrp->s_port->dev->ifindex))
   329				goto nla_put_failure;
   330			if (nla_put_u16(skb, IFLA_BRIDGE_MRP_INFO_PRIO,
   331					mrp->prio))
   332				goto nla_put_failure;
   333			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_STATE,
   334					mrp->ring_state))
   335				goto nla_put_failure;
   336			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_ROLE,
   337					mrp->ring_role))
   338				goto nla_put_failure;
   339			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_INTERVAL,
   340					mrp->test_interval))
   341				goto nla_put_failure;
   342			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_MAX_MISS,
   343					mrp->test_max_miss))
   344				goto nla_put_failure;
   345			if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_MONITOR,
   346					mrp->test_monitor))
   347				goto nla_put_failure;
   348	
   349			nla_nest_end(skb, tb);
   350		}
   351		nla_nest_end(skb, mrp_tb);
   352	
   353		return 0;
   354	
   355	nla_put_failure:
   356		nla_nest_cancel(skb, tb);
   357	
   358	nla_info_failure:
   359		nla_nest_cancel(skb, mrp_tb);
   360	
   361		return -EMSGSIZE;
   362	}
   363	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--azLHFNyN32YCQGCU
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
dg48L+K9RHkVAPI/qjwX7ZMjAgA=

--azLHFNyN32YCQGCU--
