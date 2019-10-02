Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80D7C88A5
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 14:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfJBMcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 08:32:53 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44496 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfJBMcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 08:32:52 -0400
Received: by mail-yb1-f195.google.com with SMTP id f1so6618145ybq.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 05:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lK9nHlEURCnbz2v5ttFZL5rgBtDlxRRrcIzqAAig4dc=;
        b=njQEvcMl3PvFO3Z7zgtbc9l1MfJsGt+qrq1f7wmgdEPphOesHU+lf3JDIIFwIBZAbd
         ikudFw9mK+/u0US9tnFpa5wj6N4Zl8YS04gibW7UIhlsL4eZrPvsje5mGSi4yxwCdTOF
         6PZm0HWg8J3vlKo+gYaTnuzpoxEzf6grxX2fF6hRpwlFRihKVQ8uJflXua4Pc2M/i/3S
         PjacbelvSQoQPXBGOQHKsJ6zBrIu325J/9C8Ski4wL8xNWWacxi+1ANyzZxeRxfnIcgu
         5o7Nb5eCiOneYu7HPT0dffv6fuqBSoBubuMGMA78eZetO4cgkDSfL3bQqn5rLwCpfi6d
         RfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lK9nHlEURCnbz2v5ttFZL5rgBtDlxRRrcIzqAAig4dc=;
        b=T7Bx321ve2M+ByD/WZAoF2tLIX8oKqXr+Ofyzz2gDuiC7D27uHYE8t9E99qMuoQyWj
         aNL6NVy+t0R1z6wvEUgLxQIhKIZLJWzFuWhm0oDWiXiceG0zuVmx08ZzGeFdCxtHhybb
         U1G9rH9bv7YJxRhIz/UTDNMVCDM4dLMOw5t9JRvUnnDkyJtGWpk07pOR1XUtJTiUeprc
         ZYQJ/h8ZwpYyjfBDt1kASPZHF8/IqRCUvtWxu8hcrY55zYI5g7AE7I2pbrCEdymRw3MC
         5J95eDIIBMsJXr/k0056yaK3hW3x4DFRJOVJ6DS53A/DrQi5KaAuDxaPFRNs+ytQrCHn
         LtkQ==
X-Gm-Message-State: APjAAAXNEm5ws7k3hn9W7MxLU3CZZYlXQpdjxwFxOol7gjZuuXIIvuB5
        n65hNAlFaVKY/dKw97YfOd1C2Q/2
X-Google-Smtp-Source: APXvYqwxRa9b63rD+d4cO27a6p7KBFy+4i78NroTWOAW5+Bw3v9NAK3l0m8w73wCY8dpT4/MR4fOkw==
X-Received: by 2002:a25:be03:: with SMTP id h3mr2176368ybk.179.1570019570963;
        Wed, 02 Oct 2019 05:32:50 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id m62sm4209895ywf.70.2019.10.02.05.32.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 05:32:50 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id m7so1885451ywe.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 05:32:49 -0700 (PDT)
X-Received: by 2002:a81:3182:: with SMTP id x124mr2207033ywx.411.1570019569334;
 Wed, 02 Oct 2019 05:32:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-4-steffen.klassert@secunet.com> <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
 <20190930062427.GF2879@gauss3.secunet.de> <CA+FuTScxNZKdb0FqAXjxPXY4XEhFFh+_COy0QjCfvw4phSQF3g@mail.gmail.com>
 <20191001061816.GP2879@gauss3.secunet.de> <CA+FuTSdTDAG95XCc8qcb7pJJn_6HuxCrCJnta+sJZa7Bi9x6tw@mail.gmail.com>
 <20191002082733.GR2879@gauss3.secunet.de>
In-Reply-To: <20191002082733.GR2879@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 2 Oct 2019 08:32:11 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfaPLENo+bmsVreDFJWPfhMx953uv=J8U1nnnh70atWmQ@mail.gmail.com>
Message-ID: <CA+FuTSfaPLENo+bmsVreDFJWPfhMx953uv=J8U1nnnh70atWmQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] net: Add a netdev software feature set that
 defaults to off.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 4:27 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Tue, Oct 01, 2019 at 08:43:05AM -0400, Willem de Bruijn wrote:
> > On Tue, Oct 1, 2019 at 2:18 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > On Mon, Sep 30, 2019 at 11:26:55AM -0400, Willem de Bruijn wrote:
> > > >
> > > > Instead, how about adding a UDP GRO ethtool feature independent of
> > > > forwarding, analogous to fraglist GRO? Then both are explicitly under
> > > > admin control. And can be enabled by default (either now, or after
> > > > getting more data).
> > >
> > > We could add a protocol specific feature, but what would it mean
> > > if UDP GRO is enabled?
> > >
> > > Would it be enabled for forwarding, and for local input only if there
> > > is a GRO capable socket? Or would it be enabled even if there
> > > is no GRO capable socket? Same question when UDP GRO is disabled.
> >
> > Enable UDP GRO for all traffic if GRO and UDP GRO are set, and only
> > then.
>
> But this means that we would need to enable UDP GRO by default then.

That is what your patch 1/5 does. My concern was that that is a bold
change without an admin opt-out.

> Currently, if an application uses a UDP GRO capable socket, it
> can expect that it gets GROed packets without doing any additional
> configuration. This would change if we disable it by default.
> Unfortunately, enabling UDP GRO by default has the biggest
> risk because most applications don't use UDP GRO capable sockets.
>
> The most condervative way would be to leave standard GRO as it is.
> But on some workloads standard GRO might be preferable, in
> particular on forwarding to a NIC that can do UDP segmentation
> in hardware.
>
> > That seems like the easiest to understand behavior to me, and
> > gives administrators an opt-out for workloads where UDP GRO causes a
> > regression. We cannot realistically turn off all GRO on a mixed
> > TCP/UDP workload (like, say, hosting TCP and QUIC).
> >
> > > Also, what means enabling GRO then? Enable GRO for all protocols
> > > but UDP? Either UDP becomes something special then,
> >
> > Yes and true. But it is something special. We don't know whether UDP
> > GRO is safe to deploy everywhere.
> >
> > Only enabling it for the forwarding case is more conservative, but
> > gives no path to enabling it systemwide, is arguably confusing and
> > still lacks the admin control to turn off in case of unexpected
> > regressions. I do think that for a time this needs to be configurable
> > unless you're confident that the forwarding path is such a win that
> > no plan B is needed. But especially without fraglist, I'm not sure.
>
> On my tests it was a win on forwarding, but there might be
> usecases where it is not. I guess the only way to find this out
> is to enable is and wait what happens.
>
> I'm a bit hesitating on adding a feature flag that might be only
> temporary usefull. In particular on the background of the talk
> that Jesse Brandeburg gave on the LPC last year. Maybe you
> remember the slide where he showed the output of
> ethtool --show-offloads, it filled the whole page.

I was using ethtool -K just yesterday to debug a peculiar mix of
tunneling protocols. And yes, used grep on it ;) But I don't have much
of a problem with this.

But agreed that if default on works in all cases, then it's unnecessary.

> >
> > > or we need
> > > to create protocol specific features for the other protocols
> > > too. Same would apply for fraglist GRO.
> >
> > We don't need it for other protocols after the fact, but it's a good
> > question: I don't know how it was enabled for them. Perhaps confidence
> > was gained based on testing. Or it was enabled for -rc1, no one
> > complained and stayed turned on. In which case you could do the same.
>
> Maybe we should go that way to enable it and wait whether somebody
> complains. A patch to add the feature flag could be prepared
> beforehand for that case.

This early in the cycle, that may work. Yes, it's definitely good to
have the plan B at the ready.

>
> It is easy to make a suboptimal design decision here, so
> some more opinions would be helpfull.

Agreed.
