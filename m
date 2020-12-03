Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112862CDDAF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgLCScZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgLCScY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:32:24 -0500
Date:   Thu, 3 Dec 2020 10:31:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607020304;
        bh=zLTuRRNyqm/9S0nu+4KALa2XevJTfTuFlFD19BmxBP8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LPPu3+4953FUJ+EGvy18buAUsQ3zhVBtm7INbNcR43Xi+RCtxMSUyn9CzlhrJ2QXU
         kUMGvHMQj++FnL8LP9tPq2vSLnAcYqBxBi0HtgJJJJiownKNmXlU6c2ccfZAvfCz0t
         K4eOIARmjuj2ztA44RagHmsQXoDdF8H0fwEDmtNU5ZOMfa9XGGcVe7cQQQqYfjcYXQ
         XxlUo8A3IF/Yf9/8tV5+ZN5Y4zbLqk/ilsXLgKe5BWM32ppLj9QhzqhNXwjxsnfEEM
         /tgHHlqDXAMt4cNrmDOqg5Se7A0p8CSM97aHCsUExyhO5EZ0mwLEOK0li6qUWzeXrL
         BrZ4pZb3Sspgw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH 2/4] net: stmmac: start phylink instance before
 stmmac_hw_setup()
Message-ID: <20201203103140.3a4e6125@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202085949.3279-4-qiangqing.zhang@nxp.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
        <20201202085949.3279-4-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 16:59:47 +0800 Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> Start phylink instance and resume back the PHY to supply
> RX clock to MAC before MAC layer initialization by calling
> .stmmac_hw_setup(), since DMA reset depends on the RX clock,
> otherwise DMA reset cost maximum timeout value then finally
> timeout.

We'll need a Fixes tag here.

> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
