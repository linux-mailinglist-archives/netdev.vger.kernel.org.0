Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464FA196607
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 13:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgC1MPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 08:15:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:28516 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgC1MPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 08:15:39 -0400
IronPort-SDR: 9AXDKXDF1ivEPQZ6T2strQiuWb8YYEnHV1rtsFvt/mJczBsrMgQhhxvjFPqOZyCraOX/tq0QbT
 Ow319tDz3y9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2020 05:15:38 -0700
IronPort-SDR: 3tokL2ETUr6Wx66bgsXv10SOXsGVwXSP+zDYysIcBRTZ5pkQYmF2h5WRfDnB+/qSpmNli94kYz
 tg2mj/0O0l8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,316,1580803200"; 
   d="scan'208";a="449300479"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 28 Mar 2020 05:15:37 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jIANE-0002kU-JV; Sat, 28 Mar 2020 20:15:36 +0800
Date:   Sat, 28 Mar 2020 20:14:45 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Dmitry Bogdanov <dbogdanov@marvell.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [net-next:master 1995/2057]
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c:224:2-3: Unneeded
 semicolon
Message-ID: <202003282039.WXQ1A9KZ%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   1a147b74c2fd4058dea0133cb2471724c3b3de09
commit: 27736563ce320d3390c2423bc82c54b07f2a3d50 [1995/2057] net: atlantic: MACSec egress offload implementation

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/aquantia/atlantic/aq_macsec.c:224:2-3: Unneeded semicolon
   drivers/net/ethernet/aquantia/atlantic/aq_macsec.c:240:2-3: Unneeded semicolon

vim +224 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c

   207	
   208	static u32 aq_sc_idx_max(const enum aq_macsec_sc_sa sc_sa)
   209	{
   210		u32 result = 0;
   211	
   212		switch (sc_sa) {
   213		case aq_macsec_sa_sc_4sa_8sc:
   214			result = 8;
   215			break;
   216		case aq_macsec_sa_sc_2sa_16sc:
   217			result = 16;
   218			break;
   219		case aq_macsec_sa_sc_1sa_32sc:
   220			result = 32;
   221			break;
   222		default:
   223			break;
 > 224		};
   225	
   226		return result;
   227	}
   228	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
