Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F05E1D97D0
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgESNb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:31:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:32836 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgESNb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 09:31:57 -0400
IronPort-SDR: cBjBPivloJHnCAw0HanN3MAUk2r6tcroPTm2cqidGwYYUtdCoipKJFiisKDNk8la9hEa2OkAbi
 PjUvfpqZ/s9w==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 06:31:56 -0700
IronPort-SDR: yoCDFL4MOGVcqAR93UuUUNMcgyswfcEgEnN/7XAp9n5QMaFlFMtnwM96rVdNRt47hKJ4n0Hf6S
 8iouJXogz7fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="gz'50?scan'50,208,50";a="288956969"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 06:31:53 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jb2LY-000BOg-Jn; Tue, 19 May 2020 21:31:52 +0800
Date:   Tue, 19 May 2020 21:31:08 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, dsahern@gmail.com,
        davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next 3/6] vxlan: ecmp support for mac fdb entries
Message-ID: <202005192109.T869qDB6%lkp@intel.com>
References: <1589854474-26854-4-git-send-email-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <1589854474-26854-4-git-send-email-roopa@cumulusnetworks.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Roopa,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master kselftest/next sparc-next/master linus/master v5.7-rc6 next-20200518]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Roopa-Prabhu/Support-for-fdb-ECMP-nexthop-groups/20200519-185605
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5cdfe8306631b2224e3f81fc5a1e2721c7a1948b
config: um-defconfig (attached as .config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>, old ones prefixed by <<):

cc1: warning: arch/um/include/uapi: No such file or directory [-Wmissing-include-dirs]
In file included from include/linux/kernel.h:11:0,
from net/ipv4/ip_tunnel_core.c:9:
include/asm-generic/fixmap.h: In function 'fix_to_virt':
include/asm-generic/fixmap.h:32:19: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
^
include/linux/compiler.h:330:9: note: in definition of macro '__compiletime_assert'
if (!(condition))                 ^~~~~~~~~
include/linux/compiler.h:350:2: note: in expansion of macro '_compiletime_assert'
_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
^~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
^~~~~~~~~~~~~~~~
include/asm-generic/fixmap.h:32:2: note: in expansion of macro 'BUILD_BUG_ON'
BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
^~~~~~~~~~~~
In file included from include/linux/uaccess.h:11:0,
from include/linux/sched/task.h:11,
from include/linux/sched/signal.h:9,
from include/linux/rcuwait.h:6,
from include/linux/percpu-rwsem.h:7,
from include/linux/fs.h:34,
from include/linux/huge_mm.h:8,
from include/linux/mm.h:679,
from include/linux/bvec.h:13,
from include/linux/skbuff.h:17,
from net/ipv4/ip_tunnel_core.c:10:
arch/um/include/asm/uaccess.h: In function '__access_ok':
arch/um/include/asm/uaccess.h:17:29: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
(((unsigned long) (addr) >= FIXADDR_USER_START) &&                                 ^
arch/um/include/asm/uaccess.h:45:3: note: in expansion of macro '__access_ok_vsyscall'
__access_ok_vsyscall(addr, size) ||
^~~~~~~~~~~~~~~~~~~~
In file included from net/ipv4/ip_tunnel_core.c:38:0:
include/net/vxlan.h: In function 'vxlan_fdb_nh_path_select':
include/net/vxlan.h:496:8: error: implicit declaration of function 'nexthop_path_fdb_result' [-Werror=implicit-function-declaration]
nhc = nexthop_path_fdb_result(nh, hash);
^~~~~~~~~~~~~~~~~~~~~~~
>> include/net/vxlan.h:496:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
nhc = nexthop_path_fdb_result(nh, hash);
^
cc1: some warnings being treated as errors

vim +496 include/net/vxlan.h

   489	
   490	static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
   491						    int hash,
   492						    struct vxlan_rdst *rdst)
   493	{
   494		struct fib_nh_common *nhc;
   495	
 > 496		nhc = nexthop_path_fdb_result(nh, hash);
   497		if (unlikely(!nhc))
   498			return false;
   499	
   500		switch (nhc->nhc_gw_family) {
   501		case AF_INET:
   502			rdst->remote_ip.sin.sin_addr.s_addr = nhc->nhc_gw.ipv4;
   503			rdst->remote_ip.sa.sa_family = AF_INET;
   504			break;
   505		case AF_INET6:
   506			rdst->remote_ip.sin6.sin6_addr = nhc->nhc_gw.ipv6;
   507			rdst->remote_ip.sa.sa_family = AF_INET6;
   508			break;
   509		}
   510	
   511		return true;
   512	}
   513	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--k+w/mQv8wyuph6w0
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
pfR/pViFVG2DAAA=

--k+w/mQv8wyuph6w0--
