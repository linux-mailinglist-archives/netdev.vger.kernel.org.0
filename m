Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B791AFBA0
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDSPLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 11:11:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgDSPLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 11:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hccV7HGXuDlGWiOBVr5T3h4obmkusLKjgyGJWPEzlHc=; b=nwo2clu9f98nng0PdkfDffd818
        kZqs9/x3KcwCTA1rtB4n3EPTzcSJ5SdCPWZn0FqCRC+vL07rfN7iUMtCEP/fd13VVymXUnWozZntd
        cFxo13fGvRahTXL7PjCwtSQLMjZdab98927rIkeuYxF1f2DhAX+3rdbnfVauPD6eoK08=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQBba-003eIX-4b; Sun, 19 Apr 2020 17:11:34 +0200
Date:   Sun, 19 Apr 2020 17:11:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: mdio: Document common
 properties
Message-ID: <20200419151134.GF836632@lunn.ch>
References: <20200419030843.18870-1-f.fainelli@gmail.com>
 <20200419030843.18870-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419030843.18870-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 08:08:42PM -0700, Florian Fainelli wrote:
> Some of the properties pertaining to the broken turn around or resets
> were only documented in ethernet-phy.yaml while they are applicable
> across all MDIO devices and not Ethernet PHYs specifically which are a
> superset.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/mdio.yaml         | 27 +++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
> index 50c3397a82bc..d268ed80bb77 100644
> --- a/Documentation/devicetree/bindings/net/mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/mdio.yaml
> @@ -50,6 +50,33 @@ patternProperties:
>          description:
>            The ID number for the PHY.
>  
> +      broken-turn-around:
> +        $ref: /schemas/types.yaml#definitions/flag
> +        description:
> +          If set, indicates the MDIO device does not correctly release
> +          the turn around line low at the end of a MDIO transaction.

Sorry, missed this the first time. Turn around is in the middle of the
transaction, after the register bits for C22, not at the end of the
transaction.

	Andrew
