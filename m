Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD0260A15
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfGEQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfGEQSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 12:18:38 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4126E2184C;
        Fri,  5 Jul 2019 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562343517;
        bh=xOIxjFWCdUg/QzY8jG0dDlcgVuLYcga80F9ng4zPuEg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mpk95tMyeX3X8mpTvJZl5RsUhro+ETsedPjYB5FQTddm4Kk02kmq0VXPkqdXkLbvg
         9/N+FBi49A6ursraCd/dYOZ0FuGjkSpbmgC89nsnbbUeHSqTvhoDNiZW1plpWEsp6r
         6je9Pjtbh9WxWJWyn8gnKCO8aFOrQ7vEw3kL9PHY=
Received: by mail-qt1-f170.google.com with SMTP id n11so11654694qtl.5;
        Fri, 05 Jul 2019 09:18:37 -0700 (PDT)
X-Gm-Message-State: APjAAAVZDq1pFm7J1hUla1yVUtfgOZb2TaJRuGZU16zFafT0djZvfSDS
        N8Dzc6i0b1sZ30Qpbgqp1eePoNZSwzatmLZuOQ==
X-Google-Smtp-Source: APXvYqyWwInsxP4rlueEvxGtABj1VCNUmJtsFiyNODQo5Xnzl9iA0U3kWhRBsi53C+LnojS0tqFPRhJQeLwLngb63Nw=
X-Received: by 2002:aed:3fb0:: with SMTP id s45mr3505782qth.136.1562343516543;
 Fri, 05 Jul 2019 09:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190703193724.246854-1-mka@chromium.org> <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
 <20190703213327.GH18473@lunn.ch> <20190703220843.GJ250418@google.com>
In-Reply-To: <20190703220843.GJ250418@google.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 5 Jul 2019 10:18:24 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+9RhjxwX9Z6U269u2Mki__P0GMiZo9HsqpMFKtdveNZw@mail.gmail.com>
Message-ID: <CAL_Jsq+9RhjxwX9Z6U269u2Mki__P0GMiZo9HsqpMFKtdveNZw@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 4:08 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> On Wed, Jul 03, 2019 at 11:33:27PM +0200, Andrew Lunn wrote:
> > > I think if we're going to have custom properties for phys, we should
> > > have a compatible string to at least validate whether the custom
> > > properties are even valid for the node.
> >
> > Hi Rob
> >
> > What happens with other enumerable busses where a compatible string is
> > not used?
> >
> > The Ethernet PHY subsystem will ignore the compatible string and load
> > the driver which fits the enumeration data. Using the compatible
> > string only to get the right YAML validator seems wrong. I would
> > prefer adding some other property with a clear name indicates its is
> > selecting the validator, and has nothing to do with loading the
> > correct driver. And it can then be used as well for USB and PCI
> > devices etc.
>
> I also have doubts whether a compatible string is the right answer
> here. It's not needed/used by the subsystem, but would it be a
> required property because it's needed for validation?

It could be required only for phy's with vendor specific properties.
