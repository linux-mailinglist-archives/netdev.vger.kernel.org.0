Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D91444D9A
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 04:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhKDDKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 23:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKDDKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 23:10:05 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F7CC06127A;
        Wed,  3 Nov 2021 20:07:27 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id t127so11150780ybf.13;
        Wed, 03 Nov 2021 20:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0WKPz/ZeRoXF3sQd10dP+NWHOO9HPyrJzM/t8aB8TmY=;
        b=Wjd9fo6bCdElVb1YXBrSNg3JCK1xq0lb12EgVc75FhmqjnhmHTbJ/jtsw3PYsZDlZm
         kYsh2SexP2mUIbZYwgzdxbZBrfuezC7qcE4cJ8WuUbJ1n7/z+TlETrbXjoc/xkNeYAq3
         T34zIMeOPZUBivg7aZdSIWsRTW8yFpW49O59x79jmgEDZ27Fzg6sN6+7l/lRTdaVKYWV
         SjAgsqe1JQRc57N6Tv0WKR4TFK8XvTJFgdwsCvww6mKCWbqDIkgnLbioKe6zBfiL7poY
         mXcjJwGjhXhM6JUWr18wjFJvZTaV/uePkP00x03kdkpTXGsMzVamHVgM8Y0yxw5D7RlH
         lx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0WKPz/ZeRoXF3sQd10dP+NWHOO9HPyrJzM/t8aB8TmY=;
        b=V7DQJ9siVWzmnOGYmSNtpTOWlTjhtOCL+lXybPeHn2p881uTwN7CyRzv3ZKN6DG5E3
         RxLDmXpEAwZWYwe9IUl5dl4gLv2aeW7KAWh3GKQBvVLnYiGjMD1wrPk69EpiKdEkZQRI
         4WFzx6p/JStuGLCD9ci1aa4L/4NJiHVJq5ZThoBuDSz508EGPiAUi/I0L++R9WO2uA2W
         wXENnRRvO3vZH/zZJ7FaZ+c8JPQAwoyJeWfj3sKdrJLh4wE/DVd1+SKb6fCdv8oNI8WK
         f54Vxos0cj2M0G1SqPWlKRv5teDY1LW2u596DQSymWcvj8T8tRF8gZ0O05bpfYyBD7U2
         36Hw==
X-Gm-Message-State: AOAM530fyQRTuib4yehYLC+kekaggDBRjAIC9TsUb3JKH8g4LopUKF+Q
        iQvGLQzwTHCRmR0re/vRWDXvEufTpJKtQajJpIo=
X-Google-Smtp-Source: ABdhPJxWi84Hxm87iRlfOMCXUAAUhHWSPnwgeuEl2u0peU86R5XsuHbk9+iUtB5TvFzOmqRa537B05jdrdvCxWeoh+g=
X-Received: by 2002:a25:bb0c:: with SMTP id z12mr54482892ybg.181.1635995246618;
 Wed, 03 Nov 2021 20:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAFcO6XMgwuz97EJN+8jh9PJ9seaUbousDBOh9sduM6MZ6MRHxA@mail.gmail.com>
 <20211103095308.7ff68a7f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211103095308.7ff68a7f@kicinski-fedora-PC1C0HJN>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Thu, 4 Nov 2021 11:07:16 +0800
Message-ID: <CAFcO6XPA5uR6PLqRYxNmie6jZkkZxpkyTzJmB7pyNNf17gg3Wg@mail.gmail.com>
Subject: Re: A kernel-infoleak bug in pppoe_getname() in drivers/net/ppp/pppoe.c
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mostrows@earthlink.net, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, I will check. Oh, you are right.



On Thu, Nov 4, 2021 at 12:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 4 Nov 2021 00:14:31 +0800 butt3rflyh4ck wrote:
> > Hi, I report a kernel-infoleak bug in pppoe_getname()) in
> > drivers/net/ppp/pppoe.c.
> > And we can call getname ioctl to invoke pppoe_getname().
> >
> > ###anaylze
> > ```
> > static int pppoe_getname(struct socket *sock, struct sockaddr *uaddr,
> >   int peer)
> > {
> > int len = sizeof(struct sockaddr_pppox);
> > struct sockaddr_pppox sp;    ///--->  define a 'sp' in stack but does
> > not clear it
> >
> > sp.sa_family = AF_PPPOX;   ///---> sp.sa_family is a short type, just
>
> But the structure is marked as __packed.
>
> > 2 byte sizes.
> > sp.sa_protocol = PX_PROTO_OE;
> > memcpy(&sp.sa_addr.pppoe, &pppox_sk(sock->sk)->pppoe_pa,
> >        sizeof(struct pppoe_addr));
> >
> > memcpy(uaddr, &sp, len);
> >
> > return len;
> > }
> > ```
> > There is an anonymous 2-byte hole after sa_family, make sure to clear it.
> >
> > ###fix
> > use memset() to clear the struct sockaddr_pppox sp.
> > ```
> > diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
> > index 3619520340b7..fec328ad7202 100644
> > --- a/drivers/net/ppp/pppoe.c
> > +++ b/drivers/net/ppp/pppoe.c
> > @@ -723,6 +723,11 @@ static int pppoe_getname(struct socket *sock,
> > struct sockaddr *uaddr,
> >         int len = sizeof(struct sockaddr_pppox);
> >         struct sockaddr_pppox sp;
> >
> > +       /* There is an anonymous 2-byte hole after sa_family,
> > +        * make sure to clear it.
> > +        */
> > +       memset(&sp, 0, len);
> > +
> >         sp.sa_family    = AF_PPPOX;
> >         sp.sa_protocol  = PX_PROTO_OE;
> >         memcpy(&sp.sa_addr.pppoe, &pppox_sk(sock->sk)->pppoe_pa,
> > ```
> > The attachment is a patch.
>


--
Active Defense Lab of Venustech
