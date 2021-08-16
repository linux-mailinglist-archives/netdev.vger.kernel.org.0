Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A2E3ED25A
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhHPKvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:51:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:46497 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230250AbhHPKvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:51:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="195422586"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="195422586"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 03:50:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="530423882"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 16 Aug 2021 03:50:43 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 571FE5808DB;
        Mon, 16 Aug 2021 03:50:40 -0700 (PDT)
Date:   Mon, 16 Aug 2021 18:50:37 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, vee.khee.wong@intel.com,
        weifeng.voon@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/3] net: stmmac: add ethtool per-queue
 statistic framework
Message-ID: <20210816105037.GA11930@linux.intel.com>
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
 <b0fd3bf4e5c105e959df60d3c876297721b62ee6.1629092894.git.vijayakannan.ayyathurai@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0fd3bf4e5c105e959df60d3c876297721b62ee6.1629092894.git.vijayakannan.ayyathurai@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 02:15:59PM +0800, Vijayakannan Ayyathurai wrote:
> Adding generic ethtool per-queue statistic framework to display the
> statistics for each rx/tx queue. In future, users can avail it to add
> more per-queue specific counters. Number of rx/tx queues displayed is
> depending on the available rx/tx queues in that particular MAC config
> and this number is limited up to the MTL_MAX_{RX|TX}_QUEUES defined
> in the driver.
> 
> Ethtool per-queue statistic display will look like below, when users
> start adding more counters.
> 
> Example:
>  q0_tx_statA:
>  q0_tx_statB:
>  q0_tx_statC:
>  |
>  q0_tx_statX:
>  .
>  .
>  .
>  qMAX_tx_statA:
>  qMAX_tx_statB:
>  qMAX_tx_statC:
>  |
>  qMAX_tx_statX:
> 
>  q0_rx_statA:
>  q0_rx_statB:
>  q0_rx_statC:
>  |
>  q0_rx_statX:
>  .
>  .
>  .
>  qMAX_rx_statA:
>  qMAX_rx_statB:
>  qMAX_rx_statC:
>  |
>  qMAX_rx_statX:
> 
> In addition, this patch has the support on displaying the number of
> packets received and transmitted per queue.
>

Acked-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

> Signed-off-by: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
> ---
