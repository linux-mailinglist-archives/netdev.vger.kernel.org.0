Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B8524D71
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfEULBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:01:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:4115 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfEULBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 07:01:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 04:01:34 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 21 May 2019 04:01:33 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hT2WS-0009Mw-Ls; Tue, 21 May 2019 19:01:32 +0800
Date:   Tue, 21 May 2019 19:01:12 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net,
        nirranjan@chelsio.com, indranil@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH net-next] cxgb4: Enable hash filter with offload
Message-ID: <201905211845.3ECR6kq7%lkp@intel.com>
References: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vishal,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Vishal-Kulkarni/cxgb4-Enable-hash-filter-with-offload/20190521-171528
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:6216:14: sparse: sparse: symbol 't4_get_tp_e2c_map' was not declared. Should it be static?
   drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3838:9: sparse: sparse: context imbalance in 't4_load_phy_fw' - different lock contexts for basic block

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
