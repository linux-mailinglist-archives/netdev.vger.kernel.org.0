Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C588295D04
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896802AbgJVKy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:54:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46776 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444354AbgJVKy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:54:57 -0400
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603364094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/fC5Y7y3IxeDmxl+3w+jc+KFBzOSk//96ieJ/UONk0=;
        b=viQtrCkKSe30Qieil1Gu5eZpDPKTS8n4OBk34mB3YNQe02Dp7rchwDv09VV2ywHi952kLI
        BG64szPZnlLvxpDXRwBgDApGkdg6BYyNOmumdMivLSc7+5hzmDmGsm8XcMbe49RpWpv49D
        PBHnMOHxEbhCAs4d9zwgKist/vgI6r9C0lYh3YepYxcbAX1XcyxwkIvT6cZstwS1SqT6ca
        XRM1A6/vsKo7VSKelcAHMvFOL9AvVsDHkFSMmbaPtwq0Z1HqhtIoeZm+eozl31zVa34dOu
        HsYWEiQP6c255ydM1+7t7HFPkQi4/pLCZOW/dPpBrPaoZWZ0TI5fjK+6wWa+Tw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603364094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/fC5Y7y3IxeDmxl+3w+jc+KFBzOSk//96ieJ/UONk0=;
        b=NLUz3CmcxqLBMNZvyJBu++JD+0bv79htNvwhfhBi4+dWJgUZ/Tfw9yX3Wt26nvZey4k6Q4
        U/8kjN4l2Quxh0AQ==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: dsa: convert ksz bindings document to yaml
In-Reply-To: <3cf2e7f8-7dc8-323f-0cee-5a025f748426@gmail.com>
References: <20201019172435.4416-1-ceggers@arri.de> <20201019172435.4416-2-ceggers@arri.de> <87lfg0rrzi.fsf@kurt> <20201022001639.ozbfnyc4j2zlysff@skbuf> <3cf2e7f8-7dc8-323f-0cee-5a025f748426@gmail.com>
Date:   Thu, 22 Oct 2020 12:54:52 +0200
Message-ID: <87h7qmil8j.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Oct 21 2020, Florian Fainelli wrote:
> On 10/21/2020 5:16 PM, Vladimir Oltean wrote:
>> On Wed, Oct 21, 2020 at 08:52:01AM +0200, Kurt Kanzenbach wrote:
>>> On Mon Oct 19 2020, Christian Eggers wrote:
>>> The node names should be switch. See dsa.yaml.
>>>
>>>> +            compatible =3D "microchip,ksz9477";
>>>> +            reg =3D <0>;
>>>> +            reset-gpios =3D <&gpio5 0 GPIO_ACTIVE_LOW>;
>>>> +
>>>> +            spi-max-frequency =3D <44000000>;
>>>> +            spi-cpha;
>>>> +            spi-cpol;
>>>> +
>>>> +            ports {
>>>
>>> ethernet-ports are preferred.
>>=20
>> This is backwards to me, instead of an 'ethernet-switch' with 'ports',
>> we have a 'switch' with 'ethernet-ports'. Whatever.
>
> The rationale AFAIR was that dual Ethernet port controllers like TI's=20
> CPSW needed to describe each port as a pseudo Ethernet MAC and using=20
> 'ethernet-ports' as a contained allowed to disambiguate with the 'ports'=
=20
> container used in display subsystem descriptions.

Yes, that was the outcome of previous discussions.

> We should probably enforce or recommend 'ethernet-switch' to be used
> as the node name for Ethernet switch devices though.

After using grep, it seems like 'ethernet-switch' as well as simply
'switch' are being used today. Yes, maybe both should be allowed.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+RZPwACgkQeSpbgcuY
8KZ1Zg/+O1K8qE24ikz3QxBFBaUfbiSIbx8FLtvGbeYwH+KwOgx2Qi6KZQaGBKjP
MHIoWH2k8SrxY9JdMTanf7YK8b7/vrQ0GuGjl1D0gTrvoU3sT1FgTP8gcnN/aoxh
mPwZpj2QWiYbcr25tmPHW757+eo8TQ9GR8A2Jh+Sb/wucV+vdpToV3fMTuIGL55r
WFJ/Es5/ZoSqa52i/YHXgD6e/zlChqDh6/MPJhvvznjbg3ehHSw3OTB8fane82+r
/8MlavfklKX7mPawBYPZPZxXerElc9lQ1GUoYC7w6M6nF6HWhPhDIM1Q2LjCGRFa
YUhtB6mcP+oIMSQc6RjcBX2pVGzs/K+uvhZZ3LxUTeseUbX4teoKp1cz3M//e6Yt
hwsIb1EbfIzm2DMatNzE+kjmq7uBdNHtuiDpja5gaoEx+/JjnpwBcEubVfT9YBaH
J6kBRwueamWEVDMoJmojar/rG7yBURS/BZaUouXl+J+EYY3kIrknNnwjh78qF+cM
FURCf/EgSSuxfiIf+t3CorDWpbr0+2eYIkWFACU1OWeszFsFTGEpJCIaO6bHxoAy
vYkzzYSxwWjyoV4nonErHaYId4ixojSiE3cad5w2UQxvI8tvYPuFcFbHtwUnPSJ4
fOmcXPjSzzG5iieus7POa6n7+Mf6xJl/uPdtbnwDupu1UoAutBc=
=Ks1w
-----END PGP SIGNATURE-----
--=-=-=--
