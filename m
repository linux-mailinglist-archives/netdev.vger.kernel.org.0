Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C20D46C0B9
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbhLGQdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhLGQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:33:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4897C061746;
        Tue,  7 Dec 2021 08:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E9FBB81CF5;
        Tue,  7 Dec 2021 16:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBCEC341C8;
        Tue,  7 Dec 2021 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638894574;
        bh=EhrcWI9mWDI5wSadeNb9DYuTlUXsfjqAGucxFodehUM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sQiCDWKiLCt0NYliDY3ZjcINoLTG/4QT0oVjoabAyZ+yDpwc0LjgCzZ+QYjIKNofo
         W8U0FzINZwNMBUYC+/3guo1B+Q1s97eIGgwBYFh35WC4I09oNJa+al4875PoPPdm/A
         nsuuPnN+W+AGfVRzlWZSi/l8DyHgMLVpiyLG3Sokl+kaABQq8T9rjWSHn+l4OyYx+U
         yQsERvQsP4mMZ592gPkb+am1UBSEm4PZdHlO7978P2Iy6rbSzaTCFnGQwkxJJ0oIk3
         OZLU+MXeRKy4684n4eCl6Bw9FkJCY9yVpYKf57y1YBEShZrkVBoBPHcoDaOySDvz6b
         trvI76qcWbeZQ==
Received: by mail-ed1-f47.google.com with SMTP id g14so58582781edb.8;
        Tue, 07 Dec 2021 08:29:34 -0800 (PST)
X-Gm-Message-State: AOAM532f2W9ZreoQH9VcOnFC/ifB5eVRJCe17HoxaICUtglcqoNo6f8m
        mX43EIyA+RbtmUWESsQQE92lFP4/0AtpMTzo/w==
X-Google-Smtp-Source: ABdhPJz98fbAnvVe1AhaSmP08wxHXrR8BpSqIXazh8lXQCVGqRo0DowpOQD1f/F8ykH7vGksg5xQxq1VgImntCBby0Y=
X-Received: by 2002:a05:6402:84f:: with SMTP id b15mr5840714edz.342.1638894573258;
 Tue, 07 Dec 2021 08:29:33 -0800 (PST)
MIME-Version: 1.0
References: <20211206174153.2296977-1-robh@kernel.org> <Ya8cZ69WGfeh0G4I@orome.fritz.box>
In-Reply-To: <Ya8cZ69WGfeh0G4I@orome.fritz.box>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 7 Dec 2021 10:29:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLmeLKeORpPtUFAZc9Uy7uFc0DnVQuczkkEvDq8CyQN1w@mail.gmail.com>
Message-ID: <CAL_JsqLmeLKeORpPtUFAZc9Uy7uFc0DnVQuczkkEvDq8CyQN1w@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: Add missing properties used in examples
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 2:33 AM Thierry Reding <thierry.reding@gmail.com> wr=
ote:
>
> On Mon, Dec 06, 2021 at 11:41:52AM -0600, Rob Herring wrote:
> > With 'unevaluatedProperties' support implemented, the following warning=
s
> > are generated in the net bindings:
> >
> > Documentation/devicetree/bindings/net/actions,owl-emac.example.dt.yaml:=
 ethernet@b0310000: Unevaluated properties are not allowed ('mdio' was unex=
pected)
> > Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dt.yaml:=
 ethernet@3a000000: Unevaluated properties are not allowed ('snps,pbl', 'md=
io0' were unexpected)
> > Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: ether=
net@19000000: Unevaluated properties are not allowed ('qca,ethcfg' was unex=
pected)
> > Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: ether=
net@1a000000: Unevaluated properties are not allowed ('mdio' was unexpected=
)
> > Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethe=
rnet@40028000: Unevaluated properties are not allowed ('reg-names', 'snps,p=
bl' were unexpected)
> > Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: m=
dio@1000: Unevaluated properties are not allowed ('clocks', 'clock-names' w=
ere unexpected)
> > Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.=
yaml: mdio@f00: Unevaluated properties are not allowed ('clocks', 'clock-na=
mes' were unexpected)
> >
> > Add the missing properties/nodes as necessary.
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: "Andreas F=C3=A4rber" <afaerber@suse.de>
> > Cc: Manivannan Sadhasivam <mani@kernel.org>
> > Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> > Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> > Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> > Cc: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
> > Cc: "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> > Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> > Cc: Christophe Roullier <christophe.roullier@foss.st.com>
> > Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-actions@lists.infradead.org
> > Cc: linux-stm32@st-md-mailman.stormreply.com
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../devicetree/bindings/net/actions,owl-emac.yaml          | 3 +++
> >  .../devicetree/bindings/net/intel,dwmac-plat.yaml          | 2 +-
> >  Documentation/devicetree/bindings/net/qca,ar71xx.yaml      | 5 ++++-
> >  Documentation/devicetree/bindings/net/stm32-dwmac.yaml     | 6 ++++++
> >  Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml | 7 +++++++
> >  .../devicetree/bindings/net/toshiba,visconti-dwmac.yaml    | 5 ++++-
> >  6 files changed, 25 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yam=
l b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
> > index 1626e0a821b0..e9c0d6360e74 100644
> > --- a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
> > +++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
> > @@ -51,6 +51,9 @@ properties:
> >      description:
> >        Phandle to the device containing custom config.
> >
> > +  mdio:
> > +    type: object
>
> In one of the conversions I've been working on, I've used this construct
> for the mdio node:
>
>         mdio:
>           $ref: mdio.yaml
>
> In the cases here this may not be necessary because we could also match
> on the compatible string, but for the example that I've been working on
> there is no compatible string for the MDIO bus, so that's not an option.

$nodename is also used to match if there's no compatible, so the above
is somewhat redundant (the schema will be applied twice). Matching on
the node name is useful where we don't have a specific schema in place
or if you want to validate DT files with just that schema, but that's
becoming less useful as we get schemas for everything.

Thinking about this some more, what we need for these is:

mdio:
  $ref: mdio.yaml
  unevaluatedProperties: false

Because mdio.yaml on its own is incomplete and allows for additional
properties. That ensures all the properties are documented and no
extra properties are present.

> On the other hand, it looks like the snps,dwmac-mdio that the examples
> here use don't end up including mdio.yaml, so no validation (or rather
> only very limited validation) will be performed on their properties and
> children.

There is more validation than you were thinking, but it also needs the
above added.

Rob
