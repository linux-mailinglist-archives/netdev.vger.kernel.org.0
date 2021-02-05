Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A90310219
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhBEBJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:09:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:30707 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhBEBJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 20:09:30 -0500
IronPort-SDR: UlNY7Xq9Ryi8uj4H2WO0xTzHYU0k4maPRvuAwX/ZN9fRMhD+jUg6p+SIAlES9b/EeOkLz1rXDQ
 CTU8PASWGVHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181505413"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="181505413"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 17:08:49 -0800
IronPort-SDR: rSfRk5qnf8S7RAXfEShK9dRTrJv8e2F2Uvfi8eVy379xAp/EEV6qVAXAJ39lCYB+uOohpQ5kLa
 1y52B6iOCZvg==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393623628"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.188.246])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 17:08:49 -0800
Date:   Thu, 4 Feb 2021 17:08:48 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Ong Boon Leong" <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Gomes Vinicius <vinicius.gomes@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: set TxQ mode back to DCB after
 disabling CBS
Message-ID: <20210204170848.00000aff@intel.com>
In-Reply-To: <1612447396-20351-1-git-send-email-yoong.siang.song@intel.com>
References: <1612447396-20351-1-git-send-email-yoong.siang.song@intel.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Yoong Siang wrote:

> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> When disable CBS, mode_to_use parameter is not updated even the operation
> mode of Tx Queue is changed to Data Centre Bridging (DCB). Therefore,
> when tc_setup_cbs() function is called to re-enable CBS, the operation
> mode of Tx Queue remains at DCB, which causing CBS fails to work.
> 
> This patch updates the value of mode_to_use parameter to MTL_QUEUE_DCB
> after operation mode of Tx Queue is changed to DCB in stmmac_dma_qmode()
> callback function.
> 
> Fixes: 1f705bc61aee ("net: stmmac: Add support for CBS QDISC")
> Suggested-by: Gomes, Vinicius <vinicius.gomes@intel.com>
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> Signed-off-by: Song, Yoong Siang <yoong.siang.song@intel.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
