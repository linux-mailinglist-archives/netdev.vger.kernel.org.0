Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4E307D62
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhA1SGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:06:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhA1SEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 13:04:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l5BdN-0034Q1-If; Thu, 28 Jan 2021 19:03:09 +0100
Date:   Thu, 28 Jan 2021 19:03:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] net: dsa: tag_ksz: add tag handling for
 Microchip LAN937x
Message-ID: <YBL8XaZlVQRVg+qA@lunn.ch>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-3-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128064112.372883-3-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 12:11:06PM +0530, Prasanna Vengateshan wrote:
> The Microchip LAN937X switches have a tagging protocol which is
> very similar to KSZ tagging. So that the implementation is added to
> tag_ksz.c and reused common APIs
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  include/net/dsa.h |  2 ++
>  net/dsa/Kconfig   |  4 +--
>  net/dsa/tag_ksz.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 2f5435d3d1db..b9bc7a9a8c15 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -47,6 +47,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_RTL4_A_VALUE		17
>  #define DSA_TAG_PROTO_HELLCREEK_VALUE		18
>  #define DSA_TAG_PROTO_XRS700X_VALUE		19
> +#define DSA_TAG_PROTO_LAN937X_VALUE		20
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -69,6 +70,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
>  	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
>  	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
> +	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
>  };
>  
>  struct packet_type;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 2d226a5c085f..217fa0f8d13e 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -92,10 +92,10 @@ config NET_DSA_TAG_MTK
>  	  Mediatek switches.
>  
>  config NET_DSA_TAG_KSZ
> -	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
> +	tristate "Tag driver for Microchip 8795/9477/9893/937x families of switches"

You might want to keep these in numerical order.

    Andrew
