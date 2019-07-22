Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4083709AC
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbfGVT0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:26:01 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33727 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbfGVT0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:26:01 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so76553457iog.0
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 12:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W/llILHdFeOrwlMyXQ0Mn0XLeTgB+/sBH6Qu9vreSWg=;
        b=bm9UsVT4a5vwrxSNdvXQt+rK24h1E6wq9FCrbTc9r9dKD7Rh/h50WY2rMn+Q6l2kJv
         O0nZFGIy3B9fzCfD+xYoT2f4S44Rz4A4fN5rTkL2+q1Y9Gn7qTBnw3+t0m0akLA5cz2m
         UlSESUGyM80NB3CjYmM1c80jfHw2/jPahcRcuBS7SaRpvEPECs/Zp9ul9NmDXJKgAjJ4
         2/gq657z8T6xuf4jrox97xmjaVCoQbNwdhkTHAS6bDD6PbRuFM33grZMvtTO9qGYWaIO
         4l+Za+lbg4lstV2G5B8Y7O/v12YIfTESpI6FOkhO2PA00FKnTTvJ/2tWtkMA8xzDcHqQ
         l13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W/llILHdFeOrwlMyXQ0Mn0XLeTgB+/sBH6Qu9vreSWg=;
        b=aAikls6WrbTrEB5N/nvYjR2b11dGr9vAcys1OcamynBjxbfAK/fKLrRLsPUTcpsURV
         EtcUBbI8qcIJwP/qMYLSZRrz2QJ5M8td31qI3D3hS3bmXdXgi4GTqTvAzonRQVLmUXfa
         3Kss+UvrxSelUQd8H/IKbLf5z1VrXttGS0ZXY0F51196lNgk8RKNDra+3Sy2pQ3kRtZq
         COgnHLsfUqVHENnQ4mdvJWSLBw9g5EiY4+kgqeVvmXz3IcOCf3alMJcBMfgIJBw+vxGf
         cUQIVAewUKQKf1740WHs9uTt9OUg1bjhKmZCG1w7V5Li6T6mITHogGw+PtO9Kf5/blwD
         sfeQ==
X-Gm-Message-State: APjAAAUKqjbGYikWuzq2LMQWRWwK+nLGDTO5kvLpCZg6VRwuwGdyB8tY
        ftjnIqQA2LSc5Y3AXqvs6pRpnmfAQNl9E1SJ4UCFgRyj
X-Google-Smtp-Source: APXvYqyG/6tHHD02/8id0le8BYFvd5VgsH5wCvJ8+hUfaMp6+V+ttHeb31UuPZZrOiefnj/13auz9ugiHb9qWEX1Hz8=
X-Received: by 2002:a02:ab99:: with SMTP id t25mr73651876jan.113.1563823560998;
 Mon, 22 Jul 2019 12:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAOp4FwSB_FRhpf1H0CdkvfgeYKc53E56yMkQViW4_w_9dY0CVg@mail.gmail.com>
 <CAOp4FwQszD4ocAx6hWud5uvzv5EtuTOpYqJ10XhR5gxkXSZvFQ@mail.gmail.com> <CAA93jw7raM7F6jmXGbPyekCtjdhFmobk5sKXnNqJMeE+w1Goyg@mail.gmail.com>
In-Reply-To: <CAA93jw7raM7F6jmXGbPyekCtjdhFmobk5sKXnNqJMeE+w1Goyg@mail.gmail.com>
From:   Loganaden Velvindron <loganaden@gmail.com>
Date:   Mon, 22 Jul 2019 23:25:49 +0400
Message-ID: <CAOp4FwSPJ8iKQYJmcm-KK0huBX6tUdae8Onz85R0ohBhX07gww@mail.gmail.com>
Subject: Re: Request for backport of 96125bf9985a75db00496dd2bc9249b777d2b19b
To:     Dave Taht <dave.taht@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 5:45 PM Dave Taht <dave.taht@gmail.com> wrote:
>
> On Mon, Jul 15, 2019 at 11:01 AM Loganaden Velvindron
> <loganaden@gmail.com> wrote:
> >
> > On Fri, Jul 5, 2019 at 6:15 PM Loganaden Velvindron <loganaden@gmail.co=
m> wrote:
> > >
> > > Hi folks,
> > >
> > > I read the guidelines for LTS/stable.
> > > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> > >
> > >
> > > Although this is not a bugfix, I am humbly submitting a request so
> > > that commit id
> > > -- 96125bf9985a75db00496dd2bc9249b777d2b19b Allow 0.0.0.0/8 as a vali=
d
> > > address range --  is backported to all LTS kernels.
> > >
> > > My motivation for such a request is that we need this patch to be as
> > > widely deployed as possible and as early as possible for interop and
> > > hopefully move into better utilization of ipv4 addresses space. Hence
> > > my request for it be added to -stable.
> > >
> >
> > Any feedback ?
> >
> > > Kind regards,
> > > //Logan
>
> I am perfectly willing to wait a year or so on the -stable front to
> see what, if any, problems that ensue from mainlining this in 5.3.
> It's straightforward for distros that wish to do this backport (like
> openwrt) to do it now, and other OSes will take longer than this to
> adopt, regardless.
>
>
ping davem
> --
>
> Dave T=C3=A4ht
> CTO, TekLibre, LLC
> http://www.teklibre.com
> Tel: 1-831-205-9740
