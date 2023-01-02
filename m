Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3986D65B707
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 21:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjABUAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 15:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjABUAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 15:00:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE119766B;
        Mon,  2 Jan 2023 12:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ete+lRG0p6Sm4vnDlyJwGrAaoy/sCpH3Y/5LuvQ9f2k=; b=XOEMfmiDBqmEXK6CnaBcduwOcU
        iwxouwbe4ZXp3SYImFJMCMimMx8yYM11Mu5jwvG4ccE62lPnch659TC2zUK2SHY0TaQvnvZhSVXGR
        wAhYAindFGkFZrpZasCoenleg98cRW9G1K6KjEWav5g4QhqbppakP7iuzMEl3ndm3D4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCQyc-000xcu-Qa; Mon, 02 Jan 2023 21:00:06 +0100
Date:   Mon, 2 Jan 2023 21:00:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH v3 2/3] net: dsa: mv88e6xxx: add support for MV88E6020
 switch
Message-ID: <Y7M3xg0mJhhr8Xg8@lunn.ch>
References: <20230102150209.985419-1-lukma@denx.de>
 <20230102150209.985419-2-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102150209.985419-2-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 04:02:08PM +0100, Lukasz Majewski wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> A mv88e6250 family (i.e. LinkStreet) switch with 2 PHY and RMII ports
> and no PTP support.

>  static const struct mv88e6xxx_info mv88e6xxx_table[] = {
> +	[MV88E6020] = {
> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6020,
> +		.family = MV88E6XXX_FAMILY_6250,
> +		.name = "Marvell 88E6020",
> +		.num_databases = 64,
> +		.num_ports = 7,
> +		.num_internal_phys = 5,

You say in the commit message there are two PHYs, yet you have 5 here?

    Andrew
