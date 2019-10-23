Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B191E2366
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389134AbfJWTpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:45:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:31501 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbfJWTpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:45:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 12:45:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,222,1569308400"; 
   d="scan'208";a="197513146"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 12:45:01 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iNMZ2-000CAG-SD; Thu, 24 Oct 2019 03:45:00 +0800
Date:   Thu, 24 Oct 2019 03:44:41 +0800
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
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v3 net-next 06/12] net: aquantia: implement data PTP
 datapath
Message-ID: <201910240348.7QggoVlk%lkp@intel.com>
References: <13c973abf7a0573fbe8e98d48ab07f7d62d05cb5.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13c973abf7a0573fbe8e98d48ab07f7d62d05cb5.1571737612.git.igor.russkikh@aquantia.com>
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

   drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:794:45: sparse: sparse: cast to restricted __le16
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1201:15: sparse: sparse: cast to restricted __be64
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1202:14: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1202:14: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1202:14: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1202:14: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1202:14: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1202:14: sparse: sparse: cast to restricted __be32

vim +1201 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c

  1175	
  1176	static u16 hw_atl_b0_rx_extract_ts(struct aq_hw_s *self, u8 *p,
  1177					   unsigned int len, u64 *timestamp)
  1178	{
  1179		unsigned int offset = 14;
  1180		struct ethhdr *eth;
  1181		u64 sec;
  1182		u8 *ptr;
  1183		u32 ns;
  1184	
  1185		if (len <= offset || !timestamp)
  1186			return 0;
  1187	
  1188		/* The TIMESTAMP in the end of package has following format:
  1189		 * (big-endian)
  1190		 *   struct {
  1191		 *     uint64_t sec;
  1192		 *     uint32_t ns;
  1193		 *     uint16_t stream_id;
  1194		 *   };
  1195		 */
  1196		ptr = p + (len - offset);
  1197		memcpy(&sec, ptr, sizeof(sec));
  1198		ptr += sizeof(sec);
  1199		memcpy(&ns, ptr, sizeof(ns));
  1200	
> 1201		sec = be64_to_cpu(sec) & 0xffffffffffffllu;
> 1202		ns = be32_to_cpu(ns);
  1203		*timestamp = sec * NSEC_PER_SEC + ns + self->ptp_clk_offset;
  1204	
  1205		eth = (struct ethhdr *)p;
  1206	
  1207		return (eth->h_proto == htons(ETH_P_1588)) ? 12 : 14;
  1208	}
  1209	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
