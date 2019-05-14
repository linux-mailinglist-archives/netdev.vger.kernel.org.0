Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBF61C0CC
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfENDBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:01:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34727 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfENDBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 23:01:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G3zxPkEx8xFAbyKPcWX048WseX1r8i9WLN8ua6tPwmc=; b=tSmoC5EMuNCDWWJh44SydrloQ7
        GgY0QYJRcyXdrf2nbti5fSz9evr36xmIFcXYj7FBobiupdZJC8N8lt2mzYEuJ+KIakZO5OKHh219H
        0Nx/WfMMc2wY0dS/wXCbGu1GEZk3WafJTguYGrM8KbxuCaRLTMO7VrYG/AOl+wqfWPKM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQNfs-000604-5y; Tue, 14 May 2019 05:00:16 +0200
Date:   Tue, 14 May 2019 05:00:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Jose Abreu <joabreu@synopsys.com>, davem@davemloft.net,
        jianguo.zhang@mediatek.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yt.shen@mediatek.com, linux-mediatek@lists.infradead.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [v2, PATCH 0/4] fix some bugs in stmmac
Message-ID: <20190514030016.GA19642@lunn.ch>
References: <1557800933-30759-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557800933-30759-1-git-send-email-biao.huang@mediatek.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 10:28:49AM +0800, Biao Huang wrote:
> changes in v2:                                                                  
>         1. update rx_tail_addr as Jose's comment                                
>         2. changes clk_csr condition as Alex's proposition                      
>         3. remove init lines in dwmac-mediatek, get clk_csr from dts instead.   

Hi Biao

Since these are fixes, could you provide a Fixes: tag for each one?

Thanks
	Andrew
