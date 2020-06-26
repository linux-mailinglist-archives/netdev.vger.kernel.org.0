Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BE720AA77
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 04:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgFZChA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 22:37:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:49720 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgFZCg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 22:36:59 -0400
IronPort-SDR: h/FXcAQNzGw7sz0WLb+mDAvk/KdGV2c3P2B8nD+LkNRW8vbuG26PnzqqJoSWhOhkeHbjLDQVPt
 eSWsgHq+dO1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="125385889"
X-IronPort-AV: E=Sophos;i="5.75,281,1589266800"; 
   d="gz'50?scan'50,208,50";a="125385889"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 19:30:56 -0700
IronPort-SDR: 3QcxE2JgHnAEnUPR/h5tYP24ebqZAwk2j4as0s2wK0PWtxKDzIuIHRDLN+sO8bLKNohn01hYKs
 JpQM5h0xKnwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,281,1589266800"; 
   d="gz'50?scan'50,208,50";a="276227772"
Received: from lkp-server01.sh.intel.com (HELO 538b5e3c8319) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 25 Jun 2020 19:30:54 -0700
Received: from kbuild by 538b5e3c8319 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1joe8j-0001xu-Qp; Fri, 26 Jun 2020 02:30:53 +0000
Date:   Fri, 26 Jun 2020 10:30:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
Message-ID: <202006261048.OjhBU8FX%lkp@intel.com>
References: <20200626000929.217930-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20200626000929.217930-1-sdf@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stanislav,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf/master]
[also build test ERROR on net/master net-next/master v5.8-rc2 next-20200625]
[cannot apply to bpf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use  as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Stanislav-Fomichev/bpf-add-BPF_CGROUP_INET_SOCK_RELEASE-hook/20200626-081210
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
config: nds32-defconfig (attached as .config)
compiler: nds32le-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=nds32 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from ./arch/nds32/include/generated/asm/bug.h:1,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:12,
                    from include/linux/uio.h:9,
                    from include/linux/socket.h:8,
                    from net/ipv4/af_inet.c:69:
   include/linux/dma-mapping.h: In function 'dma_map_resource':
   arch/nds32/include/asm/memory.h:82:32: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
      82 | #define pfn_valid(pfn)  ((pfn) >= PHYS_PFN_OFFSET && (pfn) < (PHYS_PFN_OFFSET + max_mapnr))
         |                                ^~
   include/asm-generic/bug.h:144:27: note: in definition of macro 'WARN_ON_ONCE'
     144 |  int __ret_warn_once = !!(condition);   \
         |                           ^~~~~~~~~
   include/linux/dma-mapping.h:352:19: note: in expansion of macro 'pfn_valid'
     352 |  if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
         |                   ^~~~~~~~~
   net/ipv4/af_inet.c: In function 'inet_release':
>> net/ipv4/af_inet.c:415:4: error: implicit declaration of function 'BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE'; did you mean 'BPF_CGROUP_RUN_PROG_INET_SOCK'? [-Werror=implicit-function-declaration]
     415 |    BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk);
         |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |    BPF_CGROUP_RUN_PROG_INET_SOCK
   cc1: some warnings being treated as errors

vim +415 net/ipv4/af_inet.c

   400	
   401	
   402	/*
   403	 *	The peer socket should always be NULL (or else). When we call this
   404	 *	function we are destroying the object and from then on nobody
   405	 *	should refer to it.
   406	 */
   407	int inet_release(struct socket *sock)
   408	{
   409		struct sock *sk = sock->sk;
   410	
   411		if (sk) {
   412			long timeout;
   413	
   414			if (!sk->sk_kern_sock)
 > 415				BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk);
   416	
   417			/* Applications forget to leave groups before exiting */
   418			ip_mc_drop_socket(sk);
   419	
   420			/* If linger is set, we don't return until the close
   421			 * is complete.  Otherwise we return immediately. The
   422			 * actually closing is done the same either way.
   423			 *
   424			 * If the close is due to the process exiting, we never
   425			 * linger..
   426			 */
   427			timeout = 0;
   428			if (sock_flag(sk, SOCK_LINGER) &&
   429			    !(current->flags & PF_EXITING))
   430				timeout = sk->sk_lingertime;
   431			sk->sk_prot->close(sk, timeout);
   432			sock->sk = NULL;
   433		}
   434		return 0;
   435	}
   436	EXPORT_SYMBOL(inet_release);
   437	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--vkogqOf2sHV7VnPd
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--vkogqOf2sHV7VnPd--
