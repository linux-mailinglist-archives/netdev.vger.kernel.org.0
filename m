Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FF0107F24
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKWPxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 10:53:04 -0500
Received: from mga05.intel.com ([192.55.52.43]:10022 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfKWPxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Nov 2019 10:53:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Nov 2019 07:53:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,234,1571727600"; 
   d="scan'208";a="407890582"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 23 Nov 2019 07:53:01 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYXiW-000GCG-Tb; Sat, 23 Nov 2019 23:53:00 +0800
Date:   Sat, 23 Nov 2019 23:52:21 +0800
From:   kbuild test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [RFC PATCH] i40e: ____xdp_call_i40e_xdp_call_tramp can be static
Message-ID: <20191123155221.s32llr6jsoxtdmoc@4978f4969bb8>
References: <20191119160757.27714-4-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119160757.27714-4-bjorn.topel@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: cfbcb56c2871 ("i40e: start using xdp_call.h")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 i40e_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 59b530e4198f2..6771d77871152 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12518,7 +12518,7 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
-DEFINE_XDP_CALL(i40e_xdp_call);
+static DEFINE_XDP_CALL(i40e_xdp_call);
 
 /**
  * i40e_xdp_setup - add/remove an XDP program
