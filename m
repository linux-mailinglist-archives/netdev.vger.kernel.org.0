Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A903B222E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFWVDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhFWVDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:03:11 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE79CC061756
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:00:52 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id y29so7268513qky.12
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wWc7S1al1WwAVOp+y6zQe0CWSp+8hVb9XJrJmdJfBBU=;
        b=eUrA2uEsrdP8RvvO4m51oEKWTX2Qswv+d2+PL/m8WFQVCIL2f09FxousY0CsIS+/+K
         jThpFKoOmBLw3lKktqNw/fRGHt0sM7kkB4o9pupIzDZS9POK+65OOp1ogpOsIvOea+0S
         0fNbTGIy9p0/Dd8yUASCaERBMb0FOjh3vZv15C89/puNbHM2gurGb38tB407ijVjdlKr
         cI3eavDSiqfoloXBni1Wyg8osmNC/EVCg0MdtgNHYrnbaHJyjMxvTXht8rwvXAQuheCm
         E6JiZQ73lKfGzVdgjZtAuelbfNCGSmz3+rXK0z8gGkCc7w+F0sbwbMIIVlmG5OjFSoEl
         fyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wWc7S1al1WwAVOp+y6zQe0CWSp+8hVb9XJrJmdJfBBU=;
        b=uAmvS9PcydiC9v6oWldqjRQNFa68wl2rdawKX5DZbups9NJuKLdx+DVzCOZ85C6ARZ
         wSjKmUtcEpld/baAb+86YkgQo275T8ZfahR916gPcw29TS6bmLnX17m8tkXVrNVMx43g
         hPxcs+GDwC59CILnCqOm1YF4GYu/SvYbG3TWtgKgzyO1voNc0HGX3zmaFQvRdVOTeGcx
         wnFN/N/IRijbJIisSZwMRvHnbR2+GBX/u3KqAf4QFn0ELY8NhJVIGcl2ULRSlz+2bDV2
         7ZCXXZS5YeiCZ4EY427KMsyquU9guB87T4NbAmOevRpPNmtzp9uKBzEPpLZPV/GO9SlH
         tDMg==
X-Gm-Message-State: AOAM531dXTG/I6sLfqKvJEzJb9p51H8Ec1pQpedvV+MikqrJtwiOhFqG
        ycc+pgx7Mp1WZms6z/XcHkw6dogLcyng9nW/smGCgQ==
X-Google-Smtp-Source: ABdhPJxxsQSUj31dvJRDYjgDMyLXsvuem6+pypfokYWpON7PFK8GL48uVo0QJFwKl2NczV8nr5j1V1Gr9vkQf7GAPgU=
X-Received: by 2002:a37:311:: with SMTP id 17mr1235839qkd.295.1624482051895;
 Wed, 23 Jun 2021 14:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210621173028.3541424-1-mw@semihalf.com> <20210621173028.3541424-2-mw@semihalf.com>
 <YNOW+mQNEmSRx/6V@lunn.ch>
In-Reply-To: <YNOW+mQNEmSRx/6V@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 23 Jun 2021 23:00:42 +0200
Message-ID: <CAPv3WKctVLzTZxH2gc-M_ZT7T-i6OmwSQk30AQ4oHEm8BUrpiw@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 1/6] Documentation: ACPI: DSD: describe
 additional MAC configuration
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

=C5=9Br., 23 cze 2021 o 22:18 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > +MAC node example with a "fixed-link" subnode.
> > +---------------------------------------------
> > +
> > +.. code-block:: none
> > +
> > +     Scope(\_SB.PP21.ETH1)
> > +     {
> > +       Name (_DSD, Package () {
> > +         ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +              Package () {
> > +                  Package () {"phy-mode", "sgmii"},
> > +              },
> > +         ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> > +              Package () {
> > +                  Package () {"fixed-link", "LNK0"}
> > +              }
> > +       })
>
> At least in the DT world, it is pretty unusual to see both fixed-link
> and phy-mode.

I did a quick experiment:
git grep -C 8 fixed-link arch/arm64/boot/dts/
git grep -C 8 fixed-link arch/arm/boot/dts/
almost all MAC nodes (i.e. not switch ports) containing 'fixed-link'
have an adjacent 'phy-mode' property defined. How else would the
drivers know how to configure the HW connection type in its registers?

> You might have one of the four RGMII modes, in order to
> set the delays when connecting to a switch. But sgmii and fixed link
> seems very unlikely, how is sgmii autoneg going to work?
>

Indeed most cases in the tree are "rgmii*", but we can also see e.g.
10gbase-r, sgmii and 2500base-x. You can find sgmii + fixed-link on
the eth1 of the armada-388-clearfog. Regarding the autoneg - I'm
mostly familiar with the mvneta/mvpp2, but in this mode the
autonegotiation is disabled and the link is forcibly set up/down in
MAC registers during the netedev_open/close accordingly. FYI, along
with the 10G ports on CN913x-DB, I tested fixed-link on Macchiatobin
sgmii port.

Anyway - all above is a bit side discussion to the actual DSDT
description and how the fixed-link subnode looks like. I think
phy-mode set to "sgmii" is not incorrect, but we can change it to
whatever other type of your preference, as well.

Best regards,
Marcin

> > +       Name (LNK0, Package(){ // Data-only subnode of port
> > +         ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +              Package () {
> > +                  Package () {"speed", 1000},
> > +                  Package () {"full-duplex", 1}
> > +              }
> > +       })
> > +     }
> > +
>
>   Andrew
