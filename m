Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD993944DE
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 17:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhE1PN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 11:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbhE1PNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 11:13:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C96C061574;
        Fri, 28 May 2021 08:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DKqV70MMMK3G6vetpPVH3agOFHnwPsPuzF2wR4m/9r8=; b=EiNIcVQXpM/nr6D6KBoUNOviYJ
        /d+VzVV6EQmbOPYoJ2fsaoNxs+05SzPCb72qQuUNR1UVoa/DdpoGHza5kblsDuN73rG5Yh5IgXeVW
        a5tJFw8kX0WbgLn9ke23nLEhwfAycVa82ApYgkzJIAO0C8RSgVax5NS5sL4kApo1OXGk+oAYfzk0G
        cwQiIeyz8laGNuTQy9RKj5RSnZfYSNHvRNHA5aNIXouBbT1mbc3SQag5xfmqw34OBxx1r7ArBUogr
        +9z4/1YKrc6LdWlXgK0b1dGXivcm5GWP3QL/dAs5pSIWBPuIN8GG5+BBnsJlIRESAKhgjyTYq9PLm
        YPiYZekw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lme9C-006jtR-8E; Fri, 28 May 2021 15:11:39 +0000
Date:   Fri, 28 May 2021 16:11:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <YLEIKk7IuWu6W4Sy@casper.infradead.org>
References: <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 07:58:10AM -0700, James Bottomley wrote:
> On Thu, 2021-05-27 at 15:29 +0200, Greg KH wrote:
> > On Thu, May 27, 2021 at 03:23:03PM +0200, Christoph Lameter wrote:
> > > On Fri, 30 Apr 2021, Theodore Ts'o wrote:
> > > 
> > > > I know we're all really hungry for some in-person meetups and
> > > > discussions, but at least for LPC, Kernel Summit, and
> > > > Maintainer's Summit, we're going to have to wait for another
> > > > year,
> > > 
> > > Well now that we are vaccinated: Can we still change it?
> > > 
> > 
> > Speak for yourself, remember that Europe and other parts of the world
> > are not as "flush" with vaccines as the US currently is :(
> 
> The rollout is accelerating in Europe.  At least in Germany, I know
> people younger than me are already vaccinated.  I think by the end of
> September the situation will be better ... especially if the EU and US
> agree on this air bridge (and the US actually agrees to let EU people
> in).
> 
> One of the things Plumbers is thinking of is having a meetup at what
> was OSS EU but which is now in Seattle.  The Maintainer's summit could
> do the same thing.  We couldn't actually hold Plumbers in Seattle
> because the hotels still had masks and distancing requirements for
> events that effectively precluded the collaborative aspects of
> microconferences, but evening events will be governed by local
> protocols, rather than the Hotel, which are already more relaxed.

Umm.  Let's remember that the vaccines are 33-93% effective [1],
which means that there's approximately a 100% certainty that at least
one person arriving at the event from a trans-atlantic flight has been
exposed to someone who has the virus.  I'm not convinced that holding a
"more relaxed protocol" event is a great idea.

[1] Depending exactly which vaccine, which variant, how many doses, etc, etc
https://www.sciencemediacentre.org/expert-reaction-to-preprint-from-phe-on-vaccine-effectiveness-against-the-b-1-617-2-indian-variant/

