Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA94E210940
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 12:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgGAK17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 06:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729683AbgGAK16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 06:27:58 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E93C061755;
        Wed,  1 Jul 2020 03:27:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 207so10628659pfu.3;
        Wed, 01 Jul 2020 03:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m3FZxDrlLt48LmtqU4CU5m/XuCUHORmhZRpZzXJKt1c=;
        b=F640izKjqUNFfwPYQodt/bdItFy5xb3UYVBMO+wQyVBhRzFY6FTSR1/wjdawZlsdOF
         uwqSjtvxrvZQrjISy88NsGRrFSAqF8r8qk1D6Cx047QUUxU8AaUF+5EoW/ZodwfNH0Rv
         oaEcs7F9b6LEGPC21F8PatjRXvNVrIA/OFywxfuoPllg/wPGWh1egNkfLVPm9bJgg5Hm
         YrWNoTef2d7X2RP/jUrdO63vYRJKwkIvTc1W3V8ycuiz8ypXojiDluMEGuT6vS6IPQN3
         WyIgwQAvou/CIvRiN/y02zqPY8YN3ppcL9XAfdC0vS4MnfW48JAM2XSSnDM5Lu2mqbzl
         hB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m3FZxDrlLt48LmtqU4CU5m/XuCUHORmhZRpZzXJKt1c=;
        b=sZBY63nJJGos73vBJ+R0saH9pK7kfGU+6rdftdlj4GPtY+GBcMik6FcBcW7RWpDOLN
         4ohd/Y07Zq5Q09JLTDjQGptXkqwHw4b7IoZxJU8PWEWGUe8HQgV2Mg2lp4wis7+nBVUU
         FXzpnCRNye19HHlPRw0MBUtWyGN/nB8/WhLSl2A2WGoF5JgYId/g5ZsiFhGPhSEI9Pp6
         DhXydhObcPXTB1ZjC/p8ajwF6RJCKIheumyR3JhbPpp+707pyaZqFkZkYESLy5c0JqW/
         dGSiLqLeU3zHR9shYlMxj5Tklo6FHGVXePdNT+OhMRMak51b4lmBAZm/2jtp3gnE2gy5
         m4nw==
X-Gm-Message-State: AOAM5332kfB440ygVNfRVpV6iJd47AacEz4QSR9QYnkhdVblA/RkJxn7
        lroQVCMUFnNxcdlcB1ThfeWS/os68SElypLC+IA=
X-Google-Smtp-Source: ABdhPJwEM2tn83JW4KiTR3vh672XMQ7bxMrQqVOpB9OU+4kR2m5bq4L4a4iK+7TUI0oFW8gFMQKq7VKddB3VE3QbFqA=
X-Received: by 2002:a63:a05f:: with SMTP id u31mr13499247pgn.4.1593599277215;
 Wed, 01 Jul 2020 03:27:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com> <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 1 Jul 2020 13:27:43 +0300
Message-ID: <CAHp75VfxpogiUhiwGDaj3wT5BN7U4s9coMd3Rw10zX=sxSn6Lg@mail.gmail.com>
Subject: Re: [net-next PATCH v2 2/3] Documentation: ACPI: DSD: Document MDIO PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 9:13 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
>
> An ACPI node property "mdio-handle" is introduced to reference the
> MDIO bus on which PHYs are registered with autoprobing method used
> by mdiobus_register().

...

> +                    Package (2) {"mdio-handle", Package (){\_SB.MDI0}}

Reference as a package? Hmm... Is it really possible to have more than
one handle here?

...

> +                   Package (2) {"phy-channel", 2},
> +                   Package (2) {"phy-mode", "rgmii-id"},
> +                   Package (2) {"mdio-handle", Package (){\_SB.MDI0}}

And drop all these 2s. They are counted automatically by `iasl`.

-- 
With Best Regards,
Andy Shevchenko
