Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553974A9D54
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376727AbiBDRE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:04:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236336AbiBDRE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 12:04:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xzbIZkKNfNZlOnpceTUufYPgNrcPtbnsWdhukx8SdZA=; b=RWvrBVoQ/TBWtCOKIqFcnXFch7
        1iJRaG+XfrQSIE9uOga41M8yeYo2iiDpYWr7lodRrP3RIG8HOBNo0I60+zhdMqJz3SGsF5VOFaCed
        KFvZRLA6MUY5NUsJ4nyHTljzsHYZocROGQXzV9/d0oTHS852su/P1EUFPhdRtNsCJn78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nG20W-004IQj-Jg; Fri, 04 Feb 2022 18:04:24 +0100
Date:   Fri, 4 Feb 2022 18:04:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY
 support
Message-ID: <Yf1cmDw3RN1ul6Av@lunn.ch>
References: <20220204133635.296974-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220204133635.296974-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <Yf0ykctMgWKswgpC@lunn.ch>
 <526221306.489515.1643987866650.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526221306.489515.1643987866650.JavaMail.zimbra@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You can probably use PHY_ID_MATCH_EXACT().
> 
> Thank you for your feedback! The rest of the driver always uses
> this style instead of PHY_ID_MATCH_EXACT().

You could add another patch converting them. It looks like some could
also use PHY_ID_MATCH_MODEL(). Up to you, depending on how much time
you want to spend on this.

      Andrew
