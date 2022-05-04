Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7839751B121
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349543AbiEDVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378877AbiEDVjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:39:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ED949FA6;
        Wed,  4 May 2022 14:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=6d2C22GP1N4bE5JwOJ8qY5ddIY+8LBhEhE6OWI1tQX8=; b=XU
        ps/Jn9hVqM/U8Qlnq71Ae0KSkWr3SpP60ImvIvBCPnvX+RZosfzWGrdU1yL61ZQBcnGuRP6YTkKFd
        LeluSK8CdL4T/cPxl9e5cidPrsgWQInSB5ZkBHCBtSkIDix0k3LUmL0j/k84jKsL7eO4azc0boVSC
        O55/drl9PfrX3JM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmMf9-001GT7-DU; Wed, 04 May 2022 23:35:59 +0200
Date:   Wed, 4 May 2022 23:35:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, atenart@kernel.org,
        thomas.petazzoni@free-electrons.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <YnLxv8PbDyBE1ODa@lunn.ch>
References: <20220504043603.949134-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220504043603.949134-1-chris.packham@alliedtelesis.co.nz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 04:36:02PM +1200, Chris Packham wrote:
> Convert the marvell,orion-mdio binding to JSON schema.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     Thomas, Antione & Florian I hope you don't mind me putting you as
>     maintainers of the binding. Between you you've written the majority of
>     the mvmdio.c driver.

I actually think it will be me doing any maintenance work on that
driver.

>     This does throw up the following dtbs_check warnings for turris-mox:
>     
>     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: switch0@10:reg: [[16], [0]] is too long
>             From schema: Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml

I assume this is coming from

		reg = <0x10 0>;

This is odd. Lets see what Marek Behún has to say.

     Andrew
