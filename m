Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A602D4E9B
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgLIXQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:16:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728403AbgLIXQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:16:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn8fw-00B8L0-3O; Thu, 10 Dec 2020 00:15:12 +0100
Date:   Thu, 10 Dec 2020 00:15:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v11 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Message-ID: <20201209231512.GF2649111@lunn.ch>
References: <cover.1607488953.git.pavana.sharma@digi.com>
 <0537d23a6178c8507f3fda2ab8e0140b6117ef74.1607488953.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0537d23a6178c8507f3fda2ab8e0140b6117ef74.1607488953.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 03:03:47PM +1000, Pavana Sharma wrote:
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

Hi Pavana

For v10 i said:

> What value does the comment add?

I don't remember you replying. Why is 5gbase-r special and it needs a
comment, saying the same thing in CAPS LETTERS? What value is there in
the CAPS LETTERS string?

Thanks
	Andrew
