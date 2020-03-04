Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB280178D89
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgCDJg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 04:36:28 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45992 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgCDJg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 04:36:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id v2so1462123wrp.12;
        Wed, 04 Mar 2020 01:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oBcw/ZuX+PnblQJRKpiTQFzgs/nhSOyn9RjGSvzKFBo=;
        b=NzICCaQ5VzpXWy97NBp10evWxxCpwwq+SsaFM8Vze4/6BdHDXk9/iXhaX01zS9XL62
         JUXGqKwMd/PuCl6BQZQDTvKFXxT5A4TNvVqr/Uzcfvt0vk8xm9VZSpQaT4z6kAj24YET
         qwzI8gwTaxCW+MUUPsWOEmw7ry+Fl3Cu0NVVhQP52hBUAy589uyb8bWc0IJwVbf2AUL7
         4RDXGnihzlg3jFD1ZTqwRz8DzpYwkl6Ke99ZC7YKp8Cuv62sp9tVlUXaaeiIKas5s+1u
         EW18HHsGCLSaUWixbu+Uutj1W6MRYxqg05GFi4tBSNbYbKXgxp9UGdkZbCYjlXDKPZiV
         fffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oBcw/ZuX+PnblQJRKpiTQFzgs/nhSOyn9RjGSvzKFBo=;
        b=YKoOKnw3jvWwNVv40KSXXBFSbTshyr28XVVJTAUYNFPShZS36MIr78/Lsj28cp3yJY
         1BoFlpHjna3hRnC9HgE/j6bPfC6/tg4bQv6g/6uc4cFZez46hq1Xh0fFfau6DJ9Dut2c
         g0lpsOqVsGEDbmRZZgMEZJnroJZKOj9SC8gF8ZDwle+HZxI3bf9rGABIm/XbgX2IOd1b
         4HBnQdnuKtB9ditR0gw4mIQTWIyN6wqu40CV6EJOe8WqCOmqlbDcFhyl5451EXQY6gVu
         Hi8up9E58sVOL+gcXnFyOhbsCN1xaA9noN7w4GFE8YMzBoQ3reBr04K9605xDqbdQr4C
         5hJg==
X-Gm-Message-State: ANhLgQ0tiPW0xZgtcZuLL9f/N/wfOgH2AYqRP8DfJzO/FsA6gwJiY/Fp
        zGuJlmmZL4bxy5SUONLeVwUd/5NjB+h9zla8Tuk=
X-Google-Smtp-Source: ADFU+vtf/5db620XKudtSPvPoC7J4Tnc5OkCqIy37mBhtTZL46sKzjR4565V8kLrdzlGEb//AnxHjeGY/0Blfq7QgLM=
X-Received: by 2002:a5d:6083:: with SMTP id w3mr3172089wrt.395.1583314586871;
 Wed, 04 Mar 2020 01:36:26 -0800 (PST)
MIME-Version: 1.0
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
 <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com>
In-Reply-To: <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 4 Mar 2020 17:38:24 +0800
Message-ID: <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing peeloff
To:     "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
<jere.leppanen@nokia.com> wrote:
>
> On Mon, 2 Mar 2020, Xin Long wrote:
>
> > As it says in rfc6458#section-9.2:
> >
> >   The application uses the sctp_peeloff() call to branch off an
> >   association into a separate socket.  (Note that the semantics are
> >   somewhat changed from the traditional one-to-one style accept()
> >   call.)  Note also that the new socket is a one-to-one style socket.
> >   Thus, it will be confined to operations allowed for a one-to-one
> >   style socket.
> >
> > Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> > on which some operations are not allowed, like shutdown, as Jere
> > reported.
> >
> > This patch is to change it to return a one-to-one type socket instead.
>
> Thanks for looking into this. I like the patch, and it fixes my simple
> test case.
>
> But with this patch, peeled-off sockets are created by copying from a
> one-to-many socket to a one-to-one socket. Are you sure that that's
> not going to cause any problems? Is it possible that there was a
> reason why peeloff wasn't implemented this way in the first place?
I'm not sure, it's been there since very beginning, and I couldn't find
any changelog about it.

I guess it was trying to differentiate peeled-off socket from TCP style
sockets.

>
> With this patch there's no way to create UDP_HIGH_BANDWIDTH style
> sockets anymore, so the remaining references should probably be
> cleaned up:
>
> ./net/sctp/socket.c:1886:       if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && msg->msg_name) {
> ./net/sctp/socket.c:8522:       if (sctp_style(sk, UDP_HIGH_BANDWIDTH))
> ./include/net/sctp/structs.h:144:       SCTP_SOCKET_UDP_HIGH_BANDWIDTH,
>
> This patch disables those checks. The first one ignores a destination
> address given to sendmsg() with a peeled-off socket - I don't know
> why. The second one prevents listen() on a peeled-off socket.
My understanding is:
UDP_HIGH_BANDWIDTH is another kind of one-to-one socket, like TCP style.
it can get asoc by its socket when sending msg, doesn't need daddr.

Now I thinking to fix your issue in sctp_shutdown():

@@ -5163,7 +5163,7 @@ static void sctp_shutdown(struct sock *sk, int how)
        struct net *net = sock_net(sk);
        struct sctp_endpoint *ep;

-       if (!sctp_style(sk, TCP))
+       if (sctp_style(sk, UDP))
                return;

in this way, we actually think:
one-to-many socket: UDP style socket
one-to-one socket includes: UDP_HIGH_BANDWIDTH and TCP style sockets.
