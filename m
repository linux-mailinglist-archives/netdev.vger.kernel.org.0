Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D7728FEE7
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 09:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404364AbgJPHJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 03:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404250AbgJPHJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 03:09:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E87C061755;
        Fri, 16 Oct 2020 00:09:03 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t9so1448047wrq.11;
        Fri, 16 Oct 2020 00:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIIdpu2aafryC7SkAft1rO9mxaExxYzvxUJKMsE57LM=;
        b=h8++BVrBVk+QB6QAgRp+N/cQmQNmxnsd8hWZgb8maJcShr2uJA6CI/LyeI3/szH85d
         eSgyTWtvn0SCjWxGw/i2GvxQTjBnvrFmW+s6n3spVlwg/7aTGw6ZOWjNTr4do4QYQpaq
         w5mhlbpFNG8RiUWj+JHpmvyTT+DB0pO40jONYnTydEW02rnACGGTFMYDB2l3Uz4OHog/
         ZfpMOu2yiPWkHUSrjeahGpMzjgsqWWJq4dP++tG2sxEI2l66yjYXO9TZQFzpIZ8Ir+lM
         wtLYWmaXCoAVEW7Zrfges56GS3mcZqSHdMbreFamNaU1l4jO89PVGTM0MPbO+DKJFhgs
         dndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIIdpu2aafryC7SkAft1rO9mxaExxYzvxUJKMsE57LM=;
        b=NATU+sqTE9RahBuHRKPT3Y7N9wgyL0pyt411VgUfBidypgLH40c0K+QRjxKUav7v17
         nkhdKwrrkQ13aKyOKEB3nLA4bYCgcoJRYoWqnB9auomKVZqDbTNWU2HbW+a48/pqBRwM
         G4YugSxyJMqqv9aKkPCyUQkaZds0nuYyOr7mx12Z8+8VX2hg+LjONc1cgKbOhcrr7MJF
         Tkt9oC4HKCeRMTY/zZrraDlaPa2FgQbqxe1YsKl6slWN4Xj5wrOTxa54CNhZ2PyFIPf2
         dUUvC5ILd+Gt7MyyegrDmiaEd/vO9oZ5MxGfszklSPD8PiHDZbxOJUahu7lNg6DKP6hS
         S1Fg==
X-Gm-Message-State: AOAM532uspoZf+oUecMqasucZul2gcM8AVaemuyRjGO4hmQbaP8MQV+H
        qLLhQVMcqqxLHNIhQMeQCFWZllOjRuDe21v5W+I=
X-Google-Smtp-Source: ABdhPJzU+rpl7mleJ7UmiIByEj8QhJlPpO6xYuF54LSPCCiaSNBB6n63CehF1DuVgJ4kCSLSJjwPW4HUEt/ebgQeKmo=
X-Received: by 2002:a5d:5748:: with SMTP id q8mr2165039wrw.299.1602832142701;
 Fri, 16 Oct 2020 00:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602574012.git.lucien.xin@gmail.com> <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
 <20201015174252.GB11030@localhost.localdomain>
In-Reply-To: <20201015174252.GB11030@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 16 Oct 2020 15:08:51 +0800
Message-ID: <CADvbK_eMOPQfB2URNshOizSe9_j0dpbA47TVWSwctziFas3GaQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 1:42 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Actually..
>
> On Tue, Oct 13, 2020 at 03:27:41PM +0800, Xin Long wrote:
> ...
> > Also add sysctl udp_port to allow changing the listening
> > sock's port by users.
> ...
> > ---
> >  net/sctp/protocol.c |  5 +++++
> >  net/sctp/sysctl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 55 insertions(+)
>
> Xin, sorry for not noticing this earlier, but we need a documentation
> update here for this new sysctl. This is important. Please add its
> entry in ip-sysctl.rst.
no problem, I will add it.

>
> >
> > diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> > index be002b7..79fb4b5 100644
> > --- a/net/sctp/protocol.c
> > +++ b/net/sctp/protocol.c
> > @@ -1469,6 +1469,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
> >       if (status)
> >               pr_err("Failed to initialize the SCTP control sock\n");
> >
> > +     status = sctp_udp_sock_start(net);
> > +     if (status)
> > +             pr_err("Failed to initialize the SCTP udp tunneling sock\n");
>                                                       ^^^ upper case please.
> Nit. There are other occurrences of this.
You mean we can remove this log, as it's been handled well in
sctp_udp_sock_start()?

>
> > +
> >       return status;
> ...
> > +     ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > +     if (write && ret == 0) {
> > +             struct sock *sk = net->sctp.ctl_sock;
> > +
> > +             if (new_value > max || new_value < min)
> > +                     return -EINVAL;
> > +
> > +             net->sctp.udp_port = new_value;
> > +             sctp_udp_sock_stop(net);
>
> So, if it would be disabling the encapsulation, it shouldn't be
> calling _start() then, right? Like
>
>                 if (new_value)
>                         ret = sctp_udp_sock_start(net);
>
> Otherwise _start() here will call ..._bind() with port 0, which then
> will be a random one.
right, somehow I thought it wouldn't bind with port 0.

Thanks.
>
> > +             ret = sctp_udp_sock_start(net);
> > +             if (ret)
> > +                     net->sctp.udp_port = 0;
> > +
> > +             /* Update the value in the control socket */
> > +             lock_sock(sk);
> > +             sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
> > +             release_sock(sk);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> >  int sctp_sysctl_net_register(struct net *net)
> >  {
> >       struct ctl_table *table;
> > --
> > 2.1.0
> >
