Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A2121FFFC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgGNVZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:25:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59920 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726446AbgGNVZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594761902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KnSNqmybt8HNArRgeGmYXuasqK8sE275yDfj/hSXDoI=;
        b=WkRJaDUK00mIHX/ozJtARsSC4PpB/kosOXzjqALHDu3lPpWNhf4a9DvSrSRKsBNQ+8ZttL
        +dyYRl92MIjQB4/oCROklpn1lYYH36uoV5w9sIxPpRSWzUhPDk3Q7eAK6I7py3xbTGkIgi
        fEd7BNA1s5+oQeYA0uNQ2HUd2SKlyTI=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-dYpsyGdsO-CbtyLOOm7pYA-1; Tue, 14 Jul 2020 17:25:00 -0400
X-MC-Unique: dYpsyGdsO-CbtyLOOm7pYA-1
Received: by mail-ot1-f72.google.com with SMTP id p3so10345827ota.0
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:24:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KnSNqmybt8HNArRgeGmYXuasqK8sE275yDfj/hSXDoI=;
        b=AqUZOzbMj1rx2rrrHaTW9UUT8CD7gGT9+FbNgv4o8w9w9wVpevuLoqteHHWKiycmDz
         ldwSOS2zTWQJJyzPHGO8h9enNB/55LNpeiRmXBgXw4DrAknio7UeUx3NB1kkMvWzXPi7
         ntwHLB+w73bFXUjVIZZY1aVkgHMUIiW9OKyEKMGDpmi9RA7Hlvlypk5JH74+hnYXwS6Z
         aO6PHMMZePr+afB6j+gCGwsBxTBt6VkUWbxvcDguj6iW8lVCO3cNFYQtiF2Lc6NtYaD3
         kjYQC1Emo2JEqD+Zvh1PyoyvsNBl5T8VkIM6NGsFoJId0IWFY99/YHKSe1ghSy8227sJ
         zH4Q==
X-Gm-Message-State: AOAM532hUsH3ZAryQKxa0sHlTSE2+hlMDrmdwkYf4JutcvEw/fhArerm
        079cnhqtL9nFQPMmxcQlNG9aG9bLSnuBDt7GCoLGP5S9aHGAxJ3A7mBhwVnI4a5Ho7GBsdqTYV1
        Pcz3GsPvR+7nCHkB57qTwhN7Xz1/kSGsY
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr5182558oih.92.1594761899346;
        Tue, 14 Jul 2020 14:24:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxz/zjd5qK9jZde8Zzq6i6gskLZEYBES05InWUFjPOX3zjbkRxVTmYDeePGuZrPChd1+xrChm7N+Xy6UFZACOM=
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr5182541oih.92.1594761899018;
 Tue, 14 Jul 2020 14:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <87y2nlgb37.fsf@toke.dk> <20200714203915.GK74252@localhost.localdomain>
In-Reply-To: <20200714203915.GK74252@localhost.localdomain>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Tue, 14 Jul 2020 17:24:47 -0400
Message-ID: <CAKfmpSeNM=1_43sW=E-KexPTVrRH_33WQRzf4TNq=bK4DZHCew@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 4:39 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Jul 14, 2020 at 09:17:48PM +0200, Toke H=C3=83=C2=B8iland-J=C3=83=
=C2=B8rgensen wrote:
> > Jarod Wilson <jarod@redhat.com> writes:
> >
> > > As part of an effort to help enact social change, Red Hat is
> > > committing to efforts to eliminate any problematic terminology from
> > > any of the software that it ships and supports. Front and center for
> > > me personally in that effort is the bonding driver's use of the terms
> > > master and slave, and to a lesser extent, bond and bonding, due to
> > > bondage being another term for slavery. Most people in computer
> > > science understand these terms aren't intended to be offensive or
> > > oppressive, and have well understood meanings in computing, but
> > > nonetheless, they still present an open wound, and a barrier for
> > > participation and inclusion to some.
> > >
> > > To start out with, I'd like to attempt to eliminate as much of the us=
e
> > > of master and slave in the bonding driver as possible. For the most
> > > part, I think this can be done without breaking UAPI, but may require
> > > changes to anything accessing bond info via proc or sysfs.
> > >
> > > My initial thought was to rename master to aggregator and slaves to
> > > ports, but... that gets really messy with the existing 802.3ad bondin=
g
> > > code using both extensively already. I've given thought to a number o=
f
> > > other possible combinations, but the one that I'm liking the most is
> > > master -> bundle and slave -> cable, for a number of reasons. I'd
> > > considered cable and wire, as a cable is a grouping of individual
> > > wires, but we're grouping together cables, really -- each bonded
> > > ethernet interface has a cable connected, so a bundle of cables makes
> > > sense visually and figuratively. Additionally, it's a swap made easie=
r
> > > in the codebase by master and bundle and slave and cable having the
> > > same number of characters, respectively. Granted though, "bundle"
> > > doesn't suggest "runs the show" the way "master" or something like
> > > maybe "director" or "parent" does, but those lack the visual aspect
> > > present with a bundle of cables. Using parent/child could work too
> > > though, it's perhaps closer to the master/slave terminology currently
> > > in use as far as literal meaning.
> >
> > I've always thought of it as a "bond device" which has other netdevs as
> > "components" (as in 'things that are part of'). So maybe
> > "main"/"component" or something to that effect?
>
> Same here, and it's pretty much like how I see the bridge as well.
> "bridge device" and "legs".

I did toy with the idea of "torso" or "thorax" for the bond aggregate
device and "legs" for the bond components, but at this point, I guess
it's mostly bikeshedding, the bigger issue is "how messy would it
be?". I've scripted most of the changes, but not all of them. Still
working on it... :)

--=20
Jarod Wilson
jarod@redhat.com

