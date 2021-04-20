Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858C1364FD6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 03:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbhDTB0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 21:26:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233087AbhDTB0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 21:26:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lYf9U-0001V5-DU; Tue, 20 Apr 2021 03:26:08 +0200
Date:   Tue, 20 Apr 2021 03:26:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <YH4tsFtGJUMf2BFS@lunn.ch>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419225133.2005360-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +      mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phy1: phy@1 {
> +          #phy-cells = <0>;

Hi Linus

phy-cells is not part of the Ethernet PHY binding.

	  Andrew
