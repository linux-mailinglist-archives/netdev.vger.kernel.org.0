Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0753C9459
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 01:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhGNXWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 19:22:09 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:41666 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGNXWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 19:22:09 -0400
Received: by mail-io1-f44.google.com with SMTP id z9so4166298iob.8;
        Wed, 14 Jul 2021 16:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LUNUFAcQQ4LrGddTIzbrZj64GBEysZ0p5i9HgiQ2feM=;
        b=YaB18uRtJPmzE4ZfbyadSg8VIt4bUwEQu276476Q/tz0Q+1RNEoJRW2ST5BGJwTGSp
         BZN5hHnVHmzrFFbvgKUsMqJxGklVceCLAHVY8iFidWtMh/5h9XLIUu9q3aiy9YTS+GHo
         MXflThnEYA7WxhBsWTF11mdADwoYkV8KepKrfbxTBLtx1G2BIoNPa8cRV4+1dS5nDh12
         7LkUA2jaV0HuEnX/ZwlqMxMGQIjWuXt8yegHvUxwUXr2/Te+oWkG+vmUKFKVqC4GPOKg
         cLtuYg61zsf58ROGNS6+TXjmcNlSBCWI4rTyzOYIKgxQ3KAYA5Bet5AYXmpZEedpSFr6
         wO5Q==
X-Gm-Message-State: AOAM530wzOkY443ckHy7PtiUQ4Ol2dk6ioGOp6nRdocWWg9OwtfRNOVP
        CYp6JJB4V7+klYR4rw/cDw==
X-Google-Smtp-Source: ABdhPJy/69WQBHLT9ogwSA9q9WOw3l1R1cYbsqmu0BTIxrfO0u5TwUQtuGN1eJPoyFrOOb0ekTYMEg==
X-Received: by 2002:a6b:1406:: with SMTP id 6mr425321iou.25.1626304756597;
        Wed, 14 Jul 2021 16:19:16 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id p10sm1899691ilh.57.2021.07.14.16.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 16:19:16 -0700 (PDT)
Received: (nullmailer pid 3728562 invoked by uid 1000);
        Wed, 14 Jul 2021 23:19:14 -0000
Date:   Wed, 14 Jul 2021 17:19:14 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V1 net-next 1/5] dt-bindings: fec: add the missing clocks
 properties
Message-ID: <20210714231914.GB3723991@robh.at.kernel.org>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
 <20210709081823.18696-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709081823.18696-2-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 04:18:19PM +0800, Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> Both driver and dts have already used these clocks properties, so add the
> missing clocks info.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl-fec.txt | 11 +++++++++++
>  1 file changed, 11 insertions(+)

There's enough changes in this series, please convert this to schema.

> 
> diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
> index 9b543789cd52..6754be1b91c4 100644
> --- a/Documentation/devicetree/bindings/net/fsl-fec.txt
> +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
> @@ -39,6 +39,17 @@ Optional properties:
>    tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
>    For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
>    per second interrupt associated with 1588 precision time protocol(PTP).
> +- clocks: Phandles to input clocks.
> +- clock-name: Should be the names of the clocks
> +  - "ipg", for MAC ipg_clk_s, ipg_clk_mac_s that are for register accessing.
> +  - "ahb", for MAC ipg_clk, ipg_clk_mac that are bus clock.
> +  - "ptp"(option), for IEEE1588 timer clock that requires the clock.
> +  - "enet_clk_ref"(option), for MAC transmit/receiver reference clock like
> +    RGMII TXC clock or RMII reference clock. It depends on board design,
> +    the clock is required if RGMII TXC and RMII reference clock source from
> +    SOC internal PLL.
> +  - "enet_out"(option), output clock for external device, like supply clock
> +    for PHY. The clock is required if PHY clock source from SOC.
>  
>  Optional subnodes:
>  - mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
> -- 
> 2.17.1
> 
> 
