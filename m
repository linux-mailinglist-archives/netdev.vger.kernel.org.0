Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3013D1DC512
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 04:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgEUCQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 22:16:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:46200 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgEUCQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 22:16:19 -0400
IronPort-SDR: U4JsnvEqFgSP1YZ+ksDgqZ/JTPTlQhMBWnn63AYHAeo5Cvh1UZaK6tkSn/MgT/z0zDZxYhDETd
 W1Uq00y1Cgeg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 19:16:19 -0700
IronPort-SDR: 8n1tZKjilHE1yeeX+gYPj7JLVQvH/p0lrAyl+Sacbdqd2deTRV302QojjhSuVDzhcjOQvAVYb5
 xEZGSI0wo2ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,416,1583222400"; 
   d="scan'208";a="300146069"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2020 19:16:17 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jbakq-000FLT-T9; Thu, 21 May 2020 10:16:16 +0800
Date:   Thu, 21 May 2020 10:15:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC PATCH] net: atlantic: ptp_ring_idx() can be static
Message-ID: <20200521021528.GA70605@6bfd3b9cba2b>
References: <20200520134734.2014-4-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520134734.2014-4-irusskikh@marvell.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kbuild test robot <lkp@intel.com>
---
 aq_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 9aee49c50f1f8..599ced261b2a4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -948,7 +948,7 @@ void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
 /* Index must be 8 (8 TCs) or 16 (4 TCs).
  * It depends on Traffic Class mode.
  */
-unsigned int ptp_ring_idx(const enum aq_tc_mode tc_mode)
+static unsigned int ptp_ring_idx(const enum aq_tc_mode tc_mode)
 {
 	if (tc_mode == AQ_TC_MODE_8TCS)
 		return PTP_8TC_RING_IDX;
