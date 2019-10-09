Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E483D1246
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfJIPTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:19:42 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37308 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfJIPTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:19:42 -0400
Received: by mail-yb1-f196.google.com with SMTP id z125so857330ybc.4
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1sXtMiiILCvspQsB2tmMbzdpda6Lfi5dX0ihyiC0sjc=;
        b=t6NFEHjfTI7YRq0ODo2I+4N5zruE5dw5gTfJRaoeFm5o4snPmyRjL/AHPuwy/Y+ttC
         s0mD94Lwkt8PAnfDa2aS7sa+8GUQw/uSWdf6wuFrHaleSvHPxGOP+5HsXOm9CG3Natex
         XKdFa9OfQZ7ORmbS+Q/KhdmRUIk+f0dWrEho1joTy9BsmRdrO7Xk19LJLUzpP1VDFniS
         OYpKNjC1UxM2jtalZXxqe0g6udgt5m/IB+DO6YtWgaY+rc8e+S5lyk+Jvksc0CT19ARy
         FSxZFGKJ5GbTNbPFH3Y94XLDVowjkOmvSRtRZVjn2AjpqglNPZbdX6hmOyOJYZfr16it
         RHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1sXtMiiILCvspQsB2tmMbzdpda6Lfi5dX0ihyiC0sjc=;
        b=Ym0zDlgosrJJv2+WNuOO/wFmOwPttd8ni3yAxoTjnz8obMCJF/7lSRHpVB+c3A3sgx
         EejPKyuUyg+zR4uGMBfPE3+Z78QemreI0Aq1Xau4JzburVW8gd/1KKa8VHV4xKyep8N/
         7ZTUsRkQvL2u4lPmlmHOTgT/2thZWwQuuiTJpAuMWKS2JyCe7Crn0wllq2zXTFq8kRwE
         13QY6EEP64bZ5XFZrjPs6pcUzzB8zBQdhrqnJW9wwqoXvc0KdX7RIDHDSjZHHB6h1Imo
         yuY5n2LYTsPIv4xOapF0JKZka7QfFeoXAHFESEf5PFT7KI4vC1jeZ4NjV8Bl2nMMDVi5
         l7uQ==
X-Gm-Message-State: APjAAAUNijcM+5UNdKHxb/iA4MJgzt3de6Ls212V2udtBLqcdnNiGDYn
        icCyW284waGUyJRh3XaOsstbtwzZ
X-Google-Smtp-Source: APXvYqw9EQrlbvjNX2pY0Csdl6siE3n49hzM6Jg0Xzsg9xcy/HKGv8kE2F0hYy+ZKv80PtrtAuCnkg==
X-Received: by 2002:a25:204:: with SMTP id 4mr2475838ybc.242.1570634380516;
        Wed, 09 Oct 2019 08:19:40 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id v40sm597813ywh.109.2019.10.09.08.19.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:19:39 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id v1so844936ybo.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:19:39 -0700 (PDT)
X-Received: by 2002:a25:af0a:: with SMTP id a10mr2525846ybh.203.1570634378793;
 Wed, 09 Oct 2019 08:19:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc_L_2sGSvSOtF2t6rKFenNp+L-0YBjqhTT6_NZBS9XJQ@mail.gmail.com>
 <20191009133840.GC17712@martin-VirtualBox> <CA+FuTSeqwDS_W4K6jtbPFF14iL+OAEN-fvom8Ls-j3inzmhVqQ@mail.gmail.com>
In-Reply-To: <CA+FuTSeqwDS_W4K6jtbPFF14iL+OAEN-fvom8Ls-j3inzmhVqQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Oct 2019 11:19:02 -0400
X-Gmail-Original-Message-ID: <CA+FuTSddt_W4P_9s2j_QdAAnmq4+73AY7S51o3KGFEZMAN8AVA@mail.gmail.com>
Message-ID: <CA+FuTSddt_W4P_9s2j_QdAAnmq4+73AY7S51o3KGFEZMAN8AVA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] Special handling for IP & MPLS.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 11:06 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Oct 9, 2019 at 9:39 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Tue, Oct 08, 2019 at 12:09:49PM -0400, Willem de Bruijn wrote:
> > > On Tue, Oct 8, 2019 at 5:52 AM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > From: Martin <martin.varghese@nokia.com>
> > > >
> > >
> > > This commit would need a commit message.
> > >
> > > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > >
> > > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > > ---
> > > >  Documentation/networking/bareudp.txt | 18 ++++++++
> > > >  drivers/net/bareudp.c                | 82 +++++++++++++++++++++++++++++++++---
> > > >  include/net/bareudp.h                |  1 +
> > > >  include/uapi/linux/if_link.h         |  1 +
> > > >  4 files changed, 95 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> > > > index d2530e2..4de1022 100644
> > > > --- a/Documentation/networking/bareudp.txt
> > > > +++ b/Documentation/networking/bareudp.txt
> > > > @@ -9,6 +9,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> > > >  support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> > > >  a UDP tunnel.
> > > >
> > > > +Special Handling
> > > > +----------------
> > > > +The bareudp device supports special handling for MPLS & IP as they can have
> > > > +multiple ethertypes.
> > >
> > > Special in what way?
> > >
> > The bareudp device associates a L3 protocol (ethertype) with a UDP port.
> > For some protocols like MPLS,IP there exists multiplle ethertypes.
> > IPV6 and IPV4 ethertypes for IP and MPLS unicast & Multicast ethertypes for
> > MPLS. There coud be use cases where both MPLS unicast and multicast traffic
> > need to be tunnelled using the same bareudp device.Similarly for ipv4 and ipv6.
>
> IP is already solved. I would focus on MPLS.
>
> Also, the days where IPv6 is optional (and needs IPv4 enabled) are
> behind us, really.

Ah sorry, there is nothing stopping someone from creating an
ETH_P_IPV6 only device before this path.

> Maybe just let the admin explicitly specify MPLS unicast, multicast or
> both, instead of defining a new extended label.

Deriving the inner protocol type from the outer protocol mode sounds
fine, indeed.
