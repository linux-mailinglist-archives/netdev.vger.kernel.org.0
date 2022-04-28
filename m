Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DAC513385
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 14:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346151AbiD1MYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 08:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346140AbiD1MYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 08:24:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4514822BC3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 05:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5+Lq/NDQo/x/y4UMLoiISDBIJiIKMRhXgnKhy9Dy+ig=; b=nTVkl41oU7+WfOM5RXDl68Ejid
        xBL3oEne5T39Xm3JxMQjLLrZOMFriPrRVPXIXwVQlq238O/8dSiyIL3rfzTl87nmcMqbJJs64HROM
        DpxrOrgUuGJVwAl0J1w1i2CJ40OhfebhDPLYjoAMhdK97nB1hSVCL5cJH6UAubRRhnFk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nk398-000IRt-Cj; Thu, 28 Apr 2022 14:21:22 +0200
Date:   Thu, 28 Apr 2022 14:21:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 2/3] net: phy: adin: add support for clock output
Message-ID: <YmqGwjGt/Fbeu2kJ@lunn.ch>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-3-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428082848.12191-3-josua@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin_config_clk_out(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	const char *val = NULL;
> +	u8 sel = 0;
> +
> +	device_property_read_string(dev, "adi,phy-output-clock", &val);
> +	if(!val) {

I'm pretty sure the coding style requires a space between if and (.

Did you use checkpatch on this?

    Andrew
