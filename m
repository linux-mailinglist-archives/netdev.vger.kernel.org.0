Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED51F9EC3
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 19:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbgFORpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 13:45:19 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:40524 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgFORpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 13:45:19 -0400
Received: by mail-il1-f195.google.com with SMTP id t8so187996ilm.7;
        Mon, 15 Jun 2020 10:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yY9vsdbUetvZHFE31+hfyR4zS8VWyOrgrboCYCv/8Es=;
        b=Ad+HGS6IhiQAKe6aWHl9u1CsHcl2nBr2y9cFsNKUX07qldfl/lUKKGmoPIFsIjZbk0
         ClsrbLeA6vKNI++uRbmqYKbalPsi6RZlEKDSaC0tEqLyh8h9wGSXF3R5J/7St+bLYXbU
         775ZBLEIm9dN/3rxndWWFNVGPuilhl7LwFnaJXV5c0myQlQwMbvsXwrZ4TlGR5Js7krP
         aNN/ctDoMKcunKDZ5k8BckAUTfMflqKQSR2KZIMK/c8hGBQTVTjeA1YgChS6IGKtbbMu
         KnNhUbkbX0FCnGOUIPfP+s/Ij+gmC/+aHKFNsij2CvvIQEhNfCtFgZ6S+CpvzF0/0rg/
         gySQ==
X-Gm-Message-State: AOAM531te8qLfIqPnKI7o5KQ5dUOrkigk+BgJuG06HtENKqbJ7So3zjK
        KvXGaZ4nYr60nmKjiGSBdA==
X-Google-Smtp-Source: ABdhPJwOXqazAV/sM0GMJuEhVIuLysGJdm4vB1cY73m25QTyGn1nHq3E9zbNcU5wGs7GjtP99KP3sg==
X-Received: by 2002:a92:c985:: with SMTP id y5mr28134527iln.50.1592243118446;
        Mon, 15 Jun 2020 10:45:18 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id z16sm8322579ilz.64.2020.06.15.10.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 10:45:17 -0700 (PDT)
Received: (nullmailer pid 2023356 invoked by uid 1000);
        Mon, 15 Jun 2020 17:45:16 -0000
Date:   Mon, 15 Jun 2020 11:45:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: dsa: qca8k: document SGMII
 properties
Message-ID: <20200615174516.GA2018349@bogus>
References: <cover.1591380105.git.noodles@earth.li>
 <ca767d2dd00280f7c0826c133d1ff6f262b6736d.1591380105.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca767d2dd00280f7c0826c133d1ff6f262b6736d.1591380105.git.noodles@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 07:10:02PM +0100, Jonathan McDowell wrote:
> This patch documents the qca8k's SGMII related properties that allow
> configuration of the SGMII port.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index ccbc6d89325d..9e7d74a248ad 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -11,7 +11,11 @@ Required properties:
>  
>  Optional properties:
>  
> +- disable-serdes-autoneg: Boolean, disables auto-negotiation on the SerDes
>  - reset-gpios: GPIO to be used to reset the whole device
> +- sgmii-delay: Boolean, presence delays SGMII clock by 2ns
> +- sgmii-mode: String, operation mode of the SGMII interface.
> +  Supported values are: "basex", "mac", "phy".

Either these should be common properties and documented in a common 
spot or they need vendor prefixes. They seem like they former to me 
(though 'sgmii-delay' would need to be more general and take a time).

Rob
