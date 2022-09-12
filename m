Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25895B63C3
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiILWeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiILWeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:34:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD82626557;
        Mon, 12 Sep 2022 15:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PZcE42H0CL/2nnqpWQz9tnJsL8lOemx/gpQykn8JVCM=; b=Y9Xp4OmrzrXl/TgSMCumEwYV3C
        DbkjRRtHpLSOuJmPpmGbysOB695l4L0NU5s8aaH3OE31Y1d6NTLtkvWZRPeB9tEo/GRkQDMhOp6rj
        dS32jXl3SSLyYiz21BiU7PFOAUMQeHQBaAv9CeQUW5S3OYEQTIF1g8ILAvGOmUldQStY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXs06-00GX0g-Bw; Tue, 13 Sep 2022 00:33:58 +0200
Date:   Tue, 13 Sep 2022 00:33:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <Yx+z1gbdNuNM8scD@lunn.ch>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 10:26:12PM +0900, Yoshihiro Shimoda wrote:
> Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
> ethernet controller.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/Kconfig          |   11 +
>  drivers/net/ethernet/renesas/Makefile         |    4 +
>  drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  154 ++
>  drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   71 +

Please split PTP into a patch of its own, and Cc: the PTP maintainer.

       Andrew
