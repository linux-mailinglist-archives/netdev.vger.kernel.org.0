Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEDE40CB90
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhIORUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhIORUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:20:42 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFADC061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:19:23 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id k65so7109382yba.13
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fcARgMDO3sHmRKPtN7f2pmzPFunzoTl53IPz4NJSUaI=;
        b=dKM6iCxT5AAQBmagGlPrp9ttSolaaBPV0lgwA6vmAQjNnNbzqaa3H3COonvJb/XbWm
         2ihe9WBo5GOxOTwRZ+OgyvsAdLwtyZ4SBFC09Uqhjs2cM/B0SpCWhmoU0dfxd1S7IjUs
         CZWLXk+kkWjvkYkMK5CUcd5JAkYdpAyjR1QTWhQ8GNNAk2vvJioOhWoDvUesjf/8GbNO
         Z3eJSYo0cUs/NYdX1pUhkNHeHaY+ogdvGGDQzaWc7gScKuUJ7fcfOqms8y24HmFlDCRT
         XmswJP69F3LoGSvqLSbvmJm0Hwxf7yt+WhMeBbCgFy2kx2NX8vasm/fiKScjoNRqFkRs
         njDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fcARgMDO3sHmRKPtN7f2pmzPFunzoTl53IPz4NJSUaI=;
        b=TpajrfbLBiotAkkVSrP7TTuMQnr5a1807qPkaB7UQpbzuwR9pmTaYgAiFP7Y0M2zrG
         LsG18DGAs3TISXpbDAXr4QluAZEYIKZV79QkNNVenDb/OMuZglO8bxqloovGRCijBMSX
         DgmRDSdAcscwwSZOCngnMluCvANjK1LDuJX0MjT0Z0tMnhinvFk+qR9UTJS07SqB3WoI
         Cx54sGfNTjAXNIHsKac9UczGZOur9DKohRdwTxecRX1+VrLxCKXzS9eoIKwMhij9ZF7E
         vD8bPm9DWcLpjCI0OmaWhnI+HiRkW8Kp/gKT8rKcjVmEZWkrGLvmM3lloWFYNEw12WaB
         1fYA==
X-Gm-Message-State: AOAM532CQkwMOCwINKJ6kbyc4kgjVmbjuseT4W5Nty4G5nhyTo5A+tiq
        rf023aCk52eOb0X1h+x5/S0LbwzUJxeb75FhqYsXkg==
X-Google-Smtp-Source: ABdhPJyO2jRMPKX2+rlE4hInFo5Tt738OyUO7N0J4cYlu9nL/Yd0y23SxmKlAUGsgPZIE8l2eCiodmmbiAd9PAEkuOk=
X-Received: by 2002:a25:b94:: with SMTP id 142mr1334731ybl.508.1631726362131;
 Wed, 15 Sep 2021 10:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210915081139.480263-1-saravanak@google.com> <YUHjvKRX76Jf7Bt5@lunn.ch>
In-Reply-To: <YUHjvKRX76Jf7Bt5@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 15 Sep 2021 10:18:46 -0700
Message-ID: <CAGETcx8s9iKJnw=LP_p6rtB+Lx7orkKF5hicGWPGc+bL8kpk=g@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] fw_devlink improvements
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 5:14 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Sep 15, 2021 at 01:11:32AM -0700, Saravana Kannan wrote:
> > Patches ready for picking up:
> > Patch 1 fixes a bug in fw_devlink.
> > Patch 2-4 are meant to make debugging easier
> > Patch 5 and 6 fix fw_devlink issues with PHYs and networking
> >
> > Andrew,
> >
> > I think Patch 5 and 6 should be picked up be Greg too. Let me know if
> > you disagree.
> >
> > -Saravana
>
> You are mixing fixes and development work. You should not do that,
> please keep them separate. They are heading in different
> directions. Fixed should get applied to -rc1, where as development
> work will be queued for the next merge window.

Done.
https://lore.kernel.org/lkml/20210915170940.617415-1-saravanak@google.com/

-Saravana


-Saravana

>
> You are also missing Fixes: tags for the two MDIO patches. Stable
> needs them to know how far back to port the fixes.
>
>       Andrew
