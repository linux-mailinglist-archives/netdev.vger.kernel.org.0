Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39E243154
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 23:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfFLVJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 17:09:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfFLVJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 17:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9YmJ2DBObebHfwNsdI+eNLnRZLXeK+64ASDuQcSMRtg=; b=u3rQ+SDV981ti15WXtn9kdrGnT
        6ptdchdeZzpJtoDfcjLTIVBFHnyM0nf3CvQm1RSiwYD9zAWziw4+qWoCBR8AYTLy6/ZWvDzg/TJov
        ONqQCZLF24NJrV0PVAd0g/2d3QPYsuCDXOSpJ8EK0WQ0aIdq7dIybHv8OORScY/3NwwQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hbAUj-000822-UU; Wed, 12 Jun 2019 23:09:21 +0200
Date:   Wed, 12 Jun 2019 23:09:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        maxime.ripard@bootlin.com
Subject: Re: [PATCH net-next v2 1/1] net: stmmac: use GPIO descriptors in
 stmmac_mdio_reset
Message-ID: <20190612210921.GE23695@lunn.ch>
References: <20190612193115.6751-1-martin.blumenstingl@googlemail.com>
 <20190612193115.6751-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612193115.6751-2-martin.blumenstingl@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 09:31:15PM +0200, Martin Blumenstingl wrote:
> Switch stmmac_mdio_reset to use GPIO descriptors. GPIO core handles the
> "snps,reset-gpio" for GPIO descriptors so we don't need to take care of
> it inside the driver anymore.
> 
> The advantage of this is that we now preserve the GPIO flags which are
> passed via devicetree. This is required on some newer Amlogic boards
> which use an Open Drain pin for the reset GPIO. This pin can only output
> a LOW signal or switch to input mode but it cannot output a HIGH signal.
> There are already devicetree bindings for these special cases and GPIO
> core already takes care of them but only if we use GPIO descriptors
> instead of GPIO numbers.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
