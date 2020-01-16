Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9713DC46
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgAPNne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:43:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgAPNne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J0Fk1hDLs8lmcz1SLIOMMSz56qx4PBNGnuo2BZVSt8Q=; b=ZDFPHK4K8LTkfDLUymK77njYow
        20pVJayBPmvwot7S0BfDRvzSqfM1YjmI/JKWjBgJ7TvgRksK/vuyhkRXQOmDKt+aVnfumkEpE7blM
        W9tmm6tQmpq7A4A73RcQyMnLFtJ5CQQ8vOTSlML5fsbio/S2qbUO7YFQP6OLLI52mJyA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1is5Qo-0005Ct-CJ; Thu, 16 Jan 2020 14:43:30 +0100
Date:   Thu, 16 Jan 2020 14:43:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH 4/4] dt-bindings: net: adin: document 1588 TX/RX SOP
 bindings
Message-ID: <20200116134330.GD19046@lunn.ch>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
 <20200116091454.16032-5-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116091454.16032-5-alexandru.ardelean@analog.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  adi,1588-rx-sop-delays-cycles:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/uint8-array
> +      - items:
> +          - minItems: 3
> +            maxItems: 3
> +    description: |
> +      Enables Start Packet detection (SOP) for received IEEE 1588 time stamp
> +      controls, and configures the number of cycles (of the MII RX_CLK clock)
> +      to delay the indication of RX SOP frames for 10/100/1000 BASE-T links.
> +      The first element (in the array) configures the delay for 10BASE-T,
> +      the second for 100BASE-T, and the third for 1000BASE-T.

Do you know the clock frequency? It would be much better to express
this in ns, as with adi,1588-tx-sop-delays-ns.

> @@ -62,5 +116,11 @@ examples:
>              reg = <1>;
>  
>              adi,fifo-depth-bits = <16>;
> +
> +            adi,1588-rx-sop-delays-cycles = [ 00 00 00 ];
> +            adi,1588-rx-sop-pin-name = "int_n";
> +
> +            adi,1588-tx-sop-delays-ns = [ 00 08 10 ];

10 is not a multiple of 8!

   Andrew
