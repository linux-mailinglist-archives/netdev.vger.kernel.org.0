Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631CD1AC174
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 14:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635870AbgDPMjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 08:39:24 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49927 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635720AbgDPMjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 08:39:11 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N7zJj-1jClw02wGx-0155ZG; Thu, 16 Apr 2020 14:39:07 +0200
Received: by mail-lj1-f177.google.com with SMTP id y4so7622553ljn.7;
        Thu, 16 Apr 2020 05:39:07 -0700 (PDT)
X-Gm-Message-State: AGi0PuZCrYRbhBk6titTh0aN0KepnQmgROdDLy6FfIZ4bV/9xH4uJq/+
        7CeBoTRRXBt2AuyNw0zYIfkmF8xcEalFZzPxAX8=
X-Google-Smtp-Source: APiQypJBjKSJ60PBcmBCW4rJUa3iEMj8puJUFjtDtgFXYZenSiZo1kQ7qfLc3ugSe7HBLKnPyUhQlFliM3tyUpQ3SD4=
X-Received: by 2002:a2e:6a08:: with SMTP id f8mr6773388ljc.8.1587040747110;
 Thu, 16 Apr 2020 05:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
 <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
 <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
 <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
 <20200410171320.GN11886@ziepe.ca> <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
 <20200414132900.GD5100@ziepe.ca> <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca> <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
 <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
 <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
 <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
 <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com> <874ktj4tvn.fsf@intel.com>
In-Reply-To: <874ktj4tvn.fsf@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 16 Apr 2020 14:38:50 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
Message-ID: <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:F8U/N57N4ckbcTeNDfExN5yylgb+ezCMC5CxuKhm89y+pGLDcau
 TREUOKo1o7WqeUtbope5PEn3ZpW/vvn9CO6eTPp4FgVJSWUMLQkv9ZiwTNMlTrUksypdRkL
 iekpBmtIaw/V0rrPXVnRsSsS4KnQG9tja4TN0vUbG4n6n8i7TRUGcMnwdO/uVog7m/pWJMQ
 szUoSrbUSgkQ1PeMQ3Qhg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EG5Pwn24R0E=:NEbJWW3YOe8tbYtXoYzQlB
 OYg76xqSVyfU+/ffXRtmY2F9L/jdC9+7winJhhdBcrgqy/cmI9hA1PzJ+O63YcHHjaKN/gghJ
 Rfp1wl6U7HQetDu3+0QYelsd+30GJVA03G9SL0JR6NY52MLgLMcXXjcbpBnR7HdRzB8OptiqP
 oUJfdahNM4nDohNOj+WsdsVatMuKlloeqszEytPxYNHOZHOiJNo3nlMHrhOFMnkc+c+rhCs01
 Tp5oyyUP+RRoLiEAvYn/YxY03443yZmMYCrOIfGDdmwc7wURorYc725p4fyKeT9X8CxzuPKMn
 4QlugRQEkWhj9+0kUJLnelNqBjg/nRpzSgm5bdeNwoeH4o1ouafmEcMYPJ/qXpaANcDLIQpCd
 x4gPZmDJ+kxDxf+c/0v5LZJ75+sUQ4DPLfuOlUfAenV6xxU0lSpZVkdeDaUXXjbbRub6SOAHD
 srVyUcUFbDpXjch+HtEqUMQcQKepiKhm/bl4pDktj6VicPIkd3ZkEpA7o6wNOHgj4XK0GlSxB
 01k415eeDnDwMhVrQqarpasfYw7yWI6ftUYtaOZMY5N6JP3nchBTSHOuuw2SX/t3+dBBF1akg
 J/dQilZQjOljqzOyKDfx/7/6lwexgABL7jI7ys3SApuTzsYIX5M8TD4vA59r0VoQlEWUJ1emQ
 2ptxk0G9LLwXYi+SxR4sjzZ61XreMX+Jw7B7vi30YHtbHNH/FUTcAFDAjL1ytz5lYq6IYfMMq
 ihIyKkE8nLu0z0bsFkuo3GNPdUKZhstr81HUW7Tus5uYok8AMo/+Qxf1O5zOK1vfIeTOalrcO
 3BNPsKq2lLZray15UpWQU5C20cOWblEffC2DJIUeh0mNPOqgMI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 12:17 PM Jani Nikula
<jani.nikula@linux.intel.com> wrote:
>
> On Thu, 16 Apr 2020, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thu, Apr 16, 2020 at 5:25 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> >> BTW how about adding a new Kconfig option to hide the details of
> >> ( BAR || !BAR) ? as Jason already explained and suggested, this will
> >> make it easier for the users and developers to understand the actual
> >> meaning behind this tristate weird condition.
> >>
> >> e.g have a new keyword:
> >>      reach VXLAN
> >> which will be equivalent to:
> >>      depends on VXLAN && !VXLAN
> >
> > I'd love to see that, but I'm not sure what keyword is best. For your
> > suggestion of "reach", that would probably do the job, but I'm not
> > sure if this ends up being more or less confusing than what we have
> > today.
>
> Ah, perfect bikeshedding topic!
>
> Perhaps "uses"? If the dependency is enabled it gets used as a
> dependency.

That seems to be the best naming suggestion so far

> Of course, this is all just talk until someone(tm) posts a patch
> actually making the change. I've looked at the kconfig tool sources
> before; not going to make the same mistake again.

Right. OTOH whoever implements it gets to pick the color of the
bikeshed. ;-)

      Arnd
