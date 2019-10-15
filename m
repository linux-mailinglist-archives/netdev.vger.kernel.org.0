Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9FD7186
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 10:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbfJOIsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 04:48:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:61669 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbfJOIsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 04:48:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 01:48:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="279124843"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 15 Oct 2019 01:48:50 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iKIVd-0005Wf-KZ; Tue, 15 Oct 2019 16:48:49 +0800
Date:   Tue, 15 Oct 2019 16:48:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at byte
 level
Message-ID: <201910151628.aXIOUKNY%lkp@intel.com>
References: <20191014221051.8084-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014221051.8084-4-pablo@netfilter.org>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[cannot apply to v5.4-rc3 next-20191014]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Pablo-Neira-Ayuso/flow_offload-update-mangle-action-representation/20191015-061232
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-43-g0ccb3b4-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   net/sched/cls_api.c:200:22: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] protocol @@    got icted __be16 [usertype] protocol @@
   net/sched/cls_api.c:200:22: sparse:    expected restricted __be16 [usertype] protocol
   net/sched/cls_api.c:200:22: sparse:    got unsigned int [usertype] protocol
   net/sched/cls_api.c:1587:16: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/sched/cls_api.c:1587:16: sparse:    struct tcf_proto *
   net/sched/cls_api.c:1587:16: sparse:    struct tcf_proto [noderef] <asn:4> *
   net/sched/cls_api.c:1680:20: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/sched/cls_api.c:1680:20: sparse:    struct tcf_proto [noderef] <asn:4> *
   net/sched/cls_api.c:1680:20: sparse:    struct tcf_proto *
   net/sched/cls_api.c:1643:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/sched/cls_api.c:1643:25: sparse:    struct tcf_proto [noderef] <asn:4> *
   net/sched/cls_api.c:1643:25: sparse:    struct tcf_proto *
   net/sched/cls_api.c:1662:16: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/sched/cls_api.c:1662:16: sparse:    struct tcf_proto *
   net/sched/cls_api.c:1662:16: sparse:    struct tcf_proto [noderef] <asn:4> *
   net/sched/cls_api.c:1727:25: sparse: sparse: restricted __be16 degrades to integer
   net/sched/cls_api.c:2372:50: sparse: sparse: restricted __be16 degrades to integer
>> net/sched/cls_api.c:3396:27: sparse: sparse: symbol 'tc_proto_udp_hdr' was not declared. Should it be static?
>> net/sched/cls_api.c:3499:27: sparse: sparse: cast to restricted __be32
>> net/sched/cls_api.c:3499:27: sparse: sparse: cast to restricted __be32
>> net/sched/cls_api.c:3499:27: sparse: sparse: cast to restricted __be32
>> net/sched/cls_api.c:3499:27: sparse: sparse: cast to restricted __be32
>> net/sched/cls_api.c:3499:27: sparse: sparse: cast to restricted __be32
>> net/sched/cls_api.c:3499:27: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3533:33: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3533:33: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3533:33: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3533:33: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3533:33: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3533:33: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3543:25: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3543:25: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3543:25: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3543:25: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3543:25: sparse: sparse: cast to restricted __be32
   net/sched/cls_api.c:3543:25: sparse: sparse: cast to restricted __be32

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
