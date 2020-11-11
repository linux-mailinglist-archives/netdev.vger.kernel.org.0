Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DDD2AFC0E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgKLBb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgKKXPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 18:15:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5B720797;
        Wed, 11 Nov 2020 23:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605136544;
        bh=BsryHKz3dVxK2sBEfXD2LfC5W276gDYqCQDz8imsdS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bZOBzJf7ulaTmNfU8C4zP9exUVyaxz1AzeaDx7ywfgMz8C0uigyiwwMLY23x1hme0
         +sDAq6cLhG00Msc1SSLgguG6y5ZbNluc1o3aKotR7yEAVx4LDxh4e0jR8YuTC+58+S
         ID4KS6X1Rea3PE8uKEF6V3AbK8P9diX8nNZrgTE8=
Date:   Wed, 11 Nov 2020 15:15:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: dwc-qos: Change the
 dwc_eth_dwmac_data's .probe prototype
Message-ID: <20201111151542.4b9addde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109160440.3a736ee3@xhacker.debian>
References: <20201109160440.3a736ee3@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 16:05:14 +0800 Jisheng Zhang wrote:
> The return pointer of dwc_eth_dwmac_data's .probe isn't used, and
> "probe" usually return int, so change the prototype to follow standard
> way. Secondly, it can simplify the tegra_eqos_probe() code.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Applied, thanks!
