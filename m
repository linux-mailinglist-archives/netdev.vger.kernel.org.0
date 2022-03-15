Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7EA4D9DB6
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349314AbiCOOfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349180AbiCOOf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:35:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC4314019;
        Tue, 15 Mar 2022 07:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eJsfs1ayMlkHRMVaZjiTJvsea1SB/3jhR8tU9VpMC4Q=; b=noTAN4Ep6VH8aqKxHHTygbvmc3
        GAYZ0uSnZPDa80wL00A9Zed3nWWcHfqGIg9dZwNZK8THRjMmQEaGn/qaPmrGvepVa2eMBhZWPw+gk
        CEKltoMLGKEa7cfbM0Qh4V6h0cdlEg5sjMhW/5xlJIyKMn/e6+g6WVJily/0hvNVFpos=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nU8FH-00Aybj-Jz; Tue, 15 Mar 2022 15:33:55 +0100
Date:   Tue, 15 Mar 2022 15:33:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/8] pinctrl: mvebu: pinctrl driver for 98DX2530 SoC
Message-ID: <YjCj07kxGh8n45GE@lunn.ch>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-5-chris.packham@alliedtelesis.co.nz>
 <04ed13f1-671f-7416-61d0-0bf452ae862e@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ed13f1-671f-7416-61d0-0bf452ae862e@canonical.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static struct platform_driver ac5_pinctrl_driver = {
> > +	.driver = {
> > +		.name = "ac5-pinctrl",
> > +		.of_match_table = of_match_ptr(ac5_pinctrl_of_match),
> 
> of_match_ptr() does not look correct for OF-only platform. This should
> complain in W=1 compile tests on !OF config.

The Marvell family of SoC which this embedded SoC borrows HW blocks
from can boot using ACPI. I doubt anybody would boot this particularly
SoC using ACPI, but the drivers Chris copied probably do build !OF for
when ACPI is in us.

     Andrew
