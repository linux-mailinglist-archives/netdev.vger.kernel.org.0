Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A649C6CF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiAZJsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:48:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:4595 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232255AbiAZJsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:48:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643190494; x=1674726494;
  h=from:to:cc:subject:date:message-id;
  bh=JDgk8tdiajGeraEL32XBZT7Uhv8Nx78Co1o96ic4M6o=;
  b=fgp6mHeKFisG7b4zAnqSij4OeZmuHwKT5oZL/Iib26ZoyYFPY6KYvXWG
   4q0EmCnCv3fv7mAzZKbXbEX4uf4wVgJiEpJ7wim3vjr1OphbX68lEEEoz
   s4tGZnQMzFvdZ+aRAV0eCOMb4xZwVtsSr2nYOo5V4XPfPWh98+wtBRXbs
   6cF1yrw742tN6gPuCJwJKSTEhHNX0L3RNqHRwP5rbW7MQIQH2BTnmPVgi
   hORsO7N1+7raH7lAGOQQEDsyYVGRo6JdsHgJw8l3N3Z4TzzWHsyJpAopT
   HL3WVc8S1tjG+567XSDmiUaKuVcCM1G4Y2uo1uWoy540NPvYc+VuANtxe
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="230090777"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="230090777"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="617918575"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Jan 2022 01:48:08 -0800
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
Date:   Wed, 26 Jan 2022 17:47:21 +0800
Message-Id: <20220126094723.11849-1-mohammad.athari.ismail@intel.com>
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

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 ++++++++++---------
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  3 ---
 2 files changed, 12 insertions(+), 14 deletions(-)

-- 
2.17.1

