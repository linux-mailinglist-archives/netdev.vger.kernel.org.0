Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2270D151971
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 12:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgBDLRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 06:17:46 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38954 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgBDLRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 06:17:46 -0500
Received: by mail-pf1-f193.google.com with SMTP id 84so9296817pfy.6;
        Tue, 04 Feb 2020 03:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJrcFiRGFHpeFKIvgEGIts5N+gXYNo7ESY+LB68CPkY=;
        b=abh9OyqK6w5mLqZzYDKcPYa59w2kpiI51le1AN+3A+rOUb0P5/yjVA6/PBWopXrCFa
         aLcaoxbWVOubeL4X0f2h5sbapQpEbkPgl3oVaEt5WKFdA2OcCViy7PK/UrN1AXjs5C4U
         uvHwpTRNBUTxcwSlbGP+T5afL/79kucoekn+opShhLhmW8R3bntLfYRZq0erAGs83Em6
         LBHnC7u2tDikZvVfGL5dkfOIQ7/qrncNjwfJSd8VVvUoKbvpT5MD3Kf4kAaGCxC1cdGx
         VH15CRASgPMmp3dPGgMTMMRCHvRO3eYwwtVf3Fagv0UtvBMDTGC1u7PiXjPtt5QjtU/d
         yyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJrcFiRGFHpeFKIvgEGIts5N+gXYNo7ESY+LB68CPkY=;
        b=unthTuHjCon0EBaYJsRl4Kzas2MxpWn4UVSZB8dgHWhYHh8Y7yLEVDZoqeYTucVZl0
         kZFa2PwLBhT+ubwO/xEZf5Y5ugWQgWGsnvmUyEtDFZwAZ560FKQHa8VA95U9zVhw3rTl
         Fr1EQO1aqpe1JuKqXg/HOW3OXY73LNmy0hBLCeKZ498xyG/dW+DzLjVZzeosODct0I1/
         ehWryelv9AxsqQm73pn0IU/JjsWnS9f/NmuEmutJqtg2EC2aK1MTXC2ESSsPq/WtslS1
         8adhI4tKmZViFm7UA0ueTOurzcZYecUYWevvoeckXkL8JOB7WoTiXq1DAVyE6+W+FB7k
         BflQ==
X-Gm-Message-State: APjAAAU3fMnWnZDVNxyfR+0F/1n5X2b3ucIbJxD3GamI2o1CQabETxSy
        /gIrotHFJx1sZSLPsdg7Nwsa3WMX13vViOIWpbk=
X-Google-Smtp-Source: APXvYqzgvBRis5uAOLpaw8DD2lKOdBTQZLfiNZX4j56TL3j0UnIOLzC7dnkRtQNHZJRN/Ty4HTOskmiSy1lfIVZOVW4=
X-Received: by 2002:a65:4685:: with SMTP id h5mr32220017pgr.203.1580815064309;
 Tue, 04 Feb 2020 03:17:44 -0800 (PST)
MIME-Version: 1.0
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-4-calvin.johnson@nxp.com> <CAHp75VeRq8XT67LJOM+9R9xVpsfv7MxZpaCHYkfnCqAzgjXo9A@mail.gmail.com>
 <AM0PR04MB5636EA716C9D029C97C5854293030@AM0PR04MB5636.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB5636EA716C9D029C97C5854293030@AM0PR04MB5636.eurprd04.prod.outlook.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Feb 2020 13:17:36 +0200
Message-ID: <CAHp75VehAzdXrQRL5t3-5Nm0rrdkRdX20rEUhyHNFy_D0Vvtqg@mail.gmail.com>
Subject: Re: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
To:     "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
Cc:     "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 9:18 AM Calvin Johnson (OSS)
<calvin.johnson@oss.nxp.com> wrote:
> > -----Original Message-----
> > From: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Subject: Re: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
> > On Fri, Jan 31, 2020 at 5:37 PM Calvin Johnson <calvin.johnson@nxp.com>
> > wrote:

...

> > > -       snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long
> > long)res.start);
> > > +       snprintf(bus->id, MII_BUS_ID_SIZE, "%llx",
> > > +                (unsigned long long)res->start);
> >
> > Why this has been touched?
>
> Without this change, I get:
> ---------------------------------------------------------
> drivers/net/ethernet/freescale/xgmac_mdio.c: In function 'xgmac_mdio_probe':
> drivers/net/ethernet/freescale/xgmac_mdio.c:269:27: error: request for member 'start' in something not a structure or union
>     (unsigned long long)res.start);
>                            ^
> scripts/Makefile.build:265: recipe for target 'drivers/net/ethernet/freescale/xgmac_mdio.o' failed
> make[4]: *** [drivers/net/ethernet/freescale/xgmac_mdio.o] Error 1
> ---------------------------------------------------------

I see. Thanks.
Can you leave it one line as it was before?

...

> > (Hint: missed terminator)
> static const struct acpi_device_id xgmac_mdio_acpi_match[] = {
>         { "NXP0006", 0 },
>         { }
> };
> Is this what you meant?

Yes!

...

> > > +               .acpi_match_table = ACPI_PTR(xgmac_mdio_acpi_match),
> >
> > ACPI_PTR is not needed otherwise you will get a compiler warning.
>
> No compiler warning was observed in both cases.

You mean you tried CONFIG_ACPI=n and didn't get a warning about unused
static variable?
Perhaps you may run `make W=1 ...`

> I can see other drivers using this macro.

They might have hidden same issue.

-- 
With Best Regards,
Andy Shevchenko
