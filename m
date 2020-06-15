Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2561F9BAE
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgFOPQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgFOPQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:16:07 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0A7C061A0E;
        Mon, 15 Jun 2020 08:16:05 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id p18so11788599eds.7;
        Mon, 15 Jun 2020 08:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lJsAjZwO8wfco17hLaoDhz3k/56n9ZjvjOrVGW/lo+I=;
        b=Yk8aUgIqQSvFkLGgbFkKXUBn0wfg8D9SQTbAjJtEZ/mMe2Sbs1Pw0QcIu/ReWn49F3
         yNtfPoCdu2DUyIa91TtHQUyP8fkv9SL61Tzlgn8RVovQcxuQlnRNmMXqoeGlvgW4sIo1
         jQii+wKvCvLBpd1+AQ9owb9eVWET3/J1v5xUtSThnCbruEwQIpigFdo3jXfFT4pMZ4XI
         Ww6b57Nrf59w+hsttmejutnWo1bMeyLJz1KunwBRmCTgOtsmThPBghoVMaVrKHH4DTXU
         VrsF/WEDHCqFPhFZt4z4JCiGNZac3aY2PSm9KS48CwVBhTA4dZ9BVgDzmcfOTwxiBG51
         VL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lJsAjZwO8wfco17hLaoDhz3k/56n9ZjvjOrVGW/lo+I=;
        b=CQPNtsZQOAvFNuA8gMHdUxzPrrncSudF7p/6W3KIORqcr+6IXDJuymVdknfZXn4GQr
         mjnewgK5n46Z6RRMzl839oNKteAjSe0Renw4Zqbw+upHNtZdgYS3VSuwDDUNr4Xkw50s
         IQzVQMy4zzrmT4kBIrfkJsYUttxEuS0784ELOQeDRRpv1QMWM8sxNR+Iv45xsX2M3f8s
         fDBSzjkicQX/2wSkPlbjoBNTFOugZdJcf17vSl7WvKM1jC97GhLzv9zjlmpSxovgJyZQ
         jfcfZfK4YcsaG3B6qoJj3oCs10xh6U3kpH7H98hLCqIcpTNW/CPhWLpnRNQSf3TMIxpW
         VX1g==
X-Gm-Message-State: AOAM530JbVlgj0+Tv9Av9lT3+1fEpgQWm1HJcUvmnmWZQWTXxUURSB/C
        LnUL+/SzIYqORwHRZ7nKK7s5DScwreNVKVbes0E=
X-Google-Smtp-Source: ABdhPJwfEgimSyzGwECDSV7hoj1ie9SGS8xz/g/1O7Jfx/ELarqkge1lENHl2cY4gerhF7X3QYMKm1yyAH1cV1JbaOU=
X-Received: by 2002:a50:d790:: with SMTP id w16mr23280069edi.231.1592234163427;
 Mon, 15 Jun 2020 08:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
 <20200615130139.83854-5-mika.westerberg@linux.intel.com> <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
 <20200615135112.GA1402792@kroah.com> <CA+CmpXst-5i4L5nW-Z66ZmxuLhdihjeNkHU1JdzTwow1rNH7Ng@mail.gmail.com>
 <20200615142247.GN247495@lahna.fi.intel.com>
In-Reply-To: <20200615142247.GN247495@lahna.fi.intel.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Mon, 15 Jun 2020 18:15:47 +0300
Message-ID: <CA+CmpXuN+su50RYHvW4S-twqiUjScnqM5jvG4ipEvWORyKfd1g@mail.gmail.com>
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 5:22 PM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> On Mon, Jun 15, 2020 at 05:18:38PM +0300, Yehezkel Bernat wrote:
> > On Mon, Jun 15, 2020 at 4:51 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Jun 15, 2020 at 04:45:22PM +0300, Yehezkel Bernat wrote:
> > > > On Mon, Jun 15, 2020 at 4:02 PM Mika Westerberg
> > > > <mika.westerberg@linux.intel.com> wrote:
> > > > >
> > > > > diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
> > > > > index ff397c0d5c07..5db2b11ab085 100644
> > > > > --- a/include/linux/thunderbolt.h
> > > > > +++ b/include/linux/thunderbolt.h
> > > > > @@ -504,8 +504,6 @@ struct tb_ring {
> > > > >  #define RING_FLAG_NO_SUSPEND   BIT(0)
> > > > >  /* Configure the ring to be in frame mode */
> > > > >  #define RING_FLAG_FRAME                BIT(1)
> > > > > -/* Enable end-to-end flow control */
> > > > > -#define RING_FLAG_E2E          BIT(2)
> > > > >
> > > >
> > > > Isn't it better to keep it (or mark it as reserved) so it'll not cause
> > > > compatibility issues with older versions of the driver or with Windows?
> > >
> > >
> > > How can you have "older versions of the driver"?  All drivers are in the
> > > kernel tree at the same time, you can't ever mix-and-match drivers and
> > > kernels.
> > >
> > > And how does Windows come into play here?
> > >
> >
> > As much as I remember, this flag is sent as part of creating the
> > interdomain connection.
> > If we reuse this bit to something else, and the other host runs an
> > older kernel or
> > Windows, this seems to be an issue.
> > But maybe I don't remember it correctly.
>
> We never send this flag anywhere. At the moment we do not announce
> support the "full E2E" in the network driver. Basically this is dead
> code what we remove.

OK, maybe we never sent it, but Windows driver does send such a flag somewhere.
This is the only way both sides can know both of them support it and that they
should start using it. I'd prefer at least leaving a comment here that mentions
this, so if someone goes to add flags in the future, they will know to
take it into consideration.
