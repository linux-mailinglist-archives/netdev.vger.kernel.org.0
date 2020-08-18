Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D84248C6B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgHRRFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:05:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59498 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728367AbgHRRFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 13:05:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k852W-009wPo-DE; Tue, 18 Aug 2020 19:04:48 +0200
Date:   Tue, 18 Aug 2020 19:04:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, ajayg@nvidia.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: stmmac: Fix signedness bug in
 stmmac_probe_config_dt()
Message-ID: <20200818170448.GH2330298@lunn.ch>
References: <20200818143952.50752-1-yuehaibing@huawei.com>
 <20200818151500.51548-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818151500.51548-1-yuehaibing@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 11:15:00PM +0800, YueHaibing wrote:
> The "plat->phy_interface" variable is an enum and in this context GCC
> will treat it as an unsigned int so the error handling is never
> triggered.
> 
> Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Hi YueHaibing

Please take a look at:

commit 0c65b2b90d13c1deaee6449304dd367c5d4eb8ae
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Mon Nov 4 02:40:33 2019 +0100

    net: of_get_phy_mode: Change API to solve int/unit warnings

You probably want to follow this basic idea.

    Andrew
