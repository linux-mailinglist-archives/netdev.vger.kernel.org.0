Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E5F6EF66C
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbjDZO3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbjDZO3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:29:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984774EE8;
        Wed, 26 Apr 2023 07:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eJ6kU9377LEtzb94GNpF+uPP087SBNoxlzn9ZJOuDwY=; b=OwvBcSq65JERkQeqoL6gcvtSJF
        C+DbcZyLHGx50klrTZiKhqU6EqBBNih9g6DU3v/6vlVoIlF2X4PWNDGbVYYip+Cm78KJsj3BwITxJ
        Z28nUHAXj2hODT1zLA4subiFl6ILSqQPGdMGdkZ1OZoOGUpi+u6ReQmvgNrK/Sbpn6DA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prg95-00BHWN-ED; Wed, 26 Apr 2023 16:29:23 +0200
Date:   Wed, 26 Apr 2023 16:29:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Frank <Frank.Sae@motor-comm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v1 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
Message-ID: <fef3aed8-b664-4d36-94f5-266cea4c57a7@lunn.ch>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
 <20230426063541.15378-2-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426063541.15378-2-samin.guo@starfivetech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 02:35:40PM +0800, Samin Guo wrote:
> The motorcomm phy (YT8531) supports the ability to adjust the drive
> strength of the rx_clk/rx_data, the value range of pad driver
> strength is 0 to 7.
> 
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../devicetree/bindings/net/motorcomm,yt8xxx.yaml      | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> index 157e3bbcaf6f..e648e486b6d8 100644
> --- a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> @@ -18,6 +18,16 @@ properties:
>        - ethernet-phy-id4f51.e91a
>        - ethernet-phy-id4f51.e91b
>  
> +  rx-clk-driver-strength:
> +    description: drive strength of rx_clk pad.
> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
> +    default: 3

What do the numbers mean? What are the units? mA?

     Andrew
