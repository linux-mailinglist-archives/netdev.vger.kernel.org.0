Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A3A433B15
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhJSPv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:51:27 -0400
Received: from mail-ua1-f41.google.com ([209.85.222.41]:33781 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbhJSPvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:51:12 -0400
Received: by mail-ua1-f41.google.com with SMTP id i15so908804uap.0;
        Tue, 19 Oct 2021 08:48:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HNaCNDIMKi9f5orM5Jol9xHR3VahWyBHoZmsq1Eeb20=;
        b=k+geyGmZIBzvsxD0ArpgebLewKURGVA+YsuQJqGJ8v1ya3qruj6PGFuAgrAftkT9Qe
         2O9z/1M0ADg7XEhqYPgbTbuwfA35VWyj+lSbox+4PHjUNBWpcMBSNiwJ3ir9wMeIjws1
         DKBTkIG1joKyARuMM94lLin6KTls4f1sq3pa3PaAqn1dztGIXOXbVwzneS8To8SlshpO
         xGbJUFneKoywJawOaH3YcB6+H/WNT9mijVb3iYCT2OY0FT5olTNA8/S1BBOUyipKqE/G
         45I0sJ9+vpnXe2dGcKOG6Lfd13Vw746iz/VXBtv2xWpo2+0F/WVoL2Zbr6L/TdoSIvDa
         eoVQ==
X-Gm-Message-State: AOAM533osZLaAPGd5OZmg70na7P781druF21xayNmZk22hCgZpKWmjsm
        vrEFJdBN/20gqI8wtdeYuwyoPSDuXEW5ZA==
X-Google-Smtp-Source: ABdhPJziWFXHbttaGhABKofRQCK6LlxVlvrspebAP2565jCfhx5Tnun1PrBhCjFF4mmreoo8EjQDTQ==
X-Received: by 2002:ab0:212:: with SMTP id 18mr725437uas.103.1634658538771;
        Tue, 19 Oct 2021 08:48:58 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id u26sm11291347vsj.9.2021.10.19.08.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 08:48:58 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id f4so794095uad.4;
        Tue, 19 Oct 2021 08:48:58 -0700 (PDT)
X-Received: by 2002:ab0:3154:: with SMTP id e20mr854747uam.14.1634658537875;
 Tue, 19 Oct 2021 08:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634646975.git.geert+renesas@glider.be> <c1814db9aff7f09ea41b562a2da305312d8df2dd.1634646975.git.geert+renesas@glider.be>
 <70d3efb8-e379-5d20-1873-4752e893f10b@lechnology.com>
In-Reply-To: <70d3efb8-e379-5d20-1873-4752e893f10b@lechnology.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Oct 2021 17:48:46 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWBwh6uZ_NtMsGjHcV4bTUgZfs0iKg-jCCLM8gkRcRi6g@mail.gmail.com>
Message-ID: <CAMuHMdWBwh6uZ_NtMsGjHcV4bTUgZfs0iKg-jCCLM8gkRcRi6g@mail.gmail.com>
Subject: Re: [PATCH 3/3] dt-bindings: net: ti,bluetooth: Convert to json-schema
To:     David Lechner <david@lechnology.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Reichel <sre@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list:TI ETHERNET SWITCH DRIVER (CPSW)" 
        <linux-omap@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, Oct 19, 2021 at 5:41 PM David Lechner <david@lechnology.com> wrote:
> On 10/19/21 7:43 AM, Geert Uytterhoeven wrote:
> > Convert the Texas Instruments serial-attached bluetooth Device Tree
> > binding documentation to json-schema.
> >
> > Add missing max-speed property.
> > Update the example.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > I listed David as maintainer, as he wrote the original bindings.
> > Please scream if not appropriate.
>
> I'm not affiliated with TI in any way, so if someone from TI
> wants to take responsibility, that would probably be better.
>
> For for the time being...
>
> Acked-by: David Lechner <david@lechnology.com>

Thanks!

> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
> > @@ -0,0 +1,91 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/ti,bluetooth.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Texas Instruments Bluetooth Chips
> > +
> > +maintainers:
> > +  - David Lechner <david@lechnology.com>
> > +
> > +description: |
> > +  This documents the binding structure and common properties for serial
> > +  attached TI Bluetooth devices. The following chips are included in this
> > +  binding:
> > +
> > +  * TI CC256x Bluetooth devices
> > +  * TI WiLink 7/8 (wl12xx/wl18xx) Shared Transport BT/FM/GPS devices
> > +
> > +  TI WiLink devices have a UART interface for providing Bluetooth, FM radio,
> > +  and GPS over what's called "shared transport". The shared transport is
> > +  standard BT HCI protocol with additional channels for the other functions.
> > +
> > +  TI WiLink devices also have a separate WiFi interface as described in
> > +  wireless/ti,wlcore.yaml.
> > +
> > +  This bindings follows the UART slave device binding in ../serial/serial.yaml.
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - ti,cc2560
> > +      - ti,wl1271-st
> > +      - ti,wl1273-st
> > +      - ti,wl1281-st
> > +      - ti,wl1283-st
> > +      - ti,wl1285-st
> > +      - ti,wl1801-st
> > +      - ti,wl1805-st
> > +      - ti,wl1807-st
> > +      - ti,wl1831-st
> > +      - ti,wl1835-st
> > +      - ti,wl1837-st
> > +
> > +  enable-gpios:
> > +    maxItems: 1
> > +
> > +  vio-supply:
> > +    description: Vio input supply (1.8V)
> > +
> > +  vbat-supply:
> > +    description: Vbat input supply (2.9-4.8V)
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  clock-names:
> > +    items:
> > +      - const: ext_clock
> > +
> > +  max-speed: true
>
> Does this mean that max-speed from serial.yaml is supported
> but current-speed is not?

I added it because one DTS uses "max-speed", and the driver
supports it.
The driver does not support "current-speed", but seems to ask for
an initial speed of 115200, and an operational speed of max-speed
(default 3000000, perhaps that should be documented in the bindings):

        hci_uart_set_speeds(hu, 115200, max_speed);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
