Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6263DA9FFA
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732175AbfIEKjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:39:54 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35686 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfIEKjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:39:54 -0400
Received: by mail-ed1-f66.google.com with SMTP id t50so2218094edd.2
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 03:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sGxOAYT15qI5OMXfo8+5qUnea8NFB7aSKsTydG8dS/c=;
        b=De0QW/7DDtEJmC1xmooNTWlxg5VC3R7Wd9q25zlvUZOlP8cFpJD/UgEF5tGAa5toUy
         zgY1WkZZBBtsccHfdXunz8hYxSBv9ZVf0Wh35rH7XpfQF5qyjLCQQiHmqof+NWaShGvT
         86K/S5dAw9/980szeHaZ11A4GIaBO/XUMmkrflU1Yk8Oa4QzjpPhak2H363Xg2Ql20yd
         l6vYcb9FKneBMzF8qc2/fmjWhtrmKR+ER22J4lMs9gHHueW8iEmUpoGjFSQPPA0nsOI5
         aIUGZuKccY3mIBoz+5ejhlMN3PhSYfo47zGc6s4vuaA1cy0hcC7rMAbuFtrXHwBYEBmu
         S3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sGxOAYT15qI5OMXfo8+5qUnea8NFB7aSKsTydG8dS/c=;
        b=Gr+yRC8CsaXgAQltFbgDWbTEJO4Wx5mZaVFO4jz4V4d22bg8Ofl4FpwDBdmc6kPGtJ
         rsNpBJw0GedlBThSJtmvT4o4gvLyhQ7A0OkF7XEKB7o0P7l3V++bADmpHjRB3qxcZhS9
         GsTJuvJx6gJuGj6Tq2jpl9OE/hNFyQiChy+y0V9ICJpNX5GQ+kQ7G+6vn5TtUv3RqV2P
         +Hds8Ov2jZZqzX3JH9DPiI3w/7OAXP0r5rb0JVDOkcqzGrJQ6vg85FFybNbYkSpo//pm
         wp3HtBoR9AYt5cZYutISOPaWTFlvYPnQAjiO33fMJN/VQHtbCv9Qrm/G+xcvKdnUMIq4
         xp/Q==
X-Gm-Message-State: APjAAAUBQjfx4i+hY/h4uL1WNuv32RDy6k1WjFcN/sdj4kGmIwHbVOOm
        u7NY8KiIYxDF9uo1s9RI5Dx5PjZK0Y8fSs92bB8=
X-Google-Smtp-Source: APXvYqzSANp4b3QIbBM93nOry82YCKPvqABrPk6E1UlJ0QARXG/6X9MEUhkkSeJV596lIsmlQT0YEXRokhu+cWd0T7g=
X-Received: by 2002:a50:d552:: with SMTP id f18mr3009315edj.36.1567679992768;
 Thu, 05 Sep 2019 03:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
 <20190904135223.31754-1-asolokha@kb.kras.ru>
In-Reply-To: <20190904135223.31754-1-asolokha@kb.kras.ru>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 5 Sep 2019 13:39:41 +0300
Message-ID: <CA+h21hpbtsJtUSVUqRO1mpi+Y-KxEi-BfesbDF80bgH-QGAAnQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] gianfar: some assorted cleanup
To:     Arseny Solokha <asolokha@kb.kras.ru>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Sep 2019 at 16:53, Arseny Solokha <asolokha@kb.kras.ru> wrote:
>
> This is a cleanup series for the gianfar Ethernet driver, following up a
> discussion in [1]. It is intended to precede a conversion of gianfar from
> PHYLIB to PHYLINK API, which will be submitted later in its version 2.
> However, it won't make a conversion cleaner, except for the last patch in
> this series. Obviously this series is not intended for -stable.
>
> The first patch looks super controversial to me, as it moves lots of code
> around for the sole purpose of getting rid of static forward declarations
> in two translation units. On the other hand, this change is purely
> mechanical and cannot do any harm other than cluttering git blame output.
> I can prepare an alternative patch for only swapping adjacent functions
> around, if necessary.
>
> The second patch is a trivial follow-up to the first one, making functions
> that are only called from the same translation unit static.
>
> The third patch removes some now unused macro and structure definitions
> from gianfar.h, slipped away from various cleanups in the past.
>
> The fourth patch, also suggested in [1], makes the driver consistently use
> PHY connection type value obtained from a Device Tree node, instead of
> ignoring it and using the one auto-detected by MAC, when connecting to PHY.
> Obviously a value has to be specified correctly in DT source, or omitted
> altogether, in which case the driver will fall back to auto-detection. When
> querying a DT node, the driver will also take both applicable properties
> into account by making a proper API call instead of open-coding the lookup
> half-way correctly.
>
> [1] https://lore.kernel.org/netdev/CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com/
>
> Arseny Solokha (4):
>   gianfar: remove forward declarations
>   gianfar: make five functions static
>   gianfar: cleanup gianfar.h
>   gianfar: use DT more consistently when selecting PHY connection type
>
>  drivers/net/ethernet/freescale/gianfar.c      | 4647 ++++++++---------
>  drivers/net/ethernet/freescale/gianfar.h      |   45 -
>  .../net/ethernet/freescale/gianfar_ethtool.c  |   13 -
>  3 files changed, 2303 insertions(+), 2402 deletions(-)
>
> --
> 2.23.0
>

Thanks for the cleanup!

-Vladimir
