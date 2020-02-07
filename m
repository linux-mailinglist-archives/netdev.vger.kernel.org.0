Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A915587D
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGNcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 08:32:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGNcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 08:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k+RNLZTniJRRRyBN0pswuLEqgka8vHJHmd3fETb5+CE=; b=FC3VcDC2xE+tTcLzIAskQ5uK7W
        Bszji7B8P8H00Q+qIQ4ACOkdf+7nkLwXVn23El9UAGFGANB/26ufuu/jNvFZXKXQJhxCRLkSUnF6M
        EVhal8AgmqGp1ZMZEzapk0WMSyhtYKu0OTA2fKES4OJlsRpwqma1Tjj1E3IUZfq2SMkQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j03jy-0003pJ-D1; Fri, 07 Feb 2020 14:32:14 +0100
Date:   Fri, 7 Feb 2020 14:32:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net,
        Razvan Stefanescu <razvan.stefanescu@microchip.com>
Subject: Re: [PATCH v2] net: dsa: microchip: enable module autoprobe
Message-ID: <20200207133214.GB14393@lunn.ch>
References: <20200207104643.1049-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207104643.1049-1-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 12:46:43PM +0200, Codrin Ciubotariu wrote:
> From: Razvan Stefanescu <razvan.stefanescu@microchip.com>
> 
> This matches /sys/devices/.../spi1.0/modalias content.
> 
> Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
> ---
> 
> Changes in v2:
>  - added alias for all the variants of this driver
> 
>  drivers/net/dsa/microchip/ksz9477_spi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
> index c5f64959a184..1142768969c2 100644
> --- a/drivers/net/dsa/microchip/ksz9477_spi.c
> +++ b/drivers/net/dsa/microchip/ksz9477_spi.c
> @@ -101,6 +101,12 @@ static struct spi_driver ksz9477_spi_driver = {
>  
>  module_spi_driver(ksz9477_spi_driver);
>  
> +MODULE_ALIAS("spi:ksz9477");
> +MODULE_ALIAS("spi:ksz9897");
> +MODULE_ALIAS("spi:ksz9893");
> +MODULE_ALIAS("spi:ksz9563");
> +MODULE_ALIAS("spi:ksz8563");
> +MODULE_ALIAS("spi:ksz9567");
>  MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
>  MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch SPI access Driver");
>  MODULE_LICENSE("GPL");

Hi Codrin

You might want to consider adding a Fixes tag?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
