Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0ED4BECC2
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiBUVor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:44:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiBUVoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:44:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCC922BC6;
        Mon, 21 Feb 2022 13:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WenxZscsM06/+bT/19IGHZEhWMyvVaGW5AQNl0sRgAg=; b=c1Zpoi2CCRTbgsy/twPRazIVDE
        RsaVvwLsNgoYnXukPhUxNayXBYCtgChSG9VOR8/fDcq5RZyrCkh+v11lnHnRe2YnmKtRTFzAR1s/Y
        obF0/aidXb21wf1uaGahKjhyW6T53io0igFHZbNlRQg23achMWsKdIH5wvUMIfJoXO78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMGTY-007Qz4-3N; Mon, 21 Feb 2022 22:44:08 +0100
Date:   Mon, 21 Feb 2022 22:44:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YhQHqDJvahgriDZK@lunn.ch>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162652.103834-1-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This series has been tested on a x86 kernel build without CONFIG_OF.
> Another kernel was also built with COMPILE_TEST and CONFIG_OF support
> to build as most drivers as possible. It was also tested on a sparx5
> arm64 with CONFIG_OF. However, it was not tested with an ACPI
> description evolved enough to validate all the changes.

By that, do you mean a DSD description?

In the DT world, we avoid snow flakes. Once you define a binding, it
is expected every following board will use it. So what i believe you
are doing here is defining how i2c muxes are described in APCI. How
SFP devices are described in ACPI. Until the ACPI standards committee
says otherwise, this is it. So you need to clearly document
this. Please add to Documentation/firmware-guide/acpi/dsd.

      Andrew
