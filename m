Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3543B22B2
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhFWVrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWVrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:47:32 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1546C061756
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:45:14 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id e3so3348970qte.0
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eO/gYbfA6Dk3fvPEfq//UAVbrBE1Hl+b3nbIln7zxCo=;
        b=IWYpWrmxb6b5oYYzL2CGARVvY1cJdnFmp0pf3q3Bz5VW+Yv5HFpsH4M9Bq+Nw/sjHK
         2L0nDVw45GcJe7nQTlZ28k/miOGGntJR8W5J4Voi7MO1jrBUJgB5Ea0Esw50VWRmm45Y
         38AF8mhKCT8oJimpI7VLn2vlR+sGga5+4DD9qedz7Z2rFAxEOHAA6DcEET+mez1x3J6+
         GOvlJYnOt+dfs+bJsq/MHUwUv+NMt525B239rkOXryVQEIrngwee2HEu7obvBb4/uncB
         6O+ax7RxC2XTTn3FxGkC3LYkt9ImH0/OqEC7GesBlxBxvHieu9Z9J226aKdj5hGBSXcE
         O9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eO/gYbfA6Dk3fvPEfq//UAVbrBE1Hl+b3nbIln7zxCo=;
        b=HMZlveGuO7QqYwpJkKr7Z2G9qAiqrrIRIUw+W/l/MHN6iMksNXxqg6LHnnYgTy9qeb
         f5SnF9lLEwim+mOChXyzs0PB5pECuG7mUcVKAVQ7EGdPvVbS9IISeYIiCq3O3KYkDNWD
         2vjfcDcbzKqZzJsk9vO3MYstAMeATOz3z/6iDWe0cqS31IpdWd1UsbpTTklcek7gcUC/
         zuB8Wo3oNvsUMHB+BwgyQ15/pnCZlGwXaGxo+zcDHldNEmA8CyghPfIpXi2ZGdHiWNWl
         6BnAXws3ExsPOYr/5j39tfd4qhBk/1Wiwnf51I3G6XWry58PsgetqMlTspgg06gWJ19q
         w4KQ==
X-Gm-Message-State: AOAM530X/5/aHdZtgQwPfcUapqF83cqYi3IHhpiW7GegPSCuJuSt4ISL
        GNFCyZWG9gHNi4DOeUaXrl4KkKZlrv1UM0+SXu0jM7k/tK8=
X-Google-Smtp-Source: ABdhPJw3GtJtGKNZUWMs5ocfXyKukzULEu9ZrESDoOs8YOI4F1k7sQ982AKQG9jIeOCBC6M9JqVFAyAKPrwT60U/sRM=
X-Received: by 2002:aed:2064:: with SMTP id 91mr1931402qta.318.1624484713483;
 Wed, 23 Jun 2021 14:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210621173028.3541424-1-mw@semihalf.com> <20210621173028.3541424-6-mw@semihalf.com>
 <YNObfrJN0Qk5RO+x@lunn.ch>
In-Reply-To: <YNObfrJN0Qk5RO+x@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 23 Jun 2021 23:45:04 +0200
Message-ID: <CAPv3WKfdCwq=AYhARGxfRA92XcZjXYwdOj6_JLP+wOmPV8xxzQ@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 5/6] net: mvpp2: enable using phylink with ACPI
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

Hi,

=C5=9Br., 23 cze 2021 o 22:37 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > +static bool mvpp2_use_acpi_compat_mode(struct fwnode_handle *port_fwno=
de)
> > +{
> > +     if (!is_acpi_node(port_fwnode))
> > +             return false;
> > +
> > +     return (!fwnode_property_present(port_fwnode, "phy-handle") &&
> > +             !fwnode_property_present(port_fwnode, "managed") &&
> > +             !fwnode_get_named_child_node(port_fwnode, "fixed-link"));
>
> I'm not too sure about this last one. You only use fixed-link when
> connecting to an Ethernet switch. I doubt anybody will try ACPI and a
> switch. It has been agreed, ACPI is for simple hardware, and you need
> to use DT for advanced hardware configurations.
>
> What is your use case for fixed-link?
>

Regardless of the "simple hardware" definition or whether DSA + ACPI
feasibility, you can still have e.g. the switch left in "unmanaged"
mode (or whatever the firmware configures), connected via fixed-link
to the MAC. The same effect as booting with DT, but not loading the
DSA/switch driver - the "CPU port" can be used as a normal netdev
interface.

I'd also prefer to have all 3 major interface types supported in
phylink, explicitly checked in the driver - it has not been supported
yet, but can be in the future, so let's have them covered in the
backward compatibility check.

Best regards,
Marcin
