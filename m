Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C6125AB4C
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 14:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgIBMoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 08:44:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIBMnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 08:43:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDS6x-00CtCS-4e; Wed, 02 Sep 2020 14:43:35 +0200
Date:   Wed, 2 Sep 2020 14:43:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: Document Broadcom SF2
 switch clocks
Message-ID: <20200902124335.GB3071395@lunn.ch>
References: <20200901225913.1587628-1-f.fainelli@gmail.com>
 <20200901225913.1587628-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901225913.1587628-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 03:59:11PM -0700, Florian Fainelli wrote:
> Describe the two possible clocks feeding into the Broadcom SF2
> integrated Ethernet switch. BCM7445 systems have two clocks, one for the
> main switch core clock, and another for controlling the switch clock
> divider whereas BCM7278 systems only have the first kind.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt   | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
> index 88b57b0ca1f4..97ca62b0e14d 100644
> --- a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
> +++ b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
> @@ -50,6 +50,13 @@ Optional properties:
>  - reset-names: If the "reset" property is specified, this property should have
>    the value "switch" to denote the switch reset line.
>  
> +- clocks: when provided, the first phandle is to the switch's main clock and
> +  is valid for both BCM7445 and BCM7278. The second phandle is only applicable
> +  to BCM7445 and is to support dividing the switch core clock.
> +
> +- clock-names: when provided, the first phandle must be "sw_switch", and the
> +  second must be named "sw_switch_mdiv".

Hi Florian

Since you look clocks up by name, i don't think the order matters.

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
