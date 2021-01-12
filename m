Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308952F379F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbhALRui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:50:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbhALRuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 12:50:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED653230FC;
        Tue, 12 Jan 2021 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610473797;
        bh=fDsLZOS1Gg0wF7ON2jO2gwNE1rsJRlu/lF4AuguhXNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T4N/FA/fizNZpl4cpP+3dyU+hzKAJZKg5QfnVhufVU/d5L+laeauzpCob1pmW9cnq
         JsZrOFGlTZRvHGG89pEMJlRcsnJJ6mRCBQf91095UHg1eFpmMLA5M+SbthOgWDrLiF
         O2n07jsMwR4f3nbOZqnP1uw6LbA8S/0viW+pbQEaswRH3w0aQREsexNyo86NVxq0sz
         3sk/zia4t2ItfG/gmgJSTH+WI9FOCc3HyLCPhakqOmI4kISCKQ87RTxEuI5h+UEuiY
         NTDXXwlj2x2gK2pGlNeT+P8EM4QQBLakGWO8uJtEheptE+qSyUYE3YLtzGPfd9tbAc
         gyIZutNKXABag==
Date:   Tue, 12 Jan 2021 18:49:51 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210112184951.489d11b1@kernel.org>
In-Reply-To: <X/2sCciKK9kVwnog@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
        <20210111050044.22002-2-kabel@kernel.org>
        <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
        <X/2sCciKK9kVwnog@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 15:02:49 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > I'd think that mdio-i2c.c is for generic code. When adding a
> > vendor-specific protocol, wouldn't it make sense to use a dedicated
> > source file for it?  
> 
> Hi Heiner
> 
> There is no standardised way to access MDIO over i2c. So the existing
> code is vendor code, even if it is used by a few different vendors.
> 
>      Andrew

Andrew, if you could find the time, could you please review these
patches? Patches 2 and 4 already have reviewed-by Russell, but 1 and 3
still need some review.

Marek
