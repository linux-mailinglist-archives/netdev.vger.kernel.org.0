Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35367AF640
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfIKHAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:00:17 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37937 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfIKHAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:00:17 -0400
Received: by mail-ot1-f67.google.com with SMTP id h17so17717188otn.5;
        Wed, 11 Sep 2019 00:00:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9dr69d7D9AZxG4ptlvv1ouodNVo3Kf2fAKXXlCgtDP4=;
        b=BHbwToTOy7gV+Sqb0XdCfOWHFyMJhmRslvW20JdZHukCG9CZIbRgbKr+froKoeNk/q
         O9QzPQKRgFMNPb6QanP9hz2se6oqURScWVOIsHh6sJ6HKupeLggZvXqdW6VhEhDi4ugW
         79tOCiZpgJPz5TZFlYGVv1//3YgpPu6+CVDX5Lz0fuXQREu2Dg1eSHZ99jl6NuoNSdUH
         CewR+rngrkWwPZ8+EHQZPhqsmkfEg6IGZ29wsaKqWoHPbDUfDs6ED2DyHwEyf7R2AHDL
         1MB5cOUZoWjUJn/HaYeN16p/ye54shNwdcU4P8D7xFY3Tnl2lKterZcrOVBoRci7vmud
         tGAA==
X-Gm-Message-State: APjAAAXaukwcNuOE8SU3EttZwyJ+XdscYWOC9iz25+R9CuILV5facJ7e
        5ykAMaH0Be7h/vlbp1ZtoBSdGbaivnmp9+mP+vE2BQ==
X-Google-Smtp-Source: APXvYqy4nHbGq/yzYGyyJzdHSy/BGAXMkUJgPZNy7UvGhLOxuZGHxNeZq+CTxvohtCCs/uICkjnYAnt9e3O/5m5p1Vo=
X-Received: by 2002:a9d:32a1:: with SMTP id u30mr24883499otb.107.1568185215069;
 Wed, 11 Sep 2019 00:00:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190822211514.19288-1-olteanv@gmail.com> <20190822211514.19288-6-olteanv@gmail.com>
 <CA+h21hqWGDCfTg813W1WaXFnRsMdE30WnaXw5TJvpkSp0-w5JA@mail.gmail.com>
 <20190827180502.GF23391@sirena.co.uk> <CA+h21hr3qmTG1LyWsEp+hZZW2NJFtg9Dh1k6SXVDd+A_YSQjjw@mail.gmail.com>
 <20190827181318.GG23391@sirena.co.uk> <CA+h21hqMVdsUjBdtiHKtKGpyvuaOf25tc4h-GdDEBQqa3EB7tw@mail.gmail.com>
 <20190911063350.GB17142@dragon>
In-Reply-To: <20190911063350.GB17142@dragon>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 11 Sep 2019 09:00:03 +0200
Message-ID: <CAMuHMdU0nu2z9o-McSw0tXNsJDX-1rk2fvnqW37M6OeEpL770w@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ARM: dts: ls1021a-tsn: Use the DSPI controller in
 poll mode
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 8:34 AM Shawn Guo <shawnguo@kernel.org> wrote:
> On Tue, Aug 27, 2019 at 09:16:39PM +0300, Vladimir Oltean wrote:
> > On Tue, 27 Aug 2019 at 21:13, Mark Brown <broonie@kernel.org> wrote:
> > > On Tue, Aug 27, 2019 at 09:06:14PM +0300, Vladimir Oltean wrote:
> > > > On Tue, 27 Aug 2019 at 21:05, Mark Brown <broonie@kernel.org> wrote:
> > > > > On Mon, Aug 26, 2019 at 04:10:51PM +0300, Vladimir Oltean wrote:
> > >
> > > > > > I noticed you skipped applying this patch, and I'm not sure that Shawn
> > > > > > will review it/take it.
> > > > > > Do you have a better suggestion how I can achieve putting the DSPI
> > > > > > driver in poll mode for this board? A Kconfig option maybe?
> > >
> > > > > DT changes go through the relevant platform trees, not the
> > > > > subsystem trees, so it's not something I'd expect to apply.
> > >
> > > > But at least is it something that you expect to see done through a
> > > > device tree change?
> > >
> > > Well, it's not ideal - if it performs better all the time the
> > > driver should probably just do it unconditionally.  If there's
> > > some threashold where it tends to perform better then the driver
> > > should check for that but IIRC it sounds like the interrupt just
> > > isn't at all helpful here.
> >
> > I can't seem to find any situation where it performs worse. Hence my
> > question on whether it's a better idea to condition this behavior on a
> > Kconfig option rather than a DT blob which may or may not be in sync.
>
> DT is a description of hardware not condition for software behavior,
> where module parameter is usually used for.

+1

DT says the interrupt line is wired.
The driver should know if it should make use of the interrupt, or not.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
