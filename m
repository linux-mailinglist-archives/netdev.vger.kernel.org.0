Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1EC37A70C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhEKMuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:50:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230475AbhEKMuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:50:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eK2pfUjKqdUq1I83ebVnzyIBTPQFhKtrKzA32ciX9ok=; b=UzqwLkJybQIrlPu1Eaxob2jElv
        T22TNr/cOyZz+b2JvAqOZCuZrkXObvLg8ln+FVnOfMf6DBjG9rMuktnogCTi6zR+VHgHMXgGLLpt5
        2EudFY/8JebB4ADqq9Wz/I/SBLDlo/iK+PX5P5CUEbkemqEcmJWjtqnmUhae2wveEVL0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRok-003k9Y-7h; Tue, 11 May 2021 14:48:54 +0200
Date:   Tue, 11 May 2021 14:48:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v3 2/2] ARM: dts: imx6dl-riotboard: configure PHY clock
 and set proper EEE value
Message-ID: <YJp9Nnzxz3mW1KXL@lunn.ch>
References: <20210511043039.20056-1-o.rempel@pengutronix.de>
 <20210511043039.20056-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043039.20056-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:30:39AM +0200, Oleksij Rempel wrote:
> Without SoC specific PHY fixups the network interface on this board will
> fail to work. Provide missing DT properties to make it work again.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
