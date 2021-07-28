Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370CB3D87B5
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhG1GNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhG1GNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:13:06 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616B9C061757;
        Tue, 27 Jul 2021 23:13:05 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i1so1392155plr.9;
        Tue, 27 Jul 2021 23:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wyYRguHUYGmijFGDOaM4ez6FDfg83TH7CoepnZpiCFk=;
        b=YJ/hfPv0PQnc9e1FEROGbS2DAOHUrCBj5EFAhd66H9UW/KrO+8Y6utgNmWsPSU/iLv
         l5s6pOPkceh4tSnMtluzY1It1p6V/2jWgwzimvkUJPnyp0VhavO8JAaRziTl7yK45pYn
         7wQaD+CyjCEARdS7u+epTUFD7xwH9EeqrBORMKvfPXqMAwjDvn+PZLrsjZgXFmTcUy/F
         +h6zQjMoVi628glO1M/cvrR4BwZpTH7KqoYYu7YeSKPUXQragfmU2puAIjzoaLO/PJAH
         tX4khBhPdmoPV8bHlnN9CP53GDMhic4QvYOC/ab2pOaX7JOuN6wSaHOTOmMkdN0svdRo
         Ia5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wyYRguHUYGmijFGDOaM4ez6FDfg83TH7CoepnZpiCFk=;
        b=O13dh8tycPSyJJL6ym/+MrAKR7QJiaY+xLQqdktlApalkl+QC7vjrecPUVNuaBzTf3
         W1GJmr7bt25qaFU7RbtRKPuyb+6Rz/S38XEcia/kR+x9Wr2MGsKKKnx72VhBr3GZzvr5
         NMWEuDpbKn8E2cFiU9ypR17+K0MJWeX5JS8YqxprudRw9PweU83cgdkoQbNHyYDW5LDK
         kMidtS4Up9nUqvhPYo2DAW1GTorWfWvr24IRhOyI7yG/vVGpS3mb3DjauIYZiOlit2/m
         lRHJPoW96VdcvHO9LWQlR6gObExRL5YtlHWfvSJJT59atZTOXUe0mo2g3z5JeuFFvk/s
         8YNA==
X-Gm-Message-State: AOAM530CsRIN7Pg3b91C4wrZuFx3kP9Sm7T9uWZHqyBl1Vel+hVzkruj
        xtaP3sbsaLQgTFnJthzGpjBWWtbiA1sisoC8MzU=
X-Google-Smtp-Source: ABdhPJw1njkc66jUGA/LfB7OBpLu4OKubg7+A0Le2fIiT5AsfIZ5sPNvAuJwawC7TTrcvultA/ZZI/v1Uesao9gOjwM=
X-Received: by 2002:a17:90a:d58f:: with SMTP id v15mr7933685pju.117.1627452784967;
 Tue, 27 Jul 2021 23:13:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
 <20210727131753.10924-2-magnus.karlsson@gmail.com> <d152389f-815b-34f9-b6f4-a4cb6377ab4f@fb.com>
In-Reply-To: <d152389f-815b-34f9-b6f4-a4cb6377ab4f@fb.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 28 Jul 2021 08:12:54 +0200
Message-ID: <CAJ8uoz0CrDab86Ajdx+1Gkt8-7Lh-SEKg0iKgEeiYF0Na5+VFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/17] selftests: xsk: remove color mode
To:     Yonghong Song <yhs@fb.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Jussi Maki <joamaki@gmail.com>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 6:43 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/27/21 6:17 AM, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Remove color mode.
>
> Could you add some reasoning in the commit message why
> removing color mode is a good idea?

Will do. The reason is that I do not see color text output adding any
value and less code means less of a maintenance burden which is a good
thing. But if someone feels that color output is adding value and is
using it, I can likely be convinced to keep it.

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   tools/testing/selftests/bpf/test_xsk.sh    | 10 +++-----
> >   tools/testing/selftests/bpf/xsk_prereqs.sh | 27 +++++-----------------
> >   2 files changed, 9 insertions(+), 28 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> > index 46633a3bfb0b..cd7bf32e6a17 100755
> > --- a/tools/testing/selftests/bpf/test_xsk.sh
> > +++ b/tools/testing/selftests/bpf/test_xsk.sh
> > @@ -63,14 +63,11 @@
> >   # ----------------
> >   # Must run with CAP_NET_ADMIN capability.
> >   #
> > -# Run (full color-coded output):
> > -#   sudo ./test_xsk.sh -c
> > +# Run:
> > +#   sudo ./test_xsk.sh
> >   #
> >   # If running from kselftests:
> > -#   sudo make colorconsole=1 run_tests
> > -#
> > -# Run (full output without color-coding):
> > -#   sudo ./test_xsk.sh
> > +#   sudo make run_tests
> [...]
