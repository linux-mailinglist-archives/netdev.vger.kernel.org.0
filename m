Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B25FD759
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfKOHuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOHuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 02:50:12 -0500
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63B92072A;
        Fri, 15 Nov 2019 07:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573804211;
        bh=N5y9/j9jBDmNZvdMr4J2c/QD6EJfi4NYUK5ANzDGnqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oifm6v9/MIrfdTFrfE3u0TStPDjx8gWCUbH7cfP+DrK/7cEn6jOrKLR+x6nvdWHsq
         bD6U5rkgwVBc0onFAOv6BjEpg+rV2swpf2Oyve36luFTe7cWhG+arflCpgXBY0v8lo
         zCZ18z8QZlN2ddgL74/mlHnIIbciyditdaqB1hMg=
Date:   Fri, 15 Nov 2019 08:50:08 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Christophe ROULLIER <christophe.roullier@st.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] dt-bindings: net: dwmac: increase 'maxItems' for
 'clocks', 'clock-names' properties
Message-ID: <20191115075008.GY4345@gilmour.lan>
References: <20191108103526.22254-1-christophe.roullier@st.com>
 <20191108103526.22254-2-christophe.roullier@st.com>
 <20191108104231.GE4345@gilmour.lan>
 <f934df21-ac57-50ad-3e7b-b3b337daabe1@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5ZoQamfY1dF16JN0"
Content-Disposition: inline
In-Reply-To: <f934df21-ac57-50ad-3e7b-b3b337daabe1@st.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5ZoQamfY1dF16JN0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 08, 2019 at 01:02:14PM +0000, Christophe ROULLIER wrote:
> On 11/8/19 11:42 AM, Maxime Ripard wrote:
> > Hi,
> >
> > On Fri, Nov 08, 2019 at 11:35:25AM +0100, Christophe Roullier wrote:
> >> This change is needed for some soc based on snps,dwmac, which have
> >> more than 3 clocks.
> >>
> >> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> >> ---
> >>   Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 +++++++-
> >>   1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/D=
ocumentation/devicetree/bindings/net/snps,dwmac.yaml
> >> index 4845e29411e4..376a531062c2 100644
> >> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> >> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> >> @@ -27,6 +27,7 @@ select:
> >>             - snps,dwmac-3.710
> >>             - snps,dwmac-4.00
> >>             - snps,dwmac-4.10a
> >> +          - snps,dwmac-4.20a
> >>             - snps,dwxgmac
> >>             - snps,dwxgmac-2.10
> >>
> >> @@ -62,6 +63,7 @@ properties:
> >>           - snps,dwmac-3.710
> >>           - snps,dwmac-4.00
> >>           - snps,dwmac-4.10a
> >> +        - snps,dwmac-4.20a
> >>           - snps,dwxgmac
> >>           - snps,dwxgmac-2.10
> >>
> >> @@ -87,7 +89,8 @@ properties:
> >>
> >>     clocks:
> >>       minItems: 1
> >> -    maxItems: 3
> >> +    maxItems: 5
> >> +    additionalItems: true
> > Those additional clocks should be documented
> >
> > Maxime
>
> Hi Maxime,
>
> The problem it is specific to our soc, so is it possible to
>
> propose "optional clock" for 2 extras clocks in snps,dwmac.yaml
>
> and "official" description in soc yaml file (stm32-dwmac.yaml) ?
>
>  =A0 clocks:
>  =A0=A0=A0 minItems: 1
>  =A0=A0=A0 maxItems: 5
>  =A0=A0=A0 additionalItems: true
>  =A0=A0=A0 items:
>  =A0=A0=A0=A0=A0 - description: GMAC main clock
>  =A0=A0=A0=A0=A0 - description: Peripheral registers interface clock
>  =A0=A0=A0=A0=A0 - description:
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0 PTP reference clock. This clock is used for =
programming the
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0 Timestamp Addend Register. If not passed the=
n the system
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0 clock will be used and this is fine on some =
platforms.
>
> +=A0=A0=A0=A0=A0 - description: optional clock
>
> +=A0=A0=A0=A0=A0 - description: optional clock

I guess we'd really need to figure out what those clocks are doing,
they are probably helpful (and used, under a different name) by
others.

Hopefully the questions Rob asked will clear that out

Maxime

--5ZoQamfY1dF16JN0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXc5YsAAKCRDj7w1vZxhR
xfOIAQDuF3beQ9RfPAYD67pkf3/F/dORXIo+wvQohXSAQvcs3QD/UFc1TjzfsZGJ
pYg8YtyMyILwneRXRbb0MDJ8mG1A2Q0=
=DopP
-----END PGP SIGNATURE-----

--5ZoQamfY1dF16JN0--
