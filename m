Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EB63654D4
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhDTJIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:08:20 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:42069 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhDTJIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:08:18 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M3lLh-1lYVNL03GN-000snS; Tue, 20 Apr 2021 11:07:44 +0200
Received: by mail-wr1-f47.google.com with SMTP id e7so27820771wrs.11;
        Tue, 20 Apr 2021 02:07:43 -0700 (PDT)
X-Gm-Message-State: AOAM530bK2/Zhpk5hISNbBeQuJc8bwXLZL3Op5+Z3jB4wVxrjl+Sao6S
        C+gjr8AN0THF/N2eQjocMKwjVco4O5LSgtigO90=
X-Google-Smtp-Source: ABdhPJwSiNwlZ27l6d0oeVOJMjBIBpaEf6fV+Kr02yQOCGa6DdHdokE+eIs4+TiyDD+ybgS8jO4hGYikHl0QAhmuRDs=
X-Received: by 2002:adf:db4f:: with SMTP id f15mr19571156wrj.99.1618909652608;
 Tue, 20 Apr 2021 02:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210419042722.27554-1-alice.guo@oss.nxp.com> <20210419042722.27554-4-alice.guo@oss.nxp.com>
 <YH0O907dfGY9jQRZ@atmark-techno.com> <CAMuHMdVY1SLZ0K30T2pimyrR6Mm=VoSTO=L-xxCy2Bj7_kostw@mail.gmail.com>
 <YH1OeFy+SepIYYG0@atmark-techno.com> <CAK8P3a1Mu2F0irDDCL-50HiHth29iYFL5b7WHZ=UX6W7zzoxAg@mail.gmail.com>
 <YH4VdPNO9cdzc5MD@atmark-techno.com>
In-Reply-To: <YH4VdPNO9cdzc5MD@atmark-techno.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 20 Apr 2021 11:07:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1GjeHyMCworQYVtp5U0uu2B9VBHmf9y0hGn-o8aKSJZw@mail.gmail.com>
Message-ID: <CAK8P3a1GjeHyMCworQYVtp5U0uu2B9VBHmf9y0hGn-o8aKSJZw@mail.gmail.com>
Subject: Re: [RFC v1 PATCH 3/3] driver: update all the code that use soc_device_match
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "Alice Guo (OSS)" <alice.guo@oss.nxp.com>,
        gregkh <gregkh@linuxfoundation.org>,
        Rafael Wysocki <rafael@kernel.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        aymen.sghaier@nxp.com, Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        peter.ujfalusi@gmail.com, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>, tomba@kernel.org,
        jyri.sarha@iki.fi, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kishon <kishon@ti.com>, Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Roy Pledge <Roy.Pledge@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>, Felipe Balbi <balbi@kernel.org>,
        Tony Prisk <linux@prisktech.co.nz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>, dmaengine@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Amlogic Meson SoC support" 
        <linux-amlogic@lists.infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-phy@lists.infradead.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-staging@lists.linux.dev,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ltcVWPzbOzdUu0wQVBbKGnNxKoc98HAW0duSMZcYgv925OTLSOo
 ZELSDbcdcLSNH6jcDj67BsKk30EPrQcQ8Efw82x799k6bMj9s2S+m69ZiBVlhuvUlnJi1KE
 D7RnoNvLskVAUP5tUpp+AzAQkOM4ikGI/bBCnIU1DkH5GwBwAgWr5giBTyb98Y4I7MSVa9V
 glR/dmIR70ry9QtHaxTJQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:m62Jwkt4Q9A=:KANWiBROdRHMBQ5xLHe3U2
 hzC4pqyCkSOIDCpwHHpdfePw/DSVMWP11cjA9UAjvJaYaBXCZ5ZviOUZuds+WAtiQuHxsqgvG
 nZi4yzXKiBDbdqpDmqSnJSLdXBr5QaacWl8ByR2QA/IPJEKeZxqlFpXmUIRvvw9yILmSAgAwm
 kTxiSk1xsoLYt4eUP9X1BKjgUadX4/EsohQRwshD6awFocrh/vn5To8p+UeSEy9M6vG6ayoc3
 KzloVi0GVUYRFc1NPbKUAVnYQJMIhG77x+Cm3slvPquhclTau9xa2jEDlsYf9AmTY1xTPSiJr
 /g5TniSnhP8grlfVciwqdoi923h7Wd+xuUOomDfXdzWsGmOnj0YXIDpS+jnskS4OcxhO+FRMn
 FzZZ9kkBvKQlYDBBlVJSIXMDuM+k11tV7v8z5yaqgg7dlymVRjd+HCL64OR8G/W0vIDw4rPr2
 pp7HSGeYD00x82SkyzleiGe82V3CUweY4dnSbInIp/X4AIhFXsZWIlACLNsg0WEDBBic9FOVB
 pe4HnvYTumVgpgOpu+WBCL4nBvUWvDUeLp2H0ZtwDqDlJhW2cPSYgGYmEkc9JgZOSAjBhucWB
 ySMJnPpH3XQziDvSrylbWsiz0S5V3jaD6fnbfN05zGkdzDFwrWIH2hlbOI7PqXh7Y+r9HScxY
 jsF4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 1:44 AM Dominique MARTINET
<dominique.martinet@atmark-techno.com> wrote:
> Arnd Bergmann wrote on Mon, Apr 19, 2021 at 02:16:36PM +0200:
> > For built-in drivers, load order depends on the initcall level and
> > link order (how things are lined listed in the Makefile hierarchy).
> >
> > For loadable modules, this is up to user space in the end.
> >
> > Which of the drivers in this scenario are loadable modules?
>
> All the drivers involved in my case are built-in (nvmem, soc and final
> soc_device_match consumer e.g. caam_jr that crashes the kernel if soc is
> not identified properly).

Ok, in that case you may have a chance to just adapt the initcall
levels. This is somewhat fragile if someone else already relies
on a particular order, but it's an easy one-line change to change
a driver e.g. from module_init() or device_initcall() to arch_initcall().

> I frankly don't like the idea of moving nvmem/ above soc/ in
> drivers/Makefile as a "solution" to this (especially as there is one
> that seems to care about what soc they run on...), so I'll have a look
> at links first, hopefully that will work out.

Right, that would be way more fragile.

I think the main problem in this case is the caam driver that really
should not look into the particular SoC type or even machine
compatible string. This is something we can do as a last resort
for compatibility with busted devicetree files, but it appears that
this driver does it as the primary method for identifying different
hardware revisions. I would suggest fixing the binding so that
each SoC that includes one of these devices has a soc specific
compatible string associated with the device that the driver can
use as the primary way of identifying the device.

We probably need to keep the old logic around for old dtb files,
but there can at least be a comment next to that table that
discourages people from adding more entries there.

      Arnd
