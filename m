Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4006F3D9016
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhG1OIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:08:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233439AbhG1OIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 10:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p1ZPqb4JnoiqJdUy3vnukyeR01HwkRN6PlUru+n8cQk=; b=3H8BpUcZNCR7qZ5elLTY+OrAXg
        lW2dhXJwczo0A9Xdg+esFXvfYBmqWRwlM5parI7UKDosoXS09/yQHSyFDDf1U96dVK01wie9SxHjQ
        9Wmm0BxPjA7ovj/f4eJJcUooQQLz6Rzy0BXOQyxZtp4C/Yx35EyWVPxYAt9uaU2ya0Hc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8kEE-00FB6E-5W; Wed, 28 Jul 2021 16:08:10 +0200
Date:   Wed, 28 Jul 2021 16:08:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 2/7] dt-bindings: net: fsl,fec: add RGMII
 internal clock delay
Message-ID: <YQFkysjHFEN1w6Yz@lunn.ch>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
 <20210728115203.16263-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728115203.16263-3-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 07:51:58PM +0800, Joakim Zhang wrote:

> +      The "enet_2x_txclk"(option), for RGMII sampling clock which fixed at 250Mhz.
> +      The clock is required if SoC RGMII enable clock delay.

Hi Joakim

So you only need the clock if you are using RGMII delays? For RGMII
without delays, the clock is not needed?

You might want to add a check in the C code that the clock is provided
when needed.

     Andrew
