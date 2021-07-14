Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679CA3C945C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 01:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbhGNXWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 19:22:34 -0400
Received: from mail-il1-f169.google.com ([209.85.166.169]:41770 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGNXWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 19:22:33 -0400
Received: by mail-il1-f169.google.com with SMTP id p3so3260225ilg.8;
        Wed, 14 Jul 2021 16:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TdiVnL9TCdV9D90wyycXpqb6/XoNPPRyQNze/q/HwxQ=;
        b=cMjpjAo4w51CMuO7tZaA27M/imXEmgp1Tar9ial6P32KhyZPaGy/3sCvnhG6sQ4aGC
         1DkEyTumkmNQ7T78zvEec5zxs0RYEAQyw9ymjFdqUH1UHA06ETwIE4UMzklRGc4N6PbA
         OlsyzXr45De/RBNgirb699mWe/KuYkU8OFliQ7u3c4L+litfTGeBKsEUm72e++vpkef5
         zra9Ah2mTQZvpshQjVyeNd+6S8YX6oxRn2R3lA7B3xNgfByz+UxTsy8Lnq/RGyDSn3mE
         SFeP/KORP5wtthb5c54Nl5XaR97J3Tt8GOpRdbgd0DPNA7dQTXyOTC444C8uUk3alE1w
         abWA==
X-Gm-Message-State: AOAM5332SwdUePqnzijavXmwRhQYiKNWEgYUvtCrBVSFKpIbMs8ojeRi
        r5rjQAdC97LxXDc7lnnMEg==
X-Google-Smtp-Source: ABdhPJy8135iVbf+1sCQN0Ze0x/1KSuu7VpqGJi9LWy/q1N7Mh9sLN19a2m1kusfK+SNbbf2ECYgKg==
X-Received: by 2002:a05:6e02:1d8d:: with SMTP id h13mr219264ila.40.1626304780647;
        Wed, 14 Jul 2021 16:19:40 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l5sm1799552ilv.38.2021.07.14.16.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 16:19:40 -0700 (PDT)
Received: (nullmailer pid 3729159 invoked by uid 1000);
        Wed, 14 Jul 2021 23:19:37 -0000
Date:   Wed, 14 Jul 2021 17:19:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V1 net-next 2/5] dt-bindings: fec: add RGMII delayed
 clock property
Message-ID: <20210714231937.GC3723991@robh.at.kernel.org>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
 <20210709081823.18696-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709081823.18696-3-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 04:18:20PM +0800, Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> Add property for RGMII delayed clock.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl-fec.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
> index 6754be1b91c4..f93b9552cfc5 100644
> --- a/Documentation/devicetree/bindings/net/fsl-fec.txt
> +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
> @@ -50,6 +50,10 @@ Optional properties:
>      SOC internal PLL.
>    - "enet_out"(option), output clock for external device, like supply clock
>      for PHY. The clock is required if PHY clock source from SOC.
> +  - "enet_2x_txclk"(option), for RGMII sampleing clock which fixed at 250Mhz.
> +    The clock is required if SOC RGMII enable clock delay.
> +- fsl,rgmii_txc_dly: add RGMII TXC delayed clock from MAC.
> +- fsl,rgmii_rxc_dly: add RGMII RXC delayed clock from MAC.

Don't we have standard properties for this?

>  
>  Optional subnodes:
>  - mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
> -- 
> 2.17.1
> 
> 
