Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CCC46674A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359250AbhLBP5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347568AbhLBP5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:57:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AD2C06174A;
        Thu,  2 Dec 2021 07:53:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9564762666;
        Thu,  2 Dec 2021 15:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE27CC00446;
        Thu,  2 Dec 2021 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638460435;
        bh=p9hg5KiYEIKDgkuhP8bMh5fQC9zCuDcZvD38zcEt4Qs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qgJ/QDh4OPh/hMUjUVPVOIbzcKzIL1J6XVNujvVQOm4Bdr525kZ36hSaJi8zuAENh
         jMtx+6k6hwowemst2PjPOdCCKMETjkiSCX9IVub+i64T5ztdQdrbExOVJXLEhcuvz9
         nPa7l//wTk9SSJVy0QUfnNqCHp6htDLUuLeELiCrpMbdAXNFlm6kPx3J3dG8fYgpJv
         sWoxDdIBYxWZ5ehAR5NEGkK2fDLTjOsRSxETrg+q8obKsPljpy4jGjHSjfOW1Osu0A
         modG8/GSbiEBsnPidmxYJLMt6twdZZjjra1RrmlSxrJVxGlQkgU76U1LVFRhUauOC4
         5OAzvXTDQdqnQ==
Received: by mail-ed1-f47.google.com with SMTP id y13so117893128edd.13;
        Thu, 02 Dec 2021 07:53:54 -0800 (PST)
X-Gm-Message-State: AOAM533hz6GXyzX8O6j/exUF3rBKVC28ECd88lzDX1J3P5ZK/XG7tZHB
        3f6zl6dVq6SNbOuPtpK+7dzq8nMoQAZZJ3TLcg==
X-Google-Smtp-Source: ABdhPJwROJ4+lSwyI3qjOChmDMbVmrc95Ha+N5fwobg4BPs5x0NI009WfnFBvuItnpPvBAM40zWIJb2e+KbZ07m2c5E=
X-Received: by 2002:a05:6402:4394:: with SMTP id o20mr18414066edc.342.1638460424728;
 Thu, 02 Dec 2021 07:53:44 -0800 (PST)
MIME-Version: 1.0
References: <104dcbfd22f95fc77de9fe15e8abd83869603ea5.1637927673.git.geert@linux-m68k.org>
 <YagEai+VPAnjAq4X@robh.at.kernel.org> <CAMuHMdW5Ng9225a6XK0VKd0kj=m8a1xr_oKeazQYxdpvn4Db=g@mail.gmail.com>
In-Reply-To: <CAMuHMdW5Ng9225a6XK0VKd0kj=m8a1xr_oKeazQYxdpvn4Db=g@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 2 Dec 2021 09:53:30 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJHkL_Asqd5WPc7rfqXkbz1dpYfR0zxp5erVCyLiHaJNQ@mail.gmail.com>
Message-ID: <CAL_JsqJHkL_Asqd5WPc7rfqXkbz1dpYfR0zxp5erVCyLiHaJNQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: cdns,macb: Convert to json-schema
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 4:10 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Rob,
>
> CC Michal
>
> On Thu, Dec 2, 2021 at 12:25 AM Rob Herring <robh@kernel.org> wrote:
> > On Fri, Nov 26, 2021 at 12:57:00PM +0100, Geert Uytterhoeven wrote:
> > > Convert the Cadence MACB/GEM Ethernet controller Device Tree binding
> > > documentation to json-schema.
> > >
> > > Re-add "cdns,gem" (removed in commit a217d8711da5c87f ("dt-bindings:
> > > Remove PicoXcell bindings")) as there are active users on non-PicoXcell
> > > platforms.
> > > Add missing "ether_clk" clock.
> > > Add missing properties.
> > >
> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
>
> > > +  '#stream-id-cells':
> > > +    const: 1
> >
> > I can't figure out why you have this here. I'll drop it while applying.
>
> See arch/arm64/boot/dts/xilinx/zynqmp.dtsi and
> drivers/iommu/arm/arm-smmu/arm-smmu.c.
>
> It wasn't clear to me if this is still needed, or legacy. Michal?

They should update to the iommu binding instead of the legacy smmu
one. It's been around for years now.

Rob
