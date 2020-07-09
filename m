Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102C5219E1E
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgGIKqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:46:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:46560 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgGIKqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 06:46:05 -0400
IronPort-SDR: ahtnCVKxnfHMTqMeOjp57WxzTGILVFl8chdMNz/eFGXNwwYvaRCFg6vXUfMUj9/1f4UH3Mvgg+
 NaieXzmwA7Cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="146057726"
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="gz'50?scan'50,208,50";a="146057726"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 03:20:03 -0700
IronPort-SDR: nDV9N651BYPdaRtpfap4p4Cycmq/so4Li159B7DvMdqu8f3FV+rdaqQriw0OA/4TukmmMC7L0s
 De1s6thFuziA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="gz'50?scan'50,208,50";a="323202652"
Received: from lkp-server01.sh.intel.com (HELO 6136dd46483e) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jul 2020 03:20:01 -0700
Received: from kbuild by 6136dd46483e with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jtTer-0000Yl-3W; Thu, 09 Jul 2020 10:20:01 +0000
Date:   Thu, 9 Jul 2020 18:19:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
Message-ID: <202007091828.KTlaLIvZ%lkp@intel.com>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Xiangning",

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/YU-Xiangning/Lockless-Token-Bucket-LTB-Qdisc/20200709-004116
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8cb601f15886f6d05479e46913d954e9ff237312
config: parisc-randconfig-s032-20200709 (attached as .config)
compiler: hppa-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.2-37-gc9676a3b-dirty
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=parisc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/sched/sch_ltb.c:231:35: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
>> net/sched/sch_ltb.c:231:35: sparse:     expected void const [noderef] __percpu *__vpp_verify
>> net/sched/sch_ltb.c:231:35: sparse:     got struct ltb_pcpu_data *
   net/sched/sch_ltb.c:327:35: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:327:35: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:327:35: sparse:     got struct ltb_pcpu_data *
>> net/sched/sch_ltb.c:704:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
>> net/sched/sch_ltb.c:704:17: sparse:    struct ltb_class [noderef] __rcu *
>> net/sched/sch_ltb.c:704:17: sparse:    struct ltb_class *
   net/sched/sch_ltb.c:752:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/sched/sch_ltb.c:752:17: sparse:    struct ltb_class [noderef] __rcu *
   net/sched/sch_ltb.c:752:17: sparse:    struct ltb_class *
   net/sched/sch_ltb.c:988:16: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/sched/sch_ltb.c:988:16: sparse:    struct ltb_class [noderef] __rcu *
   net/sched/sch_ltb.c:988:16: sparse:    struct ltb_class *
   net/sched/sch_ltb.c:1000:16: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:1000:16: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:1000:16: sparse:     got struct ltb_pcpu_data *
   net/sched/sch_ltb.c:1029:16: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:1029:16: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:1029:16: sparse:     got struct ltb_pcpu_data *
   net/sched/sch_ltb.c:1047:29: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:1047:29: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:1047:29: sparse:     got struct ltb_pcpu_data *
   net/sched/sch_ltb.c:1072:27: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:1072:27: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:1072:27: sparse:     got struct ltb_pcpu_data *
>> net/sched/sch_ltb.c:1080:24: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void [noderef] __percpu *__pdata @@     got struct ltb_pcpu_data *pcpu_data @@
>> net/sched/sch_ltb.c:1080:24: sparse:     expected void [noderef] __percpu *__pdata
>> net/sched/sch_ltb.c:1080:24: sparse:     got struct ltb_pcpu_data *pcpu_data
>> net/sched/sch_ltb.c:1122:24: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct ltb_pcpu_data *pcpu_data @@     got struct ltb_pcpu_data [noderef] __percpu * @@
>> net/sched/sch_ltb.c:1122:24: sparse:     expected struct ltb_pcpu_data *pcpu_data
>> net/sched/sch_ltb.c:1122:24: sparse:     got struct ltb_pcpu_data [noderef] __percpu *
   net/sched/sch_ltb.c:1141:17: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:1141:17: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:1141:17: sparse:     got struct ltb_pcpu_data *
   net/sched/sch_ltb.c:1142:17: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:1142:17: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:1142:17: sparse:     got struct ltb_pcpu_data *
   net/sched/sch_ltb.c:1168:46: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ltb_pcpu_data * @@
   net/sched/sch_ltb.c:1168:46: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/sched/sch_ltb.c:1168:46: sparse:     got struct ltb_pcpu_data *
   net/sched/sch_ltb.c:1176:32: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void [noderef] __percpu *__pdata @@     got struct ltb_pcpu_data *pcpu_data @@
   net/sched/sch_ltb.c:1176:32: sparse:     expected void [noderef] __percpu *__pdata
   net/sched/sch_ltb.c:1176:32: sparse:     got struct ltb_pcpu_data *pcpu_data

vim +231 net/sched/sch_ltb.c

   181	
   182	static int ltb_drain(struct ltb_class *cl)
   183	{
   184		struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
   185		struct ltb_pcpu_sched *pcpu_q;
   186		bool need_watchdog = false;
   187		unsigned int npkts, bytes;
   188		unsigned long now = NOW();
   189		struct cpumask cpumask;
   190		struct sk_buff *skb;
   191		s64 timestamp;
   192		int cpu;
   193	
   194		npkts = 0;
   195		bytes = 0;
   196		cpumask_clear(&cpumask);
   197		while (kfifo_peek(&cl->drain_queue, &skb) > 0) {
   198			int len = qdisc_pkt_len(skb);
   199	
   200			if (cl->curr_interval != now) {
   201				cl->curr_interval = now;
   202				timestamp = ktime_get_ns();
   203				cl->bw_measured = (cl->stat_bytes - cl->last_bytes) *
   204					NSEC_PER_SEC / (timestamp - cl->last_timestamp);
   205				cl->last_bytes = cl->stat_bytes;
   206				cl->last_timestamp = timestamp;
   207				cl->bw_used = 0;
   208			} else if (len + cl->bw_used > cl->maxbw) {
   209				need_watchdog = true;
   210				break;
   211			}
   212			kfifo_skip(&cl->drain_queue);
   213			cl->bw_used += len;
   214	
   215			/* Fanout */
   216			cpu = ltb_skb_cb(skb)->cpu;
   217			ltb_skb_cb(skb)->cpu = 0;
   218			if (unlikely(kfifo_put(&cl->fanout_queues[cpu], skb) == 0)) {
   219				kfree_skb(skb);
   220				atomic64_inc(&cl->stat_drops);
   221			} else {
   222				/* Account for Generic Segmentation Offload(gso). */
   223				cl->stat_bytes += len;
   224				cl->stat_packets += skb_is_gso(skb) ?
   225				    skb_shinfo(skb)->gso_segs : 1;
   226				cpumask_set_cpu(cpu, &cpumask);
   227			}
   228		}
   229	
   230		for_each_cpu(cpu, &cpumask) {
 > 231			struct Qdisc *q = per_cpu_ptr(ltb->pcpu_data, cpu)->qdisc;
   232	
   233			pcpu_q = (struct ltb_pcpu_sched *)qdisc_priv(q);
   234			if (!(q->state & __QDISC_STATE_SCHED) && !qdisc_is_running(q))
   235				irq_work_queue_on(&pcpu_q->fanout_irq_work, cpu);
   236		}
   237	
   238		return need_watchdog;
   239	}
   240	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--RnlQjJ0d97Da+TV1
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
y9NdNNhRw/xcktBi7SX5HylHwtgrqQEA

--RnlQjJ0d97Da+TV1--
