Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE628ED5B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 09:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgJOHF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 03:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgJOHF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 03:05:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D92C061755;
        Thu, 15 Oct 2020 00:05:27 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602745525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wKx5IQSzdiykghzSAGrSkF1QExk5tgl8xdQy5xIGQlI=;
        b=02E6X/Pz1T1A1QvesbvdrsGJE9xGHbq4N0qDGaaIU2vzBPedUHPfmISrDdN0fh/wXnTcVj
        eZNTqX91kACLjWKYhuPpIoHRad87xla2nPTxgWUfoYY83kubQwig+j48Ppcm7JM2CN09X6
        TM6rXZKI30/xPY3zAbrkJKgHeydjBJ2eYdnQotus/P384Jt/eJhIHBN7YeNrqf7kj8SJGV
        CPzz/Dh4RwvJfEeanB9CqKD+1ypBIEHDfGu/UoxqKH9gvSKREjVK3T0UcwDzFdrX5IANej
        wlCxI6BuQzmvxQhzgBYTY/188PPVbzB9QL1F58RrWvf7uDIt3KB6b5f5xvh40g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602745525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wKx5IQSzdiykghzSAGrSkF1QExk5tgl8xdQy5xIGQlI=;
        b=Gjf4bPCSAYj99xYmrZ+Z/w5XdO2HV6/VYG4ftjuHoX2totlu7ZQby5ZN4wxVoaCbzqeWdp
        QxAL9loyOyOiOdCw==
To:     Rob Herring <robh@kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Drop old bindings
In-Reply-To: <20201012184707.GA1886314@bogus>
References: <20201010164627.9309-1-kurt@kmk-computers.de> <20201010164627.9309-3-kurt@kmk-computers.de> <20201012184707.GA1886314@bogus>
Date:   Thu, 15 Oct 2020 09:05:23 +0200
Message-ID: <87r1q0c6ks.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Oct 12 2020, Rob Herring wrote:
> On Sat, Oct 10, 2020 at 06:46:27PM +0200, Kurt Kanzenbach wrote:
>> The device tree bindings have been converted to YAML. No need to keep
>> the text file around. Update MAINTAINERS file accordingly.
>
> You can squash this into the previous patch.

OK, sure.

@Florian: Should I send a v2?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+H9LMACgkQeSpbgcuY
8KbWBg//ULnvu0TuzNgWeAQCizn9k6joUmB9PybzhYqAe9vm2t1vDvP2Z8Q5THdB
oDTrwWU1GrP02lsXbKVK/U3qEnP6s97RHJ6ZmKW+ev4zG2RsaSVGujvL55lnAgma
F/Mxkxw4pBS9ixthQTsdQxy+3Py3lNUvcynxU45pK+GrW9YIUtfuQpBA7AWTJ+7u
VYqGe5bVclStHf0/nHo59wrdJqixm98DXqXKsTzXgaVWa/DMzKlU0qYbpQJv2vWM
4+agdGRyPGzbsuktfhSooMcvawEwIAGnnitVH5AnrQ18rUTw2S7IjaLNvhtIWAOe
uP/rwB3S1pUSmNlHDg0navwdzcyDGBWMHCA5V90SdWNjy1L9vQVNWjWMr2/kA5X/
6WNpGKVULE/ME6ERzT5GQ0/kQuX3IbZCuGalyWGn4+0tSFmFUH8qce4pirObLyqo
gg4S4vPX1eH6wBlS1PL/rO3X6QJH0o9J5Yr1qzMoIcFLg0K5MitJMJltMG1nSONT
K9QwMeNI9Dp8Ykngirhk/j21xzVJ27oF1M/QQlrYenfDKNFFhJMrzhJts50/VREx
n4Bv2laXq9RmZPkrkdq7AAsl3uk5TgSAvzA7dVNIcrvw0cvMIeeeDcoFmVUwfdzk
sBRSqWjSr8mO1gRsyzDiFdstgxnqGAWuARLgBwFYGbkkfOqARBo=
=I6/s
-----END PGP SIGNATURE-----
--=-=-=--
