Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42E4489A24
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiAJNin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:38:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232695AbiAJNin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CcLrL1lD8Di0L5/0LB+VzZc2YmiWo9LTYt1QDQ/BD4w=; b=2MHZmE1i50W9BKXX/JBoE/xclc
        AEFkK8tz4lVTvbxLSkTmteS+pFHVJW1HOC9gGxjVgwa4rfBjDhkF/zS9H2Zy36b9WGh+Yy1PvXDFK
        cjMPpDm32cTcPuahIWV/BjUdXXD1cN/JIIYs+79IEw6XOvbX5I0llhfOphoSB+HWL2sU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n6usJ-000zTd-1r; Mon, 10 Jan 2022 14:38:15 +0100
Date:   Mon, 10 Jan 2022 14:38:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        =?iso-8859-1?Q?Fern=E1ndez?= Rojas <noltari@gmail.com>,
        John Crispin <john@phrozen.org>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: Cleanup MDIO node schemas
Message-ID: <Ydw2x3J5mnr21lmj@lunn.ch>
References: <20220105151009.3093506-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105151009.3093506-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 09:10:09AM -0600, Rob Herring wrote:
> The schemas for MDIO bus nodes range from missing to duplicating
> everything in mdio.yaml. The MDIO bus node schemas only need to
> reference mdio.yaml, define any binding specific properties, and define
> 'unevaluatedProperties: false'. This ensures that MDIO nodes only
> contain defined properties. With this, any duplicated properties can
> be removed.

> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
