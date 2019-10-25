Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E31BE4534
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437722AbfJYIFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:05:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38374 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404500AbfJYIFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 04:05:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id 22so872347wms.3;
        Fri, 25 Oct 2019 01:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YvRgO7iz/BYk6QPXZm5OQzR3xcGxvkTek7xbrL5InWM=;
        b=L+CK+UOkIyrd+6gywJGvua4Z9kDjhbn0xCLf9GbSlZ5ViV/3iMYWIqT7QOFHgs3hZi
         l2EJqatRxtd7BMgNDdoLnhaAtSgbgCY4Bqhl40tEbomV41f4W83GE5bI0ViHPawc2kpA
         vqQcjIPKVRVGUx610U1oLGiL9Q3C5qxW2OUVIrjEFE8LoQy6MU+foXEOcpU7w0MpjWxM
         4aQygQJtD+sbRaUehqWvVM+DKLPgwCcbkuN8K5/mm+eerwwlRO6+EcUAK20w1NIQsdGt
         IG3rp9GUx+TmEpnYYbpV36A3dG6viMyxr+sTKt7AaXeBe6CNP2ihQFf8IdBNcGbWNzoC
         nyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YvRgO7iz/BYk6QPXZm5OQzR3xcGxvkTek7xbrL5InWM=;
        b=gz6GpMYkAT7FULol9CxeQ1n2GkuApTpYgUyAEa2u5GJezGa2Wky6J+5qnlytRPZIa2
         igqTMhh9bn+Eb1Be3oxYXWJXsaG59a9AvZYocSTliSMiOWRYpB4UIHebUPd7rQbDDQXT
         2J0H9Dkjs0Zt7b9TWx+F2w99vXKZ7m6bQvXT0UJyhD9fX6M9FWxf6K9XbE0v0qRgdaaS
         hLEGdP5NdTeZYuEEvFmlXWTdlQgJ8/wt/+RvDQDypf0rVIs8lmPutKcF+ljlZYVq0tjL
         XTPfq9/7EWXjVXjgtWimmGS07M/mpzKEFzGPiLmokqkgEugfNofA9VXd+vOh8kqBgQcJ
         39vQ==
X-Gm-Message-State: APjAAAWEe3YLzvtHxvlIs9FaUWXeirEtxP0pSZEx6mhC9rG3XIQjBY/C
        vTVSEkGIdH5vojS4TTz5jwBuwXeEgycqXAJE/fNB7A==
X-Google-Smtp-Source: APXvYqzT4r4q/irLUTrPereAFjgWO8KlXvBep36+Ipv///FZFwvKPEuoWufjuH19klJkRJujEZIUXeL1W3QzQLF6K4k=
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr2057725wme.99.1571990748085;
 Fri, 25 Oct 2019 01:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571033544.git.lucien.xin@gmail.com> <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
 <20191025032412.GD4326@localhost.localdomain>
In-Reply-To: <20191025032412.GD4326@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 25 Oct 2019 16:05:38 +0800
Message-ID: <CADvbK_eSJ2NhTiCqOfEG0OGgBAEyhbmT_skTgw85Uhcmb=5gdw@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 sockopt
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

On Fri, Oct 25, 2019 at 11:24 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Oct 14, 2019 at 02:14:46PM +0800, Xin Long wrote:
> > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > the Potentially Failed Path State", by which users can change
> > pf_expose per sock and asoc.
> >
> > v1->v2:
> >   - no change.
> > v2->v3:
> >   - return -EINVAL if params.assoc_value > SCTP_PF_EXPOSE_MAX.
> >   - define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE.
>
> Hm, why again? Please add it to the changelog, as it's an exception on
> the list below.
will do. thanks.

>
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/uapi/linux/sctp.h |  2 ++
> >  net/sctp/socket.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> >
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index d99b428..a190e4a 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -137,6 +137,8 @@ typedef __s32 sctp_assoc_t;
> >  #define SCTP_ASCONF_SUPPORTED        128
> >  #define SCTP_AUTH_SUPPORTED  129
> >  #define SCTP_ECN_SUPPORTED   130
> > +#define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE 131
> > +#define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
> >
> >  /* PR-SCTP policies */
> >  #define SCTP_PR_SCTP_NONE    0x0000
