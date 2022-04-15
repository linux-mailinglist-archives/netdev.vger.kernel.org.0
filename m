Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F72502C68
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354884AbiDOPPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354869AbiDOPPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:15:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828FCA94D8;
        Fri, 15 Apr 2022 08:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G5odVXCmYv7IxL9XjE1lXTsoDOBab8u1hsAiewC6LXU=; b=r2J75mQ8F4AQGg9k+MGpoR0I3D
        KNYWPoy8LxUbv6rpa5ytd0edhJ/QxThFo8R39jvwhgFP1bMa0C+qUJFPnDfELV8jLJx3UWx3nu5t9
        UjKFfvScRgHwdig2CbsECNwAjO+ymRCaPbPFLfNFAwzUDlYnxebj49epjmNzF9aofNXk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nfNcY-00Fz5H-67; Fri, 15 Apr 2022 17:12:26 +0200
Date:   Fri, 15 Apr 2022 17:12:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <YlmLWv4Hsm2uk8pa@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-10-clement.leger@bootlin.com>
 <YlismVi8y3Vf6PZ0@lunn.ch>
 <20220415102453.1b5b3f77@fixe.home>
 <Yll+Tpnwo5410B9H@lunn.ch>
 <20220415163853.683c0b6d@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415163853.683c0b6d@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok, looks like a more flexible way to doing it. Let's go with something
> like this:
> 
> renesas,miic-port-connection = <PORTIN_GMAC2>, <MAC2>, <SWITCH_PORTC>,
> <SWITCH_PORTB>, <SWITCH_PORTA>;

Not all combinations are possible. In fact, there is a limited choice
for each value. So consider getting the yaml tools to help you by
listing what is valid for each setting. You might need a different
format than. Also, this format it is not clear what each value refers
to.

renesas,miic-port-connection-mii-conv1 = <PORTIN_GMAC2>;
renesas,miic-port-connection-mii-conv2 = <MAC2>;
renesas,miic-port-connection-mii-conv3 = <SWITCH_PORTC>;
renesas,miic-port-connection-mii-conv4 = <SWITCH_PORTB>;
renesas,miic-port-connection-mii-conv5 = <SWITCH_PORTA>;

is more sense documenting, and i suspect easier to make the validator
work for you.

	Andrew
