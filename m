Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E635BDCFF
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 08:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiITGSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 02:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiITGSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 02:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867B15A144;
        Mon, 19 Sep 2022 23:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25F00B824BA;
        Tue, 20 Sep 2022 06:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9D0C433D6;
        Tue, 20 Sep 2022 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663654727;
        bh=epqbAQDzi7Y6+cm6VeGS22oyH/dSpFcCuaaWXgHqNJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVXo7WCR3E7LtLBJE/xVIcQLPe0oweis9AVS1Pq01bkzPt8XR9qfzp2yc4dHok0QJ
         BHu0sR8eY1dmRxE3A0a0I9YqxSAJ/G0IX6vOYGTXYJhPyR3iAS/2Pocslpuf8FuTzX
         HV6B4I6ABFOVSJrba34IWBx5uz0y5otia7MoZ/as4ToItVYA7SZdE3p61NdexLm0Cm
         G5yUUGy9XZ6UZUHp99hklIdL6G3tQ5EmGZ2s+Kx/REpdZLngtdC6OKUi8W9w3r8KqT
         KKvJE2GMSEmDb+z/bIVr69Ry2FnAbMUjIDzIfLI6EcVYN6IbO+LkSJcJ+/A0k2jP06
         E7OtwVh5luI3A==
Date:   Tue, 20 Sep 2022 11:48:44 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] phy: lan966x: add support for QUSGMII
Message-ID: <YylbRBPC+0JAvtQU@matsya>
References: <20220826141722.563352-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826141722.563352-1-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26-08-22, 16:17, Maxime Chevallier wrote:
> Makes so that the serdes driver also takes QUSGMII in consideration.
> It's configured exactly as QSGMII as far as the serdes driver is
> concerned.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> 
> Dear netdev and Generic PHY maintainers,
> 
> This patch should go through the net-next tree instead of the generic
> PHY tree, as it has a dependency on :
> 
> 5e61fe157a27 "net: phy: Introduce QUSGMII PHY mode"
> 
> This commits only lives in the net-next tree as of today.
> 
> Given the simplicity of this patch, would that be OK for you ?


Sure:

Acked-By: Vinod Koul <vkoul@kernel.org>

> 
> Thanks,
> 
> Maxime
> 
>  drivers/phy/microchip/lan966x_serdes.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/phy/microchip/lan966x_serdes.c b/drivers/phy/microchip/lan966x_serdes.c
> index e86a879b92b5..d1a50fa81130 100644
> --- a/drivers/phy/microchip/lan966x_serdes.c
> +++ b/drivers/phy/microchip/lan966x_serdes.c
> @@ -401,6 +401,9 @@ static int serdes_set_mode(struct phy *phy, enum phy_mode mode, int submode)
>  	    submode == PHY_INTERFACE_MODE_2500BASEX)
>  		submode = PHY_INTERFACE_MODE_SGMII;
>  
> +	if (submode == PHY_INTERFACE_MODE_QUSGMII)
> +		submode = PHY_INTERFACE_MODE_QSGMII;
> +
>  	for (i = 0; i < ARRAY_SIZE(lan966x_serdes_muxes); i++) {
>  		if (macro->idx != lan966x_serdes_muxes[i].idx ||
>  		    mode != lan966x_serdes_muxes[i].mode ||
> -- 
> 2.37.2
> 
> 
> -- 
> linux-phy mailing list
> linux-phy@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/linux-phy

-- 
~Vinod
