Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3DC367B8F
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhDVH4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:56:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:8505 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhDVH4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 03:56:12 -0400
IronPort-SDR: 0aFG2SN2QrB3so2CtiAIhCWI1/fB3HBdhmoThuqMOFlFjP1TObkuZQgi3RHjLw6E4vkIyX3W5s
 ud12VzmNBVHg==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="195956882"
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="195956882"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 00:55:22 -0700
IronPort-SDR: NzzDXLHqu2L9ny8xkAuI5KpJ53WmVuRRYa4TXBeg0VGbwjgtGyJ9SCmJPHoPY87pGnjicHzuzi
 WL7/NlHup3mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="421282361"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 00:55:17 -0700
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Chuah@vger.kernel.org, Kim Tatt <kim.tatt.chuah@intel.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net-next 0/2] Enable DWMAC HW descriptor prefetch
Date:   Thu, 22 Apr 2021 15:54:59 +0800
Message-Id: <20210422075501.20207-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

This patch series to add setting for HW descriptor prefetch for DWMAC version 5.20 onwards. For Intel platform, enable the capability by default.

Mohammad Athari Bin Ismail (2):
  net: stmmac: Add HW descriptor prefetch setting for DWMAC Core 5.20
    onwards
  stmmac: intel: Enable HW descriptor prefetch by default

 drivers/net/ethernet/stmicro/stmmac/common.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 10 ++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  5 +++++
 include/linux/stmmac.h                            |  1 +
 6 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.17.1

