Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9039F36C
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfH0TqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:46:10 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44914 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfH0TqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:46:09 -0400
Received: by mail-yb1-f195.google.com with SMTP id y21so8642419ybi.11;
        Tue, 27 Aug 2019 12:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ppLYsZdjt673IaBzcGr4uH4V5vcM6gItlNCPO5sXczk=;
        b=I1J66cFngq3ayhRq0+WjJAomdFG7DBpXuVNGVyKtkxzdHYPghuO94RfHfFosLvs2SG
         FDJYM5DrSd5vvMs3qcWz1WQlVVZ13ULgIATR1ZCRa2gtR8ASTnNH2iBG/uBDiibi1hb5
         q97PnvciLHLoze1S1ApUZij+p0awCBzIa6YFTI/rOothia6UIuNJCB9Wn1rByMMoPERE
         cj/PTxqksFPj7T3SprpdUKkRnmr5KkA7GkS2ciPXf/lRW9gxn+cAe6tOj5Bok8EjGlOh
         BcMuh9YACwXMEa5DIz8NklzRlzfTbtXCXMGsqogXvapVh8wUfn++p9b0Xll+EWs/HamX
         SbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ppLYsZdjt673IaBzcGr4uH4V5vcM6gItlNCPO5sXczk=;
        b=WWlyKBe8NBVQbwEvfwo8a2IkflW9aq0BhGtNtWr/gicF3CoKBHcEES+cDM/1jUBzJV
         uX+fojvFW59Dagqq/AYSXBUb6itN1Tn6YxdDVMAp/5N7AVPaG5ldJ3Bk2T0tcksP5UZm
         NZP0WBbSFK01L02olj7xAEnxXxRpFQw3tPycfdRHCzXGbIARCpUxnLG2mMw5Ko5U4XBD
         OTX+a+r2YHQZlwRuy6NWs4mkG74seArN0TujhI386KVJAnLdjHwHbOzd7MWvj6eRqtqD
         3enZmKVgzNZpyrPR6QDAMsBmuCQYJv+wMhcRUWkh+DiBtQWVR3i7nywwzC+Jl9x7yUtZ
         9wPQ==
X-Gm-Message-State: APjAAAWl1o3El8x/3F9v+Zu0t8x5djZP8D1IFIdzyHWl+9rjRwjRz6Qr
        no+RkOqk2nrET4U2qrpafOcFB1oGj2zz/PVEOMI=
X-Google-Smtp-Source: APXvYqzN7dajJDt4d1T6SoH60PikHcbv5rjZmZxyihsHrtvpfXGeSOhI3K9P7puetKwSNA2GtQkx795IzOp2eAG2eWE=
X-Received: by 2002:a25:ccd7:: with SMTP id l206mr360298ybf.165.1566935169170;
 Tue, 27 Aug 2019 12:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190823191421.3318-1-ffleming@gmail.com> <c2279a78904b581924894b712403299903eacbfc.camel@intel.com>
 <877726fc009ee5ffde50e589d332db90c9695f06.camel@perches.com>
 <c40b4043424055fc4dae97771bb46c8ab15c6230.camel@intel.com> <b1ea77866e8736fa691cf4658a87ca2c1bf642d6.camel@perches.com>
In-Reply-To: <b1ea77866e8736fa691cf4658a87ca2c1bf642d6.camel@perches.com>
From:   Forrest Fleming <ffleming@gmail.com>
Date:   Tue, 27 Aug 2019 12:45:58 -0700
Message-ID: <CAE7kSDuHi3e_b0qyvXqocSVaNJrj3X7PPiawBWa68ZyrLSAZyA@mail.gmail.com>
Subject: Re: [PATCH] net: intel: Cleanup e1000 - add space between }}
To:     Joe Perches <joe@perches.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 12:07 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2019-08-27 at 12:02 -0700, Jeff Kirsher wrote:
> > On Mon, 2019-08-26 at 20:41 -0700, Joe Perches wrote:
> > > On Mon, 2019-08-26 at 01:03 -0700, Jeff Kirsher wrote:
> > > > On Fri, 2019-08-23 at 19:14 +0000, Forrest Fleming wrote:
> > > > > suggested by checkpatch
> > > > >
> > > > > Signed-off-by: Forrest Fleming <ffleming@gmail.com>
> > > > > ---
> > > > >  .../net/ethernet/intel/e1000/e1000_param.c    | 28 +++++++++--
> > > > > --------
> > > > >  1 file changed, 14 insertions(+), 14 deletions(-)
> > > >
> > > > While I do not see an issue with this change, I wonder how
> > > > important it is
> > > > to make such a change.  Especially since most of the hardware
> > > > supported by
> > > > this driver is not available for testing.  In addition, this is one
> > > > suggested change by checkpatch.pl that I personally do not agree
> > > > with.
> > >
> > > I think checkpatch should allow consecutive }}.
> >
> > Agreed, have you already submitted a formal patch Joe with the
> > suggested change below?
>
> No.
>
> >   If so, I will ACK it.
>
> Of course you can add an Acked-by:
>

Totally fair - I don't have strong feelings regarding the particular rule. I do
feel strongly that we should avoid violating our rules as encoded by checkpatch,
but I'm perfectly happy for the change to take the form of modifying checkpatch
to allow a perfectly sensible (and readable) construct.

I'm happy to withdraw this patch from consideration; I couldn't find anything
about there being a formal procedure for so doing, so please let me know if
there's anything more I need to do (or point me to the relevant docs).

Thanks to everyone!
