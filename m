Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE1278CC6
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgIYPdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:33:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbgIYPdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 11:33:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLpij-00GAz6-2t; Fri, 25 Sep 2020 17:33:13 +0200
Date:   Fri, 25 Sep 2020 17:33:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net] MAINTAINERS: Add Vladimir as a maintainer for DSA
Message-ID: <20200925153313.GJ3821492@lunn.ch>
References: <20200925152616.20963-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925152616.20963-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 08:26:16AM -0700, Florian Fainelli wrote:
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9350506a1127..6dc9ebf5bf76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12077,6 +12077,7 @@ NETWORKING [DSA]
>  M:	Andrew Lunn <andrew@lunn.ch>
>  M:	Vivien Didelot <vivien.didelot@gmail.com>
>  M:	Florian Fainelli <f.fainelli@gmail.com>
> +M:	Vladimir Oltean <olteanv@gmail.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/
>  F:	drivers/net/dsa/

Acked-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
