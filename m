Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852DC3A973C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhFPKaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:30:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:51827 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhFPKaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:30:15 -0400
IronPort-SDR: E1nnEEV3lZOagHW0ImhliQTNCxChizDULEtozxHkrUIRC9mytkVEQUYS6ece4k7kvefG59TX6b
 ytVEb9w+L0MA==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="267300221"
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="gz'50?scan'50,208,50";a="267300221"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 03:28:08 -0700
IronPort-SDR: YQJlfvcljbe/X903O4v9Mt/DpeSpUmulhofBDG+WBFNiAWKQWOqFmx6m1186kQEceINj0Tv9+7
 MVdtHZpux0QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="gz'50?scan'50,208,50";a="554764707"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jun 2021 03:28:05 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ltSmD-00016q-0u; Wed, 16 Jun 2021 10:28:05 +0000
Date:   Wed, 16 Jun 2021 18:27:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Yangbo Lu <yangbo.lu@nxp.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [net-next, v3, 07/10] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Message-ID: <202106161832.M1eW74T7-lkp@intel.com>
References: <20210615094517.48752-8-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20210615094517.48752-8-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Yangbo,

I love your patch! Yet something to improve:

[auto build test ERROR on 89212e160b81e778f829b89743570665810e3b13]

url:    https://github.com/0day-ci/linux/commits/Yangbo-Lu/ptp-support-virtual-clocks-and-timestamping/20210616-141518
base:   89212e160b81e778f829b89743570665810e3b13
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/f03864a45f4fe97414824545398c837eead55409
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Yangbo-Lu/ptp-support-virtual-clocks-and-timestamping/20210616-141518
        git checkout f03864a45f4fe97414824545398c837eead55409
        # save the attached .config to linux build tree
        make W=1 ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/mptcp/sockopt.c: In function 'mptcp_setsockopt_sol_socket_tstamp':
>> net/mptcp/sockopt.c:148:12: error: 'optval' redeclared as different kind of symbol
     148 |  sockptr_t optval = KERNEL_SOCKPTR(&val);
         |            ^~~~~~
   net/mptcp/sockopt.c:145:22: note: previous definition of 'optval' was here
     145 |            sockptr_t optval,
         |            ~~~~~~~~~~^~~~~~


vim +/optval +148 net/mptcp/sockopt.c

6f0d7198084c40 Florian Westphal 2021-04-15  142  
f03864a45f4fe9 Yangbo Lu        2021-06-15  143  static int mptcp_setsockopt_sol_socket_tstamp(struct mptcp_sock *msk,
f03864a45f4fe9 Yangbo Lu        2021-06-15  144  					      int optname, int val,
f03864a45f4fe9 Yangbo Lu        2021-06-15  145  					      sockptr_t optval,
f03864a45f4fe9 Yangbo Lu        2021-06-15  146  					      unsigned int optlen)
9061f24bf82ec2 Florian Westphal 2021-06-03  147  {
9061f24bf82ec2 Florian Westphal 2021-06-03 @148  	sockptr_t optval = KERNEL_SOCKPTR(&val);
9061f24bf82ec2 Florian Westphal 2021-06-03  149  	struct mptcp_subflow_context *subflow;
9061f24bf82ec2 Florian Westphal 2021-06-03  150  	struct sock *sk = (struct sock *)msk;
9061f24bf82ec2 Florian Westphal 2021-06-03  151  	int ret;
9061f24bf82ec2 Florian Westphal 2021-06-03  152  
9061f24bf82ec2 Florian Westphal 2021-06-03  153  	ret = sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
9061f24bf82ec2 Florian Westphal 2021-06-03  154  			      optval, sizeof(val));
9061f24bf82ec2 Florian Westphal 2021-06-03  155  	if (ret)
9061f24bf82ec2 Florian Westphal 2021-06-03  156  		return ret;
9061f24bf82ec2 Florian Westphal 2021-06-03  157  
9061f24bf82ec2 Florian Westphal 2021-06-03  158  	lock_sock(sk);
9061f24bf82ec2 Florian Westphal 2021-06-03  159  	mptcp_for_each_subflow(msk, subflow) {
9061f24bf82ec2 Florian Westphal 2021-06-03  160  		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
9061f24bf82ec2 Florian Westphal 2021-06-03  161  		bool slow = lock_sock_fast(ssk);
9061f24bf82ec2 Florian Westphal 2021-06-03  162  
9061f24bf82ec2 Florian Westphal 2021-06-03  163  		switch (optname) {
9061f24bf82ec2 Florian Westphal 2021-06-03  164  		case SO_TIMESTAMP_OLD:
9061f24bf82ec2 Florian Westphal 2021-06-03  165  		case SO_TIMESTAMP_NEW:
9061f24bf82ec2 Florian Westphal 2021-06-03  166  		case SO_TIMESTAMPNS_OLD:
9061f24bf82ec2 Florian Westphal 2021-06-03  167  		case SO_TIMESTAMPNS_NEW:
9061f24bf82ec2 Florian Westphal 2021-06-03  168  			sock_set_timestamp(sk, optname, !!val);
9061f24bf82ec2 Florian Westphal 2021-06-03  169  			break;
9061f24bf82ec2 Florian Westphal 2021-06-03  170  		case SO_TIMESTAMPING_NEW:
9061f24bf82ec2 Florian Westphal 2021-06-03  171  		case SO_TIMESTAMPING_OLD:
f03864a45f4fe9 Yangbo Lu        2021-06-15  172  			sock_set_timestamping(sk, optname, val, optval, optlen);
9061f24bf82ec2 Florian Westphal 2021-06-03  173  			break;
9061f24bf82ec2 Florian Westphal 2021-06-03  174  		}
9061f24bf82ec2 Florian Westphal 2021-06-03  175  
9061f24bf82ec2 Florian Westphal 2021-06-03  176  		unlock_sock_fast(ssk, slow);
9061f24bf82ec2 Florian Westphal 2021-06-03  177  	}
9061f24bf82ec2 Florian Westphal 2021-06-03  178  
9061f24bf82ec2 Florian Westphal 2021-06-03  179  	release_sock(sk);
9061f24bf82ec2 Florian Westphal 2021-06-03  180  	return 0;
9061f24bf82ec2 Florian Westphal 2021-06-03  181  }
9061f24bf82ec2 Florian Westphal 2021-06-03  182  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ikeVEW9yuYc//A+q
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--ikeVEW9yuYc//A+q--
