Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C632D5F0BCA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiI3MhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiI3MhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:37:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48A92A436
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 05:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n/FJayw5FtkOihMhhl69GB6MI1bsY5C25Rgwi5Mwrvo=; b=GeHAXgIqr5w7tUPzM2jIUpw1mn
        4bJyhhWtvW8wFYEgDV7DoB84MJBZzpe3eKCqcRN6pK7uZl55WFS0s56zfQyU29yf5a+NnU/+2cEFS
        KebwEnUkBUmwwLYPvcjaHXaQkSSOAGFcX0L8YKDWVZUsOPiju9ffQzS/ilpgnslPhePc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oeFG3-000hly-O7; Fri, 30 Sep 2022 14:36:47 +0200
Date:   Fri, 30 Sep 2022 14:36:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <Yzbi335GQGbGLL4k@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch>
 <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch>
 <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch>
 <Yzan3ZgAw3ImHfeK@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yzan3ZgAw3ImHfeK@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yeah, I tend to agree here. I believe that phylib should probably find a
> separate way to to the flash.
> 
> But perhaps it could be a non-user-facing flash. I mean, what if phylib
> has internal routine to:
> 1) do query phy fw version
> 2) load a fw bin related for this phy (easy phy driver may provide the
> 				       path/name of the file)
> 3) flash if there is a newer version available

That was my first suggestion. One problem is getting the version from
the binary blob firmware. But this seems like a generic problem for
linux-firmware, so maybe somebody has worked on a standardised header
which can be preppended with this meta data?

      Andrew
