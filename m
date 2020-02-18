Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA33162716
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 14:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgBRNY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 08:24:56 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32983 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgBRNY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 08:24:56 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so22950966lji.0
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 05:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cp2LHXRjAwdGFGqhDpjH1tRAAkkcIyA4nhmvZj5NcIU=;
        b=MFa4w3QpReBQ5jxYBilarOKRoZcskBKPYDlAWdB0DfKbB/OhOnfZ4jc5PqM2xoiqrn
         ty/N5iqGXrC2ctyOes4AAlixwTxsdVBnLaGFXKzk3eaciIKHdLN4ruwtGO1tDJ4Seh16
         r9fE0XRaAy7n/r32gmtWlYqvBUb1agcYPnYkUMwLR3bx6LV+MaMDhw6Z55tG4UYBJHM7
         Poyz2vyrXvRAI65zYgknEpUGNo/tjXhmi3ayempl/LqrvwvWYpQmZUP6H3ieO4OwuTXg
         cNAuoazMpHOmuo+rzvLj8/oODgcYcvIobDNKUrpV5SkpuL8iUQK1cMHX0CddnUR0Hg+F
         n+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cp2LHXRjAwdGFGqhDpjH1tRAAkkcIyA4nhmvZj5NcIU=;
        b=onkR0LC2LgdG2HP25SS03UnnYnaM2/csmycjqCPrUF4oW881PdmZFmO26J73vH30Ok
         Kfex0/+NUmiV90kCAF7TnGVTgiLEqAoNhOzzJv9rCEmE8z/N2Xi11PS3HI0/YUXgWIH0
         BrRzEgp2ru3p2NqHeO/pxFzvGTAX5/eK9Sc6aXnMHxX4DiO0+F1py95pydG+/vwmExQ3
         b/hJ2sQVDdxKLpyz1FStUJN0+UBiIeLQNGU2501oPC2jUhOPv62NMVDl2YeNouX1fWYD
         k+8GmhS4UYsn9aYDJTU7TW3/QSd+2dZyKlp1gvwPFK7kH+Am/I4jq5jtIPe6eLHbYxht
         XnRw==
X-Gm-Message-State: APjAAAVq59sf3pY2BHbwfA5ztWpZAiO4Wx4Ztfi6kltHWHRIvJhfPYju
        fZ8YJnBb2Z0RrRGA1Y6Yl/nkYp+zvYQj/w8KsST391d2
X-Google-Smtp-Source: APXvYqzWvARWc1d8Ne4FYShqga7u9SwBlD8znlBgjKGpXzWX9vpjp36oM0dm5I+4ufidvr9Zd3SASM36ZhqFoTDv3ac=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr12594250ljc.195.1582032293892;
 Tue, 18 Feb 2020 05:24:53 -0800 (PST)
MIME-Version: 1.0
References: <20200217223651.22688-1-festevam@gmail.com> <20200217.214840.486235315714211732.davem@davemloft.net>
 <VI1PR0402MB3600C163FEFD846B1D5869B4FF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3600C163FEFD846B1D5869B4FF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 18 Feb 2020 10:24:42 -0300
Message-ID: <CAOMZO5CWX9dhcg_v3LgPvK97yESAi_kS72e0=vjiB+-15C5J1g@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation scheme
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Tue, Feb 18, 2020 at 3:51 AM Andy Duan <fugang.duan@nxp.com> wrote:

> > What about:
> >
> > 1) unbind fec0
> > 2) unbind fec1
> > 3) bind fec0
> >
> > It doesn't work even with the IDR scheme.
>
> Not only such case, instance#A (maybe fec0 or fec1) depends on instance#B (maybe fec1 or fec0),
> Unbind instance#B firstly has problem.
> Bind instance#A firstly also has problem.

Yes, I do see the error now with the sequence suggested by David.

I have also noticed in the fec_main.c comments:

/*
* The i.MX28 dual fec interfaces are not equal.
* Here are the differences:
*
*  - fec0 supports MII & RMII modes while fec1 only supports RMII
*  - fec0 acts as the 1588 time master while fec1 is slave
*  - external phys can only be configured by fec0
*
* That is to say fec1 can not work independently. It only works
* when fec0 is working. The reason behind this design is that the
* second interface is added primarily for Switch mode.
*
* Because of the last point above, both phys are attached on fec0
* mdio interface in board design, and need to be configured by
* fec0 mii_bus.
*/

Should we prevent unbind operation from this driver like this?

diff --git a/drivers/net/ethernet/freescale/fec_main.c
b/drivers/net/ethernet/freescale/fec_main.c
index 4432a59904c7..1d348c5d0794 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3793,6 +3793,7 @@ static struct platform_driver fec_driver = {
                .name   = DRIVER_NAME,
                .pm     = &fec_pm_ops,
                .of_match_table = fec_dt_ids,
+               .suppress_bind_attrs = true
        },
        .id_table = fec_devtype,
        .probe  = fec_probe,

Please advise.

Thanks
