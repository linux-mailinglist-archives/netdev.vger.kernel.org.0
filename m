Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DFB964B7
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfHTPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:39:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfHTPjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UrZPMCqJMHdP7J4z6kRN/Pg74Win9kev4rEIRPJuYrg=; b=lon6YRZc0uv6oxr9A3V4P3CajP
        Kgjkttxfyd1SiOYcgq8D17AUnolYIEFVPcitpLNhCsLJICvxFxEquuT65jXRtrGhCFImvbj0JisEn
        OxOpjQsqkciwEZSes77TRY1zgy3B2saD27QabCW94Vkn019I0oL767zrfoOVkaD6P8fU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i06EV-0006VL-FQ; Tue, 20 Aug 2019 17:39:39 +0200
Date:   Tue, 20 Aug 2019 17:39:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     megous@megous.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] net: stmmac: sun8i: Use devm_regulator_get for PHY
 regulator
Message-ID: <20190820153939.GL29991@lunn.ch>
References: <20190820145343.29108-1-megous@megous.com>
 <20190820145343.29108-4-megous@megous.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820145343.29108-4-megous@megous.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 04:53:40PM +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> Use devm_regulator_get instead of devm_regulator_get_optional and rely
> on dummy supply. This avoids NULL checks before regulator_enable/disable
> calls.

Hi Ondrej

What do you mean by a dummy supply? I'm just trying to make sure you
are not breaking backwards compatibility.

     Thanks
	Andrew
