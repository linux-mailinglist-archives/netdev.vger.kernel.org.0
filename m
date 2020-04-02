Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234F619B9DD
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 03:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733073AbgDBBZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 21:25:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:31748 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732462AbgDBBZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 21:25:28 -0400
IronPort-SDR: QuqhelsQuH5fwFELLouh4IRN7jz+xQIZ0iP4Iyq/l7c6hqJ4B9vtmR37SIXinIANhCngH/TeDl
 3ftNRiYFz8NQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 18:25:27 -0700
IronPort-SDR: fcqIVQPy5UeHtICWvGYTA+C8nxeVI1rHWIvruPrV5PSuWQxgJYKydUuRIdYL37u4v2yZ90KQ/t
 E3S3qzZZc1eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,333,1580803200"; 
   d="scan'208";a="249657460"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.3])
  by orsmga003.jf.intel.com with ESMTP; 01 Apr 2020 18:25:23 -0700
Date:   Thu, 2 Apr 2020 09:25:03 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kbuild-all@lists.01.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, murali.policharla@broadcom.com,
        stephen@networkplumber.org, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, nikolay@cumulusnetworks.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 4/8] net: dsa: implement auto-normalization
 of MTU for bridge hardware datapath
Message-ID: <20200402012503.GF8179@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200326224040.32014-5-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on linus/master v5.6-rc7 next-20200327]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Configure-the-MTU-on-DSA-switches/20200327-094801
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 92b7e62e5630a370955a4760bbeb3967457034ec
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-187-gbff9b106-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
:::::: branch date: 17 hours ago
:::::: commit date: 17 hours ago

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

   net/dsa/slave.c:506:13: sparse: sparse: incorrect type in initializer (different address spaces) @@    expected void const [noderef] <asn:3> *__vpp_verify @@    got const [noderef] <asn:3> *__vpp_verify @@
   net/dsa/slave.c:506:13: sparse:    expected void const [noderef] <asn:3> *__vpp_verify
   net/dsa/slave.c:506:13: sparse:    got struct pcpu_sw_netstats *
   net/dsa/slave.c:640:21: sparse: sparse: incorrect type in initializer (different address spaces) @@    expected void const [noderef] <asn:3> *__vpp_verify @@    got const [noderef] <asn:3> *__vpp_verify @@
   net/dsa/slave.c:640:21: sparse:    expected void const [noderef] <asn:3> *__vpp_verify
   net/dsa/slave.c:640:21: sparse:    got struct pcpu_sw_netstats *
   net/dsa/slave.c:1106:21: sparse: sparse: incorrect type in initializer (different address spaces) @@    expected void const [noderef] <asn:3> *__vpp_verify @@    got const [noderef] <asn:3> *__vpp_verify @@
   net/dsa/slave.c:1106:21: sparse:    expected void const [noderef] <asn:3> *__vpp_verify
   net/dsa/slave.c:1106:21: sparse:    got struct pcpu_sw_netstats *
>> net/dsa/slave.c:1264:6: sparse: sparse: symbol 'dsa_bridge_mtu_normalization' was not declared. Should it be static?
   net/dsa/slave.c:1682:20: sparse: sparse: incorrect type in assignment (different address spaces) @@    expected struct pcpu_sw_netstats *stats64 @@    got struct pcpu_sw_netstruct pcpu_sw_netstats *stats64 @@
   net/dsa/slave.c:1682:20: sparse:    expected struct pcpu_sw_netstats *stats64
   net/dsa/slave.c:1682:20: sparse:    got struct pcpu_sw_netstats [noderef] <asn:3> *pcpu_stats
   net/dsa/slave.c:1726:22: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:3> *__pdata @@    got svoid [noderef] <asn:3> *__pdata @@
   net/dsa/slave.c:1726:22: sparse:    expected void [noderef] <asn:3> *__pdata
   net/dsa/slave.c:1726:22: sparse:    got struct pcpu_sw_netstats *stats64
   net/dsa/slave.c:1745:22: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:3> *__pdata @@    got svoid [noderef] <asn:3> *__pdata @@
   net/dsa/slave.c:1745:22: sparse:    expected void [noderef] <asn:3> *__pdata
   net/dsa/slave.c:1745:22: sparse:    got struct pcpu_sw_netstats *stats64

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
