Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C4B1F4144
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 18:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgFIQpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 12:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbgFIQpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 12:45:23 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14845C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 09:45:22 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id m21so16884979eds.13
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 09:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jKWUJNaMbH8mXO94Kj7M7bC98oWTaC2jO4qO598aOKU=;
        b=Bqkgd2VoBJF4kH+PvkFgqnTHQ35Yej7r1wBJm41zLeUtBkhFUrJn+XAhBW56/K+/yG
         HbFskyaF/4tg4cvixD23TNnyarwTOmWuPeg7Vx7UfiSe1Na6fX3LA5OZbFGwOrL0n5Jh
         Irt37Mtg0ZOhRwKNL9A9qic3uf5QIrhFz2NpbCbHN9giTzKuG/W1klOvFI/JpmZmNjT0
         Fby2d0SR57rDgXagJpmHT+Gvqv/qICHeHbOVfDtbdLLoNGq7hG3YrxJjeFBwUSEJrWq5
         UEWXt79zAglu0wCUNukr/3xQeJB70L2Fjwdfmje01efSFBSQ3Z6jadYSKoLhTtUK33Hb
         xx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jKWUJNaMbH8mXO94Kj7M7bC98oWTaC2jO4qO598aOKU=;
        b=S3UOrwRT4kdhZOZNh3wZX2nF5duSxKNd77+4SIrydMHrdmuhU/0ZGAalkZPkuv9Zn0
         FSyX/aTghJCpajYHcanycMMa7K846xW92PtLomf2M9EuVRZjqGE0YkYI0aPPgLRNgddG
         D25lE3O2iSoGSf5uT2Z1ogcW1FAZL2i3RW8/Nu+qcPv+OeXEPfI1BJug+RP2oGR/JVHl
         2KJgL1le/r8uBFeeZ8WOpxE1RiLQVM5M6fUYTQBGzKqNlWbkjIIZnbwRMeiYag+IdDtQ
         5erF9HU7pk7zjj2MholtvnUK0O1XbyLD21+u1T1PZzMTIkWpmJ7sOLJ1k6EayqbMQdR3
         MMuA==
X-Gm-Message-State: AOAM530CVpVfVB/sNbu+NQPhl+BJ3DgHwwEpDw2Lcu5k0mpoaS4fYjKC
        a6DjPw7ywxULVxy3R6CrY0zfz17R6/2Hz9Wk7H0=
X-Google-Smtp-Source: ABdhPJwKe2uOFgC4+6VDMvNeAow/gaEMBA1Ajmef7IgOinShOhSwimcfjHSVWFrJ2cWgp7N/GXDgbsjW2LkamyOo+6g=
X-Received: by 2002:a05:6402:2207:: with SMTP id cq7mr25308661edb.186.1591721120682;
 Tue, 09 Jun 2020 09:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <538FB666.9050303@yahoo-inc.com> <alpine.LFD.2.11.1406071441260.2287@ja.home.ssi.bg>
 <5397A98F.2030206@yahoo-inc.com> <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
 <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
 <878029e5-b2b2-544c-f4b5-ff4c76fd6bd3@gmail.com> <CALMXkpbNeRCrOnQFWAWR8BzX4yRgDveDMPZgS6NupjXrHFX1pg@mail.gmail.com>
 <b520b541-9013-3095-2e3b-37ec835e4ff8@gmail.com> <20200607100049.GM28263@breakpoint.cc>
In-Reply-To: <20200607100049.GM28263@breakpoint.cc>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Tue, 9 Jun 2020 09:45:09 -0700
Message-ID: <CALMXkpbD_81divLN013LQyJkV8-JyZwXXhkaqTAQ3wQdh-fUZg@mail.gmail.com>
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
To:     Florian Westphal <fw@strlen.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leif Hedstrom <lhedstrom@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, Jun 7, 2020 at 3:00 AM Florian Westphal <fw@strlen.de> wrote:
>
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > Sure! TCP_DEFER_ACCEPT delays the creation of the socket until data
> > > has been sent by the client *or* the specified time has expired upon
> > > which a last SYN/ACK is sent and if the client replies with an ACK the
> > > socket will be created and presented to the accept()-call. In the
> > > latter case it means that the app gets a socket that does not have any
> > > data to be read - which goes against the intention of TCP_DEFER_ACCEPT
> > > (man-page says: "Allow a listener to be awakened only when data
> > > arrives on the socket.").
> > >
> > > In the original thread the proposal was to kill the connection with a
> > > TCP-RST when the specified timeout expired (after the final SYN/ACK).
> > >
> > > Thus, my question in my first email whether there is a specific reason
> > > to not do this.
> > >
> > > API-breakage does not seem to me to be a concern here. Apps that are
> > > setting DEFER_ACCEPT probably would not expect to get a socket that
> > > does not have data to read.
> >
> > Thanks for the summary ;)
> >
> > I disagree.
> >
> > A server might have two modes :
> >
> > 1) A fast path, expecting data from user in a small amount of time, from peers not too far away.
> >
> > 2) A slow path, for clients far away. Server can implement strategies to control number of sockets
> > that have been accepted() but not yet active (no data yet received).

to add to that: There are indeed scenarios where TCP-SYN/... without
payload go through fine but as soon as the packet-size increases
WiFi/Cell has problems because of smaller grants given by the
AP/tower. But even those connections should be able to get the data
through within a "reasonable" timeframe. Anything beyond that
timeframe will anyways have such a bad user-experience that it is
pointless to continue.

So, a use-case here would be where the user is in such a slow network
and a TCP-split proxy is deployed (such proxies are very common in
cellular networks). That proxy will be ACKing the server's SYN/ACK
retransmission at the end of the defer-accept period, while the client
is still trying very hard to get the data through to the proxy (or
even, the client might have gone totally out-of-service).

For those kinds of scenarios it would make sense to have a different
DEFER_ACCEPT-behavior (maybe with a separate socket-option as Florian
suggested).


Christoph

>
> So we can't change DEFER_ACCEPT behaviour.
> Any objections to adding TCP_DEFER_ACCEPT2 with the behaviour outlined
> by Christoph?
