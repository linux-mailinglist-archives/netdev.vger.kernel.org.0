Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8DD35C40F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhDLKd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:33:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38234 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbhDLKd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:33:57 -0400
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618223618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IeSCzkLT2TMeD064rdqHLGZki7q9FiMEKUBGP2lah28=;
        b=aOwrlZywc/YrJLZK9f5pAK6bVVkEAJbG8rauLdQSUcj94gqe+Ues1bT7vJRElQlm46GKsR
        e1CLophyGGZOa0Mey7nFRuHGdUTMMzw0WCaRlZQ3IAkbFEjtR0nAnPVhMtTVc6ZqrRpkPH
        ciAOWatoqHSKfJus4ox0SssJKJ+eTxQHOtS1QdUQkHcewDvdumoYjKYfX/h80g98f6QCtW
        Tf1+tgL6BixgjIKD+I63qAYKpXF6jPVhCYJ8wN9qTZ2pnEuJ95+FY41uZAaFc3mC/FJkPn
        o/QDPdzIPWgL7uBsEdjYBL76cMtZZA/V5CRa4DaEeXnsOncCelP6Z0pFTMXIfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618223618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IeSCzkLT2TMeD064rdqHLGZki7q9FiMEKUBGP2lah28=;
        b=mFv0Bx9kAqb1f/heYquuq0cHNEKj9RxAiMiSk+K6nqcFWebS/8czH/Rp4qoCb6tCF46Lf/
        43lpqtFX4DniNNCw==
To:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?utf-8?Q?Ren=C3=A9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v4 net-next 3/4] dt-bindings: net: dsa: add MT7530 interrupt controller binding
In-Reply-To: <20210412034237.2473017-4-dqfext@gmail.com>
References: <20210412034237.2473017-1-dqfext@gmail.com> <20210412034237.2473017-4-dqfext@gmail.com>
Date:   Mon, 12 Apr 2021 12:33:36 +0200
Message-ID: <8735vv6bcv.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Apr 12 2021, DENG Qingfang wrote:
> Add device tree binding to support MT7530 interrupt controller.
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> RFC v3 -> RFC v4:
> - Add #interrupt-cells property.
>
>  Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Docum=
entation/devicetree/bindings/net/dsa/mt7530.txt
> index de04626a8e9d..892b1570c496 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> @@ -81,6 +81,12 @@ Optional properties:
>  - gpio-controller: Boolean; if defined, MT7530's LED controller will run=
 on
>  	GPIO mode.
>  - #gpio-cells: Must be 2 if gpio-controller is defined.
> +- interrupt-controller: Boolean; Enables the internal interrupt controll=
er.
> +
> +If interrupt-controller is defined, the following property is required.
> +
> +- #interrupt-cells: Must be 1.
> +- interrupts: Parent interrupt for the interrupt controller.
>=20=20
>  See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of addi=
tional

That dsa.txt still exists, but it refers to the dsa.yaml binding. Any
chance to convert this mt7530.txt to yaml as well? Then, device trees
can be automatically validated for correct entries. There are a few
examples of dsa yaml bindings already: ksz, b53, sf2, hellcreek, ...

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmB0IgAACgkQeSpbgcuY
8Kb6eg/9FdeRCvEbOTCVRDtl5lsVRik6QqjbYTaQLNrkEUmOA9SrkbQ63yxhPF2i
j7heR52USECwZDmiUG+P7CIlk9EIZhsgy4xQngJe8BvAa+Xai4Rybrn/0QIGv8Mp
vlljoycO8z16JNQ4BV7ySXGb901RZFHEDH4MovM30fXwjWLgkV0nwzl87Wj9uisr
jXob9CTbvf7h/+kdAfP3zm1vAscwLqS+JopIbp0qkUd+1B93LZ0E6hyzMTD0/IWp
S3XQNRMOWeHOksTxmZAUvtVB+g2HeQZ4s0sXzPJjlJ2e4XSKQephjd1kjFxQcyJc
Bw14tdWW3OdP6B2lai48RsswjximG50FQHLyUMtAJiiu0S96gC+OEbQY/tPB58K3
KgmW3RCCGvefVtx+OcOiLVYUerGrdHNhteFtrNHxBL63OH1T0/UEfCnyeEq5GcXV
LtfRbSJk2LoipSbyyqqbMptBXd5I5W8Ae5iNQ9eOmkZoG3Jmujh76mJAqV2CeIJd
Rn3PKti1JwpI036y5s048CZoUd7ptSn3T2DoHTuuVuTGbvVVU8HaY/NJMMaU8CYI
1+hluj/sJM9chjGwE270w8pgh8tQV5xnpzLDD54PcaWRiynfS7V2WMCnwdwMSNdT
mz2F2GXEDDrlTaao5T4SpzvmDad9IdL0vLcR+nnH2ji3zoPzMKo=
=+a88
-----END PGP SIGNATURE-----
--=-=-=--
