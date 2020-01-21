Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C9A1446AA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgAUVvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:51:12 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41621 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbgAUVvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 16:51:12 -0500
Received: by mail-oi1-f194.google.com with SMTP id i1so4114328oie.8;
        Tue, 21 Jan 2020 13:51:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AEQJRf11+YL9JXYSw6iHmQvhDVGvtOeS/QzZTm+s+dQ=;
        b=CjnY07CdXfT6Gm1dCxUDz/1qKHwjnrkOPqO5H+8FjMr/zNErX7oMznmDTH5ok8SpMG
         UOHgtTXuVMJ6To+BHaRFmZaAlRIbzf1Gy+HvQm3SEXEul8x7l/7ZIn60lSvCrEJamOyK
         Hg8L1ZDMn2zQnl+axkRme7zYzaioC7Hbl6YfQGg3C8AeL3Ak3yJ/go5f5+O6YUhCOppA
         EEe136tX7v1sy2Pec4GhDaUMYa+DKdZqLLmcTppZ38YTpUQvCIG+Nkm0Edpo9KZYttJ4
         8tr9NLqgBYqjLhLeqYh8MKoiw6xhMqb+TXfBZm5ZGKTQiFx1myPzNRSF9Xn9ah2vFd97
         OOHQ==
X-Gm-Message-State: APjAAAXsRPx/9aRZ1vcRCp1fCZ7aMulTNAL74rooeSMN0DXtRildiRtl
        KZoGwLe8018ETbkGGiXZTg==
X-Google-Smtp-Source: APXvYqxt+cM62E+IOf/zYUPLo7beaXVus7wbv8PxvBfk1MeN6W4PybVQtCjZ0vKTYkCKN5s+jFsOCg==
X-Received: by 2002:aca:59c2:: with SMTP id n185mr4708096oib.170.1579643471112;
        Tue, 21 Jan 2020 13:51:11 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k17sm4031953otl.45.2020.01.21.13.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 13:51:10 -0800 (PST)
Received: (nullmailer pid 509 invoked by uid 1000);
        Tue, 21 Jan 2020 21:51:09 -0000
Date:   Tue, 21 Jan 2020 15:51:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 14/14] net: axienet: Update devicetree binding
 documentation
Message-ID: <20200121215109.GA26808@bogus>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-15-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110115415.75683-15-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:54:15AM +0000, Andre Przywara wrote:
> This adds documentation about the newly introduced, optional
> "xlnx,addrwidth" property to the binding documentation.
> 
> While at it, clarify the wording on some properties, replace obsolete
> .txt file references with their new .yaml counterparts, and add a more
> modern example, using the axistream-connected property.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  .../bindings/net/xilinx_axienet.txt           | 57 ++++++++++++++++---
>  1 file changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index 7360617cdedb..78c278c5200f 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -12,7 +12,8 @@ sent and received through means of an AXI DMA controller. This driver
>  includes the DMA driver code, so this driver is incompatible with AXI DMA
>  driver.
>  
> -For more details about mdio please refer phy.txt file in the same directory.
> +For more details about mdio please refer to the ethernet-phy.yaml file in
> +the same directory.
>  
>  Required properties:
>  - compatible	: Must be one of "xlnx,axi-ethernet-1.00.a",
> @@ -27,14 +28,14 @@ Required properties:
>  		  instead, and only the Ethernet core interrupt is optionally
>  		  specified here.
>  - phy-handle	: Should point to the external phy device.
> -		  See ethernet.txt file in the same directory.
> -- xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
> +		  See the ethernet-controller.yaml file in the same directory.
> +- xlnx,rxmem	: Size of the RXMEM buffer in the hardware, in bytes.
>  
>  Optional properties:
> -- phy-mode	: See ethernet.txt
> +- phy-mode	: See ethernet-controller.yaml.
>  - xlnx,phy-type	: Deprecated, do not use, but still accepted in preference
>  		  to phy-mode.
> -- xlnx,txcsum	: 0 or empty for disabling TX checksum offload,
> +- xlnx,txcsum	: 0 for disabling TX checksum offload (default if omitted),
>  		  1 to enable partial TX checksum offload,
>  		  2 to enable full TX checksum offload
>  - xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
> @@ -48,10 +49,20 @@ Optional properties:
>  		       If this is specified, the DMA-related resources from that
>  		       device (DMA registers and DMA TX/RX interrupts) rather
>  		       than this one will be used.
> - - mdio		: Child node for MDIO bus. Must be defined if PHY access is
> +- mdio		: Child node for MDIO bus. Must be defined if PHY access is
>  		  required through the core's MDIO interface (i.e. always,
>  		  unless the PHY is accessed through a different bus).
>  
> +Required properties for axistream-connected subnode:
> +- reg		: Address and length of the AXI DMA controller MMIO space.
> +- interrupts	: A list of 2 interrupts: TX DMA and RX DMA, in that order.
> +
> +Optional properties for axistream-connected subnode:
> +- xlnx,addrwidth: Specifies the configured address width of the DMA. Newer
> +		  versions of the IP allow setting this to a value between
> +		  32 and 64. Defaults to 32 bits if not specified.

I think this should be expressed using dma-ranges. This is exactly the 
purpose of dma-ranges and we shouldn't need a device specific property 
for this sort of thing.

Rob
