Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6B433BE8
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJSQUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhJSQUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 274FA6113D;
        Tue, 19 Oct 2021 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634660303;
        bh=CSThRwfLLBbnWmpSAkjzo6ykAldK6QMiL9G46/Dm69w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nVlcNJMijXvUCkk4ZNOavUI5JqGD7uYB1LEujLRt6C24Y9Dp4GGcBQzIcpTEcUJ65
         tIl/13gwTNZtxSAGmErXo80daX/BWtXLbTa3PNUN1uxc6Ja7E+JDGpYXeffBf50wPg
         kzE9NUEhBmkIja6HvQtT8CEesZLNCZRmz7YFLMfrQcJefyplMnQMZpstSdel1NoPv8
         5C9rrybmpr1+vpm3CxebjEowX9gfHUxxGHwg1syJ7mZ2CerpR+sPADgvGuru3tTLqQ
         MGXAhGoeknfwRASCjuSqq5ImM2xpA+ylpNccmFZ/XU5FGNdZKmH8br7cHU2Go2HZLK
         R2eW43Ge42x1Q==
Received: by mail-ed1-f51.google.com with SMTP id i20so14731424edj.10;
        Tue, 19 Oct 2021 09:18:23 -0700 (PDT)
X-Gm-Message-State: AOAM533dLQZYmL+GnX1F1unmNbXkLQIxmzLkPhAxCSa0ATU6oPOFQhuS
        t+0X4QjQyxSzUoRxzVpk19y2G/bv9XYC3Vr3lQ==
X-Google-Smtp-Source: ABdhPJyECg/ex6JGhxYjfVAKj9ZTQDiYmMDq836QH65YEzFdOsqIbnkT+Rd0QJdZrzxam94/CGdjldneWAz1SLg2GHg=
X-Received: by 2002:aa7:c357:: with SMTP id j23mr57477452edr.145.1634660136617;
 Tue, 19 Oct 2021 09:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211013223921.4380-1-ansuelsmth@gmail.com> <20211013223921.4380-17-ansuelsmth@gmail.com>
 <YW2BcC2izFM6HjG5@robh.at.kernel.org> <YW2Cp6vWAYDM68rs@Ansuel-xps.localdomain>
In-Reply-To: <YW2Cp6vWAYDM68rs@Ansuel-xps.localdomain>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 19 Oct 2021 11:15:24 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJ7QAMRWQs4iuEmPpj2q2t0tCEGBNP+9QvTwZ=aeJn4vQ@mail.gmail.com>
Message-ID: <CAL_JsqJ7QAMRWQs4iuEmPpj2q2t0tCEGBNP+9QvTwZ=aeJn4vQ@mail.gmail.com>
Subject: Re: [net-next PATCH v7 16/16] dt-bindings: net: dsa: qca8k: convert
 to YAML schema
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Matthew Hagan <mnhagan88@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 9:22 AM Ansuel Smith <ansuelsmth@gmail.com> wrote:
>
> On Mon, Oct 18, 2021 at 09:15:12AM -0500, Rob Herring wrote:
> > On Thu, Oct 14, 2021 at 12:39:21AM +0200, Ansuel Smith wrote:
> > > From: Matthew Hagan <mnhagan88@gmail.com>
> > >
> > > Convert the qca8k bindings to YAML format.
> > >
> > > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > > Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > >  .../devicetree/bindings/net/dsa/qca8k.txt     | 245 ------------
> > >  .../devicetree/bindings/net/dsa/qca8k.yaml    | 362 ++++++++++++++++++
> > >  2 files changed, 362 insertions(+), 245 deletions(-)
> > >  delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > >  create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml

> > > +patternProperties:
> > > +  "^(ethernet-)?ports$":
> > > +    type: object
> > > +    properties:
> > > +      '#address-cells':
> > > +        const: 1
> > > +      '#size-cells':
> > > +        const: 0
> > > +
> > > +    patternProperties:
> > > +      "^(ethernet-)?port@[0-6]$":
> > > +        type: object
> > > +        description: Ethernet switch ports
> > > +
> > > +        properties:
> > > +          reg:
> > > +            description: Port number
> > > +
> > > +          label:
> > > +            description:
> > > +              Describes the label associated with this port, which will become
> > > +              the netdev name
> > > +            $ref: /schemas/types.yaml#/definitions/string
> > > +
> > > +          link:
> > > +            description:
> > > +              Should be a list of phandles to other switch's DSA port. This
> > > +              port is used as the outgoing port towards the phandle ports. The
> > > +              full routing information must be given, not just the one hop
> > > +              routes to neighbouring switches
> > > +            $ref: /schemas/types.yaml#/definitions/phandle-array
> > > +
> > > +          ethernet:
> > > +            description:
> > > +              Should be a phandle to a valid Ethernet device node.  This host
> > > +              device is what the switch port is connected to
> > > +            $ref: /schemas/types.yaml#/definitions/phandle
> >
> > All of this is defined in dsa.yaml. Add a $ref to it and don't duplicate
> > it here.
> >
>
> The reason I redefined it is because I didn't manage to find a way on
> how to add additional bindings for the qca,sgmii... . Any hint about
> that?

The problem is we can't have a single schema for parent and child
nodes and then allow additional properties in a child node at least if
we want to make sure all child properties are defined.

The port part of dsa.yaml needs to be split out either to a separate
file or under '$defs' in the same file so that you can reference it
and add properties.

As a separate file, you can then do:

"^(ethernet-)?port@[0-9]+$":
  $ref: dsa-port.yaml#
  unevaluatedProperties: false
  properties:
    a-custom-prop: ...

>
> I tried with allOf but the make check still printed errors in the
> example with not valid binding about qca,sgmii.
