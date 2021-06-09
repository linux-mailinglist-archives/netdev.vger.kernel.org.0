Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7363A1DA6
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 21:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFITZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 15:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFITZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 15:25:27 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E99BC061574;
        Wed,  9 Jun 2021 12:23:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 302271280667;
        Wed,  9 Jun 2021 12:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1623266611;
        bh=+ygb6ehnTWGTq4+1X/LDab7SOrMZFUMoYRjlVlc0Ylo=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=F4n1wSPIfTJQLoiDdI1yZL/EUP3WrqHdOowail12Ffw336iWpi00V+GARW0MpjRsA
         +kLf4BY4Sc6Ina61GAiJ1ssSy6/WS/P/lRQXRKmRPg9vCvtpZnVZw8QLYaEO4krOTO
         cn06zPp/BfpaaJ8Ty2o2LbNdYZeyz9zun05H49Dk=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id msFIPfflViLD; Wed,  9 Jun 2021 12:23:31 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 70C251280665;
        Wed,  9 Jun 2021 12:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1623266611;
        bh=+ygb6ehnTWGTq4+1X/LDab7SOrMZFUMoYRjlVlc0Ylo=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=F4n1wSPIfTJQLoiDdI1yZL/EUP3WrqHdOowail12Ffw336iWpi00V+GARW0MpjRsA
         +kLf4BY4Sc6Ina61GAiJ1ssSy6/WS/P/lRQXRKmRPg9vCvtpZnVZw8QLYaEO4krOTO
         cn06zPp/BfpaaJ8Ty2o2LbNdYZeyz9zun05H49Dk=
Message-ID: <e993d6c84c79d083ecfe5a8c8edabef9e9caa3ce.camel@HansenPartnership.com>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>
Cc:     Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Date:   Wed, 09 Jun 2021 12:23:29 -0700
In-Reply-To: <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
References: <YH2hs6EsPTpDAqXc@mit.edu>
         <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
         <YIx7R6tmcRRCl/az@mit.edu>
         <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
         <YK+esqGjKaPb+b/Q@kroah.com>
         <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
         <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-09 at 12:37 +0200, David Hildenbrand wrote:
> On 28.05.21 16:58, James Bottomley wrote:
> > On Thu, 2021-05-27 at 15:29 +0200, Greg KH wrote:
> > > On Thu, May 27, 2021 at 03:23:03PM +0200, Christoph Lameter
> > > wrote:
> > > > On Fri, 30 Apr 2021, Theodore Ts'o wrote:
> > > > 
> > > > > I know we're all really hungry for some in-person meetups and
> > > > > discussions, but at least for LPC, Kernel Summit, and
> > > > > Maintainer's Summit, we're going to have to wait for another
> > > > > year,
> > > > 
> > > > Well now that we are vaccinated: Can we still change it?
> > > > 
> > > 
> > > Speak for yourself, remember that Europe and other parts of the
> > > world are not as "flush" with vaccines as the US currently is :(
> > 
> > The rollout is accelerating in Europe.  At least in Germany, I know
> > people younger than me are already vaccinated. 
> 
> And I know people younger than you in Germany personally ( ;) ) that
> are not vaccinated yet and might not even get the first shot before 
> September, not even dreaming about a second one + waiting until the 
> vaccine is fully in effect.

I said "is accelerating" not "is on a par with the US and UK".

> So yes, sure, nobody can stop people that think the pandemic is over 
> ("we are vaccinated") from meeting in person. Just make sure to not 
> ignore the poor souls that really won't be traveling this year,
> because "we are not vaccinated".

I realise the UK government attitude is that everyone should suffer
until we say it's over (mainly, it must be admitted, to try to keep
people from asking awkward questions about what went wrong initially)
and to some extent the EU shares that, but the US is definitely moving
to a regime that says once you're vaccinated it's pretty much over for
you and I don't see a problem with taking advantage of that for hybrid
style events.  However, even with the best will in the world, I can't
see much of a way around the problem that remote people at hybrid
events will always be at a disadvantage ... suggestions for improving
this are always welcome.

James


