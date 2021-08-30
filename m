Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B333FB8C0
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbhH3PGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:06:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48672 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237471AbhH3PGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 11:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=bL28JptUtAL4Jouyvz4ajT1BB84wg50lUMYs9+7LAQ8=; b=P5
        LbcUcU0pSZph2xB8UOOyvAk+j1U+gMY+is0vQHHJG79odnEogPiUJCWiamoPuaOqQzSNzCnIYdmQo
        J5XyPUKkepBoCS6OJVjyd75TcIQ/tLeUUWArIfi1EI99mTlupPENa9AoFO7M8qZStIX96B+MyXJL9
        VW8SyMx8CLV8s3E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mKiqm-004aHV-6G; Mon, 30 Aug 2021 17:05:28 +0200
Date:   Mon, 30 Aug 2021 17:05:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?Q2zDqW1lbnQgQsWTc2No?= <u@pkh.me>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Willy Liu <willy.liu@realtek.com>, netdev@vger.kernel.org,
        linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Subject: Re: sunxi H5 DTB fix for realtek regression
Message-ID: <YSzzuDvd1fWXxcAb@lunn.ch>
References: <YSwr6YZXjNrdKoBZ@ssq0.pkh.me>
 <YSziXfll/p/5OrOv@lunn.ch>
 <YSzsmy1f2//NNzXm@ssq0.pkh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YSzsmy1f2//NNzXm@ssq0.pkh.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> See attached patch, heavily based on other commits.

Looks good.

You need to add a Signed-off-by: See

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

Patches need to be in the body of the email, not attachments.

You can use scripts/get_maintainers.pl to get a list of people to send
it to. I would use To: for
Maxime Ripard <mripard@kernel.org> (maintainer:ARM/Allwinner sunXi SoC support)
Chen-Yu Tsai <wens@csie.org> (maintainer:ARM/Allwinner sunXi SoC support)
Jernej Skrabec <jernej.skrabec@gmail.com> (reviewer:ARM/Allwinner sunXi SoC support)

and Cc: for the rest.

> Note: running `git grep 'phy-mode\s*=\s*"rgmii"' arch` shows that it might
> affect other hardware as well.

"rgmii" can be correct. So you need to narrow your search.

> I don't know how one is supposed to check
> that, but I would guess at least sun50i-a64-nanopi-a64.dts is affected (a
> quick internet search shows that it's using a RTL8211E¹)

This seems reasonable. You could provide a second patch for this.

     Andrew
