Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7888C32B3E7
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840286AbhCCEH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242708AbhCCB0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 20:26:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHGGW-0096uO-O7; Wed, 03 Mar 2021 02:25:28 +0100
Date:   Wed, 3 Mar 2021 02:25:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org
Subject: Re: [RFC V2 resend net-next 2/3] net: stmmac: add platform level
 clocks management
Message-ID: <YD7liGdgnlke46VA@lunn.ch>
References: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
 <20210301102529.18573-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301102529.18573-3-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 06:25:28PM +0800, Joakim Zhang wrote:
> This patch intends to add platform level clocks management. Some
> platforms may have their own special clocks, they also need to be
> managed dynamically. If you want to manage such clocks, please implement
> clks_config callback.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
