Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF2427C58
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhJIRWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:22:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhJIRWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 13:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JA/9DYJu3KwR5i2N9Fs5uKDbKHpeiznfL7FRQ+x+5cc=; b=olUzjFa5mVDAx4v9YaY2wAqcvS
        hn4tnVvIEQYtpPD+ESJtRJJT7mALqmwLUxK8c4npP+xq4FkCxyRefZ/RA8iDDc09h54I9YjLAH0Tg
        9E7WNyNJJjBvx3Vbplq92fVaP9lArdk3qfkTpx2dOnpuV5NtY8yvlYI4wqRJGZtD4I60=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZG1h-00AANy-D7; Sat, 09 Oct 2021 19:20:49 +0200
Date:   Sat, 9 Oct 2021 19:20:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 13/15] dt-bindings: net: dsa: qca8k: document
 open drain binding
Message-ID: <YWHPccukYpemv77x@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-14-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008002225.2426-14-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:22:23AM +0200, Ansuel Smith wrote:
> Document new binding qca,power_on_sel used to enable Power-on-strapping
> select reg and qca,led_open_drain to set led to open drain mode.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index b9cccb657373..9fb4db65907e 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -13,6 +13,17 @@ Required properties:
>  Optional properties:
>  
>  - reset-gpios: GPIO to be used to reset the whole device
> +- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
> +                           drain or eeprom presence.

So strapping is only used for LEDs and EEPROM presence? Nothing else?
Seems link MAC0/MAC6 swap would be a good candidate for strapping?

I just want to make it clear that if you select this option, you need
to take care of X, Y and Z in DT.

	Andrew
