Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF353A3322
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhFJSeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:34:01 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:45782 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhFJSeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:34:00 -0400
Received: by mail-ot1-f48.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso603787oto.12;
        Thu, 10 Jun 2021 11:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UHeRo+PeTe+UX0jKZ5h3WsZ6XhyTgBwX+84SB07u34=;
        b=BukyVmaVIJx+UrX1FX2BCe56Tb/d+V0wd/tMBIAzMNwQnRZwkMvwY37M754PccC/d9
         sG68z0dGdYWBA4isCN+VOxCVKA/v+zRJLSRDH852iZyjZmyGbw824Wc4fvt9iKqDbL0T
         tv+Z3EnoKigOW2Cpx1LbA4HkPOhXfPlqzAU+m+8j1Tm+38+S67f+CauTEs7s43VvJfzS
         3xGrvB+vSQCq5sWdZFRrv4mhLl9gIojZbBxUxPFr3SD4uXbJr+ytLobrzCnN46eFw8+1
         3h5pBcc/n3Zd1qXNVhK5OeWTw6xzDcZCkbjNbqOTyj8IJgBAF+Nfl75/EiYG8qRYJR7e
         ViQQ==
X-Gm-Message-State: AOAM530/bXfrYHDAbOAAdk/EE78ID1aGgq3ALofrtaICf+49DNZV+tYH
        lthfvwZ88TDv68o7qlYipsQzuZQOd3DeVReKr2E=
X-Google-Smtp-Source: ABdhPJxhecC2IikQgyLki26FFDVelXz6iZP1RA1+NieCihmrWAWrD7QsiGQY3niB2yTYbQjlmdZCJ+ovTB9ATLNK2dM=
X-Received: by 2002:a05:6830:1bf7:: with SMTP id k23mr3646464otb.206.1623349910111;
 Thu, 10 Jun 2021 11:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
 <20210610163917.4138412-2-ciorneiioana@gmail.com> <CAJZ5v0jMspgw8tvA3xV5p7sRxTUOq89G5zSgaZa52EAi+9Cfbw@mail.gmail.com>
 <070d33be-8056-d54c-05c1-a13432b3167e@arm.com>
In-Reply-To: <070d33be-8056-d54c-05c1-a13432b3167e@arm.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Jun 2021 20:31:38 +0200
Message-ID: <CAJZ5v0g-NNJv=NBHxuUi6C0eJwOaZeU1nswEAuEaLciVD9wmFg@mail.gmail.com>
Subject: Re: [PATCH net-next v8 01/15] Documentation: ACPI: DSD: Document MDIO PHY
To:     Grant Likely <grant.likely@arm.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "nd@arm.com" <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 8:23 PM Grant Likely <grant.likely@arm.com> wrote:
>
> On 10/06/2021 19:05, Rafael J. Wysocki wrote:
> > On Thu, Jun 10, 2021 at 6:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
> >>
> >> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> >>
> >> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> >> provide them to be connected to MAC.
> >
> > This is not an "ACPI mechanism", because it is not part of the ACPI
> > specification or support documentation thereof.
> >
> > I would call it "a mechanism based on generic ACPI _DSD device
> > properties definition []1]".  And provide a reference to the _DSD
> > properties definition document.
> >
> > With that changed, you can add
> >
> > Acked-by: Rafael J. Wysocki <rafael@kernel.org>
> >
> > to this patch.
> >
> > Note, however, that within the traditional ACPI framework, the _DSD
> > properties are consumed by the driver that binds to the device
> > represented by the ACPI device object containing the _DSD in question
> > in its scope, while in this case IIUC the properties are expected to
> > be consumed by the general networking code in the kernel.  That is not
> > wrong in principle, but it means that operating systems other than
> > Linux are not likely to be using them.
> >
>
> Doesn't this land at the level of device drivers though? None of this
> data needs to be consumed by the OS generic ACPI parsing code, but the
> network device driver can use it to parse the MDIO and MAC configuraiton
> and set itself up appropriately.

That's right in general, which is why I said that doing it this way
wasn't wrong.
