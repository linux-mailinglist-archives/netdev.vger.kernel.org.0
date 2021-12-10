Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EF0470CDB
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 23:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344583AbhLJWNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 17:13:07 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:47081 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhLJWNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 17:13:06 -0500
Received: by mail-oi1-f178.google.com with SMTP id s139so15029734oie.13;
        Fri, 10 Dec 2021 14:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DnlVhksEB5ZOQQ74xFATWx8bJSkoD3ECOXYVPky0hJg=;
        b=qQ8FBDTpT+KPO2rB/r5ensxpIE/F+liD59OrqKza84sgdcYTTB86hogqHti3s1Dchy
         a8TQ0hi5iO638YILhkp7k74Cz+OrZ3ZM4QDHj8HHSt1mmSgvaKjVwAnoRQeAo74zUTkp
         W2aZASKSKyvLZ8Mo34pKwqPEWu5lZ5uDqUr/K0NJE4FPz4sG8bbZUW4cdBYQDw+6S8C4
         0pl5gHY1eLqJBWb+0C6lrCnf7LA5k3Oe8sguyS1DSZLpNy/045qmx/geiefbxODGnDYH
         NDyZN1KZ+XA4I/mByHQj7awTgMCcZ8R9SlbosLHPaqZhYI2KxhP8qyfpdMtxcDKuOzWu
         U2Ig==
X-Gm-Message-State: AOAM533EyHSwndHvO8K24ppRxPiafECZDH5GlI+5eYIaqem5lZiZYswT
        Qycyys8e7Q/P8zW9kwKO/Q==
X-Google-Smtp-Source: ABdhPJza8I2slXcB961QtMPv/wAgTkmX7IjX4N2f5w85KRRMoMe8e61/kte+b2amTDF1kX9bEcDuJA==
X-Received: by 2002:a54:4506:: with SMTP id l6mr15089160oil.32.1639174170538;
        Fri, 10 Dec 2021 14:09:30 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j10sm760997ooq.5.2021.12.10.14.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 14:09:29 -0800 (PST)
Received: (nullmailer pid 2016093 invoked by uid 1000);
        Fri, 10 Dec 2021 22:09:28 -0000
Date:   Fri, 10 Dec 2021 16:09:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     o.rempel@pengutronix.de, kuba@kernel.org, netdev@vger.kernel.org,
        hkallweit1@gmail.com, davem@davemloft.net, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v4 7/7] dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp
Message-ID: <YbPQGCA9OyFiqDQk@robh.at.kernel.org>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
 <20211210110509.20970-8-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210110509.20970-8-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 13:05:09 +0200, alexandru.tachici@analog.com wrote:
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

Reviewed-by: Rob Herring <robh@kernel.org>
