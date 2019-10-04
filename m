Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5BACBC22
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388847AbfJDNrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:47:05 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36004 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388796AbfJDNrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 09:47:05 -0400
Received: by mail-yb1-f193.google.com with SMTP id r2so2132906ybg.3
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 06:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g009hhWM6vTVf5s/fvAPZz/TFCqkCq3RStLhMXlxDP8=;
        b=eo1iVub6o9ByTzD54WW/WdcGdKYe0HuKUTB2ynh1H5q9XtnQFcyCLsnArQ8Pin7htN
         Sc++DTql2N3uo29J6RjMSSW2rXjJmfDDdTYn+b307RyvIDn/daagrxqWDl01/suqrBtg
         /U/RrR/UedqEft7g0CskqXs4M5cszvsorFJW3cr9y3sE7KXaj/kxQFwKXJvv9C8H9xdf
         yoQ0RvbkusTMlXSjX/M/7db/gAk0ah9Y7YJDY2yq7v62rw1O32BwccmjMlpDT/Zfi33Q
         XXMYtc2lWS8jEzz9Fq2AwZNytUJU0ZH6wk5/pNcUm9fOa+OKypT0pbjrXX19EK3gXZmX
         O+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g009hhWM6vTVf5s/fvAPZz/TFCqkCq3RStLhMXlxDP8=;
        b=tXtTii4MCX0cXPOXkCFlmvTBaFQJQjnheSrI0Hofei5rpln67OJ/Uh37SsWaIcuX6b
         aO2uB02FRuqp0uGFNuFz9V7AS7PgReJVDyDfK6wcGO/meU0oiXcix3fRTV+zfaJPgYrm
         X5rNs6kn6yOm6facbTyR14zyN//LxoJTnUr+YVHeH/p9D/1LFSJV65yFn6Kz3ehZozSi
         BTClmanSYSC+Cru1uVla8CDhE0ZYiKmgVzxtj8P1pOYvG8Q0PXZERyEdCR64bw7dLktT
         XrcZMFDdJcuK6ZWf4XH8H1IyuQiP40wQJOUZMuqjJe0BeRaTW9JAJpVqVqVmnmtHnUyn
         T6dg==
X-Gm-Message-State: APjAAAUmCl3oTjem5bUZj3aqnRcdOSih8L2sHxNxgOfr2aGcVcDJXDcB
        LbwR3oSMNni2MLtocXt18ftF4kZWw3m8fpbKeg==
X-Google-Smtp-Source: APXvYqwLI5bEhrBOtS8hEaXb/qxpZc7aUvwCdUhAzykp1h6A8tItnOpA3/gp/y+RGXiOl1E1H2sj8wVi5RGpaE2U9vI=
X-Received: by 2002:a25:bc82:: with SMTP id e2mr1935513ybk.464.1570196824029;
 Fri, 04 Oct 2019 06:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20191004013301.8686-1-danieltimlee@gmail.com> <20191004145153.6192fb09@carbon>
 <CAEKGpzj9WGepw4LPJeFhbtONYJyvLcO_ChnMRrEB5-BVTfKqMQ@mail.gmail.com> <20191004154112.7dda5cff@carbon>
In-Reply-To: <20191004154112.7dda5cff@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 4 Oct 2019 22:46:47 +0900
Message-ID: <CAEKGpzg_PGqkbUYi4Sdcm2WFxTXCQ61Mhu50kUfBtjYNhdne2A@mail.gmail.com>
Subject: Re: [v4 1/4] samples: pktgen: make variable consistent with option
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:41 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Fri, 4 Oct 2019 22:28:26 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > On Fri, Oct 4, 2019 at 9:52 PM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > >
> > >
> > > On Fri,  4 Oct 2019 10:32:58 +0900 "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
> > >
> > > > [...]
> > >
> >
> > Thanks for the review!
> >
> > > A general comment, you forgot a cover letter for your patchset.
> > >
> >
> > At first, I thought the size of the patchset (the feature to enhance)
> > was small so
> > I didn't include it with intent, but now it gets bigger and it seems
> > necessary for cover letter.
> >
> > When the next version is needed, I'll include it.
> >
> > > And also forgot the "PATCH" part of subj. but patchwork still found it:
> > > https://patchwork.ozlabs.org/project/netdev/list/?series=134102&state=2a
> > >
> >
> > I'm not sure I'm following.
> > Are you saying that the word "PATCH" should be included in prefix?
> >     $ git format-patch --subject-prefix="PATCH,v5"
> > like this?
>
> I would say "[PATCH net-next v5]" as you should also say which kernel
> tree, in this case net-next.
>
> All the rules are documented here:
>  https://www.kernel.org/doc/html/latest/process/index.html
>  https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>
> This netdev list have it's own extra rules:
>  https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
>

Thanks for the confirmation and letting me know.

I'll stick to it!

Thanks,
Daniel

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
