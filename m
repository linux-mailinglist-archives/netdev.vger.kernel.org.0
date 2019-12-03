Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CEE10F9DC
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 09:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLCIb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 03:31:56 -0500
Received: from smtp10.hushmail.com ([65.39.178.143]:49494 "EHLO
        smtp10.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfLCIb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 03:31:56 -0500
X-Greylist: delayed 1960 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2019 03:31:55 EST
Received: from smtp10.hushmail.com (localhost [127.0.0.1])
        by smtp10.hushmail.com (Postfix) with SMTP id 2E7C8C0213
        for <netdev@vger.kernel.org>; Tue,  3 Dec 2019 07:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=hush.com; h=subject:to:from:date; s=hush; bh=ngKkUxsprbuh4pj6mw365GDsCFBqSXUfDBd1yXzqwEU=; b=MbPGNc/mI9a6L8lNty1sxCTR6+PF84yqb9fun76sZ5oOOwJp1pwBY0IQ0weUApTVx7CO82yPPRMWxZY3dbPacO0uZ0q4sVb0SIu56XhdbihzvWcZdFWosCvR7CgpiwgrQmeaivwoj47NKJvuMpALYFzi6MiLzuThf/uL31oXCGCvFcYx2cm/pMNgR8GWudpFkDgZ2gD4cRF8yxcpcPtLleDgs1pvgpCw0r/hYiP+xqi+Sh94us+IcCaSsxTZwWTDyEsgUJKYpwZUQc6oKA/KBtbR6a9S/dgz8DfBn+DHG3g3mjYUmQ6XG33+W1wzfNMQusj4SR9DnxfQSOaA0k8QxA==
Received: from smtp.hushmail.com (w5.hushmail.com [65.39.178.80])
        by smtp10.hushmail.com (Postfix) with ESMTP;
        Tue,  3 Dec 2019 07:59:12 +0000 (UTC)
Subject: Re: [ANNOUNCE] nftables 0.9.3 release
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, lwn@lwn.net
References: <20191202211737.xvmd6e6xxj4xvvjl@salvia>
From:   =?UTF-8?Q?Pawe=c5=82_Krawczyk?= <pawel.krawczyk@hush.com>
Autocrypt: addr=pawel.krawczyk@hush.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2361052f72a1c9f41e2e08fc3120dd3f@smtp.hushmail.com>
Date:   Tue, 3 Dec 2019 07:59:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191202211737.xvmd6e6xxj4xvvjl@salvia>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="pYFe9sK7NMPWVZo2NgH9N5JYQ4ghI8OoX"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pYFe9sK7NMPWVZo2NgH9N5JYQ4ghI8OoX
Content-Type: multipart/mixed; boundary="tXJ04uwfTsNTqHXMLTSWcC4x3BBHFmDt4";
 protected-headers="v1"
From: =?UTF-8?Q?Pawe=c5=82_Krawczyk?= <pawel.krawczyk@hush.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter <netfilter@vger.kernel.org>,
 netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: netdev@vger.kernel.org, lwn@lwn.net
Message-ID: <93188ba6-98dd-5c8d-c63d-560978cb742e@hush.com>
Subject: Re: [ANNOUNCE] nftables 0.9.3 release
References: <20191202211737.xvmd6e6xxj4xvvjl@salvia>
In-Reply-To: <20191202211737.xvmd6e6xxj4xvvjl@salvia>

--tXJ04uwfTsNTqHXMLTSWcC4x3BBHFmDt4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

On 02/12/2019 21:17, Pablo Neira Ayuso wrote:
> Hi!
>
> The Netfilter project proudly presents:
>
>         nftables 0.9.3
>
> This release contains fixes and new features available up to the
> upcoming Linux kernel 5.5-rc release.
>
Just rebuilt & uploaded 0.9.3 to https://snapcraft.io/nftables-pk/ for
the benefit of those using Snap packages.


--=20
Pawe=C5=82 Krawczyk
+44 7879 180015



--tXJ04uwfTsNTqHXMLTSWcC4x3BBHFmDt4--

--pYFe9sK7NMPWVZo2NgH9N5JYQ4ghI8OoX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: Using GnuPG with Thunderbird - https://www.enigmail.net/

iQIzBAEBCgAdFiEEL2n/LhkSGC2mB34xT/iLCcHmSxAFAl3mFcwACgkQT/iLCcHm
SxB9IhAAzpZ0IoCfqc7rYnKA9BhOFx6+pGxb7uP25nhHGWTJTvjIfLGgs4J5xZxi
DOAUZPYqagMDl/l8YLxHCuED7/sr21OvId2OZF13ihufvt3aCGBH7/LpZm2vP8Zx
r2CBnic+1Te9nGMwrLvU8vuPJl2k8hFrpw2v1Ycpr06H1msG2fWPt8TB22rGGGu6
GtZtPwL2WE1f/zalUlTbq0Oprnvo3XQJGOt9DJtkKucEc2i1J2PKDrmNA38AppR6
xuF8dWlSXmoz1t6GgqJzOV8MuksObcEGsqDPAa1xzvs+Jeo0yTapM4U7LkzmsAot
nX9qX4KXCxANnzLTSd+UhDhMnRLaAiSEYo3qHFLvNQ8uCExDw2tt+ep+nyEYAZQu
J5TJFzRxbC/kMonxQrhguV3/8NzImurNVPOgrQW72zN31CTkFhapp9s9UtOj4k5M
zuWWjV/Nf1Jca8vmWa8y8vrVkxSPRxThwafq+wAMXbzjQ7hYXbQkq18upQi1UAZX
cwX2JIAxUdlm120Q2JnI8+lusnyemSukCpPjAKhJUzt86nnrEQU5Wx6JtFV0lFI+
WUtqWQyISUS5AZM+q0LTGDkv3sD2f7kxoQv+21TspdUmh2LT03LYwnHLu3EEeM61
+e6f8QvYHOFD9u+4KYhmJu3Up+zQ4r32jn25uuaRJSOrjO72glc=
=hy8V
-----END PGP SIGNATURE-----

--pYFe9sK7NMPWVZo2NgH9N5JYQ4ghI8OoX--

