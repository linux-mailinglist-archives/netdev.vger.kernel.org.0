Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1962C13287B
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgAGOKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:10:46 -0500
Received: from gloria.sntech.de ([185.11.138.130]:60814 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbgAGOKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 09:10:46 -0500
Received: from ip5f5a5f74.dynamic.kabel-deutschland.de ([95.90.95.116] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1iopZ3-0002o4-In; Tue, 07 Jan 2020 15:10:33 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "kernelci . org bot" <bot@kernelci.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: Re: [PATCH net] net: stmmac: Fixed link does not need MDIO Bus
Date:   Tue, 07 Jan 2020 15:10:32 +0100
Message-ID: <10785975.EuRkUOQc5v@diego>
In-Reply-To: <5764e60da6d3af7e76c30f63b07f1a12b4787918.1578400471.git.Jose.Abreu@synopsys.com>
References: <5764e60da6d3af7e76c30f63b07f1a12b4787918.1578400471.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, 7. Januar 2020, 13:35:42 CET schrieb Jose Abreu:
> When using fixed link we don't need the MDIO bus support.
> 
> Reported-by: Heiko Stuebner <heiko@sntech.de>
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Fixes: d3e014ec7d5e ("net: stmmac: platform: Fix MDIO init for platforms without PHY")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

On px30
Tested-by: Heiko Stuebner <heiko@sntech.de>


