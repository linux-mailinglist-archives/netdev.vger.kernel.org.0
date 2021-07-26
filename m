Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7F43D517A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 05:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhGZC1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 22:27:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:18086 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhGZC1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 22:27:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10056"; a="211868952"
X-IronPort-AV: E=Sophos;i="5.84,269,1620716400"; 
   d="scan'208";a="211868952"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2021 20:07:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,269,1620716400"; 
   d="scan'208";a="504552717"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jul 2021 20:07:30 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9DADB58060A;
        Sun, 25 Jul 2021 20:07:27 -0700 (PDT)
Date:   Mon, 26 Jul 2021 11:07:24 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     mohammad.athari.ismail@intel.com
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: add est_irq_status callback function
 for GMAC 4.10 and 5.10
Message-ID: <20210726030724.GA9206@linux.intel.com>
References: <20210726022020.5907-1-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726022020.5907-1-mohammad.athari.ismail@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 10:20:20AM +0800, mohammad.athari.ismail@intel.com wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> Assign dwmac5_est_irq_status to est_irq_status callback function for
> GMAC 4.10 and 5.10. With this, EST related interrupts could be handled
> properly.
> 
> Fixes: e49aa315cb01 ("net: stmmac: EST interrupts handling and error reporting")
> Cc: <stable@vger.kernel.org> # 5.13.x
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

Acked-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

