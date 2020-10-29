Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5413429F186
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgJ2Qb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727075AbgJ2QaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 12:30:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A842E20790;
        Thu, 29 Oct 2020 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603989019;
        bh=9qhq57YW26n72bx0xGHlYkeFUw8S8iXUH+E7GrcU/d0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RTrNaTsY/n9cT4d2kzaUUdjJl1Qe6hy0UVi5cERrFdZ4x9yGkPVT3KsH9hOTl+xT6
         Nl7zLXZIhvuR2tzd/kokkwdVIJqs33gIeNgbj7cIM4JYi4ODaqN78gzUCahvRRp/7e
         VxmGh66H6uGi4/k+rW2q03PCMg4SkBKorJz9dD3w=
Date:   Thu, 29 Oct 2020 09:30:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        driverdevel <devel@driverdev.osuosl.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] wimax: move out to staging
Message-ID: <20201029093017.01e7b1a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAK8P3a0+C450705M2-mHtvoS1Ogb4YiBCq830d1KAgodKpWK4A@mail.gmail.com>
References: <20201027212448.454129-1-arnd@kernel.org>
        <20201028055628.GB244117@kroah.com>
        <20201029085627.698080a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAK8P3a0+C450705M2-mHtvoS1Ogb4YiBCq830d1KAgodKpWK4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 17:26:09 +0100 Arnd Bergmann wrote:
> n Thu, Oct 29, 2020 at 4:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 28 Oct 2020 06:56:28 +0100 Greg Kroah-Hartman wrote:  
> > > On Tue, Oct 27, 2020 at 10:20:13PM +0100, Arnd Bergmann wrote:
> > >
> > > Is this ok for me to take through the staging tree?  If so, I need an
> > > ack from the networking maintainers.
> > >
> > > If not, feel free to send it through the networking tree and add:
> > >
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>  
> >
> > Thinking about it now - we want this applied to -next, correct?
> > In that case it may be better if we take it. The code is pretty dead
> > but syzbot and the trivial fix crowd don't know it, so I may slip,
> > apply something and we'll have a conflict.  
> 
> I think git will deal with a merge between branches containing
> the move vs fix, so it should work either way.
> 
> A downside of having the move in net-next would be that
> you'd get trivial fixes send to Greg, but him being unable to
> apply them to his tree because the code is elsewhere.
> 
> If you think it helps, I could prepare a pull request with this one
> patch (and probably the bugfix I sent first that triggered it), and
> then you can both merge the branch into net-next as well
> as staging-next.

If you wouldn't mind branch sounds like the best solution.

Acked-by: Jakub Kicinski <kuba@kernel.org>
