Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F45149EE7
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 07:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgA0GBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 01:01:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:13409 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgA0GBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 01:01:45 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 22:01:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,368,1574150400"; 
   d="scan'208";a="228872828"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2020 22:01:17 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ivxSW-0005Zm-TY; Mon, 27 Jan 2020 14:01:16 +0800
Date:   Mon, 27 Jan 2020 14:00:18 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     kbuild-all@lists.01.org, michal.kalderon@marvell.com,
        ariel.elior@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 net-next 11/13] qed: Debug feature: ilt and mdump
Message-ID: <202001271349.Dc4ppCRx%lkp@intel.com>
References: <20200123105836.15090-12-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123105836.15090-12-michal.kalderon@marvell.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on linus/master v5.5 next-20200121]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Michal-Kalderon/qed-Utilize-FW-8-42-2-0/20200125-055253
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9bbc8be29d66cc34b650510f2c67b5c55235fe5d
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-153-g47b6dfef-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/qlogic/qed/qed_debug.c:1916:29: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1916:58: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1918:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1918:22: sparse:    expected unsigned int [assigned] [usertype] addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1918:22: sparse:    got restricted __le32 [addressable] [usertype] grc_addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1920:33: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:2049:65: sparse: sparse: incorrect type in argument 4 (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:2049:65: sparse:    expected unsigned int [usertype] param_val
   drivers/net/ethernet/qlogic/qed/qed_debug.c:2049:65: sparse:    got restricted __le32 [addressable] [usertype] timestamp
   drivers/net/ethernet/qlogic/qed/qed_debug.c:5088:25: sparse: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:5920:17: sparse: sparse: symbol 'qed_dbg_ilt_get_dump_buf_size' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:5936:17: sparse: sparse: symbol 'qed_dbg_ilt_dump' was not declared. Should it be static?
   drivers/net/ethernet/qlogic/qed/qed_debug.c:8404:46: sparse: sparse: incorrect type in assignment (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:8404:46: sparse:    expected unsigned int [usertype]
   drivers/net/ethernet/qlogic/qed/qed_debug.c:8404:46: sparse:    got restricted __be32 [assigned] [usertype] val

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
