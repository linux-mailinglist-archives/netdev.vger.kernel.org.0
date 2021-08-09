Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7A53E4682
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhHIN04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhHIN0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:26:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824C0C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 06:26:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mD5IA-0004iF-74; Mon, 09 Aug 2021 15:26:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:565a:9e00:3ca4:4826])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0E7656634B6;
        Mon,  9 Aug 2021 13:26:06 +0000 (UTC)
Date:   Mon, 9 Aug 2021 15:26:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
Message-ID: <20210809132605.m76mnxkp6bdcn77c@pengutronix.de>
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6f5psdbuggvhxqx7"
Content-Disposition: inline
In-Reply-To: <20210727133022.634-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6f5psdbuggvhxqx7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.07.2021 14:30:20, Lad Prabhakar wrote:
> Add CANFD binding documentation for Renesas RZ/G2L SoC.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/net/can/renesas,rcar-canfd.yaml  | 69 +++++++++++++++++--
>  1 file changed, 63 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd=
=2Eyaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> index 0b33ba9ccb47..546c6e6d2fb0 100644
> --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> @@ -30,13 +30,15 @@ properties:
>                - renesas,r8a77995-canfd     # R-Car D3
>            - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
> =20
> +      - items:
> +          - enum:
> +              - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
> +          - const: renesas,rzg2l-canfd     # RZ/G2L family
> +
>    reg:
>      maxItems: 1
> =20
> -  interrupts:
> -    items:
> -      - description: Channel interrupt
> -      - description: Global interrupt
> +  interrupts: true
> =20
>    clocks:
>      maxItems: 3
> @@ -50,8 +52,7 @@ properties:
>    power-domains:
>      maxItems: 1
> =20
> -  resets:
> -    maxItems: 1
> +  resets: true
> =20
>    renesas,no-can-fd:
>      $ref: /schemas/types.yaml#/definitions/flag
> @@ -91,6 +92,62 @@ required:
>    - channel0
>    - channel1
> =20
> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - renesas,rzg2l-canfd
> +then:
> +  properties:
> +    interrupts:
> +      items:
> +        - description: CAN global error interrupt
> +        - description: CAN receive FIFO interrupt
> +        - description: CAN0 error interrupt
> +        - description: CAN0 transmit interrupt
> +        - description: CAN0 transmit/receive FIFO receive completion int=
errupt
> +        - description: CAN1 error interrupt
> +        - description: CAN1 transmit interrupt
> +        - description: CAN1 transmit/receive FIFO receive completion int=
errupt
> +
> +    interrupt-names:
> +      items:
> +        - const: g_err
> +        - const: g_recc
> +        - const: ch0_err
> +        - const: ch0_rec
> +        - const: ch0_trx
> +        - const: ch1_err
> +        - const: ch1_rec
> +        - const: ch1_trx
> +
> +    resets:
> +      maxItems: 2
> +
> +    reset-names:
> +      items:
> +        - const: rstp_n
> +        - const: rstc_n
> +
> +  required:
> +    - interrupt-names
> +    - reset-names
> +else:
> +  properties:
> +    interrupts:
> +      items:
> +        - description: Channel interrupt
> +        - description: Global interrupt
> +
> +    interrupt-names:
> +      items:
> +        - const: ch_int
> +        - const: g_int

Are you adding the new interrupt-names to the existing DTs, too?
Otherwise this patch will generate more warnings in the existing DTs.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6f5psdbuggvhxqx7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmERLOsACgkQqclaivrt
76nvTwf+NqR4qA1ztbe9CIxqXM+nHsWtgFyIeAIoqtJpD8m66d+1kw/7X4tAeA6S
VngDNtoXruztIMRw3ozl1z73SvFM66POf4Dt3Isy24ktEI0lSgGVLoDjNr6ajqC9
JVaCQWJj27nBir2beH1ExUMayPEuTxMR7AD48Io1flp7116HfOu2vEalQKmQ77T/
v/jFswOxgqS1q6fY6IS4UCoPtK4BOTP3/xSH4ydVA+Mg6Si4iZhc6R7h6khebn3H
PyodY3HJKU3LzANv7E/WdRZiFT5QMgN87PikXZ1aR2VZ+VoEkpHN7i0eCHXT7yFv
63QtyEdEGcpaN7TTixBCepToMMRrDw==
=pgt1
-----END PGP SIGNATURE-----

--6f5psdbuggvhxqx7--
