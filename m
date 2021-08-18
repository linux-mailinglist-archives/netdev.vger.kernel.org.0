Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A794F3F0B3C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 20:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhHRSrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 14:47:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhHRSrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 14:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LslqnICK2K9Z5nZFOWZxRkc5IKeWWca/EEMOYqP7v/I=; b=lyinVlL4NDDv+cfNkZorZRKcat
        fQQkhAVP6rk6yRdCOEfirqNfGepBukIALi3lSeJdBL3J2Wx/8N/daZS1kiTuvSXOYUQHNQffzFUmb
        LpSdtDYm6pv4+zceGWbbFGAlu+ZvIP4GPJVN9ZxW18mGWz0ya0cD1waKifXcIAHq2N80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGQa6-000pTB-53; Wed, 18 Aug 2021 20:46:30 +0200
Date:   Wed, 18 Aug 2021 20:46:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: mdio-mux: Delete unnecessary devm_kfree
Message-ID: <YR1VhqiwIe85GpHE@lunn.ch>
References: <20210817180841.3210484-1-saravanak@google.com>
 <20210817180841.3210484-2-saravanak@google.com>
 <YRwlyH0cjazjsSwe@lunn.ch>
 <CAGETcx-B=oxqGP-iz4qf2YrLVw3_Q-oTc_3m+dgP1P17FmLs=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-B=oxqGP-iz4qf2YrLVw3_Q-oTc_3m+dgP1P17FmLs=g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 07:56:42PM -0700, Saravana Kannan wrote:
> On Tue, Aug 17, 2021 at 2:10 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Aug 17, 2021 at 11:08:39AM -0700, Saravana Kannan wrote:
> > > The whole point of devm_* APIs is that you don't have to undo them if you
> > > are returning an error that's going to get propagated out of a probe()
> > > function. So delete unnecessary devm_kfree() call in the error return path.
> > >
> > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > Acked-by: Marc Zyngier <maz@kernel.org>
> > > Tested-by: Marc Zyngier <maz@kernel.org>
> > > Acked-by: Kevin Hilman <khilman@baylibre.com>
> > > Tested-by: Kevin Hilman <khilman@baylibre.com>
> >
> > Please add a Fixes: tag, since you want this in stable.
> >
> > All three patches need fixes tags, possibly different for each patch?
> 
> I generally ask for patches to be picked up by stable only if it fixes
> a bug that puts the kernel in a bad state

Actually, you asked for stable. You set the subject to

[PATCH net v3 0/3] Clean up and fix error

where [PATCH net ] means stable. If you think this is just ongoing
development work, use [PATCH net-next ]. Then the Fixes tags are
optional.

	Andrew
