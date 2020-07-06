Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8FC2161D2
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGFXDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGFXDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:03:17 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D3CC061755;
        Mon,  6 Jul 2020 16:03:17 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f23so41207070iof.6;
        Mon, 06 Jul 2020 16:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UGk5VMo7016wWm4hFuTU503NGuLqOJi9iG46lhgQ9kQ=;
        b=RemhuDYAtzErC73fTdjuGrfZBTVuPaoW7+b2ZdoqwRXfLLcS0Lp9m1CuvKqY2+w2+r
         zdJQJbXoEzA0gnLtrq3SKi1HD6hGzRqTGFm9FmeiCPmYd3zqZ99Wuwg3ZJjI2EU+uqJT
         Dl0vJ3JyBS0nmbxb4++9vqPSamdIYSLzM53KvkL9FUH/HOoxPM8RY6/88Vr8LQpJlgdd
         Zs7B5d0/UYvcY5IP1QlOufzVDwmqDAZvO9I5zV/aZBaeCBnKP1S7Gx0jiseaEfbxEjT4
         c3ZbPMbYgpAgN2LfEFS+L6PiIpayX7e0/DFFiJZXQAm3DCOU3wwjrKO9mb3Ufpp5nsvc
         nSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UGk5VMo7016wWm4hFuTU503NGuLqOJi9iG46lhgQ9kQ=;
        b=BvMlAYcCNz94zdbIuPwG2XILxB0xDdz7YGkpjD2zic10CI1v6EjH55Fmt+lTMqL5mh
         2m/Tnbu4hHVotQkGB6qxb6ksflq+8GMHwuDQ2UXcucll7NX8YsyaTrcDSfAJ5ri9TKQw
         tqRQRZ2Y6lVbCme8tZTNbErjphr43r4j3Hrov2NcgSNi546e0rnCGauvk17h+HIcMRAB
         cg6pHoJk7oZy0UJlCF80ew3CHG+w/vfEjc7Jy7FaxgcMbJL82WLiXlv1X6jSlvdCgmVM
         TZo2aHCm8VN+vzPqT5SzNttOJO1CmNXXgDGAtyWS2abDALVZ+P5O6UmpjAI2tSm1KyTx
         85aQ==
X-Gm-Message-State: AOAM531QAxzkDxZdnffpflUMbRZqozrxeDnvcOZfI9jcysMYLB1e0qDA
        SVFrcrgHbCQ8jdXADZJToxbK2Ib7KM3MrUqc80o=
X-Google-Smtp-Source: ABdhPJyiuEgtO2IBSNzAk1rEWbTOkOpvaAcTTnOI2B2dT7nVtxVzq5J350MZR297Oo1WNu/zCIdGX5dxoqpN4DfZGNo=
X-Received: by 2002:a05:6602:2c0a:: with SMTP id w10mr27688990iov.46.1594076596792;
 Mon, 06 Jul 2020 16:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAFXsbZp5A7FHoXPA6Rg8XqZPD9NXmSeZZb-RsEGXnktbo04GOw@mail.gmail.com>
 <20200706200742.GB893522@lunn.ch>
In-Reply-To: <20200706200742.GB893522@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 6 Jul 2020 16:03:05 -0700
Message-ID: <CAFXsbZrNgqqOCke=iZrX_fD8N2H6YecA-8JbJkxVh-KJLjENcw@mail.gmail.com>
Subject: Re: [PATCH] net: sfp: Unique GPIO interrupt names
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 1:07 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jul 06, 2020 at 12:38:37PM -0700, Chris Healy wrote:
> > Dynamically generate a unique GPIO interrupt name, based on the
> > device name and the GPIO name.  For example:
> >
> > 103:          0   sx1503q  12 Edge      sff2-los
> > 104:          0   sx1503q  13 Edge      sff3-los
> >
> > The sffX indicates the SFP the loss of signal GPIO is associated with.
>
> Hi Chris
>
> For netdev, please put inside the [PATCH] part of the subject, which
> tree this is for, i.e. net-next.

Will do.
>
> > Signed-off-by: Chris Healy <cphealy@gmail.com>
> > ---
> >  drivers/net/phy/sfp.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 73c2969f11a4..9b03c7229320 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -220,6 +220,7 @@ struct sfp {
> >      struct phy_device *mod_phy;
> >      const struct sff_data *type;
> >      u32 max_power_mW;
> > +    char sfp_irq_name[32];
> >
> >      unsigned int (*get_state)(struct sfp *);
> >      void (*set_state)(struct sfp *, unsigned int);
> > @@ -2349,12 +2350,15 @@ static int sfp_probe(struct platform_device *pdev)
> >              continue;
> >          }
> >
> > +        snprintf(sfp->sfp_irq_name, sizeof(sfp->sfp_irq_name),
> > +             "%s-%s", dev_name(sfp->dev), gpio_of_names[i]);
> > +
>
> This is perfectly O.K, but you could consider using
> devm_kasprintf(). That will allocate as much memory as needed for the
> string, and hence avoid truncation issues, which we have seen before
> with other interrupt names.

I'll give this a try for the next version of this patch.

>
>      Andrew
