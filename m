Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072B9F9D91
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKLW6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:58:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:24827 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbfKLW6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 17:58:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 14:58:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,298,1569308400"; 
   d="scan'208";a="194480400"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 12 Nov 2019 14:58:32 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iUf7I-000FVS-7j; Wed, 13 Nov 2019 06:58:32 +0800
Date:   Wed, 13 Nov 2019 06:57:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     kbuild-all@lists.01.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Message-ID: <201911130628.42ziSpjh%lkp@intel.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111042715.13444-1-Po.Liu@nxp.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on v5.4-rc7 next-20191111]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Po-Liu/enetc-Configure-the-Time-Aware-Scheduler-via-tc-taprio-offload/20191112-193235
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git ca22d6977b9b4ab0fd2e7909b57e32ba5b95046f
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-29-g781bc5d-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/freescale/enetc/enetc.c:1430:5: sparse: sparse: symbol 'enetc_setup_tc_mqprio' was not declared. Should it be static?
--
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:66:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] btl @@    got restrunsigned int [usertype] btl @@
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:66:31: sparse:    expected unsigned int [usertype] btl
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:66:31: sparse:    got restricted __le32 [usertype]
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:68:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] bth @@    got restrunsigned int [usertype] bth @@
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:68:31: sparse:    expected unsigned int [usertype] bth
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:68:31: sparse:    got restricted __le32 [usertype]
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:71:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] btl @@    got restrunsigned int [usertype] btl @@
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:71:31: sparse:    expected unsigned int [usertype] btl
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:71:31: sparse:    got restricted __le32 [usertype]
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:73:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] bth @@    got restrunsigned int [usertype] bth @@
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:73:31: sparse:    expected unsigned int [usertype] bth
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:73:31: sparse:    got restricted __le32 [usertype]
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:77:22: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] ct @@    got restrunsigned int [usertype] ct @@
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:77:22: sparse:    expected unsigned int [usertype] ct
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:77:22: sparse:    got restricted __le32 [usertype]
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:78:23: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] cte @@    got restrunsigned int [usertype] cte @@
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:78:23: sparse:    expected unsigned int [usertype] cte
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:78:23: sparse:    got restricted __le32 [usertype]
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:86:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned char [usertype] gate @@    got restunsigned char [usertype] gate @@
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:86:32: sparse:    expected unsigned char [usertype] gate
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:86:32: sparse:    got restricted __le32 [usertype]
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:87:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] period @@    got restrunsigned int [usertype] period @@
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:87:34: sparse:    expected unsigned int [usertype] period
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:87:34: sparse:    got restricted __le32 [usertype]
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:101:21: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 @@    got unsignerestricted __le32 @@
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:101:21: sparse:    expected restricted __le32
>> drivers/net/ethernet/freescale/enetc/enetc_qos.c:101:21: sparse:    got unsigned int [usertype]
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:102:21: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 @@    got unsignerestricted __le32 @@
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:102:21: sparse:    expected restricted __le32
   drivers/net/ethernet/freescale/enetc/enetc_qos.c:102:21: sparse:    got unsigned int [usertype]

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
