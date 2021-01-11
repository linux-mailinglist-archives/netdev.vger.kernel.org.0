Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F33C2F1C05
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389191AbhAKRO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:14:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbhAKRO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 12:14:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kz0l5-00HZV5-0F; Mon, 11 Jan 2021 18:13:35 +0100
Date:   Mon, 11 Jan 2021 18:13:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH 1/6] ethernet: stmmac: remove redundant null check for
 ptp clock
Message-ID: <X/yHPnzZop6/WaC1@lunn.ch>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
 <20210111113538.12077-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111113538.12077-2-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 07:35:33PM +0800, Joakim Zhang wrote:
> Remove redundant null check for ptp clock.
> 
> Fixes: 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()")
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
