Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF5E388E13
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352999AbhESMcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:32:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47376 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhESMcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 08:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KJoK5eHV6zPsubnPIQGNm9VMcRMlk8KPOoIYCtY6QKU=; b=VmRhxzMQjDaQ55v72m/hZC/1r+
        ueLMCss6Om57671IhgF+vrUjyJRFJi2WFH1Gm3jnP0HSwV0WPszH+WeFM7cyRVajWsov4VqvfY4I8
        VnD5ygHhUIhg5eXKbiUwSVQ825FSIWZhukwpwlxZt2FtvU0yGM4x2j9FadqJYfE2K67M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ljLLS-004vM0-C9; Wed, 19 May 2021 14:30:38 +0200
Date:   Wed, 19 May 2021 14:30:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Peter Rosin <peda@axentia.se>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: net: Convert MDIO mux bindings to DT schema
Message-ID: <YKUE7hB/BRMgkd28@lunn.ch>
References: <20210519022000.1858188-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519022000.1858188-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/Documentation/devicetree/bindings/net/mdio-mux.yaml b/Documentation/devicetree/bindings/net/mdio-mux.yaml
> new file mode 100644
> index 000000000000..92163fa45f39
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mdio-mux.yaml
> @@ -0,0 +1,44 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mdio-mux.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Common MDIO bus multiplexer/switch properties.
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +
> +description: |+
> +  An MDIO bus multiplexer/switch will have several child busses that are
> +  numbered uniquely in a device dependent manner.  The nodes for an MDIO
> +  bus multiplexer/switch will have one child node for each child bus.
> +
> +properties:
> +  $nodename:
> +    pattern: '^mdio-mux[\-@]?'
> +
> +  mdio-parent-bus:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      The phandle of the I2C bus that this multiplexer's master-side port is
> +      connected to.

I2C? This seems like a cut/paste error?

     Andrew
