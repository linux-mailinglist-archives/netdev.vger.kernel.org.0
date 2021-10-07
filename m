Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED13E424ADB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbhJGALe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:11:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230360AbhJGALd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SUlwUZjTB0ltLvDv0wy8CJLHR4iDxTStK16I/6GRpTg=; b=Eq8rWurlKAlMcGTzrYqKC3wUb+
        rfTC9W2m+TLnqp7dd35TkmziBMSj/Hag31ZZjh+hFWrQbCb9d/1bopSvLPBh9cKFjdf96cgOJORW/
        3Qf/6JiIAVx93ENpw7DwWS72JmvAbcJPGj6pnTps2+/v87IqUsUubUThOQ9T/S1XO8bc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYGye-009tBl-Fu; Thu, 07 Oct 2021 02:09:36 +0200
Date:   Thu, 7 Oct 2021 02:09:36 +0200
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
Subject: Re: [net-next PATCH 06/13] Documentation: devicetree: net: dsa:
 qca8k: document rgmii_1_8v bindings
Message-ID: <YV46wJYlJZHAZLyD@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-7-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:56AM +0200, Ansuel Smith wrote:
> Document new qca,rgmii0_1_8v and qca,rgmii56_1_8v needed to setup
> mac_pwr_sel register for ar8327 switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 8c73f67c43ca..1f6b7d2f609e 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -13,6 +13,8 @@ Required properties:
>  Optional properties:
>  
>  - reset-gpios: GPIO to be used to reset the whole device
> +- qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port
> +- qca,rgmii56-1-8v: Set the internal regulator to supply 1.8v for MAC5/6 port

What is the consumer of these 1.8v? The MACs are normally internal,
the regulators are internal, so why is a DT property needed?

    Andrew
