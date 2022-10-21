Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C533D607C2E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJUQ0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJUQ0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:26:34 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1EB285284
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 09:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QZGdlcoUUHPP5FAgWDqiVqSxuSy7w9+EomKL+IXv/as=; b=wRiRQ6Kv2kLmfoZ7pYzS4NPmce
        timeXQwAshEaAlOTL+TRAZJahzJVXZxCX5hibhxpBwzT3ic41vWaZmgVnEXNWHoslkmTYL5edgkQa
        PYYY2a8gsaNFMtwNEx+Tb41GGA9aroQqHTJRV9xlGaM4LndTA+vg/19trCjRP9ZSVZtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oluD0-000FM3-Mx; Fri, 21 Oct 2022 17:45:18 +0200
Date:   Fri, 21 Oct 2022 17:45:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] net: sfp: ignore power level 2 prior to
 SFF-8472 Rev 10.2
Message-ID: <Y1K+jl4diOHG5OFk@lunn.ch>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
 <E1ol97w-00EDSd-CI@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ol97w-00EDSd-CI@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:28:56PM +0100, Russell King (Oracle) wrote:
> Power level 2 was introduced by SFF-8472 revision 10.2. Ignore
> the power declaration bit for modules that are not compliant with
> at least this revision.
> 
> This should remove any spurious indication of 1.5W modules.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
