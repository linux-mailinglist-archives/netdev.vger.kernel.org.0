Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349532343EA
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732305AbgGaKGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:06:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57074 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732140AbgGaKGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 06:06:53 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596190011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC/hy5UukrQWbwN2wHfj+RwU5XRQ5rQoGBNALt8r51I=;
        b=j8Ac/NWYZU1HM9hgVANOh1TqR8nhB4yIBOmgcHlJBdu7tE2ruU1I6jPgwA4r2UCQMPlRg8
        6rNEYA/1/1CzgQ5J1xRhvm7YGDv+KmwbK/PVCNIU3CcjCqRIkgXrJi1CUxaYZk5OiuNbt9
        ZzfC8FakpUYUvf8Uv4iONqtDOMrf8K/Y9z3y9VFaMp979eGqCQVr+luglZMAweVY71SD8K
        RhnmunL0idzfYRu/bEQiumxhlDPAQwWgRNGtSHe7Cuc6RvwFdfd10vFGlwxtW3LziJhu8u
        LQ0wC1Q/0+PRSX34Y7dFU9+JcuGoD3IdjyhxAv9bfvLcEKErMp30Wg98Iw9Puw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596190011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC/hy5UukrQWbwN2wHfj+RwU5XRQ5rQoGBNALt8r51I=;
        b=0CQ1YWAdsACb6Q4Ol4Jjb6PBBQVkNW0UmRjT957GpEQO/pRtCA8YOtPqTjbqaB4FIPCa15
        yMDpqxQQPfExu7Dg==
To:     Petr Machata <petrm@mellanox.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
In-Reply-To: <87lfj1gvgq.fsf@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com>
Date:   Fri, 31 Jul 2020 12:06:50 +0200
Message-ID: <87pn8c0zid.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jul 30 2020, Petr Machata wrote:
> Kurt Kanzenbach <kurt@linutronix.de> writes:
>
>> @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff =
*skb)
>>  }
>>  EXPORT_SYMBOL_GPL(ptp_classify_raw);
>>=20=20
>> +struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int t=
ype)
>> +{
>> +	u8 *data =3D skb_mac_header(skb);
>> +	u8 *ptr =3D data;
>
> One of the "data" and "ptr" variables is superfluous.

Yeah. Can be shortened to u8 *ptr =3D skb_mac_header(skb);

However, I'll wait a bit before sending the next version. So, that the
other maintainers have time to test their drivers.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8j7ToACgkQeSpbgcuY
8KYDPw//Q6a2p18zlyAjD7GSe/+e+Z5GCzkCit+QFlp9AMG2uZUHIN/2kX+udynJ
fw1lYvRkLkO41Vb9ktPapGaWlnQMwfX6AnKWI9loNML6R7jZUnT5XJMtIEeWkz0I
VAiHu67jV4jQ8hPdZYaDpgKMvLNYAyCkbrk4sHjLdJAfKE3tFhi2g1TjadHalfWY
nWT/TedR+A6+eFLCEvQvhg/k+dh8udMI+lumGmAJBksdTdyAdk35QQ2KwUNzSxPD
rCuSdgp5damVeLEW9JeNI24zin5XzZvBWhHbRueIwAslstWVCLEUmoICXgp/srwV
LJcL40sohyGnSVyQ+FLvFCm9HOlbXOJfbFG3pBtPrxT9o4UYgQlJ1eKCLKPl6vEW
sMLpmWwCjyEMUEg4UVo32tI1vclrsi+LKVOqx4YMFuhCVJUCJJX8Vbhd8KG1yOtV
2gjJ+BhP8rOhkAc7Fzup4u18Yoetnk5/vonb67v7yyUeN/5NJP9w0/Jzg1jhMXEB
xlzVBx44vRMh8B9n6vbHhUHWu87kZtHRoXAxqfWXGU1F1t12JzKeUxkFjfnDGa03
SN3lIGPodx9GsiVRKNOj5dK8GbUO0gBDh4vxzQ0s7Pzoj33sAHRbQ0xL37cuaHjE
9Q6rdvv8OflfW9KXaVNwfURCDsTKkONuP/1x/3AcCH5bvaPZTpc=
=UxOJ
-----END PGP SIGNATURE-----
--=-=-=--
