Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2FEC3496
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 14:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387752AbfJAMnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 08:43:46 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40187 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732701AbfJAMnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 08:43:45 -0400
Received: by mail-yb1-f195.google.com with SMTP id g9so5409969ybi.7
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 05:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFZPmfhMSJqXgCMqAdkehhLyH1lMC11fUW8pTF0cedQ=;
        b=NzY9BvwGuahCGR9xLnCCy4j1h/XDJvTL5Q51UXnFDFn655cwPVWUpU581c0f8DSdkd
         utIyxEemb+xHuVi4pO8cM6d0+RLDg3MWhXDBzuzFuw4+P3Vncu2Q2nDDUBcKSlDM6JzD
         J8pp8PGaSgvwTB9uRnIGhTuwqDSu870Ajq3O+YVEMrB7OoHi3J2ND5dcWOwPqtrh5LaL
         udzpVqN6MHnYru1oMUUwOZJuwgFwf9gWB85Suxarb2JW1VSGWuDSeivxnwMFxYBR19GQ
         MfWzc9qViz/CpgOlwGNH75l128N9K+Trj5Ygg4pAztaK3eAujQPpjMmPVaRP6yHdPtf1
         qygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFZPmfhMSJqXgCMqAdkehhLyH1lMC11fUW8pTF0cedQ=;
        b=lNC2j/SpYENFiVdgVcFymbhIRNDezTTT6TzcdgmTjLzBaPCSxChO4H3oNgwH8qDDt1
         ux+hX1i1jQm2qKuYipbe1sb+wJJqItMjgNdOt8YLoBRonq/aV4diZW7Zia9Q/Rj8GmJL
         juu5F6XlYz77fI4YXi4tYovaDvwyWGxP+pstF2epHpeKDYpbAOafZ2cuURG5Vg+SfXQ2
         1Jc/vkDxaBkpRyFdtZbG1s9M+/OChYkt7TtSjq5x+6+0CAOiBHinTFSOu5OALvXO/W4Y
         BL87m+GFKSdxoMLLd4Qa4WELSe3k7DW8k/SJizJhbGZOrkRNp9xkhBaCB0vd45oaQfIB
         kAhQ==
X-Gm-Message-State: APjAAAUbxfORiTfd7JqVnLcVVuGudiKrO49/Ir9F4DyHPWw6cL01c4jZ
        Ncsqp49Qa6wGz+fb2DHGbYMiXGDM
X-Google-Smtp-Source: APXvYqzlQBrhIOorGnl9H+ElsXb0J+p0mtmwFZzbO1IKLkTD/CtMRE9FzUBr+VhJfMb4Nl0R+vJbOQ==
X-Received: by 2002:a25:3797:: with SMTP id e145mr18699753yba.438.1569933823932;
        Tue, 01 Oct 2019 05:43:43 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id h3sm3506526ywk.40.2019.10.01.05.43.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 05:43:42 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id w125so5399249ybg.12
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 05:43:42 -0700 (PDT)
X-Received: by 2002:a25:b903:: with SMTP id x3mr16738939ybj.89.1569933822056;
 Tue, 01 Oct 2019 05:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-4-steffen.klassert@secunet.com> <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
 <20190930062427.GF2879@gauss3.secunet.de> <CA+FuTScxNZKdb0FqAXjxPXY4XEhFFh+_COy0QjCfvw4phSQF3g@mail.gmail.com>
 <20191001061816.GP2879@gauss3.secunet.de>
In-Reply-To: <20191001061816.GP2879@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 1 Oct 2019 08:43:05 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdTDAG95XCc8qcb7pJJn_6HuxCrCJnta+sJZa7Bi9x6tw@mail.gmail.com>
Message-ID: <CA+FuTSdTDAG95XCc8qcb7pJJn_6HuxCrCJnta+sJZa7Bi9x6tw@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] net: Add a netdev software feature set that
 defaults to off.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 2:18 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Mon, Sep 30, 2019 at 11:26:55AM -0400, Willem de Bruijn wrote:
> > On Mon, Sep 30, 2019 at 2:24 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > On Mon, Sep 23, 2019 at 08:38:56AM -0400, Willem de Bruijn wrote:
> > > >
> > > > The UDP GRO benchmarks were largely positive, but not a strict win if
> > > > I read Paolo's previous results correctly. Even if enabling to by
> > > > default, it probably should come with a sysctl to disable for specific
> > > > workloads.
> > >
> > > Maybe we can just keep the default for the local input path
> > > as is and enable GRO as this:
> > >
> > > For standard UDP GRO on local input, do GRO only if a GRO enabled
> > > socket is found.
> > >
> > > If there is no local socket found and forwarding is enabled,
> > > assume forwarding and do standard GRO.
> > >
> > > If fraglist GRO is enabled, do it as default on local input and
> > > forwarding because it is explicitly configured.
> > >
> > > Would such a policy make semse?
> >
> > Making the choice between fraglist or non-fraglist GRO explicitly
> > configurable sounds great. Per device through ethtool over global
> > sysctl, too.
> >
> > My main concern is not this patch, but 1/5 that enables UDP GRO by
> > default. There should be a way to disable it, at least.
> >
> > I guess your suggestion is to only enable it with forwarding, which is
> > unlikely to see a cycle regression. And if there is a latency
> > regression, disable all GRO to disable UDP GRO.
>
> Yes, do GRO only for forwarding or if there is a GRO capable socket.
>
> In this case it can be disabled only by disable all GRO.
> It might be a disadvantage, but that's how it is with other
> protocols too.
>
> >
> > Instead, how about adding a UDP GRO ethtool feature independent of
> > forwarding, analogous to fraglist GRO? Then both are explicitly under
> > admin control. And can be enabled by default (either now, or after
> > getting more data).
>
> We could add a protocol specific feature, but what would it mean
> if UDP GRO is enabled?
>
> Would it be enabled for forwarding, and for local input only if there
> is a GRO capable socket? Or would it be enabled even if there
> is no GRO capable socket? Same question when UDP GRO is disabled.

Enable UDP GRO for all traffic if GRO and UDP GRO are set, and only
then. That seems like the easiest to understand behavior to me, and
gives administrators an opt-out for workloads where UDP GRO causes a
regression. We cannot realistically turn off all GRO on a mixed
TCP/UDP workload (like, say, hosting TCP and QUIC).

> Also, what means enabling GRO then? Enable GRO for all protocols
> but UDP? Either UDP becomes something special then,

Yes and true. But it is something special. We don't know whether UDP
GRO is safe to deploy everywhere.

Only enabling it for the forwarding case is more conservative, but
gives no path to enabling it systemwide, is arguably confusing and
still lacks the admin control to turn off in case of unexpected
regressions. I do think that for a time this needs to be configurable
unless you're confident that the forwarding path is such a win that
no plan B is needed. But especially without fraglist, I'm not sure.

> or we need
> to create protocol specific features for the other protocols
> too. Same would apply for fraglist GRO.

We don't need it for other protocols after the fact, but it's a good
question: I don't know how it was enabled for them. Perhaps confidence
was gained based on testing. Or it was enabled for -rc1, no one
complained and stayed turned on. In which case you could do the same.
