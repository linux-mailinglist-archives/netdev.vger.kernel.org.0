Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98244C3D84
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbiBYFII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBYFIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:08:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C343186470;
        Thu, 24 Feb 2022 21:07:36 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id m11so3840349pls.5;
        Thu, 24 Feb 2022 21:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rOW73EZAvnc1wsgXbVE6ciQzvh8WW+Bk4gV7FTSwz4k=;
        b=TJuoQsjLE/gkBrX6QQKV7hC8q85Sw0yUl19d6iUB/LG06z2SBEruBtgpCyoEPn2SRW
         KciGQWF+2S71LboIWyg2TvFBV+jNvwhyTzyorTqMdFtWmndB+cjOicyfTLn/dk2G6Ttp
         doNA1X0Qi48/dI+2jHxtWGnQjcB+HewuruUkDDJ2nmn25foBjF9q+fOAipuqLS4zQSBf
         6LMCEQkGfwU5/pqmuC0FKnbS8IShlgxdQ+vMvYn0ERQ3uGD9zbnnzabe5pnNR+O/3ewp
         4uDCbwAovLu9QULmXOndg+F7GksHEdADOzxLZf1S3+li5icvaKW1IzwwD1QOXJkgj8ZG
         cjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rOW73EZAvnc1wsgXbVE6ciQzvh8WW+Bk4gV7FTSwz4k=;
        b=P1UaN1ibjsDpMYhj4PMMZ+/GIAhzqEAdenXQATIpbq0kbweobb4eyVaf7uv8hWukVg
         2u/G5jErxaGzCWEkV7iv+Svg9aObHe9f0gE9uo4TG5xUIUPYTyK6eAo9JQrGzggo7bB1
         +yaqpzwsnUucmH+Uu/5Ibkuqae+q0qBVNF4RbwGhjE5cvNs3zAXMHwbTBu9/2F5hDmTP
         /TRuTrIEAKrXDQMzSQLMXLInB8oWrnW+mlsZU0hOJl1z95WnUt5UCCxMzCq6ch2f5a9I
         zob/d1QIBL/YTWiJ4oOJndrWRRk3KW1nMAaMNEhs11h4vjAzQfNuZDg+V4tWymrNYiZK
         w10A==
X-Gm-Message-State: AOAM533ZTOJ1Dw3YryYAPmergXaxS79ZhRkmdmp51W8NwYCQgtl0i8hF
        7aeZMIDgFKLcx1+57Od2pFnFZULD7aQw26IgMfQ=
X-Google-Smtp-Source: ABdhPJw4XoxTyIWPFOHFfASSDY+FM8Pa4x0uPk5lChh8GWhsRtm9K2jbuWBDIVnWbdcpkETseChzQPhVsEkoM/QWFyY=
X-Received: by 2002:a17:90a:1d04:b0:1bc:98ca:5e6f with SMTP id
 c4-20020a17090a1d0400b001bc98ca5e6fmr1559118pjd.32.1645765655621; Thu, 24 Feb
 2022 21:07:35 -0800 (PST)
MIME-Version: 1.0
References: <20220221200102.6290-1-luizluca@gmail.com> <Yhfmi2Mn6e0NMXh3@robh.at.kernel.org>
In-Reply-To: <Yhfmi2Mn6e0NMXh3@robh.at.kernel.org>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 25 Feb 2022 02:07:24 -0300
Message-ID: <CAJq09z7mNzV-Kg90KsM_E33ZByLLNTk9TZgF0LcfUL630zwEBw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: dsa: add new mdio property
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Feb 21, 2022 at 05:01:02PM -0300, Luiz Angelo Daros de Luca wrote:
> > The optional mdio property will be used by dsa switch to configure
> > slave_mii_bus when the driver does not allocate it during setup.
> >
> > Some drivers already offer/require a similar property but, in some
> > cases, they rely on a compatible string to identify the mdio bus node.
>
> That case will fail with this change. It precludes any binding
> referencing dsa.yaml from defining a 'mdio' node with properties other
> than what mdio.yaml defines.

Thanks Rob.

I believe any DSA drivers mdio subnodes will reference mdio.yaml. It
doesn't make sense to not to. So, it is fine to restrict that from
dsa.yaml. Are you saying that it will also prevent extra properties
inside that mdio, either declared in dsa.yaml or in any other dsa
driver yaml?

During my tests, it looks like both "mdio", from dsa.yaml or the
<driver>.yaml are validated independently. I can include a new
property or even a "required" on either level and the checks seem to
work fine. I didn't try it harder but I believe I cannot negate/drop a
property or a requirement declared in one YAML file using the other
YAML. But, in this case, dsa.yaml mdio is only referencing mdio.yaml,
just like any dsa driver would do.

And about the compatibile string usage, it is more about code than
schema. I did checked every driver and got these results:

These already uses mdio name:
- drivers/net/dsa/qca8k.c:
of_get_child_by_name(priv->dev->of_node, "mdio");
- drivers/net/dsa/mv88e6xxx/chip.c:         of_get_child_by_name(np, "mdio");
- drivers/net/dsa/qca/ar9331.c:             of_get_child_by_name(np, "mdio")

This one creates a new mdios container for its two mdio nodes. So,
they are at a different level:
- drivers/net/dsa/sja1105/sja1105_mdio.c:
of_get_compatible_child(mdio_node, "nxp,sja1110-base-tx-mdio");
- drivers/net/dsa/sja1105/sja1105_mdio.c:
of_get_compatible_child(mdio_node, "nxp,sja1110-base-t1-mdio");

realtek-smi, even before yaml conversion required a mdio node
(although code only looks for the compatible strings),
- drivers/net/dsa/realtek/realtek-smi.c
of_get_compatible_child(priv->dev->of_node, "realtek,smi-mdio");

This one is the most problematic one. It only has a TXT that does not
mention an "mdio" node name, although examples do use it.
- drivers/net/dsa/lantiq_gswip.c:
of_get_compatible_child(dev->of_node, "lantiq,xrx200-mdio");

I still don't get why the compatible string is in use when there is a
finite number of (or only one) mdio nodes. Wouldn't it be easier to
use of_get_child_by_name? Anyway, all of them might not collide with
dsa mdio definition.

> The rule is becoming any common schema should not define more than one
> level of nodes if those levels can be extended.

Sorry but I didn't understand what you are suggesting. Should I simply
drop the dsa/mdio doc?

> > Each subdriver might decide to keep existing approach or migrate to this
> > new common property.
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index b9d48e357e77..f9aa09052785 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -32,6 +32,12 @@ properties:
> >        (single device hanging off a CPU port) must not specify this property
> >      $ref: /schemas/types.yaml#/definitions/uint32-array
> >
> > +  mdio:
> > +    unevaluatedProperties: false
> > +    description:
> > +      Container of PHY and devices on the switches MDIO bus.
> > +    $ref: /schemas/net/mdio.yaml#
> > +
> >  patternProperties:
> >    "^(ethernet-)?ports$":
> >      type: object
> > --
> > 2.35.1
> >
> >
