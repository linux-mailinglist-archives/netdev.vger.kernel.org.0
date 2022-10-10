Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E95F5FA22C
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 18:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJJQwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 12:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJJQwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 12:52:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420E04B49F;
        Mon, 10 Oct 2022 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1QxMbzayslkAE1FFMCUkmewOyzbrMACaLMR3Ux2vqSU=; b=MUwKN4rNxmFOwMVQ2P0LdFmQh0
        CdCPVdGAJpee59Ei8wFHGD6UBuWKFMiZ2VrJnBPeURURDuPJVcobicUIztKWitAUJrmnzm+tIm9BS
        NZzLWpO1Enqpdk7IDVTjZtB1Dx+pmXKYV5t1u08CMZTKrBGAyh5E6QJ4cF3GGLh08UfY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ohw0X-001dZw-IC; Mon, 10 Oct 2022 18:52:01 +0200
Date:   Mon, 10 Oct 2022 18:52:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Soha Jin <soha@lohu.info>, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: add fwnode_phy_is_fixed_link()
Message-ID: <Y0RNsZUnV0GJqIlO@lunn.ch>
References: <20221009162006.1289-1-soha@lohu.info>
 <Y0Q0P4MlTXmzkJSG@lunn.ch>
 <Y0RLm0qU8MwGt40d@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0RLm0qU8MwGt40d@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 05:43:07PM +0100, Russell King (Oracle) wrote:
> On Mon, Oct 10, 2022 at 05:03:27PM +0200, Andrew Lunn wrote:
> > On Mon, Oct 10, 2022 at 12:20:06AM +0800, Soha Jin wrote:
> > > A helper function to check if PHY is fixed link with fwnode properties.
> > > This is similar to of_phy_is_fixed_link.
> > 
> > You need to include a user of this new function.
> > 
> > Also, not that ACPI only defines the 'new binding' for fixed-link.  If
> > this is being called on a device which is ACPI underneath, it should
> > only return true for the 'new binding', not the old binding.
> 
> Do we want to support the "managed" property in the fwnode variant,
> or persuade people to switch to phylink if they want that?

managed has been documented in
Documentation/firmware-guide/acpi/dsd/phy.rst so i think we need to
support it.

	Andrew
