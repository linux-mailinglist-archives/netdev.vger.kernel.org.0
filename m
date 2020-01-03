Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3D12FBA7
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgACRfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:35:22 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43472 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbgACRfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 12:35:22 -0500
Received: by mail-ed1-f66.google.com with SMTP id dc19so42162996edb.10
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 09:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U8I/Xm5TvYBJo1cYXIzzKI4hL0KN+qaj3LQaK4iUQ6Q=;
        b=zWEHmE/Kf2qTWtLCB7tx846wxzau0AH3d0LKgIM4LGIr23brpWykG4vIG2bCAOMasf
         GeqzbmjZUle5qiPOkYNayJCvbdcedXV8xxFzUbN1Dph/Qy0kE7HjzpU9THxjKgl5CwYL
         uRWGInFbRzzsagnJ2slKxwSbv6kXammTLUU/oUdntV6+iyYAow6hNfbGqbnTYAbrZcQm
         vX2tuaChxQa5cxYPHoJHXCXpOvdUNhx3ck+AIgn1wPxp9T0xGOUyUZsEsZtQyDSAB4Ci
         2CWwy9RNSs5SADsK/g9EDWJCyi3mMqdTGCFIQFg3c/oXD8MAVNWWb14Wnsn+Vecl5sze
         GVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U8I/Xm5TvYBJo1cYXIzzKI4hL0KN+qaj3LQaK4iUQ6Q=;
        b=hga8ijZXHCLO/7IARwLIeDST1hqt03ePOfmsqn4BEVN25t7hhafclNKvRez//AL80v
         0lJeiHVpG2fYx+kZtqw/ap6uLe9TF0qjidlFEhAWqO21AQFcQRkSuAQNSFAaUhTCTWOL
         4CqyeCArYVf3gqkNN2o/qU1bo5RrQM0HTVHeZtRwDPv2FJ/GJCdODahNLIKWcNqRm/5Z
         2iMROP2v2IE8A8cey8l+0sKFPlNWNvP7I+M5JYcEOE05M+ejkn5IQjFk8BaxpL+3Y+EH
         XIE9heYrYsFqXXjqTD6d4WkG0ZaGRDMyom08J5boXSZW230WOv3gCzy2s9ZVVElLUvv8
         TTzA==
X-Gm-Message-State: APjAAAWsslkTtV0Zhc4qzWGs031flMvbFt0EN54yiEg/HSLQlwJlLSbr
        6qSiO5Rj8AM78s2tGhxTJtvq6eZcDmMIbodMw3zdWQ==
X-Google-Smtp-Source: APXvYqwHwBCty1tWgkqC9SojsKI+Ngu+3PgaMoN1wW1YW/bUkFMhrfw5N48hsUavKiMpTQKrEEzHUvXi9tmQ4IWBB5g=
X-Received: by 2002:a50:c048:: with SMTP id u8mr93330278edd.226.1578072919259;
 Fri, 03 Jan 2020 09:35:19 -0800 (PST)
MIME-Version: 1.0
References: <1577400698-4836-1-git-send-email-tom@herbertland.com>
 <20200102.134138.1618913847173804689.davem@davemloft.net> <CALx6S37uWDOgWqx_8B0YunQZRGCyjeBY_TLczxmKZySDK4CteA@mail.gmail.com>
 <20200103081147.8c27b18aec79bb1cd8ad1a1f@gmail.com>
In-Reply-To: <20200103081147.8c27b18aec79bb1cd8ad1a1f@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 3 Jan 2020 09:35:08 -0800
Message-ID: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
To:     kernel Dev <ahabdels.dev@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 2, 2020 at 11:11 PM kernel Dev <ahabdels.dev@gmail.com> wrote:
>
> Tom,
> Happy new year!!
>
Happy new year to you!

> I believe that these patches cost you great effort. However, we would lik=
e to see the 6-10 subsequent patch set to be really able to understand wher=
e are you going with these ones.
>
I can post those as RFC.

> At some point you mentioned that router vendors make protocol in miserabl=
e way. Do you believe the right way is that every individual defines the pr=
otocol the way he wants in a single authored IETF draft ?
>
No, that defies the whole purpose of standard and interoperable
protocols. The problem we are finding with IETF is that it has no
means to enforce conformance of the protocols it standardizes. Router
vendors openly exploit this, for instance at the last IETF the Cisco
engineer presenting extension header insertion (a clear violation of
RFC8200) plainly said upfront that regardless of any feedback or input
they will continue developing and deploying it the way they want. Note
this is not an indictment of all router vendors and their engineers,
there are many that are trying to do the right thing-- but it's really
pretty easy for a few engineers at large vendors to cheat the system
in different ways. The only pushback IETF can do is to not standardize
these non-conformant quasi-proprietary protocols. The real way to
combat this provide open implementation that demonstrates the correct
use of the protocols and show that's more extensible and secure than
these "hacks".

> Regarding 10) Support IPv4 extension headers.
> I see that your drafts describing the idea are expired [1][2].
> Do you plan to add to the kernel the implementation of expired contents ?=
 or did you abandoned these drafts and described the idea somewhere else th=
at I=E2=80=99m not aware of ?
>
> [1] https://tools.ietf.org/html/draft-herbert-ipv4-udpencap-eh-01
> [2] https://tools.ietf.org/html/draft-herbert-ipv4-eh-01
>
[1] is obsoleted by [2]. I will update [2] shortly. I may also propose
an IETF hackathon project to bring up IOAM over IPv4 if you are
interested.

Tom

> Ahmed
>
>
> On Thu, 2 Jan 2020 16:42:24 -0800
> Tom Herbert <tom@herbertland.com> wrote:
>
> > On Thu, Jan 2, 2020 at 1:41 PM David Miller <davem@davemloft.net> wrote=
:
> > >
> > > From: Tom Herbert <tom@herbertland.com>
> > > Date: Thu, 26 Dec 2019 14:51:29 -0800
> > >
> > > > The fundamental rationale here is to make various TLVs, in particul=
ar
> > > > Hop-by-Hop and Destination options, usable, robust, scalable, and
> > > > extensible to support emerging functionality.
> > >
> > > So, patch #1 is fine and it seems to structure the code to more easil=
y
> > > enable support for:
> > >
> > > https://tools.ietf.org/html/draft-ietf-6man-icmp-limits-07
> > >
> > > (I'll note in passing how frustrating it is that, based upon your
> > > handling of things in that past, I know that I have to go out and
> > > explicitly look for draft RFCs containing your name in order to figur=
e
> > > out what your overall long term agenda actually is.  You should be
> > > stating these kinds of things in your commit messages)
> > >
> > > But as for the rest of the patch series, what are these "emerging
> > > functionalities" you are talking about?
> > >
> > > I've heard some noises about people wanting to do some kind of "kerbe=
ros
> > > for packets".  Or even just plain putting app + user ID information i=
nto
> > > options.
> > >
> > > Is that where this is going?  I have no idea, because you won't say.
> > >
> > Yes, there is some of that. Here are some of the use cases for HBH opti=
ons:
> >
> > PMTU option: draft-ietf-6man-mtu-option-01. There is a P4
> > implementation as well as Linux PoC for this that was demonstated
> > @IETF103 hackathon.
> > IOAM option: https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-opti=
ons-00.
> > There is also P4 implementation and Linux router support demonstrated
> > at IETF104 hackathon. INT is a related technology that would also use
> > this.
> > FAST option: https://datatracker.ietf.org/doc/draft-herbert-fast/. I
> > have PoC for this. There are some other protocol proposals in the is
> > are (I know Huawei has something to describe the QoS that should be
> > applied).
> >
> > There are others including the whole space especially as a real
> > solution for host to networking signaling gets fleshed out. There's
> > also the whole world of segment routing options and where that's
> > going.
> >
> > > And honestly, this stuff sounds so easy to misuse by governments and
> > > other entities.  It could also be used to allow ISPs to limit users
> > > in very undesirable and unfair ways.   And honestly, surveilance and
> > > limiting are the most likely uses for such a facility.  I can't see
> > > it legitimately being promoted as a "security" feature, really.
> > >
> > Yes, but the problem isn't unique to IPv6 options nor would abuse be
> > prevented by not implementing them in Linux. Router vendors will
> > happily provide the necessary support to allow abuse :-) AH is the
> > prescribed way to prevent this sort of abuse (aside from encrypting
> > everything that isn't necessary to route packets, but that's another
> > story). AH is fully supported by Linux, good luck finding a router
> > vendor that cares about it :-)
> >
> > > I think the whole TX socket option can wait.
> > >
> > > And because of that the whole consolidation and cleanup of the option
> > > handling code is untenable, because without a use case all it does is
> > > make -stable backports insanely painful.
> >
> > The problem with "wait and see" approach is that Linux is not the only
> > game in town. There are other players that are pursuing this area
> > (Cisco and Huawei in particular). They are able to implement protocols
> > more to appease their short term marketing requirements with little
> > regard for what is best for the community. This is why Linux is so
> > critical to networking, it is the only open forum where real scrutiny
> > is applied to how protocols are implemented. If the alternatives are
> > given free to lead then it's very likely we'll end up being stuck with
> > what they do and probably have to follow their lead regardless of how
> > miserable they make the protocols. We've already seen this in segment
> > routing, their attempts to kill IP fragmentation, and all the other
> > examples of protocol ossification that unnecessarily restrict what
> > hosts are allowed to send in the network and hence reduce the utility
> > and security we are able to offer the user.
> >
> > The other data point I will offer is that the current Linux
> > implementation of IPv6 destination and hop-by-hop options in the
> > kernel is next to useless. Nobody is using the ones that have been
> > implemented, and adding support for a new is a major pain-- the
> > ability for modules to register support for an option seems like an
> > obvious feature to me. Similarly, the restriction that only admin can
> > set options is overly restrictive-- allowing to non-privileged users
> > to send options under tightly controlled constraints set by the admin
> > also seems reasonable to me.
> >
> > Tom
>
>
> --
> kernel Dev <ahabdels.dev@gmail.com>
