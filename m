Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08497AF250
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 22:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfIJUgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 16:36:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:57378 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfIJUgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 16:36:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 13:36:02 -0700
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="178795905"
Received: from jesse-tab.amr.corp.intel.com (HELO localhost) ([134.134.177.212])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 13:36:01 -0700
Date:   Tue, 10 Sep 2019 13:36:01 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     <netdev@vger.kernel.org>, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next 0/6] net: stmmac: Improvements for -next
Message-ID: <20190910133601.00001c98@intel.com>
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
X-Mailer: Claws Mail 3.14.0 (GTK+ 2.24.30; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Sep 2019 16:41:21 +0200 Jose wrote:
> Misc patches for -next. It includes:
>  - Two fixes for features in -next only
>  - New features support for GMAC cores (which includes GMAC4 and GMAC5)
> 
> ---
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
> Jose Abreu (6):
>   net: stmmac: Prevent divide-by-zero
>   net: stmmac: Add VLAN HASH filtering support in GMAC4+
>   net: stmmac: xgmac: Reinitialize correctly a variable
>   net: stmmac: Add support for SA Insertion/Replacement in GMAC4+
>   net: stmmac: Add support for VLAN Insertion Offload in GMAC4+
>   net: stmmac: ARP Offload for GMAC4+ Cores

For the series, looks good to me.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
