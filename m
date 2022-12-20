Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F666529E7
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiLTXfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbiLTXf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:35:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A571FF8D;
        Tue, 20 Dec 2022 15:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Et1XQAkk8Burzuw1hwryUWC1PbUtGtsyxLGWsj9/DEU=; b=NXewspVxBWnDAjUPwCXoEUwj28
        dAXIC6lMG1ddfM/F7DA4iZ7ks+0p9XfS9NgcgmosGfk4Hm9Wh+oteMfLYTnlMIwFdsrXDoTgeZVRt
        8kQOxuWTjco8oHg7jfU71I74q3Ms+um/Li4zKYXxkxEtT2+HJEBTG7L+tZTdFQ5J9jOs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7m8i-0008Do-AO; Wed, 21 Dec 2022 00:35:16 +0100
Date:   Wed, 21 Dec 2022 00:35:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH v7 01/11] leds: add support for hardware driven LEDs
Message-ID: <Y6JGtC5XFRKdZq1t@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-2-ansuelsmth@gmail.com>
 <Y5tHjwx1Boj3xMok@shell.armlinux.org.uk>
 <639ca0a4.050a0220.99395.8fd3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639ca0a4.050a0220.99395.8fd3@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 05:45:25PM +0100, Christian Marangi wrote:
> On Thu, Dec 15, 2022 at 04:13:03PM +0000, Russell King (Oracle) wrote:
> > Hi Christian,
> > 
> > Thanks for the patch.
> > 
> > I think Andrew's email is offline at the moment.
> >
> 
> Notice by gmail spamming me "I CAN'T SEND IT AHHHHH"
> Holidy times I guess?

That was part of the problem. Away travelling when foot gun hit foot,
and i didn't have access to the tools to fix it while away.

    Andrew
