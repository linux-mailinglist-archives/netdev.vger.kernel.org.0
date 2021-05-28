Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60B239455B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 17:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhE1PqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 11:46:01 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:33708 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235056AbhE1Pp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 11:45:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id AE0D71280235;
        Fri, 28 May 2021 08:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622216664;
        bh=r7DAWioy6q80kr0AnI5AjcAcd7Z86u6UuomPqBtqu9c=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=RJq81pLRXPiTe+M3Ono4U6rhZy/oPRas8tcF4mSaIXNbLtrdAF6L3JhTfm1rCsN5m
         W7AuerCMcJXDqGIi+U6HEcrkT1aj5totMt9I9KINRy8fUbJYdVrvUVSsGmX1e3alOy
         4imhbUpCEDpnOEcdmrTjpX4C2eJSj9oqcJ78E3yo=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id naO3ZSCI_eNm; Fri, 28 May 2021 08:44:24 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E942E1280200;
        Fri, 28 May 2021 08:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1622216664;
        bh=r7DAWioy6q80kr0AnI5AjcAcd7Z86u6UuomPqBtqu9c=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=RJq81pLRXPiTe+M3Ono4U6rhZy/oPRas8tcF4mSaIXNbLtrdAF6L3JhTfm1rCsN5m
         W7AuerCMcJXDqGIi+U6HEcrkT1aj5totMt9I9KINRy8fUbJYdVrvUVSsGmX1e3alOy
         4imhbUpCEDpnOEcdmrTjpX4C2eJSj9oqcJ78E3yo=
Message-ID: <15419fa8e5c0047327395387b28c09d775b35a55.camel@HansenPartnership.com>
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
Date:   Fri, 28 May 2021 08:44:23 -0700
In-Reply-To: <YLEM2WE0ezdrfMPt@pendragon.ideasonboard.com>
References: <YH2hs6EsPTpDAqXc@mit.edu>
         <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
         <YIx7R6tmcRRCl/az@mit.edu>
         <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
         <YK+esqGjKaPb+b/Q@kroah.com>
         <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
         <YLEIKk7IuWu6W4Sy@casper.infradead.org>
         <a8bbc5dab99a4af6e89a9521a5eb4cb4747d2afe.camel@HansenPartnership.com>
         <YLEM2WE0ezdrfMPt@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-28 at 18:31 +0300, Laurent Pinchart wrote:
> On Fri, May 28, 2021 at 08:27:44AM -0700, James Bottomley wrote:
[...]
> > Well, I'm not going to get into a debate over the effectiveness of
> > the current vaccines.  I will say that all conferences have to now
> > recognize that a sizeable proportion of former attendees will have
> > fears about travelling and therefore remote components are going to
> > be a fixture of conferences going forward.
> > 
> > However, while we should accommodate them, we can't let these fears
> > override people willing to take the risk and meet in person.
> 
> The interesting question is how we'll make sure that those people
> will not be de facto excluded from the community, or end up as
> second-class citizens.

Before the pandemic, there was a small contingent who refused to fly
for various reasons.  We did sort of accommodate that by rotating the
conference to Europe where more people could come in by train (like
they did in Lisbon) but we didn't govern the whole conference by trying
to make aerophobes first class citizens.

The bottom line is that as long as enough people are willing to meet in
person and in-person delivers more value that remote (even though we'll
try to make remote as valuable as possible) we should do it.   We
should not handicap the desires of the one group by the fears of the
other because that's a false equality ... it's reducing everyone to the
level of the lowest common denominator rather than trying to elevate
people.

James


