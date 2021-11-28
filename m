Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7037F460B42
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 00:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241220AbhK1XtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 18:49:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhK1XrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 18:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fJiPS9v16G3hq2S03AwHtOfRgaYKPPmksYWZXdatOUQ=; b=4XiYowIQ+YgxdKzdtFO44GHjyP
        O7al4YTQHjWrX4dZoEIJS5wsBGxvDDhTjzZICf3ADhifUPdNZQsaninOq5BaRcSy/KgmJ4RTHmelb
        UaOzBAFK4gxBO32Hvsn9UqgQHtJuLD+5mESv2NCfIH1Ou0CLsiTyXFNf63MygSS2d5Rw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrTpm-00ErqL-KF; Mon, 29 Nov 2021 00:43:50 +0100
Date:   Mon, 29 Nov 2021 00:43:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next] stmmac: remove ethtool driver version info
Message-ID: <YaQUNsgF1KNENbCY@lunn.ch>
References: <c1bab067-00ba-f6b5-f683-709f1d5b09a9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1bab067-00ba-f6b5-f683-709f1d5b09a9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 07:45:56PM +0100, Heiner Kallweit wrote:
> I think there's no benefit in reporting a date from almost 6 yrs ago.
> Let ethtool report the default (kernel version) instead.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
