Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF5A24314B
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 01:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHLXFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 19:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgHLXFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 19:05:21 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B05822BF3;
        Wed, 12 Aug 2020 23:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597273520;
        bh=6kwxpshrOlbOHxWnmXC6+dWtt2L5X/Drj58h8rpdMCA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pXDZRt76CPWxVlpilBeAf66pO/Ch1+UOaSOgdUpIGMcw2xAS2mFHBEgkKJVucyrd/
         hFrdQmO7EEU0DOv8a5XHHMAntvFEpH8ijK+mCysryubzOS2R2XGypW54K9swm6SsIs
         b7zU39V5JMU64Uhe2oipgDLWWHGgSe5VXnIpigps=
Received: by mail-oi1-f170.google.com with SMTP id u63so3384377oie.5;
        Wed, 12 Aug 2020 16:05:20 -0700 (PDT)
X-Gm-Message-State: AOAM531IZBzkm9SW7u4Ll0dz2BzE1TEIB7GJrdP7SZFkd9Fl6578K6/D
        TZuN3gv5Y+jYhGEA04MJz9gQHCjYIc3va2d6mQ==
X-Google-Smtp-Source: ABdhPJx2qQebZiNBPQzgE1fpdypeYG9ycnPVX3JxYluiX5nbkNkxeZlpxpCsMAonDMWnL7JIOVI286FePABwvHucHl8=
X-Received: by 2002:aca:bb82:: with SMTP id l124mr1235268oif.106.1597273520003;
 Wed, 12 Aug 2020 16:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200812203618.2656699-1-robh@kernel.org> <f5dedf2d8d8057de3eaa2f9126f44cebb0653b09.camel@perches.com>
In-Reply-To: <f5dedf2d8d8057de3eaa2f9126f44cebb0653b09.camel@perches.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 12 Aug 2020 17:05:08 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKBzqMHMMRwBJUjomxOpZAop_+TXBjLCb6ntwZzNMy=3Q@mail.gmail.com>
Message-ID: <CAL_JsqKBzqMHMMRwBJUjomxOpZAop_+TXBjLCb6ntwZzNMy=3Q@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Whitespace clean-ups in schema files
To:     Joe Perches <joe@perches.com>
Cc:     devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" 
        <linux-remoteproc@vger.kernel.org>,
        Linux HWMON List <linux-hwmon@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "open list:IIO SUBSYSTEM AND DRIVERS" <linux-iio@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:REAL TIME CLOCK (RTC) SUBSYSTEM" 
        <linux-rtc@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 4:32 PM Joe Perches <joe@perches.com> wrote:
>
> On Wed, 2020-08-12 at 14:36 -0600, Rob Herring wrote:
> > Clean-up incorrect indentation, extra spaces, long lines, and missing
> > EOF newline in schema files. Most of the clean-ups are for list
> > indentation which should always be 2 spaces more than the preceding
>                                      ^
> > keyword.

keyword is the key part...

> []
> > diff --git a/Documentation/devicetree/bindings/arm/arm,integrator.yaml b/Documentation/devicetree/bindings/arm/arm,integrator.yaml
> > index 192ded470e32..f0daf990e077 100644
> > --- a/Documentation/devicetree/bindings/arm/arm,integrator.yaml
> > +++ b/Documentation/devicetree/bindings/arm/arm,integrator.yaml
> > @@ -67,9 +67,9 @@ patternProperties:
> >        compatible:
> >          items:
> >            - enum:
> > -            - arm,integrator-ap-syscon
> > -            - arm,integrator-cp-syscon
> > -            - arm,integrator-sp-syscon
> > +              - arm,integrator-ap-syscon
> > +              - arm,integrator-cp-syscon
> > +              - arm,integrator-sp-syscon
>
> Confused a bit here.
>           - enum:
>         10 spaces to dash
> old line:
>             - arm,integrator-ap-syscon
>         12 spaces to dash
> new line:
>               - arm,integrator-ap-syscon
>         14 spaces to dash
>
> Is it supposed to be 2 spaces more than the preceding line
> or 4 more?

If the preceding line is a list entry (i.e. starts with '-'), then
it's 4 more spaces. It's always 2 more spaces than the preceding
keyword start (aka json-schema vocabulary).

Arguably, this style is a bit inconsistent in that the '-' counts
toward as indentation of the current line, but not the preceding line.
However, I think this style is a bit less error prone and easier to
review. With the other style (always N more spaces) it's harder to
distinguish lists vs. dicts. For example, you can have something like
this:

- key:
  - foo
  - bar

- key:
    foo
    bar

- key:
  - foo
    bar

All 3 of these could be valid. Which one was intended? (Can't really
tell here, but you can with actual DT schema.)

Rob
