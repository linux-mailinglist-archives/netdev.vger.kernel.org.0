Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4776F332070
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCIIXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:23:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:64901 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhCIIXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 03:23:01 -0500
IronPort-SDR: X4Vu/po1/AfJV6teSOccyfk741VvbsMMcA36lQYBsQ5qd1tIpcFPKZyyiQS+/MuzNYoRWIAdA1
 Kn/OnME8IeLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184824938"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="gz'50?scan'50,208,50";a="184824938"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 00:23:00 -0800
IronPort-SDR: EKBk8D64zvFIGy3hb6uwgMFe5Q8myCGxWnHYEGCrmoHqe3Hb3SHhIxQHmlVA1kshAOJeglmrZW
 2mSgj7CLPk/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="gz'50?scan'50,208,50";a="369706126"
Received: from lkp-server01.sh.intel.com (HELO 3e992a48ca98) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 09 Mar 2021 00:22:56 -0800
Received: from kbuild by 3e992a48ca98 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lJXdo-0001Tf-7R; Tue, 09 Mar 2021 08:22:56 +0000
Date:   Tue, 9 Mar 2021 16:22:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast
 support
Message-ID: <202103091607.YXhmDMeL-lkp@intel.com>
References: <20210309072948.2127710-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20210309072948.2127710-3-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hangbin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Hangbin-Liu/xdp-extend-xdp_redirect_map-with-broadcast-support/20210309-153218
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: s390-randconfig-s031-20210309 (attached as .config)
compiler: s390-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.3-262-g5e674421-dirty
        # https://github.com/0day-ci/linux/commit/d0e1734db001fb56c1428e92145c7f3a001402f3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Hangbin-Liu/xdp-extend-xdp_redirect_map-with-broadcast-support/20210309-153218
        git checkout d0e1734db001fb56c1428e92145c7f3a001402f3
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/filter.c: In function '__bpf_tx_xdp_map':
>> net/core/filter.c:3928:15: error: 'BPF_F_REDIR_BROADCAST' undeclared (first use in this function); did you mean 'BPF_F_BROADCAST'?
    3928 |   if (flags & BPF_F_REDIR_BROADCAST)
         |               ^~~~~~~~~~~~~~~~~~~~~
         |               BPF_F_BROADCAST
   net/core/filter.c:3928:15: note: each undeclared identifier is reported only once for each function it appears in
>> net/core/filter.c:3930:20: error: 'BPF_F_REDIR_EXCLUDE_INGRESS' undeclared (first use in this function); did you mean 'BPF_F_EXCLUDE_INGRESS'?
    3930 |            flags & BPF_F_REDIR_EXCLUDE_INGRESS);
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                    BPF_F_EXCLUDE_INGRESS
   net/core/filter.c: In function 'xdp_do_generic_redirect_map':
   net/core/filter.c:4090:19: error: 'BPF_F_REDIR_BROADCAST' undeclared (first use in this function); did you mean 'BPF_F_BROADCAST'?
    4090 |   if (ri->flags & BPF_F_REDIR_BROADCAST)
         |                   ^~~~~~~~~~~~~~~~~~~~~
         |                   BPF_F_BROADCAST
   net/core/filter.c:4092:24: error: 'BPF_F_REDIR_EXCLUDE_INGRESS' undeclared (first use in this function); did you mean 'BPF_F_EXCLUDE_INGRESS'?
    4092 |            ri->flags & BPF_F_REDIR_EXCLUDE_INGRESS);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                        BPF_F_EXCLUDE_INGRESS
   net/core/filter.c: In function '____bpf_xdp_redirect_map':
   net/core/filter.c:4182:44: error: 'BPF_F_REDIR_BROADCAST' undeclared (first use in this function); did you mean 'BPF_F_BROADCAST'?
    4182 |  if (unlikely(!ri->tgt_value) && !(flags & BPF_F_REDIR_BROADCAST)) {
         |                                            ^~~~~~~~~~~~~~~~~~~~~
         |                                            BPF_F_BROADCAST


vim +3928 net/core/filter.c

  3920	
  3921	static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
  3922				    struct bpf_map *map, struct xdp_buff *xdp,
  3923				    u32 flags)
  3924	{
  3925		switch (map->map_type) {
  3926		case BPF_MAP_TYPE_DEVMAP:
  3927		case BPF_MAP_TYPE_DEVMAP_HASH:
> 3928			if (flags & BPF_F_REDIR_BROADCAST)
  3929				return dev_map_enqueue_multi(xdp, dev_rx, map,
> 3930							     flags & BPF_F_REDIR_EXCLUDE_INGRESS);
  3931			else
  3932				return dev_map_enqueue(fwd, xdp, dev_rx);
  3933		case BPF_MAP_TYPE_CPUMAP:
  3934			return cpu_map_enqueue(fwd, xdp, dev_rx);
  3935		case BPF_MAP_TYPE_XSKMAP:
  3936			return __xsk_map_redirect(fwd, xdp);
  3937		default:
  3938			return -EBADRQC;
  3939		}
  3940		return 0;
  3941	}
  3942	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ZGiS0Q5IWpPtfppv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
tKf9qQaPbYVjR7jS0+SEwcpTwf8Bgh9KZRfaAAA=

--ZGiS0Q5IWpPtfppv--
