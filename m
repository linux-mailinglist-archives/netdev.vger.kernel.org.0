Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E85E4502
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437507AbfJYH65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:58:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36736 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437404AbfJYH65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:58:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id w18so1180360wrt.3;
        Fri, 25 Oct 2019 00:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vdb3TAXtbeCpbt8XEPXSNtT49ZuDRK67UpgEzfDdybg=;
        b=ff1MVgb+5Wog9V7NE0T0mwdg3DCaIA+RRo+FE0IKfIqV1Iu7LDTg7WWlq0JM9Jp0FF
         Wx0bk2YLVHzscAbuDN2Jl//DOl1Rxp0qFUFOOJVJLqhwRjTpX/21tnzfuV7FuuR3/PRx
         /gtt31YzC5wG4Goed64e2tuYCY+zsW+/Ng3p+teWa34QLewWT7HvQTR6AUMbzEnoxKla
         /FApBG2ACam1+vC8c+gHuhh+tYTH/4RnUTl5zu04J1pOXeT8ZD4atyn8rBxdYXx1ovWG
         flvYMqnXgtwnxwvZjW6b5lXKDxHt66N5NU+20iSNEj/ECNgh7M87QgiVlEBh6/0FqU6g
         St4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vdb3TAXtbeCpbt8XEPXSNtT49ZuDRK67UpgEzfDdybg=;
        b=Jx9Eq3lIVFpIYPrFR6Y5hOacceSbl9DPBZ4md00gPUhZpX/5RlcYbVR3EA1exspIVr
         juIlo29VO3cKcLG8Jq4QfK8DrPXTmJ0Y4QzITCiZmnDSCG8cGgw6j6nKAzst+dyBbwf2
         ZQ2Ay3N+Ql6BESng2uj6Gc2XinjRkSzVXnZplumYARlyEbuuv1FQHx/TdCYfmkQmCjsC
         wqjl2FsdYQ6KTqgtVDO145iIQnL2S/a1etyNsmxU5N6nAcjSc7YP7Tw1MrhORIwpxpNj
         f154i54EI4d5UVJ637kXQcl5nDJZQp7VqUVWSi82B+4mnWT/aUnHyHFLqdYqgYXs6qEc
         u6Lw==
X-Gm-Message-State: APjAAAWJ23+vYngMKzRIwDxjARS1rftfSjJx2kKBsIah8Ci7pi42NxOx
        T4vD+yf25OVrwtYCvgTxQXGy5BF34/eJ+mpMW0w=
X-Google-Smtp-Source: APXvYqySnvN4zd5OkD6LKsvnbPUUpMHsQ7MvD2dzA9fZpzH/XMKYsBaeVVZXvfKhVkgfns7XBAl5BZZOX/mZer0fxkM=
X-Received: by 2002:adf:e7cf:: with SMTP id e15mr1573570wrn.303.1571990332361;
 Fri, 25 Oct 2019 00:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571033544.git.lucien.xin@gmail.com> <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <fb115b1444764b3eacdf69ebd9cf9681@AcuMS.aculab.com> <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
 <20191025032206.GB4326@localhost.localdomain>
In-Reply-To: <20191025032206.GB4326@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 25 Oct 2019 15:58:42 +0800
Message-ID: <CADvbK_fi78Sof4n4KcgdQgPDJ-QZtP9O9W2zpFryRqm3FLeW3Q@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 11:22 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Sat, Oct 19, 2019 at 04:55:01PM +0800, Xin Long wrote:
> > > > @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> > > >                       spc_state = SCTP_ADDR_CONFIRMED;
> > > >               else
> > > >                       spc_state = SCTP_ADDR_AVAILABLE;
> > > > -             /* Don't inform ULP about transition from PF to
> > > > -              * active state and set cwnd to 1 MTU, see SCTP
> > > > -              * Quick failover draft section 5.1, point 5
> > > > -              */
> > > > -             if (transport->state == SCTP_PF) {
> > > > -                     ulp_notify = false;
> > > > -                     transport->cwnd = asoc->pathmtu;
> > > > -             }
> > >
> > > This is wrong.
> > > If the old state is PF and the application hasn't exposed PF the event should be
> > > ignored.
> > yeps, in Patch 2/5:
> > +               if (transport->state == SCTP_PF &&
> > +                   asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
> > +                       ulp_notify = false;
> > +               else if (transport->state == SCTP_UNCONFIRMED &&
> > +                        error == SCTP_HEARTBEAT_SUCCESS)
> >                         spc_state = SCTP_ADDR_CONFIRMED;
> >                 else
> >                         spc_state = SCTP_ADDR_AVAILABLE;
>
> Right, yet for one bisecting the kernel, a checkout on this patch will
> see this change regardless of patch 2. Patches 1 and 2 could be
> swapped to avoid this situation.
>
> >
> > >
> > > >               transport->state = SCTP_ACTIVE;
> > > >               break;
> > > >
> > > > @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> > > >                * to inactive state.  Also, release the cached route since
> > > >                * there may be a better route next time.
> > > >                */
> > > > -             if (transport->state != SCTP_UNCONFIRMED)
> > > > +             if (transport->state != SCTP_UNCONFIRMED) {
> > > >                       transport->state = SCTP_INACTIVE;
> > > > -             else {
> > > > +                     spc_state = SCTP_ADDR_UNREACHABLE;
> > > > +             } else {
> > > >                       sctp_transport_dst_release(transport);
> > > >                       ulp_notify = false;
> > > >               }
> > > > -
> > > > -             spc_state = SCTP_ADDR_UNREACHABLE;
> > > >               break;
> > > >
> > > >       case SCTP_TRANSPORT_PF:
> > > >               transport->state = SCTP_PF;
> > > > -             ulp_notify = false;
> > >
> > > Again the event should be supressed if PF isn't exposed.
> > it will be suppressed after Patch 2/5:
> > +               if (asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
> > +                       ulp_notify = false;
> > +               else
> > +                       spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
> >                 break;
>
> Same here.
okay, will swap them. thanks.

>
> >
> > >
> > > > +             spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
> > > >               break;
> > > >
> > > >       default:
> > > > --
> > > > 2.1.0
> > >
> > > I also haven't spotted where the test that the application has actually enabled
> > > state transition events is in the code.
> > all events will be created, but dropped in sctp_ulpq_tail_event() when trying
> > to deliver up:
> >
> >         /* Check if the user wishes to receive this event.  */
> >         if (!sctp_ulpevent_is_enabled(event, ulpq->asoc->subscribe))
> >                 goto out_free;
> >
> > > I'd have thought it would be anything is built and allocated.
> > >
> > >         David
> > >
> > > -
> > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > Registration No: 1397386 (Wales)
> > >
> >
