Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7322207ECA
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404648AbgFXVog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:44:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:59595 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404455AbgFXVod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 17:44:33 -0400
IronPort-SDR: GlSi11sNotYZ3z6otYLrHa/SgoBeJjYi0Xj0xMAfclRZ14dJR9Jc7SVueXpkL5rH83H6aWWWll
 fABdaDNPYAIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="146148244"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="gz'50?scan'50,208,50";a="146148244"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 14:38:23 -0700
IronPort-SDR: 4THmD1t7GZ+RJE3/nog3QzP8mTeZUd8n3T7Ga0JJFh+VuaDqaCogs4YUzRxfGI6krPaGbKhWcO
 bv4MNy6S7+VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="gz'50?scan'50,208,50";a="293681412"
Received: from lkp-server01.sh.intel.com (HELO 538b5e3c8319) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 24 Jun 2020 14:38:21 -0700
Received: from kbuild by 538b5e3c8319 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1joD64-00019m-Ax; Wed, 24 Jun 2020 21:38:20 +0000
Date:   Thu, 25 Jun 2020 05:37:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        justin.iurman@uliege.be
Subject: Re: [PATCH net-next 3/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
Message-ID: <202006250501.CZ3RyUCN%lkp@intel.com>
References: <20200624192310.16923-4-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20200624192310.16923-4-justin.iurman@uliege.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Justin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Justin-Iurman/Data-plane-support-for-IOAM-Pre-allocated-Trace-with-IPv6/20200625-033536
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 0558c396040734bc1d361919566a581fd41aa539
config: um-allmodconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
reproduce (this is a W=1 build):
        # save the attached .config to linux build tree
        make W=1 ARCH=um 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   cc1: warning: arch/um/include/uapi: No such file or directory [-Wmissing-include-dirs]
   In file included from include/linux/uaccess.h:11,
                    from include/linux/sched/task.h:11,
                    from include/linux/sched/signal.h:9,
                    from include/linux/rcuwait.h:6,
                    from include/linux/percpu-rwsem.h:7,
                    from include/linux/fs.h:33,
                    from include/linux/net.h:23,
                    from net/ipv6/ioam6.c:12:
   arch/um/include/asm/uaccess.h: In function '__access_ok':
   arch/um/include/asm/uaccess.h:17:29: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
      17 |    (((unsigned long) (addr) >= FIXADDR_USER_START) && \
         |                             ^~
   arch/um/include/asm/uaccess.h:45:3: note: in expansion of macro '__access_ok_vsyscall'
      45 |   __access_ok_vsyscall(addr, size) ||
         |   ^~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/kernel.h:11,
                    from net/ipv6/ioam6.c:11:
   include/asm-generic/fixmap.h: In function 'fix_to_virt':
   include/asm-generic/fixmap.h:32:19: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
      32 |  BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
         |                   ^~
   include/linux/compiler.h:372:9: note: in definition of macro '__compiletime_assert'
     372 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler.h:392:2: note: in expansion of macro '_compiletime_assert'
     392 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |  ^~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:32:2: note: in expansion of macro 'BUILD_BUG_ON'
      32 |  BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
         |  ^~~~~~~~~~~~
   net/ipv6/ioam6.c: At top level:
>> net/ipv6/ioam6.c:81:6: warning: no previous prototype for 'ioam6_fill_trace_data_node' [-Wmissing-prototypes]
      81 | void ioam6_fill_trace_data_node(struct sk_buff *skb, int nodeoff,
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~

vim +/ioam6_fill_trace_data_node +81 net/ipv6/ioam6.c

    80	
  > 81	void ioam6_fill_trace_data_node(struct sk_buff *skb, int nodeoff,
    82					u32 trace_type, struct ioam6_namespace *ns)
    83	{
    84		u8 *data = skb_network_header(skb) + nodeoff;
    85		struct __kernel_sock_timeval ts;
    86		u64 raw_u64;
    87		u32 raw_u32;
    88		u16 raw_u16;
    89		u8 byte;
    90	
    91		/* hop_lim and node_id */
    92		if (trace_type & IOAM6_TRACE_TYPE0) {
    93			byte = ipv6_hdr(skb)->hop_limit - 1;
    94			raw_u32 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
    95			if (!raw_u32)
    96				raw_u32 = IOAM6_EMPTY_FIELD_u24;
    97			else
    98				raw_u32 &= IOAM6_EMPTY_FIELD_u24;
    99			*(__be32 *)data = cpu_to_be32((byte << 24) | raw_u32);
   100			data += sizeof(__be32);
   101		}
   102	
   103		/* ingress_if_id and egress_if_id */
   104		if (trace_type & IOAM6_TRACE_TYPE1) {
   105			raw_u16 = __in6_dev_get(skb->dev)->cnf.ioam6_id;
   106			if (!raw_u16)
   107				raw_u16 = IOAM6_EMPTY_FIELD_u16;
   108			*(__be16 *)data = cpu_to_be16(raw_u16);
   109			data += sizeof(__be16);
   110	
   111			raw_u16 = __in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id;
   112			if (!raw_u16)
   113				raw_u16 = IOAM6_EMPTY_FIELD_u16;
   114			*(__be16 *)data = cpu_to_be16(raw_u16);
   115			data += sizeof(__be16);
   116		}
   117	
   118		/* timestamp seconds */
   119		if (trace_type & IOAM6_TRACE_TYPE2) {
   120			if (!skb->tstamp) {
   121				*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_FIELD_u32);
   122			} else {
   123				skb_get_new_timestamp(skb, &ts);
   124				*(__be32 *)data = cpu_to_be32((u32)ts.tv_sec);
   125			}
   126			data += sizeof(__be32);
   127		}
   128	
   129		/* timestamp subseconds */
   130		if (trace_type & IOAM6_TRACE_TYPE3) {
   131			if (!skb->tstamp) {
   132				*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_FIELD_u32);
   133			} else {
   134				if (!(trace_type & IOAM6_TRACE_TYPE2))
   135					skb_get_new_timestamp(skb, &ts);
   136				*(__be32 *)data = cpu_to_be32((u32)ts.tv_usec);
   137			}
   138			data += sizeof(__be32);
   139		}
   140	
   141		/* transit delay */
   142		if (trace_type & IOAM6_TRACE_TYPE4) {
   143			*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_FIELD_u32);
   144			data += sizeof(__be32);
   145		}
   146	
   147		/* namespace data */
   148		if (trace_type & IOAM6_TRACE_TYPE5) {
   149			*(__be32 *)data = (__be32)ns->data;
   150			data += sizeof(__be32);
   151		}
   152	
   153		/* queue depth */
   154		if (trace_type & IOAM6_TRACE_TYPE6) {
   155			*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_FIELD_u32);
   156			data += sizeof(__be32);
   157		}
   158	
   159		/* hop_lim and node_id (wide) */
   160		if (trace_type & IOAM6_TRACE_TYPE7) {
   161			byte = ipv6_hdr(skb)->hop_limit - 1;
   162			raw_u64 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
   163			if (!raw_u64)
   164				raw_u64 = IOAM6_EMPTY_FIELD_u56;
   165			else
   166				raw_u64 &= IOAM6_EMPTY_FIELD_u56;
   167			*(__be64 *)data = cpu_to_be64(((u64)byte << 56) | raw_u64);
   168			data += sizeof(__be64);
   169		}
   170	
   171		/* ingress_if_id and egress_if_id (wide) */
   172		if (trace_type & IOAM6_TRACE_TYPE8) {
   173			raw_u32 = __in6_dev_get(skb->dev)->cnf.ioam6_id;
   174			if (!raw_u32)
   175				raw_u32 = IOAM6_EMPTY_FIELD_u32;
   176			*(__be32 *)data = cpu_to_be32(raw_u32);
   177			data += sizeof(__be32);
   178	
   179			raw_u32 = __in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id;
   180			if (!raw_u32)
   181				raw_u32 = IOAM6_EMPTY_FIELD_u32;
   182			*(__be32 *)data = cpu_to_be32(raw_u32);
   183			data += sizeof(__be32);
   184		}
   185	
   186		/* namespace data (wide) */
   187		if (trace_type & IOAM6_TRACE_TYPE9) {
   188			*(__be64 *)data = ns->data;
   189			data += sizeof(__be64);
   190		}
   191	
   192		/* buffer occupancy */
   193		if (trace_type & IOAM6_TRACE_TYPE10) {
   194			*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_FIELD_u32);
   195			data += sizeof(__be32);
   196		}
   197	
   198		/* checksum complement */
   199		if (trace_type & IOAM6_TRACE_TYPE11) {
   200			*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_FIELD_u32);
   201			data += sizeof(__be32);
   202		}
   203	
   204		/* opaque state snapshot */
   205		if (trace_type & IOAM6_TRACE_TYPE22) {
   206			if (!ns->schema) {
   207				*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_FIELD_u24);
   208			} else {
   209				*(__be32 *)data = ns->schema->hdr;
   210				data += sizeof(__be32);
   211				memcpy(data, ns->schema->data, ns->schema->len);
   212			}
   213		}
   214	}
   215	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--T4sUOijqQbZv57TR
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AVQWKk5oYgEA

--T4sUOijqQbZv57TR--
