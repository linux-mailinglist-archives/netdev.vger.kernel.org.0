Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F4222B538
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgGWRvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:51:31 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:34899 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgGWRva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 13:51:30 -0400
Received: by mail-il1-f196.google.com with SMTP id t18so5085329ilh.2;
        Thu, 23 Jul 2020 10:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x3vfsuqcq45dVFf7tEJ1CslIm8B4pPSSsUr5wIydFDw=;
        b=taO4TxIO3jG1oY4HFAJe2PGfeifdkWBD2yokBLMNO4htt2Q98wSqRLbWu1neuANb4a
         xqxE2TtcHlUbKyU8sgXUgWnGigyNf6+qDu2LBIMwcO4i7JTUsP7EbaLkc/QrdbKRLDXn
         esmmOF8wq1nY8c0budEgWSJVvE5t0vIU8TXty7jBwkZk2KTj5jaaAA3AyGKfSIZNizGw
         0XeuhJj9F/WN4hRqwDCpWS94G+x36lN5JGUpucVSh3sQ4PLlyGBqDVMBxtYRnGlXcPak
         P2byczKtWJRM08QkxO06IzFWdKBmBW+hG7FtaoKf0CqfVPtdXiqOfWvCQ9jKkYVoSOA4
         2Y9A==
X-Gm-Message-State: AOAM532m6+QpSl9ZBwRETOFCit+nLnuRIkPrOBNwmEVedeYAtbnUd+YL
        VVCZxk+k/GPFOOx3aToUoQ==
X-Google-Smtp-Source: ABdhPJxSClLzvAK16aEI2wtodmQq1Y7Nz8hTMGHEZJZ1yd8wrWEJmha1cQ9Cy56WXIjhn2qUjGZE+g==
X-Received: by 2002:a92:b685:: with SMTP id m5mr5818388ill.219.1595526689504;
        Thu, 23 Jul 2020 10:51:29 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id r2sm1790160iop.34.2020.07.23.10.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 10:51:28 -0700 (PDT)
Received: (nullmailer pid 601639 invoked by uid 1000);
        Thu, 23 Jul 2020 17:51:26 -0000
Date:   Thu, 23 Jul 2020 11:51:26 -0600
From:   Rob Herring <robh@kernel.org>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     f.fainelli@gmail.com, kuba@kernel.org, davem@davemloft.net,
        alexandre.belloni@bootlin.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        ludovic.desroches@microchip.com, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, claudiu.beznea@microchip.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v2 2/7] dt-bindings: net: macb: use an MDIO node
 as a container for PHY nodes
Message-ID: <20200723175126.GA601589@bogus>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
 <20200721171316.1427582-3-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721171316.1427582-3-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 20:13:11 +0300, Codrin Ciubotariu wrote:
> The MACB driver embeds an MDIO bus controller and for this reason there
> was no need for an MDIO sub-node present to contain the PHY nodes. Adding
> MDIO devies directly under an Ethernet node is deprecated, so an MDIO node
> is included to contain of the PHY nodes (and other MDIO devices' nodes).
> 
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
> ---
> 
> Changes in v2:
>  - patch renamed from "macb: bindings doc: use an MDIO node as a
>    container for PHY nodes" to "dt-bindings: net: macb: use an MDIO
>    node as a container for PHY nodes"
> 
>  Documentation/devicetree/bindings/net/macb.txt | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
