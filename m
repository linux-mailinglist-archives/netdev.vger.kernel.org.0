Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59C9F22F
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbfH0SQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:16:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37455 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730376AbfH0SQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:16:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id f22so32505577edt.4;
        Tue, 27 Aug 2019 11:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stDqyzInPfGYOHpVF5bI10tFZLqSV5SEn9H8bg2QREk=;
        b=Z7Qf+zp8XMv2+skujmXOWkcRCbkJmDslanNr8JCOlIdszHS+juQRf0PqfLYOPgnzPt
         8m0jH4RBvXqIZfov3d3arewtyiUgBUtORStfHZ+PjxwbOSm09p5YO+kRo8uhYorcCnQO
         fwKYYPcWeGQP0i4WWuev/X79VIMOx4JtnmFGR9R0MOslAoh3MxjBMsCTqOI47+5qzDI7
         2IBkWrCyYXbigQK7+YiZoHySLxmi29v1/x486GXWVTvgO2Scxtce/VD/9tgsUa9TzYUD
         3deAIarczt9y1PtXmF1SOKqIR95ZuxxDWnL1OGHzOGFx+J+6p8sDUDYJo9xV7BifudhH
         PXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stDqyzInPfGYOHpVF5bI10tFZLqSV5SEn9H8bg2QREk=;
        b=bq9nM7oW5FByVTYmdcJZwc+Pb69sr1q7G0/abLZsnmOhfDgCv+Di2ge2EGtqFOkMKJ
         mMhd2eLRAscs8gLJhkUnZO8ipGDfGsG+7w+fPuSCR43BOCRAYtvT9xzAs7MY2Fz23Y3b
         gOHyBZWq1oaaQel4JF9kp89RbljfDY+34UdwGBnYZNIFs3Jgu+qeeT9c+mlFRvlTMMab
         Bta9i7OK3VFM0bcmHGJgBiirI21gH8cWA/S2g42KjUHiOKzuuAAVMeTp9zTx+wE+lwvv
         IA01cQy0GgLGuTQamVs9C7evRVJqtlrWr8vf5VmM0ltUa/Rs/ZDbsMoibDXQ05nY3Uxn
         Rwfg==
X-Gm-Message-State: APjAAAXYNltjYDK5SkYTqo2XfkLnBoygW/Kf6oGUvJWjUD3ct3XYSYjJ
        RB8j/KS+BQAkIQDi19722uIOaouTy70DiL1VgdW2Nyj8
X-Google-Smtp-Source: APXvYqzXM9hwqNIrlcehaL8Go4kYYYnUaNc671AUPJ4zJdosttYd+bKZ/Uno+W2/MBJYT4s7/9kKqITnEVEu09h2q5s=
X-Received: by 2002:a17:906:4683:: with SMTP id a3mr22189723ejr.47.1566929810659;
 Tue, 27 Aug 2019 11:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190822211514.19288-1-olteanv@gmail.com> <20190822211514.19288-6-olteanv@gmail.com>
 <CA+h21hqWGDCfTg813W1WaXFnRsMdE30WnaXw5TJvpkSp0-w5JA@mail.gmail.com>
 <20190827180502.GF23391@sirena.co.uk> <CA+h21hr3qmTG1LyWsEp+hZZW2NJFtg9Dh1k6SXVDd+A_YSQjjw@mail.gmail.com>
 <20190827181318.GG23391@sirena.co.uk>
In-Reply-To: <20190827181318.GG23391@sirena.co.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 27 Aug 2019 21:16:39 +0300
Message-ID: <CA+h21hqMVdsUjBdtiHKtKGpyvuaOf25tc4h-GdDEBQqa3EB7tw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ARM: dts: ls1021a-tsn: Use the DSPI controller in
 poll mode
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 at 21:13, Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, Aug 27, 2019 at 09:06:14PM +0300, Vladimir Oltean wrote:
> > On Tue, 27 Aug 2019 at 21:05, Mark Brown <broonie@kernel.org> wrote:
> > > On Mon, Aug 26, 2019 at 04:10:51PM +0300, Vladimir Oltean wrote:
>
> > > > I noticed you skipped applying this patch, and I'm not sure that Shawn
> > > > will review it/take it.
> > > > Do you have a better suggestion how I can achieve putting the DSPI
> > > > driver in poll mode for this board? A Kconfig option maybe?
>
> > > DT changes go through the relevant platform trees, not the
> > > subsystem trees, so it's not something I'd expect to apply.
>
> > But at least is it something that you expect to see done through a
> > device tree change?
>
> Well, it's not ideal - if it performs better all the time the
> driver should probably just do it unconditionally.  If there's
> some threashold where it tends to perform better then the driver
> should check for that but IIRC it sounds like the interrupt just
> isn't at all helpful here.

I can't seem to find any situation where it performs worse. Hence my
question on whether it's a better idea to condition this behavior on a
Kconfig option rather than a DT blob which may or may not be in sync.
