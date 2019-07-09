Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB363DB3
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfGIWDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfGIWDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 18:03:42 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6F620844;
        Tue,  9 Jul 2019 22:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562709820;
        bh=EOfv0IJBF0t3DLIUgIhhzoRRwSja9eNG9rCjIupc6hc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hnT7DgxaLEp7aHxayOUXmsvnKgo/b7/ncGJoHze2v06LGOfyqY+wlRMPj3QUiFo7l
         1KDC4Bh4iPFcNIq0Morfms7doWHJbsfZgziSPL2Ed4rL7D2aFuLd5fYg1hU+aXhMR4
         IVkUvu6VIJZzIYAIq+EJ5crhos377adDwOpi27jg=
Received: by mail-qk1-f169.google.com with SMTP id g18so360311qkl.3;
        Tue, 09 Jul 2019 15:03:40 -0700 (PDT)
X-Gm-Message-State: APjAAAUSvJ6KgT8E48D9v2vMgLWbLD7b+ihhKoHn3SJ5xRqEBbSsZLXX
        NZel6aI/V8FdyP2A9tksUrOZ581OtgP9TWoWGA==
X-Google-Smtp-Source: APXvYqy8ReY8DDK/lYnBtZlNqPX5UetguMX6SjWqmS0APLvDW2/mSIY6u/4Asc4OlVXYmBFHCoK3iI+KYQPf8t/AexI=
X-Received: by 2002:a37:6944:: with SMTP id e65mr18734160qkc.119.1562709820077;
 Tue, 09 Jul 2019 15:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190706151900.14355-1-josua@solid-run.com> <20190706151900.14355-2-josua@solid-run.com>
 <CAL_JsqJJA6=2b=VzDzS1ipOatpRuVBUmReYoOMf-9p39=jyF8Q@mail.gmail.com> <20190709024143.GD5835@lunn.ch>
In-Reply-To: <20190709024143.GD5835@lunn.ch>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 9 Jul 2019 16:03:28 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK=qpCi6whqmjW2L8O=3u4oZemH=czm60q9QnC09Gr_ig@mail.gmail.com>
Message-ID: <CAL_JsqK=qpCi6whqmjW2L8O=3u4oZemH=czm60q9QnC09Gr_ig@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: allow up to four clocks for orion-mdio
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     josua@solid-run.com, netdev <netdev@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 8:41 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > >  Optional properties:
> > >  - interrupts: interrupt line number for the SMI error/done interrupt
> > > -- clocks: phandle for up to three required clocks for the MDIO instance
> > > +- clocks: phandle for up to four required clocks for the MDIO instance
> >
> > This needs to enumerate exactly what the clocks are. Shouldn't there
> > be an additional clock-names value too?
>
> Hi Rob
>
> The driver does not care what they are called. It just turns them all
> on, and turns them off again when removed.

That's fine for the driver to do, but this is the hardware description.

It's not just what they are called, but how many too. Is 1 clock in
the DT valid? 0? It would be unusual for a given piece of h/w to
function with a variable number of clocks.

Rob
