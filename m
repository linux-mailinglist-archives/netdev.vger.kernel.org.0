Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E5D3F6D95
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 05:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbhHYDB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 23:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236811AbhHYDB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 23:01:26 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982B3C061757;
        Tue, 24 Aug 2021 20:00:41 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id t190so25622571qke.7;
        Tue, 24 Aug 2021 20:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QHaHVfC9ZxdCotTX4ZlHKoxMecl4et3Tc+Q5i4v+294=;
        b=Nm5KC+mwaP5nSOwDKdt5G/qE9bXDYFPJYJSgz4UdqogrQe4unOKPDA2nrXmqCCBS+z
         gtPspbN/wzGVbOH2toSxpv+josum4DrKzylgAsnwRN4BkOpheBxD6/rlWTMTMaaixKnc
         R6pj8hEAyWp2CXC0nkQrM/i3FQji7GHNPa2lI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QHaHVfC9ZxdCotTX4ZlHKoxMecl4et3Tc+Q5i4v+294=;
        b=DPSNI0cH7q2uoHVQU+zEIdp84ByLAkyshE/MiISHJW3bXtQuIr4wyaoWtGpY4K1vJ+
         QTlG9tKVv4oW4JL5CzHPUYkF5PCrUVDihFNo+Byl1H8BokDCAsaSdRJHe4r8qUBQXOUM
         uqjDSP8NVxalx7GpT5DF5nXszxE5c6gNrKTg/69fCVv4JFfOqnfMDN4Nmhs2trkRlqOB
         U/cKj5r5869av4aVekALMczpue6KwdJ6bEhhLhxn50+///wK3zOY60ScyFE81b/x5mIG
         bOnO5yIb7Fop3Zt+78S1XY5bW4rCK5wX4/AWDeb1FI7ThnAu2lL/fjGhOlLfSgLzkNl5
         iuJw==
X-Gm-Message-State: AOAM531oK0FrgMa/IQ+FGR3LoqmyPhE/wMT0taDeXNoXwc6+y8JVJ19r
        3L/ufsyY1tmjSsjAUD58zSEuHZcnoQAYJ7giNi4=
X-Google-Smtp-Source: ABdhPJwD0kTW8mIAWxw5LZiPoTqn2EmnDmUw4QVy9ogHF2fbLdzS9nl9FYamNANpFM5qtQTEND97mxvtWAt4bt6ARYY=
X-Received: by 2002:a05:620a:2223:: with SMTP id n3mr5811879qkh.66.1629860440525;
 Tue, 24 Aug 2021 20:00:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210820074726.2860425-1-joel@jms.id.au> <20210820074726.2860425-2-joel@jms.id.au>
 <YSPseMd1nDHnF/Db@robh.at.kernel.org> <CACPK8XcU+i6hQeTWpYmt=w7A=1EzwgYcMucz7y6oLxwTFTJsiQ@mail.gmail.com>
 <CAL_Jsq+q6o88_6910brD4wEWBTi068jGDmaD8pucEFrT5FcWMw@mail.gmail.com>
In-Reply-To: <CAL_Jsq+q6o88_6910brD4wEWBTi068jGDmaD8pucEFrT5FcWMw@mail.gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 25 Aug 2021 03:00:28 +0000
Message-ID: <CACPK8Xey50=7CGb--Myue-KzFLqGKWRMiW5j0z+fp4PLnYBUqA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add bindings for LiteETH
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 at 11:52, Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Aug 23, 2021 at 10:52 PM Joel Stanley <joel@jms.id.au> wrote:
> >
> > On Mon, 23 Aug 2021 at 18:44, Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Fri, Aug 20, 2021 at 05:17:25PM +0930, Joel Stanley wrote:
> >
> > > > +
> > > > +  interrupts:
> > > > +    maxItems: 1
> > > > +
> > >
> > > > +  rx-fifo-depth: true
> > > > +  tx-fifo-depth: true
> > >
> > > Needs a vendor prefix, type, description and constraints.
> >
> > These are the standard properties from the ethernet-controller.yaml. I
> > switched the driver to using those once I discovered they existed (v1
> > defined these in terms of slots, whereas the ethernet-controller
> > bindings use bytes).
>
> Indeed (grepping the wrong repo didn't work too well :) ).
>
> Still, I'd assume there's some valid range for this h/w you can
> define? Or 0 - 2^32 is valid?

0 would be problematic, but there's not really any bound on it.

I'll send a v3 with the reg-names documented. Thanks for the review.

Cheers,

Joel
