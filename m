Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06D3A3E7C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhFKJD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:03:28 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:43710 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhFKJD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:03:27 -0400
Received: by mail-pl1-f173.google.com with SMTP id v12so2504224plo.10;
        Fri, 11 Jun 2021 02:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIlvnpCPbICwDJ4Vl00FPiAYRz1ggW2QfBtE3qOeQVk=;
        b=TCKGtdywZsQ0mUdoNA1VIXMy1S4UFr0Ur7QxJ8scHxxHbnqqyS3zEccbMsxmjBTYF1
         m5rPzJFtJuk4Y8f048RqUFJ2pXMI/EOQ8zAqiQ6Akh1+HrXreQP6fO83PnO7auH/J72A
         W9ugS5yt3wF/4/3yY6ZpFl/Se6GdI4MXMq9oM4+Pjfc7iEajS3aeMqnsYPrH012T1JmA
         O+kcBd9nMucev4zJwCRO6GxNVUibopNwpiTs7VsqPHd2aRj2/7kn8fqR527gbCQbT8K4
         x+8+w37HZ7gyaUzd1KRNEj7YiE8h5f7EgBK85+PltyFgMEZ+ObAF07llCg276oaM2umZ
         qeiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIlvnpCPbICwDJ4Vl00FPiAYRz1ggW2QfBtE3qOeQVk=;
        b=N95S2MhLkYQru+a5U6vwPC1YeDyPoKNlqjNF2zhF+vM2xGWrlMFOEhVSF3S9R+Unv2
         jX4+o+iGJBH+ZfASXlMG8LjCeu5kSmApjpqKbHe4OtWuwtmejYVx4xQGAobJQxXgqiZe
         ts888de+dRgbilLs2AeaRSxsxR8FkBLWinjpDC9UekyDEu5qJrW2GYQXMjcXPByytZPK
         J3VagULo+TXAvvSsj2nj6P6dTCIZgGf5UNe00JBFXRQJaUr8thBbR2eZeQss1J0Vo/8G
         MpAkwkqK4ztQW1fBHyXSKlVrlWuSCbhD7dJ4x6e6Fv77zrnU3JPa2F3SXRf7HcvFx+wO
         epLA==
X-Gm-Message-State: AOAM533U9RxSKoXtE/fKayTaoVExowa01hy5esHOutMxFY6Su/IwHSWU
        TiEbToZxVAO6T3BHGGN9/pA9KDnKvEkYUGC4pSQ=
X-Google-Smtp-Source: ABdhPJzWieTjQAnrXBUrCrA/glfRXSe+6PTqF2ceabrTCs2gWSFNY6hUn/WuRybe32pJBCyFKUReYtmPNT/trGAAtQE=
X-Received: by 2002:a17:90b:818:: with SMTP id bk24mr3566082pjb.228.1623402018625;
 Fri, 11 Jun 2021 02:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Jun 2021 12:00:02 +0300
Message-ID: <CAHp75VfeyWYKRYuufd8CkCwjCWPRssuQVNfCSknnJWB9HvUcMA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 00/15] ACPI support for dpaa2 driver
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 7:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>
> This patch set provides ACPI support to DPAA2 network drivers.
>
> It also introduces new fwnode based APIs to support phylink and phy
> layers
>     Following functions are defined:
>       phylink_fwnode_phy_connect()
>       fwnode_mdiobus_register_phy()
>       fwnode_get_phy_id()
>       fwnode_phy_find_device()
>       device_phy_find_device()
>       fwnode_get_phy_node()
>       fwnode_mdio_find_device()
>       acpi_get_local_address()
>
>     First one helps in connecting phy to phylink instance.
>     Next three helps in getting phy_id and registering phy to mdiobus
>     Next two help in finding a phy on a mdiobus.
>     Next one helps in getting phy_node from a fwnode.
>     Last one is used to get local address from _ADR object.
>
>     Corresponding OF functions are refactored.

In general it looks fine to me. What really worries me is the calls like

of_foo -> fwnode_bar -> of_baz.

As I have commented in one patch the idea of fwnode APIs is to have a
common ground for all resource providers. So, at the end it shouldn't
be a chain of calls like above mentioned. Either fix the name (so, the
first one will be in fwnode or device namespace) or fix the API that
it will be fwnode/device API.

-- 
With Best Regards,
Andy Shevchenko
