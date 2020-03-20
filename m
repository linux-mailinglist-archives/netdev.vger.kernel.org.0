Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3D118D4D3
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgCTQsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:48:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:37380 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgCTQsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 12:48:30 -0400
IronPort-SDR: mB3BmLr0gEiLfbpT8BfLyvShrJKimjq06CqpwRBDEjFL94z5QxbDUhF5J4hHxE5eAZR81PUM41
 O4x9M1JNnWKA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 09:48:29 -0700
IronPort-SDR: z9boVLIcpzv8r02bL/Lm/UIhDgXaPYRwjJ9mAow0Fa8/8iiF/cv/9rhbAAXOYK9fgaP6e7U5rm
 /wDE7wM2pMkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="239275155"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2020 09:48:26 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [net-next,v1, 0/3] Add additional EHL PCI info and PCI ID
Date:   Sat, 21 Mar 2020 00:48:22 +0800
Message-Id: <20200320164825.14200-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel EHL consist of 3 identical MAC. 2 are located in the Intel(R)
Programmable Services Engine (Intel(R) PSE) and 1 is located in the
platform Controller Hub (PCH). Each MAC consist of 3 PCI IDs which are
differentiated by MII and speed.

Voon Weifeng (3):
  net: stmmac: add EHL PSE0 & PSE1 1Gbps PCI info and PCI ID
  net: stmmac: add EHL PSE0 & PSE1 2.5Gbps PCI info and PCI ID
  net: stmmac: add EHL SGMII 2.5Gbps PCI info and PCI ID

 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  | 92 +++++++++++++++++--
 1 file changed, 86 insertions(+), 6 deletions(-)

-- 
2.17.1

