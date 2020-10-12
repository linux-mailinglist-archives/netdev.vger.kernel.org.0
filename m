Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8579D28ADCE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 07:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgJLFpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 01:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgJLFpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 01:45:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83927C0613CE;
        Sun, 11 Oct 2020 22:45:14 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602481513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMpL/R1nLesM5wL3p0yEU/9E+n3FxnEiinXlmtJm2FI=;
        b=mVMfimr81cirXB82mVb3JNfX1mMrb2BxY8zjaCdniW1Dibu0CvySmGyfieIz+/3DKrHemw
        Y2ZvxX6nKHTp+LNd/wUeqHHnjfHz7pz8nHwGhYiVlMlUt9kSyQUzbWY7lXsLK4PMvk30VY
        Ogbyy+Wjl5HS4vxhNOoccoGZCV6CGAp90RY3B4YOSq6mvfkiy8VAtdRMp2jHfUk1JPIXWi
        ZLRWizrmpxdgZQFUMFjQvg45WhBIOR60LupOUQQCDF/G8aDxO9eeWoFCUKPvMTqz+EMjQP
        7HpHBBbF2Igvh3FeRArU7IpFhTyXZBz2Ti/9vrz3I0Aq/J5V+AnGO1FxnYg2Fw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602481513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMpL/R1nLesM5wL3p0yEU/9E+n3FxnEiinXlmtJm2FI=;
        b=YARPKng4jcx1hiYl0VOxyal2Iw12Q5CCDn6W8Sws9lXJvH0niNbZVfknb9Wwv/VFmABW9W
        /Dc28l0RPuzVBTAA==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Add YAML bindings
In-Reply-To: <08c1a0f5-84e1-1c92-2c57-466a28d0346a@gmail.com>
References: <20201010164627.9309-1-kurt@kmk-computers.de> <20201010164627.9309-2-kurt@kmk-computers.de> <3249c764-ec4a-26be-a52d-e9e85f3162ea@gmail.com> <877drxp3i5.fsf@kmk-computers.de> <08c1a0f5-84e1-1c92-2c57-466a28d0346a@gmail.com>
Date:   Mon, 12 Oct 2020 07:45:10 +0200
Message-ID: <87o8l8f15l.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun Oct 11 2020, Florian Fainelli wrote:
> On 10/11/2020 1:32 AM, Kurt Kanzenbach wrote:
>> How should we proceed? Adding the missing compatible strings and ports
>> to the DTS files? Or adjusting the include files?
>
> The include is correct as it provides the fallback family string which=20
> is what the driver will be looking for unless we do not provide a chip=20
> compatible. The various DTS should be updated to contain both the chip=20
> compatible and the fallback family (brcm,bcm5301x-srab) string, I will=20
> update the various DTS and submit these for review later next week.

OK. It's not just the compatible strings, there are other issues as
well. You can check with `make dtbs_check DT_SCHEMA_FILES=3Dpath/to/b53.yam=
l'.

>
> Then we could imagine me taking this YAML change through the Broadcom=20
> ARM SoC pull requests that way no new regressions are introduced.
>
> Sounds good?

Sounds like a plan. But, Rob or other device tree maintainers should
have a look at the YAML file to spot issues in there first.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+D7WYACgkQeSpbgcuY
8KYI5w//YG1MK/Zs2OSAzXBXPj4K25Z7xSLXkCq+A0IBOpMhCvwWsBTTCVqZ0SUv
ERu7QqaYlsPW3qL81v4M12FVpAXGuGbB5j4rwunTGidSDeRoj89PCa5hVLsbLe0x
3Bu+xzjuLxR5tsNjC3AGgh/S4vibVenxnYn9rF3d5jxyuPC0mpcyc0hg7Zv6Eup9
/+bly+0mtzIz1YVp6UZPmtmzQ4n+rLHZShsVtqJeiROd5XPebeCBBta50PO8C8mn
y9M7AvVLugrpgg/o4nHsQHeB0Tcnv1W6UBYlRUZlTpyXSTQEuQW9CdUMT/TId3Ky
0Lymem0rB+1NSX1GwAl9dfjtxU40LRpj1VRmKEWMYBmIDYxsLOvZTAx8sFHWPv96
HoVPrOgkEOrhgQE6TAcSoRyyvM6cib1SY9M80Rzld3ZHPjy1GEx8WGMYeCBwKv79
pWYv8DIhExn8Ye2aEX6OTCvJ+LQbzggChfc7rZcmogjoa/qIPiWoDHJ11SX0aOp7
u39JP42NkgG3Z9VZtrA8z9eG0sVV5Bq4rEY6RUrQ7PXr3tUplFzi3BFAywHW3OJ/
/r+IroI3kjBOHcbeHWguTiBT28ku1zbwPEE05bIlCrW4htgcw/PW+7Ooc0W7pXOG
cgOu20D6XenODEKuRi2Q7mlRXEv9LwGakmAZAmLgTvJa8HHruWI=
=tqms
-----END PGP SIGNATURE-----
--=-=-=--
