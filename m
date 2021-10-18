Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CC6432710
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhJRTIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:08:34 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:33727 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhJRTId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 15:08:33 -0400
Received: by mail-oi1-f177.google.com with SMTP id q129so1253751oib.0;
        Mon, 18 Oct 2021 12:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0I1DAhQIKT4b0pGsLrOdgZbYNlOKF2oGK8nCiwpxq/4=;
        b=TJp3avwpDQloYnKny63dI1DULFzFi+eyD+wpLPqfXPVQoV2SLZ4fcu14vvNG5jI969
         q7tajBvKuehQF2+sATQKD3O0a+hpSLc0ELGVbYiwzcHFHmzKwXv21K0pn0HLgIDkcVE7
         LJHB9hFwBdGqNwCRW/uc8vbafABTkaIAQhCNyn6dNSYxd2lg55S1VY5sVzjWDB1bbTls
         CRAil+DmfwhWSet3vD4Wf9v/TxoJvfWkDIdiwgu1/ykurt72B7nQBR6aQlmkFobzf93j
         qrVy/GwdutuFlByUi7j7JJSBuygD/Sv0b6Si57kdAoC7NWhhqjyFKaHe+7cHJhrsLBn1
         0UsA==
X-Gm-Message-State: AOAM531lKd0N47E51M4ajv6EGV+WPKLQzAyhGeZwp6QtrY2bYeX4/CYG
        I6m1uKN1wzqUP+88cYJnag==
X-Google-Smtp-Source: ABdhPJwysvwj0Ekaq9rEf6Tx2wem4iU1C46ZVkUTn+PlkM6hNg8/as7TKlmiuZlTtK9UDjucgY2cVw==
X-Received: by 2002:aca:d6d2:: with SMTP id n201mr554420oig.120.1634583981928;
        Mon, 18 Oct 2021 12:06:21 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bp21sm3065315oib.31.2021.10.18.12.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 12:06:21 -0700 (PDT)
Received: (nullmailer pid 2767853 invoked by uid 1000);
        Mon, 18 Oct 2021 19:06:19 -0000
Date:   Mon, 18 Oct 2021 14:06:19 -0500
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp
Message-ID: <YW3Fq7WMSB+TL2u4@robh.at.kernel.org>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
 <20211011142215.9013-8-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011142215.9013-8-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 05:22:14PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add a tristate property to advertise desired transmit level.
> 
> If the device supports the 2.4 Vpp operating mode for 10BASE-T1L,
> as defined in 802.3gc, and the 2.4 Vpp transmit voltage operation
> is desired, property should be set to 1. This property is used
> to select whether Auto-Negotiation advertises a request to
> operate the 10BASE-T1L PHY in increased transmit level mode.
> 
> If property is set to 1, the PHY shall advertise a request
> to operate the 10BASE-T1L PHY in increased transmit level mode.
> If property is set to zero, the PHY shall not advertise
> a request to operate the 10BASE-T1L PHY in increased transmit level mode.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 2766fe45bb98..2bb3a96612a2 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -77,6 +77,15 @@ properties:
>      description:
>        Maximum PHY supported speed in Mbits / seconds.
>  
> +  an-10base-t1l-2.4vpp:

What does 'an' mean?

> +    description: |
> +      tristate, request/disable 2.4 Vpp operating mode. The values are:
> +      0: Disable 2.4 Vpp operating mode.
> +      1: Request 2.4 Vpp operating mode from link partner.
> +      Absence of this property will leave configuration to default values.
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    enum: [0, 1]

What happened to this one doing the same thing?:

https://lore.kernel.org/lkml/20201117201555.26723-3-dmurphy@ti.com/

