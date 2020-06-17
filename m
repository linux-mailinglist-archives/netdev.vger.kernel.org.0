Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989FF1FCCDE
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgFQL5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgFQL5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:57:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11945C061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XzAEQto/Af7+9WmajIFHZYz09OvioF7M8FcNyEuPJRQ=; b=SZ20Css2hTFhzfxCsMQev4cWF
        9KTaFgGVr4COvknkeXFQdi/f3GqVAJnKUH0QQtphloiGKCojBWx9DXlyr8b6pWGD7VRWat062baFB
        jgVh998MXepCOJ6oCZHjS3HJYhEc3VPGYo2IQSOUbSM2oUJTYDzBsDoJrBOARZD4gX2ICPb7PWiV9
        ZUwANhzuJNZha9wzeT1kn1yQE3g9lgoO7n5ZSxAFRsspHLlN8R0b2J8WvqvvFOX9udANUbRuJa27r
        SBI+7Asfonfqfs/QcDfxGvO87vRR4UsNk3S3d6S36QyG0WxikkGyJ60N+/XEJL8fZ+q8EUMN/qTMa
        sib7NH1tw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58466)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlWhC-0003ic-J4; Wed, 17 Jun 2020 12:57:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlWh4-0003i0-1k; Wed, 17 Jun 2020 12:57:26 +0100
Date:   Wed, 17 Jun 2020 12:57:26 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617115725.GR1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <CA+h21hotpF58RrKsZsET9XT-vVD3EHPZ=kjQ2mKVT2ix5XAt=A@mail.gmail.com>
 <20200617113410.GP1551@shell.armlinux.org.uk>
 <CA+h21hqrDd6FLS7vhBW6GUdi8MvimiisyEbQLE0ZfasoQ1EQbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqrDd6FLS7vhBW6GUdi8MvimiisyEbQLE0ZfasoQ1EQbw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 02:38:25PM +0300, Vladimir Oltean wrote:
> On Wed, 17 Jun 2020 at 14:34, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> 
> >
> > Why are you so abrasive?
> >
> > Not responding to this until you start behaving more reasonably.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> Sorry.
> What I meant to say is: the documentation is unclear. It has been
> interpreted in conflicting ways, where the strict interpretations have
> proven to have practical limitations, and the practical
> interpretations have been accused of being incorrect. In my opinion
> there is no way to fix it without introducing new bindings, which I am
> not sure is really worth doing.

The documentation was added in 2016, many years after we have had users
of this, in an attempt to clear up some of the confusion.  It is likely
that it had to cater for existing users though - I'm sure if Florian
cares, he can comment on that.

It would be better if it made a definitive statement about it, but doing
so would likely attract pedants to try to fix everything to conform,
causing breakage in the process.

I've recently had a painful experience of this with the Atheros PHYs,
where there are lots of platforms using "rgmii" when they should have
been using "rgmii-id".  A patch changed this in the Atheros code breaking
all these platforms, breakage which persisted over several kernel
versions, needing fixes to DT files that then had to be back-ported.
That's fine if you know what happened to break it, but if you don't, and
you don't know what the fix is, you're mostly stuffed and stuck with non-
working ethernet.  That really was not nice.

This is one of the reasons why I press for any new PHY interface mode
to be documented in the phylib documentation right from the start, so
that hopefully we can avoid this kind of thing in the future.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
