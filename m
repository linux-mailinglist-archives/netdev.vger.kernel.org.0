Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF08391A18
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhEZO06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbhEZO0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 10:26:54 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83717C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 07:25:21 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t15so1734727edr.11
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 07:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ahfOAcWPCGuABC9EMZQZUndR9UGy3UTNWdj0HZp1ufE=;
        b=jwB2GtJEIltqksd42jScP3xLSWuiaL2za2aPSNudOROJhu/dKBguKNct0ouYlaszrc
         UyLOQ7EA25OVM1uM9+74xHYfQhfpvOdVB0LIUJOgN/W8MrK0c8RmXapU2gnBjhdMl26F
         Y+q7S6KSwoPKmJ/hOVXnJjJA78GS17T61x7IVPCFXvDdu9kyOx4fxVaVW/mpMLhdZkh3
         pUz6j4tvlikbct0PwlRSIX6AA5pP8hECZrQWSIglUQUzqbsjnShN6JOpPPIjNYQO2hFM
         Kna3HgL3rnpEoiQv6ZmMh/26gmrgzBkGmUFhNTbpVYTHs1pPbuEVAKkqLd+B95cauOd9
         tiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ahfOAcWPCGuABC9EMZQZUndR9UGy3UTNWdj0HZp1ufE=;
        b=rlMDKN1lUWWXoL2RDwbcRFCbhL4y+nOg59ah0izKZy96V/MYTzUm8HwrhArqy7Og7B
         shl1Cwd7x3txvscDT6hZHbB4Pf6kSx0Vr4gIINaKzqpi4F3RqW9G+LpexraXpTeAB8wc
         jTJdnkpieFYTF6rw+l2jol8nvFvwQWqSyvSPE61S95D9EaehfHmiyJRRqs3ChZyXerMZ
         H/FMz1sQtd+1kHS/eUJrohqJSGS2UXMbDI+l3uzyOoKunUlO/3RAohm00Jthgeb+7wHK
         QomfywwFuuLR4iqg9iHJ4IMNR/C6/lP5WJR2iYf6zEPCEm1LqgWTfA+yP6SWKiDGzz7l
         pjJg==
X-Gm-Message-State: AOAM532cQDNgW3CKHaXmTnyUyC07RDV2TgoxgRmBX285/qxiAbytQntK
        +AcfQPWDQruUbrwo3hL2GXA=
X-Google-Smtp-Source: ABdhPJzRRtxv0V+dpdB8L6c1UvmnoHcPOhQ48k+X/2TTD2WU4H4CuOVVg/9M/82j5fuZbxa5t1H9BA==
X-Received: by 2002:a05:6402:3594:: with SMTP id y20mr38575239edc.63.1622039120108;
        Wed, 26 May 2021 07:25:20 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id l19sm12511547edv.17.2021.05.26.07.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:25:19 -0700 (PDT)
Date:   Wed, 26 May 2021 17:25:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH v2 linux-next 10/14] dt-bindings: net: dsa: sja1105:
 add SJA1110 bindings
Message-ID: <20210526142518.437s36xphjy2xmln@skbuf>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
 <20210526135535.2515123-11-vladimir.oltean@nxp.com>
 <CAL_JsqJA1cjozmKVA2jW_n5AKrWnGsbtMRfxj9eh+xUZZrNZQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJA1cjozmKVA2jW_n5AKrWnGsbtMRfxj9eh+xUZZrNZQw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 09:19:49AM -0500, Rob Herring wrote:
> On Wed, May 26, 2021 at 8:56 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > There are 4 variations of the SJA1110 switch which have a different set
> > of MII protocols supported per port. Document the compatible strings.
> >
> > Also, the SJA1110 optionally supports 2 internal MDIO buses for 2
> > different types of Ethernet PHYs. Document a container node called
> > "mdios" which has 2 subnodes "mdio@0" and "mdio@1", identifiable via
> > compatible string, under which the driver finds the internal PHYs.
> >
> > Cc: Rob Herring <robh@kernel.org>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > Changes in v2:
> > Patch is new.
> >
> >  .../bindings/net/dsa/nxp,sja1105.yaml         | 43 +++++++++++++++++++
> >  1 file changed, 43 insertions(+)
> 
> Please use get_maintainers.pl and resend to the right lists.
> Specifically, the DT list in this case.

Thanks, I'll resend the 2 dt-bindings patches separately right away, if
getting the driver merged in a later series compared to the bindings is
acceptable.

> > diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> > index c1f18849a54a..640da65b0f59 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> > @@ -28,10 +28,53 @@ properties:
> >            - nxp,sja1105q
> >            - nxp,sja1105r
> >            - nxp,sja1105s
> > +          - nxp,sja1110a
> > +          - nxp,sja1110b
> > +          - nxp,sja1110c
> > +          - nxp,sja1110d
> >
> >    reg:
> >      maxItems: 1
> >
> > +  # Optional container node for the 2 internal MDIO buses of the SJA1110
> > +  # (one for the internal 100base-T1 PHYs and the other for the single
> > +  # 100base-TX PHY). The "reg" property does not have physical significance.
> > +  # The PHY addresses to port correspondence is as follows: for 100base-T1,
> > +  # port 5 has PHY 1, port 6 has PHY 2 etc, while for 100base-TX, port 1 has
> > +  # PHY 1.
> > +  mdios:
> > +    type: object
> > +
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    patternProperties:
> > +      "^mdio@[0-1]$":
> > +        type: object
> > +
> > +        allOf:
> > +          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
> > +
> > +        properties:
> > +          compatible:
> > +            oneOf:
> > +              - enum:
> 
> Don't need oneOf when there is only 1 entry.

I assume this is true for the "nxp,sja1105*" compatibles for the driver
itself too.

> > +                  - nxp,sja1110-base-t1-mdio
> > +                  - nxp,sja1110-base-tx-mdio
> > +
> > +          reg:
> > +            oneOf:
> > +              - enum:
> > +                - 0
> > +                - 1
> > +
> > +        required:
> > +          - compatible
> > +          - reg
> > +
> >  patternProperties:
> >    "^(ethernet-)?ports$":
> >      type: object
> > --
> > 2.25.1
> >
