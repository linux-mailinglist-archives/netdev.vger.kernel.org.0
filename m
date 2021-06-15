Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3A3A83BC
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhFOPPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhFOPPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:15:41 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CECC061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:13:37 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u20so11494080qtx.1
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=INX7H6XxUTAVbwgV5PMueO86g/kTATWT2HWC/q8m03E=;
        b=Lpcg96UfcrHiH3Nyy8ukJUz0gllsoQBs9pKtqzq7AkElQPEGWZLL1crv+MO4vjA7XH
         y0beMwxf9TL5+eXYJKMHElQAdrzQr7eqyrk2CF8q4xhLCqZYL1OM3vk2hqtkW3hykTZs
         he8X3IKzOSJY/vIXS8bNwJZa7XngB0QJOffllg/YQsriGHzb3bzH6P/UDGogewn0WxWM
         jAiJkTKdv0LUwCLw6XRy0Ms9wCEgnh84YMX44UEHRQ8H2QFYMFE7sE8/Oj0w6uOumjYP
         pZNqYZf3BeZBMPEfzwNg3xQ3KW4YU8UDrAhtPdDEPBgrdFh6TlkhBQRDI7GZlJSZ8mUZ
         uidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=INX7H6XxUTAVbwgV5PMueO86g/kTATWT2HWC/q8m03E=;
        b=pwqFGCgyWMqcIVvAQN3KZnlvNX2KCBNdqXZTGWkzeqxDjeOvvbybop9SquzsACxjK0
         JRe0ufuRdOrkV+Ux8kBcnvyrtu8VUb9V7DFjBSbiA6S5SYCpC7itQPMtW/V8yOmGOQjL
         +KeA6uLk3Ijw3wrkfVene0av6oEmB1/oetGEwA+fvidqQsX01SPqqzVCgbPJUA51WAGY
         ouy8is6UqzauCF2BI9IiHTuPK71RTGAV8iXDNmT1pdqfjiYLQa98mFmvCNBAPYsQ1uxz
         eRDsk539HKh7GNYFkGf8b66VCeCcTnZfDHKcgcbGQVN43mJ5AN+HdlANmhR8B5kaAPVl
         6QgA==
X-Gm-Message-State: AOAM531yzHl1qv/lREVqRvoQBHWbUK1a/zvHgqH98yboNC3sc0tFi47N
        EKRxaekDZ7CtH9u17KX5ND9jTHulG6j38n7ilwzK8Q==
X-Google-Smtp-Source: ABdhPJy/hI4Ht9IcKgP9E0y1PkP86xyD/hl/gG/Z/oqdlJ/mXFapXe/6vf2wDgq927qTtpy1Fqw3xgzF4N7t63KV+cc=
X-Received: by 2002:ac8:6f11:: with SMTP id g17mr70081qtv.343.1623770016398;
 Tue, 15 Jun 2021 08:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210613183520.2247415-1-mw@semihalf.com> <20210613183520.2247415-2-mw@semihalf.com>
 <YMZaZx3oZ7tYCEPH@lunn.ch>
In-Reply-To: <YMZaZx3oZ7tYCEPH@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 15 Jun 2021 17:13:24 +0200
Message-ID: <CAPv3WKefzp=F8UtWNYP+DNiyuBA9X0TzyONUuRVeMT8xKRbGEg@mail.gmail.com>
Subject: Re: [net-next: PATCH 1/3] net: mvmdio: add ACPI support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

niedz., 13 cze 2021 o 21:20 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > -     ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
> > +     if (pdev->dev.of_node)
> > +             ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
> > +     else if (is_acpi_node(pdev->dev.fwnode))
> > +             ret =3D acpi_mdiobus_register(bus, pdev->dev.fwnode);
> > +     else
> > +             ret =3D -EINVAL;
>
>
> This seems like something which could be put into fwnode_mdio.c.
>

Agree - I'll create a simple fwnode_mdiobus_register() helper there.

Best regards,
Marcin
