Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6561F49ADAE
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384741AbiAYHfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:35:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:19550 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384456AbiAYDdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 22:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643081587; x=1674617587;
  h=from:to:cc:subject:date:message-id;
  bh=BqpKz/iORHV93aKuPrxht0whdEK91qzqUrqhI+YPHgI=;
  b=f2EFNr9Vhafi+DDlNZ6PZtvg0wgqL0/0d4P13m6lR8d0wICl+yTmcDqu
   IWWOfv8T8olEPPMMPe/3b/o34S/3B/sERKHGagRYpQoegVjYLsHVtQDkV
   rkTCWRyJMsW/E8xuJAviGpX1PJZzKvMr+HRCGOMiQ/s8GLd7WZiDHodY9
   pWcbOd6jkIqeMjDu3g4Bc7snLoCXYtidzuZqakLSMTsmb0MWNuVndwk/R
   lljAXirZht7XUPUFkvDRlmg8mkygy2VbAtm4ST95lzZrT/eGirb8QTH0x
   O5TkfRKrH8VFH7gY69KCQv/4W1jJyFv+Ka2k7QMqrqtPxpigX0g+VTcMY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="332562382"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="332562382"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 19:24:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="532293049"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jan 2022 19:24:09 -0800
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
        Huacai Chen <chenhuacai@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mohammad.athari.ismail@intel.com
Subject: [PATCH net 0/2] Fix PTP issue in stmmac
Date:   Tue, 25 Jan 2022 11:23:22 +0800
Message-Id: <20220125032324.4055-1-mohammad.athari.ismail@intel.com>
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

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 25 +++++++++++--------
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  3 ---
 2 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.17.1

