Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCAD3A88BD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhFOSmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFOSmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 14:42:42 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560EEC061574;
        Tue, 15 Jun 2021 11:40:37 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 291F94A3;
        Tue, 15 Jun 2021 20:40:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1623782434;
        bh=3PIbXGv9WJI1oVxhJvXNkSPm3iTDDkwb4+U0QZuU0Og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WOKnHeHlUSfcPRIdko29xFI6GP2fmpisAIJ6Onm7DlneHJGVJKPUxvVhF8FYC5NM6
         UR2g9IMb8ZjktLcaBkak79fOt1R4hAqkpDGUuD3835VghpbN0dmve9UuPmYperfmxT
         UdKLjXeh0fnkqPW+In7A3ix2QHQmwBRxrgekZ1yU=
Date:   Tue, 15 Jun 2021 21:40:13 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Howells <dhowells@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <YMj0Del0tnZ+dRM/@pendragon.ideasonboard.com>
References: <YLEIKk7IuWu6W4Sy@casper.infradead.org>
 <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <1745326.1623409807@warthog.procyon.org.uk>
 <e47706ee-3e4b-8f15-963f-292b5e47cb1d@metux.net>
 <YMjxqEY25A6bm47s@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YMjxqEY25A6bm47s@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 07:30:00PM +0100, Matthew Wilcox wrote:
> On Tue, Jun 15, 2021 at 08:23:55PM +0200, Enrico Weigelt, metux IT consult wrote:
> > On 11.06.21 13:10, David Howells wrote:
> > 
> > > One thing that concerns me about flying to the US is going through multiple
> > > busy international airports - take Heathrow which didn't separate incoming
> > > travellers from red-listed countries from those of amber- or green- until like
> > > a week ago.
> > > 
> > > Would it be practical/economical to charter a plane to fly, say, from a less
> > > busy airport in Europe to a less busy airport in the US and back again if we
> > > could get enough delegates together to make it worthwhile?
> > 
> > Wouldn't just taking prophylatic meds like CDS or HCQ and/or hi-dose
> > vitamins (C, D3+K2) be way more cost effective and flexible than to
> > charter a whole plane ?
> 
> Why don't you just shine a bright light up your arse?  It'll have the
> same effect.

Could we please, as requested early on by Konstantin, restrict
COVID19-related discussions on this mailing list solely to how it would
impact travel to/from the conference ?

For those who want to debate the merits of various medicines, feel free
to create your own mailing list, or an IRC channel on Freenode.

-- 
Regards,

Laurent Pinchart
