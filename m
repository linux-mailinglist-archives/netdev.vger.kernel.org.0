Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36221051CB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 12:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKULuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 06:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfKULuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 06:50:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A0BE20898;
        Thu, 21 Nov 2019 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574337015;
        bh=lC4uVUDLgruOavBG//yTCj3hlVhHQ/crx0MRzaQ50Dc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+qHtGJjbwudgUX/Q28eKVarNu6QZI5nQ3bHrd6YXrWIODI+v5nPC1o/xvvs/Qta/
         PMe/a87ciYqe7K9+thM80j4eToFITOyPQL5wRGTBu/tGS0iFJg72kvNc1nzSDUnCzY
         MPPdj1ufj1w+8udzUbl7N0dBzlXVt19nwRH1/UVM=
Date:   Thu, 21 Nov 2019 12:50:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <thoiland@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
Message-ID: <20191121115013.GA427938@kroah.com>
References: <20191120203538.199367-1-Jason@zx2c4.com>
 <877e3t8qv7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877e3t8qv7.fsf@toke.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 11:29:16AM +0100, Toke Høiland-Jørgensen wrote:
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
> 
> > RFC Note:
> >   This is a RFC for folks who want to play with this early, because
> >   Herbert's cryptodev-2.6 tree hasn't yet made it into net-next. I'll
> >   repost this as a v1 (possibly with feedback incorporated) once the
> >   various trees are in the right place. This compiles on top of the
> >   Frankenzinc patchset from Ard, though it hasn't yet received suitable
> >   testing there for me to call it v1 just yet. Preliminary testing with
> >   the usual netns.sh test suite on x86 indicates it's at least mostly
> >   functional, but I'll be giving things further scrutiny in the days to
> >   come.
> 
> Hi Jason
> 
> Great to see this! Just a few small comments for now:
> 
> > +/*
> > + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> > + */
> 
> Could you please get rid of the "All Rights Reserved" (here, and
> everywhere else)? All rights are *not* reserved: this is licensed under
> the GPL. Besides, that phrase is in general dubious at best:
> https://en.wikipedia.org/wiki/All_rights_reserved

Don't take legal questions/advice on a developer mailing list :)

This text is fine as-is, please consult your RedHat lawyers for why that
is so.

And if RedHat does have issues with this, have them please clean up the
instances in the kernel where they have this same text before asking
anyone else to do so.

thanks,

greg k-h
