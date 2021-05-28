Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D0939459B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhE1QGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbhE1QGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 12:06:06 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE819C061574;
        Fri, 28 May 2021 09:04:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8E5EB1280B1F;
        Fri, 28 May 2021 09:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622217871;
        bh=BQsrHDhyxeGmu8aQeFMcjsCrAm3fi/y8UTQs0WsxccM=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=NTkbkb973Nd1bSKSs+DE/dfGQ75YMyIT095+n+UbtL9hHk6XHJfkjFHzoGxq3JJQ7
         pXc928sZuDyZf/mk0NkH0hku+ThG6SXMBYJTL7mfR445yrF/nXw80OAPMY1S4dnoCK
         /gbjoj7ea2iAD4fsCi9MCTRxc9w8L31sTh9/1FUo=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CM7fZO3TGdez; Fri, 28 May 2021 09:04:31 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CDA5D1280B06;
        Fri, 28 May 2021 09:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622217871;
        bh=BQsrHDhyxeGmu8aQeFMcjsCrAm3fi/y8UTQs0WsxccM=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=NTkbkb973Nd1bSKSs+DE/dfGQ75YMyIT095+n+UbtL9hHk6XHJfkjFHzoGxq3JJQ7
         pXc928sZuDyZf/mk0NkH0hku+ThG6SXMBYJTL7mfR445yrF/nXw80OAPMY1S4dnoCK
         /gbjoj7ea2iAD4fsCi9MCTRxc9w8L31sTh9/1FUo=
Message-ID: <df8c7c855279ff82e05e5142440149ae531a24e9.camel@HansenPartnership.com>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Date:   Fri, 28 May 2021 09:04:29 -0700
In-Reply-To: <YLESaAP/Bu95ACvU@pendragon.ideasonboard.com>
References: <YH2hs6EsPTpDAqXc@mit.edu>
         <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
         <YIx7R6tmcRRCl/az@mit.edu>
         <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
         <YK+esqGjKaPb+b/Q@kroah.com>
         <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
         <YLEIKk7IuWu6W4Sy@casper.infradead.org>
         <a8bbc5dab99a4af6e89a9521a5eb4cb4747d2afe.camel@HansenPartnership.com>
         <YLEM2WE0ezdrfMPt@pendragon.ideasonboard.com>
         <15419fa8e5c0047327395387b28c09d775b35a55.camel@HansenPartnership.com>
         <YLESaAP/Bu95ACvU@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-28 at 18:55 +0300, Laurent Pinchart wrote:
> Hi James,
> 
> On Fri, May 28, 2021 at 08:44:23AM -0700, James Bottomley wrote:
> > On Fri, 2021-05-28 at 18:31 +0300, Laurent Pinchart wrote:
> > > On Fri, May 28, 2021 at 08:27:44AM -0700, James Bottomley wrote:
> > [...]
> > > > Well, I'm not going to get into a debate over the effectiveness
> > > > of the current vaccines.  I will say that all conferences have
> > > > to now recognize that a sizeable proportion of former attendees
> > > > will have fears about travelling and therefore remote
> > > > components are going to be a fixture of conferences going
> > > > forward.
> > > > 
> > > > However, while we should accommodate them, we can't let these
> > > > fears override people willing to take the risk and meet in
> > > > person.
> > > 
> > > The interesting question is how we'll make sure that those people
> > > will not be de facto excluded from the community, or end up as
> > > second-class citizens.
> > 
> > Before the pandemic, there was a small contingent who refused to
> > fly for various reasons.  We did sort of accommodate that by
> > rotating the conference to Europe where more people could come in
> > by train (like they did in Lisbon) but we didn't govern the whole
> > conference by trying to make aerophobes first class citizens.
> > 
> > The bottom line is that as long as enough people are willing to
> > meet in person and in-person delivers more value that remote (even
> > though we'll try to make remote as valuable as possible) we should
> > do it.   We should not handicap the desires of the one group by the
> > fears of the other because that's a false equality ... it's
> > reducing everyone to the level of the lowest common denominator
> > rather than trying to elevate people.
> 
> This should take into account the size of each group, and I believe
> even then it won't be a binary decision, there's lots of variation in
> local situations, creating more than just two groups of
> coward/careless people (let's not debate those two words if possible,
> they're not meant to insult anyway, but to emphasize that there are
> more categories). While I believe that in-person meetings will become
> the norm again in a reasonably near future, 2021 seems a bit
> premature to me.

Well, this is why Plumbers and Kernel Summit are fully virtual for this
year, so you won't miss any content.  The idea of meetups is just to
test the water for restarting the social side.  In 2021 it's
necessarily going to be governed by which country is on which other
country's friends list, but hopefully that won't be the case in 2022.

> If we want to brainstorm alternate solutions, an option could be to
> split the monolithic conference location into a small set of
> geographically distributed groups (assuming local travel would be
> easier and generally seen as an accepted solution compared to
> intercontinental travels) and link those through video conferencing.
> I don't have high hopes that this would be feasible in practice given
> the increase in efforts and costs to organize multiple locations in
> parallel, but maybe something interesting could come out of
> discussing different options.

Remember, remote isn't always the best solution either.  We got
complaints last year that we were disadvantaging people without high
speed internet by using video (i.e. large swathes of Africa and Asia). 
In a physical conference we can try to counteract this disadvantage by
offering attendance sponsorship, but I can't sponsor a fibre connection
on a continental scale.  I think we need to feel our way here, and
trying out meetups for size (which are traditionally more
geographically local) could be one way to do this.

James


