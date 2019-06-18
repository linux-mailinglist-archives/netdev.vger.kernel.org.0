Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E628497EB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 06:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfFREEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 00:04:41 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33066 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfFREEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 00:04:40 -0400
Received: by mail-lj1-f195.google.com with SMTP id h10so11571394ljg.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 21:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJLmkVwnPans9/iuFpcwnbTM7EUsIIBXDTl8TGQaxjk=;
        b=fNNVvfjLstujPCDm6U22v9kUb8V+ystPZzxjPsEpjTbMtRt6UZtFM3QfkWDyzAQMIW
         E6KfxvJkYCAiMigfxeNfkJbvlgJdvzEEfyDNXcSQ4hGpsd9Yv0PN3VCeG9Syybma3zAA
         YweVCf2jDX7KE7OToEgZ3Hm86et1Zzc1wT1rS2GKgDnXDs7wUV3rbSDjUKshW4DDBFiv
         WiW8rczljYaGap+qcx/bFr34QWpznmS62Lv9HHybuJDuuqKHqJD4Khp833m98/pUJhJR
         z/Wi3GOSjsiZFAWusKz/vCsNsKbGzD11ktzwf/VoHCT35CeFpX/vlTnPTD2hFmBTUNJt
         WypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJLmkVwnPans9/iuFpcwnbTM7EUsIIBXDTl8TGQaxjk=;
        b=PlgvB7HNPamsmRJmhfQe/QyG3us9acVIVSiUaXX5+8lfvhem0DcLVtbmX7uJiKh00i
         dMeyVWIU3GkcFz4cg3ywMDPgTJJBlyLe2bvzITPBlexXdQvFlcgThuZF9cZjNdwThym9
         3ciG843HYSXBT1MgDUpOoojcb8MAIKG1VZTXDyg/86lMNTMqZ1U7UPJqetlxa/50Z88a
         D7Yr8pjKmFzIzoSkHX4WkxGdO9yufQTkGzMsZElIRiid1W0RRc4UoFzSRCpZIHQc8iFl
         tw6DJ5gl90drJH99oKN5Z74FDM10OUKb9B588aovKEMKi217evEK6PT0agcZODWKGIYj
         cW6A==
X-Gm-Message-State: APjAAAXI0sEEAz9qU+ZDgCgANF6NIMx/7dv0WVV8iWorrGU9PPEbrkLp
        LhBrmx2/E1CnjqFJDm1qNZ8fFjMGoaYwe1qH+l03Ww==
X-Google-Smtp-Source: APXvYqzHxAVSyFWFoE5KWadzgd5NrlnSBkdcYDfnoz898BtjOkb8yWEu0/Ss3PN8knMcABE84pxCcZt3rdAD2rwB66w=
X-Received: by 2002:a2e:b047:: with SMTP id d7mr13909677ljl.8.1560830679001;
 Mon, 17 Jun 2019 21:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
 <1560745167-9866-3-git-send-email-yash.shah@sifive.com> <20190617155834.GK25211@lunn.ch>
In-Reply-To: <20190617155834.GK25211@lunn.ch>
From:   Yash Shah <yash.shah@sifive.com>
Date:   Tue, 18 Jun 2019 09:34:02 +0530
Message-ID: <CAJ2_jOEm1+HFewpvq6fdoHaTtghpnxkkz9LWTz3-xWJAtYp8-g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] macb: Add support for SiFive FU540-C000
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 9:28 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jun 17, 2019 at 09:49:27AM +0530, Yash Shah wrote:
...
> >  static const struct macb_config at91sam9260_config = {
> >       .caps = MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII,
> >       .clk_init = macb_clk_init,
> > @@ -3992,6 +4112,9 @@ static int at91ether_init(struct platform_device *pdev)
> >       { .compatible = "cdns,emac", .data = &emac_config },
> >       { .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
> >       { .compatible = "cdns,zynq-gem", .data = &zynq_config },
> > +#ifdef CONFIG_MACB_SIFIVE_FU540
> > +     { .compatible = "sifive,fu540-macb", .data = &fu540_c000_config },
> > +#endif
>
> This #ifdef should not be needed.
>
> >       { /* sentinel */ }
> >  };
> >  MODULE_DEVICE_TABLE(of, macb_dt_ids);
> > @@ -4199,6 +4322,9 @@ static int macb_probe(struct platform_device *pdev)
> >
> >  err_disable_clocks:
> >       clk_disable_unprepare(tx_clk);
> > +#ifdef CONFIG_MACB_SIFIVE_FU540
> > +     clk_unregister(tx_clk);
> > +#endif
>
> So long as tx_clk is NULL, you can call clk_unregister(). So please
> remove the #ifdef.
>
>
> >       clk_disable_unprepare(hclk);
> >       clk_disable_unprepare(pclk);
> >       clk_disable_unprepare(rx_clk);
> > @@ -4233,6 +4359,9 @@ static int macb_remove(struct platform_device *pdev)
> >               pm_runtime_dont_use_autosuspend(&pdev->dev);
> >               if (!pm_runtime_suspended(&pdev->dev)) {
> >                       clk_disable_unprepare(bp->tx_clk);
> > +#ifdef CONFIG_MACB_SIFIVE_FU540
> > +                     clk_unregister(bp->tx_clk);
> > +#endif
>
> Same here.
>
> In general try to avoid #ifdef in C code.

Will remove all the #ifdef in v3.
Thanks for your comments.

- Yash
