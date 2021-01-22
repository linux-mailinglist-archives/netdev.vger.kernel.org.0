Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54FA30111C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbhAVXqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:46:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbhAVXqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:46:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l367J-002AH9-Ij; Sat, 23 Jan 2021 00:45:25 +0100
Date:   Sat, 23 Jan 2021 00:45:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com
Subject: Re: [PATCH 17/18] net: iosm: readme file
Message-ID: <YAtjlYYivFEoNc/B@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
 <20210107170523.26531-18-m.chetan.kumar@intel.com>
 <X/eJ/rl4U6edWr3i@lunn.ch>
 <87turftqxt.fsf@miraculix.mork.no>
 <YAiF2/lMGZ0mPUSK@lunn.ch>
 <20210120153255.4fcf7e32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <82243bc066a12235099639928a271a8fe338668e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82243bc066a12235099639928a271a8fe338668e.camel@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 07:34:48PM -0600, Dan Williams wrote:
> On Wed, 2021-01-20 at 15:32 -0800, Jakub Kicinski wrote:
> > On Wed, 20 Jan 2021 20:34:51 +0100 Andrew Lunn wrote:
> > > On Sun, Jan 17, 2021 at 06:26:54PM +0100, Bjørn Mork wrote:
> > > > I was young and stupid. Now I'm not that young anymore ;-)  
> > > 
> > > We all make mistakes, when we don't have the knowledge there are
> > > other
> > > ways. That is partially what code review is about.
> > > 
> > > > Never ever imagined that this would be replicated in another
> > > > driver,
> > > > though.  That doesn't really make much sense.  We have learned by
> > > > now,
> > > > haven't we?  This subject has been discussed a few times in the
> > > > past,
> > > > and Johannes summary is my understanding as well:
> > > > "I don't think anyone likes that"  
> > > 
> > > So there seems to be agreement there. But what is not clear, is
> > > anybody willing to do the work to fix this, and is there enough
> > > ROI.
> > > 
> > > Do we expect more devices like this? Will 6G, 7G modems look very
> > > different? 
> > 
> > Didn't Intel sell its 5G stuff off to Apple?
> 
> Yes, but they kept the ability to continue with 3G/4G hardware and
> other stuff.

But we can expect 6G in what, 2030? And 7G in 2040? Are they going to
look different? Or is it going to be more of the same, meaningless
ethernet headers, VLANs where VLANs make little sense?

> > > Be real network devices and not need any of this odd stuff?
> > > Or will they be just be incrementally better but mostly the same?
> > > 
> > > I went into the review thinking it was an Ethernet driver, and kept
> > > having WTF moments. Now i know it is not an Ethernet driver, i can
> > > say
> > > it is not my domain, i don't know the field well enough to say if
> > > all
> > > these hacks are acceptable or not.
> > > 
> > > It probably needs David and Jakub to set the direction to be
> > > followed.
> > 
> > AFAIU all those cellar modems are relatively slow and FW-heavy, so
> > the
> > ideal solution IMO is not even a common kernel interface but actually
> > a common device interface, like NVMe (or virtio for lack of better
> > examples).
> 
> That was supposed to be MBIM, but unfortunately those involved didn't
> iterate and MBIM got stuck. I don't think we'll see a standard as long
> as some vendors are dominant and see no need for it.

We the kernel community need to decide, we are happy for this broken
architecture to live on, and we should give suggest how to make this
submission better. Or we need to push back and say for the long term
good, this driver is not going to be accepted, use a more sensible
architecture.

	Andrew
