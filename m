Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378EE40D3A5
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhIPHQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:16:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:6061 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhIPHQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 03:16:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10108"; a="244878061"
X-IronPort-AV: E=Sophos;i="5.85,297,1624345200"; 
   d="gz'50?scan'50,208,50";a="244878061"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 00:14:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,297,1624345200"; 
   d="gz'50?scan'50,208,50";a="471253420"
Received: from lkp-server01.sh.intel.com (HELO 285e7b116627) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 16 Sep 2021 00:14:50 -0700
Received: from kbuild by 285e7b116627 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mQlbd-0000qn-LC; Thu, 16 Sep 2021 07:14:49 +0000
Date:   Thu, 16 Sep 2021 15:14:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, liujian56@huawei.com
Subject: Re: [PATCH] skmsg: lose offset info in sk_psock_skb_ingress
Message-ID: <202109161534.AkP0zTMF-lkp@intel.com>
References: <20210915140629.18558-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20210915140629.18558-1-liujian56@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Liu,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.15-rc1 next-20210915]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Liu-Jian/skmsg-lose-offset-info-in-sk_psock_skb_ingress/20210915-220839
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 3ca706c189db861b2ca2019a0901b94050ca49d8
config: h8300-randconfig-r031-20210916 (attached as .config)
compiler: h8300-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/7736d12e30a2ff3579225cc593898ef1a24dc7aa
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Liu-Jian/skmsg-lose-offset-info-in-sk_psock_skb_ingress/20210915-220839
        git checkout 7736d12e30a2ff3579225cc593898ef1a24dc7aa
        # save the attached .config to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=h8300 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:11,
                    from include/linux/list.h:9,
                    from include/linux/timer.h:5,
                    from include/linux/workqueue.h:9,
                    from include/linux/bpf.h:9,
                    from include/linux/skmsg.h:7,
                    from net/core/skmsg.c:4:
   include/linux/scatterlist.h: In function 'sg_set_buf':
   include/asm-generic/page.h:89:51: warning: ordered comparison of pointer with null pointer [-Wextra]
      89 | #define virt_addr_valid(kaddr)  (((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
         |                                                   ^~
   include/linux/compiler.h:78:45: note: in definition of macro 'unlikely'
      78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   include/linux/scatterlist.h:143:9: note: in expansion of macro 'BUG_ON'
     143 |         BUG_ON(!virt_addr_valid(buf));
         |         ^~~~~~
   include/linux/scatterlist.h:143:17: note: in expansion of macro 'virt_addr_valid'
     143 |         BUG_ON(!virt_addr_valid(buf));
         |                 ^~~~~~~~~~~~~~~
   net/core/skmsg.c: In function 'sk_psock_verdict_apply':
>> net/core/skmsg.c:972:25: error: 'len' undeclared (first use in this function)
     972 |                         len = skb->len;
         |                         ^~~
   net/core/skmsg.c:972:25: note: each undeclared identifier is reported only once for each function it appears in
>> net/core/skmsg.c:973:25: error: 'off' undeclared (first use in this function)
     973 |                         off = 0;
         |                         ^~~
   net/core/skmsg.c: At top level:
   net/core/skmsg.c:12:13: warning: 'sk_psock_strp_data_ready' declared 'static' but never defined [-Wunused-function]
      12 | static void sk_psock_strp_data_ready(struct sock *sk);
         |             ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/len +972 net/core/skmsg.c

   953	
   954		switch (verdict) {
   955		case __SK_PASS:
   956			err = -EIO;
   957			sk_other = psock->sk;
   958			if (sock_flag(sk_other, SOCK_DEAD) ||
   959			    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
   960				goto out_free;
   961			}
   962	
   963			skb_bpf_set_ingress(skb);
   964	
   965			/* If the queue is empty then we can submit directly
   966			 * into the msg queue. If its not empty we have to
   967			 * queue work otherwise we may get OOO data. Otherwise,
   968			 * if sk_psock_skb_ingress errors will be handled by
   969			 * retrying later from workqueue.
   970			 */
   971			if (skb_queue_empty(&psock->ingress_skb)) {
 > 972				len = skb->len;
 > 973				off = 0;
   974	#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
   975				if (psock->sk->sk_data_ready == sk_psock_strp_data_ready) {
   976					stm = strp_msg(skb);
   977					off = stm->offset;
   978					len = stm->full_len;
   979				}
   980	#endif
   981				err = sk_psock_skb_ingress_self(psock, skb, off, len);
   982			}
   983			if (err < 0) {
   984				spin_lock_bh(&psock->ingress_lock);
   985				if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
   986					skb_queue_tail(&psock->ingress_skb, skb);
   987					schedule_work(&psock->work);
   988					err = 0;
   989				}
   990				spin_unlock_bh(&psock->ingress_lock);
   991				if (err < 0) {
   992					skb_bpf_redirect_clear(skb);
   993					goto out_free;
   994				}
   995			}
   996			break;
   997		case __SK_REDIRECT:
   998			err = sk_psock_skb_redirect(psock, skb);
   999			break;
  1000		case __SK_DROP:
  1001		default:
  1002	out_free:
  1003			sock_drop(psock->sk, skb);
  1004		}
  1005	
  1006		return err;
  1007	}
  1008	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--envbJBWh7q8WU6mo
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--envbJBWh7q8WU6mo--
