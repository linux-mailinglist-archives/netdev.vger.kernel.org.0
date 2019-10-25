Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F143E4505
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437516AbfJYH7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:59:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52000 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437404AbfJYH7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:59:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id q70so1009646wme.1;
        Fri, 25 Oct 2019 00:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=isCj9HnqqlVH+KvOoOVR3CxVJIpBTR1R8pbElsHgbVE=;
        b=N71jlKqvWY6To6CFU8Glc+6LzCivOuA+dHS214QqegVof6Kf+zSnzHfFlzRzvnNf0K
         neXS36NBjnoEZatH1ssgbhMzrJHZJ7oCFRbLZCfNWTQ3iJtv9JwZaG8++gdrIa8eV0cT
         GMzGm4N3VnprYTGPlOpJLzIuGkO35YjreLCZCpfjOCQqVjW9wPRunJT8WOCPrBnE4PqV
         zDW6mbDYTcE2MiJEciy/L5Gm8mABRf1P5YNXJmrae+6JHy0M55u6HVr+qjcMzVjFuci1
         wbnvChR8jBWtppRZXGKD+cWqxQM+msHbBQEvLb6xY6zCacm/occyqhY4I4HhZftZQ/R5
         Vlhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=isCj9HnqqlVH+KvOoOVR3CxVJIpBTR1R8pbElsHgbVE=;
        b=lhtP+84INROGQm5ARdb5CnyP9IH3GGuyVQ0z0wD8k5C9+u95OkXEBAdDklf/bQSeMv
         DTcvDvEKstCQw2oVQ/4QoRnw4xna27McADxbMDpfg9mxGh82oUrFtUdrmKAGTyrEuvbB
         oyoXAGSgpSzY2KwcQCRTwYZyBLmhgHdHEe5lmFQ+fuXk4K8iFctsE8yJjja3qGofq7v2
         4V14DEK1Qg0zfTGHb6bXjbOWka4gVe9y6wW48AuR8kuY5Y4wHzdWZw8fydtU1VzVZ2S5
         1rXR0zSm1rQLCZl3/h+8dYYf/zFftOPhDeuwev59NIrB3u36Y+GxJTOgys+87tLuUUfo
         HlFQ==
X-Gm-Message-State: APjAAAWpGyuqjFZRbI4B75jUwXYYlOdKiorOOxcvzcP3yrZY78tkG4YU
        sFIdxtMwde97p+hlvPy2790q3XdO3dbA2p5Nuyc=
X-Google-Smtp-Source: APXvYqztvyq4HwGG4C61dM+qDMWn7ks7Vj/J3vLNzVx7pQyRhSIAzA/M0myjXUa8gnauy4T6S8g7UhSISjEctLYpS7E=
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr2114520wmj.85.1571990367836;
 Fri, 25 Oct 2019 00:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571033544.git.lucien.xin@gmail.com> <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <20191025032156.GA4326@localhost.localdomain>
In-Reply-To: <20191025032156.GA4326@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 25 Oct 2019 15:59:18 +0800
Message-ID: <CADvbK_dzWt_LNu4sT5TtsOEzcg5cJvPqVqphE-QbFDgB7pPJdQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>,
        David Laight <david.laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 11:22 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Hi,
>
> Sorry for the long delay on this review.
>
> On Mon, Oct 14, 2019 at 02:14:44PM +0800, Xin Long wrote:
> > SCTP Quick failover draft section 5.1, point 5 has been removed
> > from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
> > Layer Protocol (ULP) about this state transition", as said in
> > section 3.2, point 8.
> >
> > So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
> > in section 7.1, "which is reported if the affected address
> > becomes PF". Also remove transport cwnd's update when moving
> > from PF back to ACTIVE , which is no longer in rfc7829 either.
> >
> > v1->v2:
> >   - no change
> > v2->v3:
> >   - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/uapi/linux/sctp.h |  2 ++
> >  net/sctp/associola.c      | 17 ++++-------------
> >  2 files changed, 6 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index 6bce7f9..f4ab7bb 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -410,6 +410,8 @@ enum sctp_spc_state {
> >       SCTP_ADDR_ADDED,
> >       SCTP_ADDR_MADE_PRIM,
> >       SCTP_ADDR_CONFIRMED,
> > +     SCTP_ADDR_POTENTIALLY_FAILED,
> > +#define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> >  };
> >
> >
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index 1ba893b..4f9efba 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>
> While at here, dealing with spc_state, please seize the moment and
> initialize it to the enum instead:
>
> @@ -787,7 +787,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>                                   sctp_sn_error_t error)
>  {
>         bool ulp_notify = true;
> -       int spc_state = 0;
> +       int spc_state = SCTP_ADDR_AVAILABLE;
>
>
> >                       spc_state = SCTP_ADDR_CONFIRMED;
> >               else
> >                       spc_state = SCTP_ADDR_AVAILABLE;
>
> This else could be removed (equals to initial value).
yes, will improve it.

>
> > -             /* Don't inform ULP about transition from PF to
> > -              * active state and set cwnd to 1 MTU, see SCTP
> > -              * Quick failover draft section 5.1, point 5
> > -              */
> > -             if (transport->state == SCTP_PF) {
> > -                     ulp_notify = false;
> > -                     transport->cwnd = asoc->pathmtu;
> > -             }
> >               transport->state = SCTP_ACTIVE;
> >               break;
> >
> > @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> >                * to inactive state.  Also, release the cached route since
> >                * there may be a better route next time.
> >                */
> > -             if (transport->state != SCTP_UNCONFIRMED)
> > +             if (transport->state != SCTP_UNCONFIRMED) {
> >                       transport->state = SCTP_INACTIVE;
> > -             else {
> > +                     spc_state = SCTP_ADDR_UNREACHABLE;
> > +             } else {
> >                       sctp_transport_dst_release(transport);
> >                       ulp_notify = false;
> >               }
> > -
> > -             spc_state = SCTP_ADDR_UNREACHABLE;
> >               break;
> >
> >       case SCTP_TRANSPORT_PF:
> >               transport->state = SCTP_PF;
> > -             ulp_notify = false;
> > +             spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
> >               break;
> >
> >       default:
> > --
> > 2.1.0
> >
