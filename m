Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB894547C70
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiFLVZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiFLVZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:25:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383CF23BD6
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UOU8U2cr9MIeqk7OLy0ZfsQMSvQiaOQ/SmdmIF+ICNE=; b=VN1ymvCU7074HzRHOJiedcN4o0
        RnuS86BPsNHK/wBdM9yzcJ1IMJC1RDIgWYo+IlwLd+mGCqXHdjjE4KvjNAoEVAI7l0v78bi9gYHVj
        T8KMXXjhSvDNbYLAe5Y7zL8s3EQb3sP/jWic5lXKKvfiMi7l6tqYqYluStZtm//iFQgU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o0V51-006ekZ-UI; Sun, 12 Jun 2022 23:25:07 +0200
Date:   Sun, 12 Jun 2022 23:25:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ondrej Spacek <ondrej.spacek@nxp.com>
Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G
 are not advertised
Message-ID: <YqZZs7EAcAFpQpXU@lunn.ch>
References: <20220610084037.7625-1-claudiu.manoil@nxp.com>
 <YqSt5Rysq110xpA3@lunn.ch>
 <AM9PR04MB8397DF04A87E32E6B7E690E096A99@AM9PR04MB8397.eurprd04.prod.outlook.com>
 <YqUjUQLOHUo55egO@lunn.ch>
 <AM9PR04MB8397DE1463E47F5AF8574A5F96A89@AM9PR04MB8397.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB8397DE1463E47F5AF8574A5F96A89@AM9PR04MB8397.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I understand the situation is not ideal. What I could do is to provide some
> logs showing that writing the correct configuration to 7.20h does not yield
> the desired result, to have some sort of detailed evidence about the issue.
> But I cannot do that until Tuesday at the earliest.
> As for documentation, there's an App Note about configuring advertising
> via the vendor specific 0xC400 reg but I don't think it's public. Not sure if
> we can use that.
> Meanwhile, it would be great if you or someone else could confirm the
> issue on a different platform.

I don't have any boards with these PHYs.

If there is a vendor document saying it has to be configured via
vendor registers, thats enough for me. But should the generic code be
removed, are those bits documented as reserved?

	 Andrew
