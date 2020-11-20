Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB71A2B9F72
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKTAwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:52:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgKTAwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 19:52:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfuew-0082MN-He; Fri, 20 Nov 2020 01:52:18 +0100
Date:   Fri, 20 Nov 2020 01:52:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     lkp@intel.com, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v10 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Message-ID: <20201120005218.GX1804098@lunn.ch>
References: <cover.1605830552.git.pavana.sharma@digi.com>
 <e4c8097e78a3277a7ac90d6a4899b110657b13bc.1605830552.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4c8097e78a3277a7ac90d6a4899b110657b13bc.1605830552.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:25:01AM +1000, Pavana Sharma wrote:
> Add 5gbase-r PHY interface mode.
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index fdf709817218..aa6ae7851de9 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -89,6 +89,8 @@ properties:
>        - trgmii
>        - 1000base-x
>        - 2500base-x
> +      # 5GBASE-R
> +      - 5gbase-r
>        - rxaui
>        - xaui

Since you are respinning anyway. What value does the comment add?

      Andrew
