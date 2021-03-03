Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0D832B3E8
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840291AbhCCEH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235968AbhCCB2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 20:28:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHGI5-0096uz-K3; Wed, 03 Mar 2021 02:27:05 +0100
Date:   Wed, 3 Mar 2021 02:27:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org
Subject: Re: [RFC V2 resend net-next 3/3] net: stmmac: dwmac-imx: add
 platform level clocks management for i.MX
Message-ID: <YD7l6Wq0p5z22cf7@lunn.ch>
References: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
 <20210301102529.18573-4-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301102529.18573-4-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 06:25:29PM +0800, Joakim Zhang wrote:
> Split clocks settings from init callback into clks_config callback,
> which could support platform level clocks management.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
