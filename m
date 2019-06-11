Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43A1416DE
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436545AbfFKV2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:28:12 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36867 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407653AbfFKV2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:28:11 -0400
Received: by mail-ot1-f66.google.com with SMTP id r10so13386785otd.4;
        Tue, 11 Jun 2019 14:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfYsg0/cES0OHcG6fX5W9snm90ggOgAM9kXY3QBEhu4=;
        b=uikxw7UtyOptEVyjeY2qK4xy247KZZSlixb4FYF44cy5IOYuGfhYNz0auK7eAN3lSf
         RDykMi53c/UWnKOss3Gbf99f02SgcsLInyU9jZT7mZ9OHg9hKC6fNrTncVfEUwMvFzyT
         LcQoyh1B+GWH1wcVdCBdLQqRjW9xbNzL/XHVXJwKNd+h41OfOLBnxXrK/w2EGMY7Sdql
         Ev+iISe8afAaHYadIsKtGIEgMDX6CnpwHgbsBe+aUSzQIjTpiqosNwjLo3ub7MMP5bSh
         sv6W0b+fg0PHcDLs3IdJMwn13c7joqsHqAOaS3kYpN0/uUkfhOoBhUB3X+c5vOw3dtMp
         LbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfYsg0/cES0OHcG6fX5W9snm90ggOgAM9kXY3QBEhu4=;
        b=VWmUwoR9ygSpzmu4vbM58zXol8+svInEvDKpx3nMhm+HUUPkpjQFP1iBHSaJGr19vS
         95FjdqeDmEyVPNLlHxujyrkm+XB4c3pgqKNuXE+cLYd/6DCBbHTUOBSY1Laaci39LtAm
         ku1YQurhfqt7Rsv8jIxnJmTy8eNUu16xvKh+JlNnQ+qNcCuvvECDFZqTp7Wf5ar24t1A
         BRP7ry1XKTd2FrHGlum+xDxKYmUGvI7VeTQgDFmlyPKlnt8yATbnMkJ4keOnzeO78NJ+
         GoEKrkqND1eAAqYaVDicBO/APMs+b88oGYLOtNTBHO11uwPHSqsANgEcL7+k6MWX8RTw
         fF7w==
X-Gm-Message-State: APjAAAVBb8lSaSZmNEGcGH0pWaR+0rEHRIElG+mC9Z4PHENl0VkTWb6j
        Ga0+tOEQHcrmhOUsjZQTRQ0HuPqxUKfRt+DCN84=
X-Google-Smtp-Source: APXvYqwZE6DuGW97Wtdkbau380s5wncliqmuWNA2I8e3nRFVHn0Gyt7oiNVh7GBK4ctz/0QIVrifVcW0qHRMDnaPYKk=
X-Received: by 2002:a9d:7b43:: with SMTP id f3mr18847440oto.337.1560288490020;
 Tue, 11 Jun 2019 14:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca> <20190611140907.899bebb12a3d731da24a9ad1@linux-foundation.org>
In-Reply-To: <20190611140907.899bebb12a3d731da24a9ad1@linux-foundation.org>
From:   Shyam Saini <mayhs11saini@gmail.com>
Date:   Wed, 12 Jun 2019 02:57:58 +0530
Message-ID: <CAOfkYf5_HTN1HO0gQY9iGchK5Anf6oVx7knzMhL1hWpv4gV20Q@mail.gmail.com>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF macro
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andreas Dilger <adilger@dilger.ca>,
        Shyam Saini <shyam.saini@amarulasolutions.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        devel@lists.orangefs.org, linux-mm <linux-mm@kvack.org>,
        linux-sctp@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        kvm@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

>
> On Tue, 11 Jun 2019 15:00:10 -0600 Andreas Dilger <adilger@dilger.ca> wrote:
>
> > >> to FIELD_SIZEOF
> > >
> > > As Alexey has pointed out, C structs and unions don't have fields -
> > > they have members.  So this is an opportunity to switch everything to
> > > a new member_sizeof().
> > >
> > > What do people think of that and how does this impact the patch footprint?
> >
> > I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> > is about 30x, and SIZEOF_FIELD() is only about 5x.
>
> Erk.  Sorry, I should have grepped.
>
> > That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> > than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> > which it is closely related, but is also closer to the original "sizeof()".
> >
> > Since this is a rather trivial change, it can be split into a number of
> > patches to get approval/landing via subsystem maintainers, and there is no
> > huge urgency to remove the original macros until the users are gone.  It
> > would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> > they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> > whittled away as the patches come through the maintainer trees.
>
> In that case I'd say let's live with FIELD_SIZEOF() and remove
> sizeof_field() and SIZEOF_FIELD().
>
> I'm a bit surprised that the FIELD_SIZEOF() definition ends up in
> stddef.h rather than in kernel.h where such things are normally
> defined.  Why is that?

Thanks for pointing out this, I was not aware if this is a convention.
Anyway, I'll keep FIELD_SIZEOF definition in kernel.h in next version.
