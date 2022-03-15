Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB24D90DF
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244294AbiCOAJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiCOAJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:09:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232E812AD4;
        Mon, 14 Mar 2022 17:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hjc1wSULAHmSnqSWyk1Jh6G8h6LbSfqbgChoiSOzNYY=; b=wYcFHObBr4e8N5sHddrfmp8wtN
        nSDS3Q+J59ltMaK6iPh77q/yxGiv48RYeQP9VasRwTwu/SDGiC1AjEQbK92rcB7LIper4E/8Ld6zG
        Gm2ieJxKqtsLsq4SEJi5+RxmISylGLiSYFBwM+WgqRlDtQN/dDs2Mmus69tGQsXqj12M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTuj4-00ApuJ-St; Tue, 15 Mar 2022 01:07:46 +0100
Date:   Tue, 15 Mar 2022 01:07:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/8] dt-bindings: pinctrl: mvebu: Document bindings
 for AC5
Message-ID: <Yi/Y0iynQbIOo8C0@lunn.ch>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-2-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314213143.2404162-2-chris.packham@alliedtelesis.co.nz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +    properties:
> +      marvell,function:
> +        $ref: "/schemas/types.yaml#/definitions/string"
> +        description:
> +          Indicates the function to select.
> +        enum: [ gpio, i2c0, i2c1, nand, sdio, spi0, spi1, uart0, uart1, uart2, uart3 ]
> +
> +      marvell,pins:
> +        $ref: /schemas/types.yaml#/definitions/string-array
> +        description:
> +          Array of MPP pins to be used for the given function.
> +        minItems: 1

Now that i've looked at the .txt files, i'm wondering if this should
be split into a marvell,mvebu-pinctrl.yaml and
marvell,ac5-pinctrl.yaml?

I don't know yaml well enough to know if this is possible. All the
mvebu pinctrl drivers have marvell,function and marvell,pins. The enum
will differ, this ethernet switch SoC does not have sata, audio etc,
where as the general purpose Socs do. Can that be represented in yaml?

      Andrew
