Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D02E2503
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 23:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406247AbfJWVQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 17:16:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:46520 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406097AbfJWVQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 17:16:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 14:16:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,222,1569308400"; 
   d="scan'208";a="204069103"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Oct 2019 14:16:26 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iNNzW-0008Bq-5j; Thu, 24 Oct 2019 05:16:26 +0800
Date:   Thu, 24 Oct 2019 05:15:27 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     kbuild-all@lists.01.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH v3 net-next 11/12] net: aquantia: add support for PIN
 funcs
Message-ID: <201910240443.6k1OmpJd%lkp@intel.com>
References: <a2a6ecfb5580858c2a690fa0ed1c98cffc61c4b9.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2a6ecfb5580858c2a690fa0ed1c98cffc61c4b9.1571737612.git.igor.russkikh@aquantia.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Igor-Russkikh/net-aquantia-PTP-support-for-AQC-devices/20191023-194531
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 88652bf8ce4b91c49769a2a49c17dc44b85b4fa2
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/aquantia/atlantic/aq_ptp.c:950:34: sparse: sparse: Using plain integer as NULL pointer
>> drivers/net/ethernet/aquantia/atlantic/aq_ptp.c:1378:6: sparse: sparse: symbol 'aq_ptp_poll_sync_work_cb' was not declared. Should it be static?
--
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:795:45: sparse: sparse: cast to restricted __le16
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1155:5: sparse: sparse: symbol 'hw_atl_b0_ts_to_sys_clock' was not declared. Should it be static?
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1259:15: sparse: sparse: cast to restricted __be64
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1260:14: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1260:14: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1260:14: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1260:14: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1260:14: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1260:14: sparse: sparse: cast to restricted __be32

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
