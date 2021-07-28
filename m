Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618B63D973A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhG1VJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:09:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhG1VJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 17:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/xnBegR0F+yMxCaBZOU6JUie42gaSmYznktbC9YyS/U=; b=mL+8+I7erydnR/5bJmhHrOaosJ
        5ioDF35tJlGbLLpHAkXDRGIbb2xu/IClrTDcE7Wl/j01cvWlodMTcugvtqgYxfOI7Yb54nds0Z50r
        vZfk28QRT5Xrf0bAakfyxd3X+nk0AkpJqOwiZ6w2XOcBFim4qXMVVD7estjOgdNZYYEY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8qo4-00FEcN-OQ; Wed, 28 Jul 2021 23:09:36 +0200
Date:   Wed, 28 Jul 2021 23:09:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YQHHkFLx4PW0vttJ@lunn.ch>
References: <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
 <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
 <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
 <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I did notice that the RJ45 link LED on each of the peer devices no longer
> light up. Previously, the LED was coming on. Perhaps it's time to check the
> following:
> 
> - confirm the network cable for each link peer is good
> - confirm each link peer works by connecting to a 100baseT or 1000baseT
> switch

ethtool --cable-test lan1

Needs a reasonably modern kernel and ethtool :-)

And i don't know if the internal PHYs in that switch actually support
it, and the PHY driver has the needed callbacks for that PHY model.

      Andrew
