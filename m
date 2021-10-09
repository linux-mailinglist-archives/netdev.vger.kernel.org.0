Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66209427C60
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhJIR0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:26:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58424 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhJIR0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 13:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0PY757O+atfP3n55fE6xHeGXtvImXJY66WSxot2qCMw=; b=dYERAs0t8jUkdWZEKIFy1upNSK
        yuGRrWF01dmNfxDJ47DScX2/OIihurcUt8M/FSlG0ec1UPY+CspJVJQgulCaB5p6AeNWH1pTBVZjp
        4KUhGl129iNP8/cT1Gg57zwJGdofF8GVYlFjPNLOYK5WuRJGRZuac7VLuo5ClUHYuffs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZG5V-00AAPG-GI; Sat, 09 Oct 2021 19:24:45 +0200
Date:   Sat, 9 Oct 2021 19:24:45 +0200
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
Subject: Re: [net-next PATCH v2 15/15] dt-bindings: net: dsa: qca8k: document
 support for qca8328
Message-ID: <YWHQXYx7kYckTcqT@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-16-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008002225.2426-16-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:22:25AM +0200, Ansuel Smith wrote:
> QCA8328 is the birrget brother of 8327. Document the new compatible

birrget?



> binding.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 9fb4db65907e..0e84500b8db2 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -3,6 +3,7 @@
>  Required properties:
>  
>  - compatible: should be one of:
> +    "qca,qca8328"
>      "qca,qca8327"
>      "qca,qca8334"
>      "qca,qca8337"

This is much nice than the old DT property. But since the internal IDs
are the same, i think it would be good to add a little documentation
here about how the 8327 and 8328 differ, since most people are not
going to look at the commit message.

      Andrew
