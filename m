Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5375149B9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359374AbiD2Mtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiD2Mta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:49:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256E59233F;
        Fri, 29 Apr 2022 05:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aRHhn40DzoM9Zivc1Yu4592Ged4ObaQxjXEhmGCOPfQ=; b=NCJkw2QvDPbR3jyHG3NIsEEFBy
        6SVKaRx2o/cAk0cMzQRz+GjdWJOC6Uq9kukTcRIVSakfXOuu08y6Pn+yFwtPpc0ZUPE0l+aVJMlcQ
        5OPOrOV9lFedeTtH3L/+J2C3PJdKiUIaH7gAtu6PcVKvwoaUtWTRKQPjs5pbs19M5wKc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkQ0U-000TrR-4D; Fri, 29 Apr 2022 14:45:58 +0200
Date:   Fri, 29 Apr 2022 14:45:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: lan966x: remove PHY reset support
Message-ID: <YmveBgHG9KCwvySO@lunn.ch>
References: <20220428114049.1456382-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428114049.1456382-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 01:40:47PM +0200, Michael Walle wrote:
> Remove the unneeded PHY reset node as well as the driver support for it.
> 
> This was already discussed [1] and I expect Microchip to Ack on this
> removal. Since there is no user, no breakage is expected.
> 
> I'm not sure it this should go through net or net-next and if the patches
> should have a Fixes: tag or not. In upstream linux there was never any user
> of it, so there is no bug to be fixed. But OTOH if the schema fix isn't
> backported, then there might be an older schema version still containing
> the reset node. Thoughts?

Is the switch driver usable in the last LTS kernel? Somebody could
build a product around 5.15, and i assume they will have issues?

That could be an argument for backporting.

      Andrew
