Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F2A3F5D55
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhHXLxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhHXLxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF9C6128A;
        Tue, 24 Aug 2021 11:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629805939;
        bh=O1ixU2ieIhwaFgCZmeCH2BZ+CyopQlNCl/awFjtVHh8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t9hr8TQoCJOSpNRpgJP/tYu+ZI6gtSXvyqLNkJHo5SPswX5KIKQkGA/PlQQXHgAPN
         6rPKtjJZGJb2SIh2saGr1H5vP4CX7IT///a+PH/oAFoaQN3SdviyOOMHozx24OOGxb
         6v35eeV0ydf0JGFhEX01Ss3ypIXJjp//CIUjYeSzR0n20iDtt6q2OLPgJ5zABtCcMZ
         e0KE+R1pniubnwvw5dbYPwMlvPQq0It9sLcAWn0+A462Kob68mO+XN2+rmEDAr0aH2
         gv6bZg7/vTnaJBSLgrarmVw1zNMiE4VY7ZC+D4evUoEqMmCkplHEwYtNKrOhn6wFoN
         FtKwn5MdIfiSQ==
Received: by mail-ej1-f48.google.com with SMTP id u3so43829734ejz.1;
        Tue, 24 Aug 2021 04:52:19 -0700 (PDT)
X-Gm-Message-State: AOAM533p11vzrZIqmzh3gqrFBgdkTT0NYjQ+ptuFVebThzwGhQbuhU6f
        6rGmHLuo/9MlVmacc8yw1bwENqnI0IhIrBugnw==
X-Google-Smtp-Source: ABdhPJxFjBECFa74niCFa1H+pxp2iB1O2hLOjmxYyU/UW1TxNB1QOPcrS0GS5+3AZT1dnONH/hA/Jt7T0hwx8JGN0Mo=
X-Received: by 2002:a17:906:ff41:: with SMTP id zo1mr10121788ejb.525.1629805937919;
 Tue, 24 Aug 2021 04:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210820074726.2860425-1-joel@jms.id.au> <20210820074726.2860425-2-joel@jms.id.au>
 <YSPseMd1nDHnF/Db@robh.at.kernel.org> <CACPK8XcU+i6hQeTWpYmt=w7A=1EzwgYcMucz7y6oLxwTFTJsiQ@mail.gmail.com>
In-Reply-To: <CACPK8XcU+i6hQeTWpYmt=w7A=1EzwgYcMucz7y6oLxwTFTJsiQ@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 24 Aug 2021 06:52:06 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+q6o88_6910brD4wEWBTi068jGDmaD8pucEFrT5FcWMw@mail.gmail.com>
Message-ID: <CAL_Jsq+q6o88_6910brD4wEWBTi068jGDmaD8pucEFrT5FcWMw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add bindings for LiteETH
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 10:52 PM Joel Stanley <joel@jms.id.au> wrote:
>
> On Mon, 23 Aug 2021 at 18:44, Rob Herring <robh@kernel.org> wrote:
> >
> > On Fri, Aug 20, 2021 at 05:17:25PM +0930, Joel Stanley wrote:
>
> > > +
> > > +  interrupts:
> > > +    maxItems: 1
> > > +
> >
> > > +  rx-fifo-depth: true
> > > +  tx-fifo-depth: true
> >
> > Needs a vendor prefix, type, description and constraints.
>
> These are the standard properties from the ethernet-controller.yaml. I
> switched the driver to using those once I discovered they existed (v1
> defined these in terms of slots, whereas the ethernet-controller
> bindings use bytes).

Indeed (grepping the wrong repo didn't work too well :) ).

Still, I'd assume there's some valid range for this h/w you can
define? Or 0 - 2^32 is valid?

Rob
