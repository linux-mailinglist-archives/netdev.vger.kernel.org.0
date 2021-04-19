Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4352C363ECA
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238716AbhDSJjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:39:52 -0400
Received: from mail-ua1-f48.google.com ([209.85.222.48]:42697 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbhDSJjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:39:51 -0400
Received: by mail-ua1-f48.google.com with SMTP id 23so1395081uac.9;
        Mon, 19 Apr 2021 02:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JFnEYs0WaAV75WlD8zGflv32bIq/erGNiBIRw5DkFRw=;
        b=I3ku2Fq+gWMhM8fgMSGyADTm+oOy4pCwjCLriLuJUNqlSRtsUih3jhwZL3lmjVKPPQ
         IexUJt70xzrA7uNBxXfBKem4Oy3srFgbfdMth0xOEaUX0v3z4hXMxzXRLAFcXPXbNRYx
         ggQ7p1aOAqFyDyk44/VS2EOWX1ABFc1A0E7PE2AvdvajBWrxJ7zry5/S+uNBqVagsNqc
         +tJM48knnHQTW4pXRCEbQxZhq1B7sP1QXgnMppBRab/x2dbCqWb5uK9i37ehz+hR6n53
         VstYc/e8NrN98vrdEdM0Tz2mxZ1MW/yxo86SPHYBT/TS5LjNLDp+G+Y2mmuNYOWQNd9G
         sT4w==
X-Gm-Message-State: AOAM533BVq04t4uGztGa48G0WXb3fWABJPvCfDEwIZNGrQw3B6FruVdO
        mHrLva+5jgkg5EgpjnQBd68suz93wGkvXxwXTxg=
X-Google-Smtp-Source: ABdhPJzI1nTVBxfpGOUmS3JtlCDIsY+hnRpCSOl2ldMILXr0qaqtQKXvm6kr3ejivGQNCy0qQnj6tDTua7gAjIQxFjw=
X-Received: by 2002:ab0:6306:: with SMTP id a6mr6143891uap.2.1618825154819;
 Mon, 19 Apr 2021 02:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-5-aford173@gmail.com>
 <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com> <CAHCN7xJrmQgC=skC7UJuzshUnf06D4nHrv1grrW8QV-+07dgKA@mail.gmail.com>
In-Reply-To: <CAHCN7xJrmQgC=skC7UJuzshUnf06D4nHrv1grrW8QV-+07dgKA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Apr 2021 11:39:03 +0200
Message-ID: <CAMuHMdUb+M-BLf1OZ31S57PaUM8wnOeaoy_hkgxyjpHtAwkL0Q@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] arm64: dts: renesas: beacon kits: Setup AVB refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Sat, Apr 17, 2021 at 3:54 PM Adam Ford <aford173@gmail.com> wrote:
> On Thu, Mar 4, 2021 at 2:04 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> > > The AVB refererence clock assumes an external clock that runs
> >
> > reference
> >
> > > automatically.  Because the Versaclock is wired to provide the
> > > AVB refclock, the device tree needs to reference it in order for the
> > > driver to start the clock.
> > >
> > > Signed-off-by: Adam Ford <aford173@gmail.com>
> >
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > i.e. will queue in renesas-devel (with the typo fixed) once the DT
> > bindings have been accepted.
>
> Geert,
>
> Since the refclk update and corresponding dt-bindings are in net-next,
> are you OK applying the rest of the DT changes so they can get into
> 5.13?

Queueing in renesas-devel for v5.14, as the soc deadline for v5.13
has already passed two weeks ago.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
