Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B381497C94
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 11:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbiAXKA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 05:00:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:24597 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236893AbiAXKAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 05:00:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643018450; x=1674554450;
  h=from:to:cc:subject:date:message-id;
  bh=CEeh4xZDN8H9We8iBFhj6xkPm9szH5elbIbkobbgreE=;
  b=EbGlahLCXuusPcGd8IHECdo2WvwupsYUK1ieae/NCTbsFs1GQNjvKhf0
   6AfxD9AtavpbxSoy5momAq93qLtdCTZ6Y0iZh5eepu3jEKPvXSBljAk10
   mV/WYLDW13X1pkfUYkjkM2ER/S44xoTLBuuK3pP1GOGvKkitBYRGOr80R
   wBPpAcw7scIbPp/GXmReW5RYctQK3cQimu4GCqFuwHUTLu64NhOlTVeCN
   rfadK4KyL7fmL1psd14esGvOGI8j/3ymvMn2Q/3Ui9No067NzBahTxfJ6
   l7tCl2elH8EFb5DzqdZJwEuhL3p+2Jc7/QRAlt9kp4KvzXrYWkjHZB2u+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309331418"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309331418"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 02:00:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="519886910"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2022 02:00:36 -0800
From:   Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net 0/2] Fix PTP issue in stmmac
Date:   Mon, 24 Jan 2022 17:59:49 +0800
Message-Id: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series to fix PTP issue in stmmac related to:
1/ PTP clock source configuration during initialization.
2/ PTP initialization during resume from suspend.

Mohammad Athari Bin Ismail (2):
  net: stmmac: configure PTP clock source prior to PTP initialization
  net: stmmac: skip only stmmac_ptp_register when resume from suspend

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 ++++++++++---------
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  3 ---
 2 files changed, 12 insertions(+), 13 deletions(-)

-- 
2.17.1

