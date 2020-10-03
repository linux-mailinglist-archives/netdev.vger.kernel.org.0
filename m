Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690E528234D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgJCJpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:45:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48134 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:45:30 -0400
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601718328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2dCex4NV0q78QQ6HHDVxFCxf0TIoxjJwpJfVg4NwFI0=;
        b=a4KEJfRxkXNCOoDS0MNQ14efTL2NyZF/AXLoevocYZzqSrhvrwOlYfEKfvSSJb2XEXwaoD
        V0Kk3MhjN3JGaIvM3HG3Vuj4mtZVDqYF5liefPjDygpITZvZa8Q5NTRaP02wUYkX+meBj2
        XXR0QFpwu4v9ZlRbwRoooat25GTwbHa22Qqs1qpYeRSbmz8yUyf1I0tcOyWTprnUc77LOd
        bgBtDDrtA7cPw38XQdn2u7OtfMh78aIvk34jE6haPK+3CiKqZCdlJnuFoTYTZFvpB/9dss
        93KT+1StFO6wMuML+2f/7nIgAcA8UOhBEaHUJuYDxQAesahA09sqNEqvKN7kKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601718328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2dCex4NV0q78QQ6HHDVxFCxf0TIoxjJwpJfVg4NwFI0=;
        b=52Eprre75WXQNlKY1yvV2cOlciWh5xyeU785flsHDbMq+Sf/ZQP8XtafxRm3o1IJV9iv6y
        8RcTUE2GR54if1Bg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set configure_vlan_while_not_filtering to true by default
In-Reply-To: <20201003075229.gxlndx7eh3vggxl7@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com> <20200907182910.1285496-5-olteanv@gmail.com> <87y2lkshhn.fsf@kurt> <20200908102956.ked67svjhhkxu4ku@skbuf> <87o8llrr0b.fsf@kurt> <20201002081527.d635bjrvr6hhdrns@skbuf> <20201003075229.gxlndx7eh3vggxl7@skbuf>
Date:   Sat, 03 Oct 2020 11:45:27 +0200
Message-ID: <87zh537idk.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

On Sat Oct 03 2020, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Fri, Oct 02, 2020 at 11:15:27AM +0300, Vladimir Oltean wrote:
>> > Is this merged? I don't see it. Do I have to set
>> > `configure_vlan_while_not_filtering' explicitly to true for the next
>> > hellcreek version?
>>=20
>> Yes, please set it to true. The refactoring change didn't get merged in
>> time, I don't want it to interfere with your series.
>
> Do you plan on resending hellcreek for 5.10?

I've implemented the configure_vlan_while_not_filtering behaviour
yesterday with caching and lists like the sja driver does. It needs some
testing and then I'll post it. Maybe next week.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl94SDcACgkQeSpbgcuY
8KYx8Q/+LgZgUMoAXmakqNHBouFf2VPipalrvOX2pYKcJ1WwfIKzQ+07Nf7PnfHa
b6sIR77uhl9tXg0/rF6NlFxec5B+qmaKPeEKIye7u8DWaU02yoM5RFBJcKEE06Ek
GZFF/AdOa4Bz+CU0dcDsK8BeC1OqStIh6b1kIoAmN5Uc2rYiyLObl7Zv89jeNFK8
tH/E2GsPn1+ORviKdrKIcSCwlFpLIIMqUhbtguyHsU2f+PYuZ3jk82hW59vbqhED
eedB8EDOzqwANYqm+dR+g/f7F5f5coNdQHQjxC4U0XHJPlQtrBRxY5i/hn/qwpVm
RVONOxjjO+M/hX0GBMg856SgMJwa1TmgES6l95UQYJuRCBq0M8jzN7PwZaRw0EUR
COEy4lClQIxCqwL3ilJHbXHYSg7+NZt/VeM1xEj39NOMWxuYVM0uCHjdQBXtDBHX
RzaDGL21rUsdovctqEzTd6Qo5wiS7UghYjbnzXSUg/G7kz0OQqakG27+m3PkbYnY
NkAnKK5N+WdDmPztdO4JZgW+bYgSmhjX1ikOlazVp2PKvwjAF2CZ24RIqR9/5SKG
3cZA+N5Gz1vsGlq6wfcZN0yp2GPFw9llEFA0keGSnP91EO2e3HKAzl1N5xedEqqf
HxsAk6ToWJ2Ewn9l0Sh11xBIuEMKiWK7S5Tdu1xqzIQwnwuaFiY=
=32E6
-----END PGP SIGNATURE-----
--=-=-=--
