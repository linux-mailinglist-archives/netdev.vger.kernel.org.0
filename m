Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361BCFE553
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfKOTB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:01:29 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45075 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOTB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 14:01:29 -0500
Received: by mail-qt1-f194.google.com with SMTP id 30so11852576qtz.12
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 11:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xYm2odlf3ltOYS+bOo8fFB8Lc/RHBepZa4W3jJCRD3Q=;
        b=QsIC/BWAtyTBXzef3aau4jiyBmtIE4ajMkoGnqbK5g73KYjduV162R3g7BOhoLZtFs
         bWB34t2kp2riFRF2X6r/i3W0jyRak+DmD6/RoGrbuqaWJVDHZAGN9KcbY+Ifv9zRUK23
         jl70HzHfPS3VieK4/+aI7QK8KZVD19cKKs4/ssKWAUzdku2bH1aL8LsKZ8DQHyi/GIJF
         zvqkgTlTdbFsUuz+y6W/UEulqSlczHvOz6IOQFB3wXm7tOd43m11DiFAMtBiBZOQM3Vy
         sSDfi+/EWv6B4KO5dTPcDh/2XYYWaNFwG0t0lXk/SVFb793R4anmsESJXEM+sgfuhhvI
         BJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYm2odlf3ltOYS+bOo8fFB8Lc/RHBepZa4W3jJCRD3Q=;
        b=M4n6bMxwx5B44wvbDjWwYzxUfxbg/Aggj3QxZvmCQpuhijoYhye03SeqYoOI6g6ex6
         /swubG9xQxTOLrzUcsTKmg/3299d7YYC6btVQoBuYBaOTTXJIAY2+Rn20gTi3Tvv3Uwh
         HVWxLDIFoPSkxUVh+MqM1fRtZDUQjJ7092K82FEbR8Pg0lBbe9T4OYDLtCOTm6iyeJj/
         o0EAHy0pomSqjPuekN1Ovk9eB+bBxf8xxb4xaRFKdkzG+/0fnuNdJlB2a0KRzmNbLOWq
         bJUoDlzFa5NU4xQzsWGHnv5DoOpHBKdQKYKLYW6On8PIyj9XLq/L7n6QvUtwUJXNDJ5p
         IloA==
X-Gm-Message-State: APjAAAW6zP57bddGsHA9yTch/x9wLcHE/1nbT865iHugjDGssjulRv5U
        EZuZJOX+itstd+5MKJhs8b/SfFXMjn+TN9dztPA7Iche
X-Google-Smtp-Source: APXvYqxBTi3WjIs1XLq7ugd9jB62/b8Le8pYttIjS39QAydTkEyUuH77kG1tFJcSuEl6Rov5gvvITnNjRHwGve+M5V0=
X-Received: by 2002:ac8:288a:: with SMTP id i10mr15260589qti.139.1573844488057;
 Fri, 15 Nov 2019 11:01:28 -0800 (PST)
MIME-Version: 1.0
References: <20191109124205.11273-1-popadrian1996@gmail.com>
 <20191109153355.GK22978@lunn.ch> <CAL_jBfQhVAy24xbz_VbpPM0QtRu-Uzawhyn=AY0b41B9=v3Ytg@mail.gmail.com>
 <20191113135925.GB27785@lunn.ch>
In-Reply-To: <20191113135925.GB27785@lunn.ch>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Fri, 15 Nov 2019 19:00:49 +0000
Message-ID: <CAL_jBfSKoDdtcfXHeFD+HgR82=gD2XQRhBM14FvSmm6qrMDC5w@mail.gmail.com>
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

You are right about defining a KAPI. Unfortunately due to the nature
of my company's business we can't really mainline our driver. I'll try
to add the QSFP-DD support myself in the future, although I have
nothing planned at the moment. Until then, maybe this thread will be
helpful for any other contributors that will decide to work on a
driver. As I said, to provide the same stats for QSFP-DD as for QSFP,
ethtool needs an extra page. My pull request is well documented and
contains information about this.

Adrian

On Wed, 13 Nov 2019 at 13:59, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Nov 13, 2019 at 12:56:51PM +0000, Adrian Pop wrote:
> > Hi Andrew!
> >
> > Thank you for your email. At the moment, there are no in-kernel drivers that
> > require this support (the 1st version of the Common Management Interface
> > Specification for the QSFP-DD 8X pluggable transceivers came out this year in
> > May [0]). I first came across implementing this extra functionality to ethtool
> > at my company, where we use a custom driver for a NIC that works with the new
> > QSFP-DD transceivers. All the ethtool readings for QSFP-DD were correct and I
> > can provide a sample if needed. Another example of somebody putting QSFP-DD
> > support in their products is Exablaze with their ExaNIC [1] and I'm sure that
> > with time there will be more. Unfortunately at the moment I'm not able to
> > provide help with an update on the mainline driver in the kernel.
> >
> > I know that ETH_MODULE_SFF_8436_MAX_LEN is 640 bytes, but to provide for
> > QSFP-DD all the stats as for QSFP (basically to maintain the same behavior/
> > functionality), we came to the conclusion that we need to read more pages than
> > before, since the memory map is different and the data is more spread around.
> >
> > Please let me know if you have any other feedback and/or suggestions for the
> > patch.
>
> Hi Adrian
>
> You are defining a kernel API here. It is very unusual to define a
> KAPI without the mainline kernel actually implementing it. So in my
> opinion, we need an in kernel implementation first.
>
> I guess you are not going to mainline your driver? The ExaNIC is also
> a long way from being mainline'able.
>
> Could i suggest you extend drivers/net/phy/sfp.c to support QSFP-DD?
> Or maybe one of Intels or Mellanox drivers? Basically, any hardware
> with an in kernel driver you can get your hands on and test. Maybe you
> already have something which you use of interoperability testing.
>
>      Andrew
