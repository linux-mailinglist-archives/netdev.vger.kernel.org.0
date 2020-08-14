Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C5F244B6A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 16:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgHNOvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 10:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgHNOvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 10:51:38 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C6E208B3;
        Fri, 14 Aug 2020 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597416697;
        bh=2azDCJAW0WmwzjFoNP1+Xf1baXp64Ykp/VUpBlKju0s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bjfRL+mBKQdeXNIPuXX+sib3fYs2/XZWJHPOjPd4x196xwXtWkEnxkwGCGKCP+vXy
         CxGeqKP68MgYI300g+hNTJd4uQCvZb/zOsnBdJ/cEKlyynKbLGyhuMbkA+R9Y9MLDY
         rajai6Sqx8HGb8L035zTD4t0BSpxCLooD+BQeHTA=
Received: by mail-ot1-f54.google.com with SMTP id t7so7776444otp.0;
        Fri, 14 Aug 2020 07:51:36 -0700 (PDT)
X-Gm-Message-State: AOAM531YqcS4MUxvcGOYChGHRoRMcVsEFsDHYR5LbkHA90TiOSl6Dmh8
        R/b9TCtT0vzAo6TEwQr7L0CGI1coatN8YZannA==
X-Google-Smtp-Source: ABdhPJzAQOVgwIRLTeJz+4kS8jI7uSM4yy2bV/QUkiEz2152JH8sgfiQxJMSY+wk4abg95jsoFr6h5Ymz6ZJoeFhB2g=
X-Received: by 2002:a05:6830:1b79:: with SMTP id d25mr1995774ote.107.1597416696235;
 Fri, 14 Aug 2020 07:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200812203618.2656699-1-robh@kernel.org> <d5808e9c-07fe-1c28-b9a6-a16abe9df458@lucaceresoli.net>
In-Reply-To: <d5808e9c-07fe-1c28-b9a6-a16abe9df458@lucaceresoli.net>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 14 Aug 2020 08:51:24 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKekx0VO4NROwLrgrU8+L584HaLHM9i3kCZvU+g5myeGw@mail.gmail.com>
Message-ID: <CAL_JsqKekx0VO4NROwLrgrU8+L584HaLHM9i3kCZvU+g5myeGw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Whitespace clean-ups in schema files
To:     Luca Ceresoli <luca@lucaceresoli.net>
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

On Thu, Aug 13, 2020 at 4:31 AM Luca Ceresoli <luca@lucaceresoli.net> wrote:
>
> Hi Rob,
>
> On 12/08/20 22:36, Rob Herring wrote:
> > Clean-up incorrect indentation, extra spaces, long lines, and missing
> > EOF newline in schema files. Most of the clean-ups are for list
> > indentation which should always be 2 spaces more than the preceding
> > keyword.
> >
> > Found with yamllint (which I plan to integrate into the checks).
>
> [...]
>
> > diff --git a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> > index 3d4e1685cc55..28c6461b9a9a 100644
> > --- a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> > +++ b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> > @@ -95,10 +95,10 @@ allOf:
> >        # Devices without builtin crystal
> >        properties:
> >          clock-names:
> > -            minItems: 1
> > -            maxItems: 2
> > -            items:
> > -              enum: [ xin, clkin ]
> > +          minItems: 1
> > +          maxItems: 2
> > +          items:
> > +            enum: [ xin, clkin ]
> >          clocks:
> >            minItems: 1
> >            maxItems: 2
>
> Thanks for noticing, LGTM.
>
> [...]
>
> > diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> > index d7dac16a3960..36dc7b56a453 100644
> > --- a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> > +++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> > @@ -33,8 +33,8 @@ properties:
> >      $ref: /schemas/types.yaml#/definitions/uint32
> >
> >    touchscreen-min-pressure:
> > -    description: minimum pressure on the touchscreen to be achieved in order for the
> > -                 touchscreen driver to report a touch event.
> > +    description: minimum pressure on the touchscreen to be achieved in order
> > +      for the touchscreen driver to report a touch event.
>
> Out of personal taste, I find the original layout more pleasant and
> readable. This third option is also good, especially for long descriptions:
>
>   description:
>     minimum pressure on the touchscreen to be achieved in order for the
>     touchscreen driver to report a touch event.
>
> At first glance yamllint seems to support exactly these two by default:
>
> > With indentation: {spaces: 4, check-multi-line-strings: true}

Turning on check-multi-line-strings results in 10K+ warnings, so no.

The other issue is the style ruamel.yaml wants to write out is as the
patch does above. This matters when doing some scripted
transformations where we read in the files and write them back out. I
can somewhat work around that by first doing a pass with no changes
and then another pass with the actual changes, but that's completely
scriptable. Hopefully, ruamel learns to preserve the style better.

Rob
