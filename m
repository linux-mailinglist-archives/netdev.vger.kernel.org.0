Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C63921A3
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 22:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbhEZUuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 16:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhEZUuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 16:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A903613CD;
        Wed, 26 May 2021 20:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622062148;
        bh=ejFNmjSi9ibYACMAzim4cZPpwocEEDkRp46nEKBos9M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YINTXAjU/mmdIfkzoy+KOH8EC0vB1pYbQ6MNTIJZP73CJOyEjZciVcsPbZ/U7hi9a
         TN284dLhFq0EdUkWW5AjJa8pskS/ADRLXqL5upvQbVB6H050+L2yccJwhmI4RCd7yP
         LFgbrMKY8YLMH3ejfp6aseKajcMxWkDbVgvliXekjWfuMUgABZIiPDhwiMt0Uf5n7e
         GOdNvfn2aeLn7zfaHc5/GN7PFcqLaSm5adkyHQLsKfq78KBhovB6G3pQ6gAsQiIBQS
         RElqdpbpLlbCioPVku+DpeB6n+uY4FHs0L1e+TjHckeIs9LlGt6V1z0IhACshH2aEZ
         x2eq8Xv8RqWdw==
Received: by mail-ej1-f43.google.com with SMTP id lg14so4554494ejb.9;
        Wed, 26 May 2021 13:49:08 -0700 (PDT)
X-Gm-Message-State: AOAM533El6ikzfb95WGtW0BvpH71mW7IsvXNzT+fb4bCDPWk/sR8dj7V
        L6CzJpr6TdNz3hxZnnE/ONZ85z6cQxC8aFXFTA==
X-Google-Smtp-Source: ABdhPJyVW5S9lIV0HGy+AT6y9ZzoBvbFJyJOKAzPU5/iGZr61pJqhizywvEM2Yn9hO/iBlG12ZAA+GOP608uDZTocsY=
X-Received: by 2002:a17:907:724b:: with SMTP id ds11mr201691ejc.108.1622062147010;
 Wed, 26 May 2021 13:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210526181411.2888516-1-robh@kernel.org> <YK6YljEYXprM/8iD@lunn.ch>
In-Reply-To: <YK6YljEYXprM/8iD@lunn.ch>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 26 May 2021 15:48:54 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKGZaCF-g6sAkpGoyFXSTd_Yue4_3=iFGamoOTdQ2=W_g@mail.gmail.com>
Message-ID: <CAL_JsqKGZaCF-g6sAkpGoyFXSTd_Yue4_3=iFGamoOTdQ2=W_g@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: Convert MDIO mux bindings to DT schema
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM BCM7XXX ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 1:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, May 26, 2021 at 01:14:11PM -0500, Rob Herring wrote:
> > Convert the common MDIO mux bindings to DT schema.
> >
> > Drop the example from mdio-mux.yaml as mdio-mux-gpio.yaml has the same one.
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Ray Jui <rjui@broadcom.com>
> > Cc: Scott Branden <sbranden@broadcom.com>
> > Cc: bcm-kernel-feedback-list@broadcom.com
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Heiner Kallweit <hkallweit1@gmail.com>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Rob Herring <robh@kernel.org>
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> > +        mdio@2 {  // Slot 2 XAUI (FM1)
> > +            reg = <2>;
> > +            #address-cells = <1>;
> > +            #size-cells = <0>;
> > +
> > +            ethernet-phy@4 {
> > +                compatible = "ethernet-phy-ieee802.3-c45";
> > +                reg = <0>;
>
> reg should really be 4 here. The same error existed in the .txt

Will fixup.

> version. I guess the examples are never actually verified using the
> yaml?

They are verified in general, but for this specific check it is dtc
that does it and only for bus types that it knows about. MDIO isn't
one of them.

Rob
