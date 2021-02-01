Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C2F30AD3A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhBAQ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhBAQ5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:57:55 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFAAC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 08:57:15 -0800 (PST)
Received: from p548daeed.dip0.t-ipconnect.de ([84.141.174.237] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1l6cVh-0006QI-Pb; Mon, 01 Feb 2021 17:57:09 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: dsa: hellcreek: Report tables sizes
In-Reply-To: <20210131212826.dcr2cur4cf2xlhje@skbuf>
References: <20210130135934.22870-1-kurt@kmk-computers.de>
 <20210131212826.dcr2cur4cf2xlhje@skbuf>
Date:   Mon, 01 Feb 2021 17:56:09 +0100
Message-ID: <87eehzbuc6.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1612198635;20a1e777;
X-HE-SMSGID: 1l6cVh-0006QI-Pb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun Jan 31 2021, Vladimir Oltean wrote:
> On Sat, Jan 30, 2021 at 02:59:32PM +0100, Kurt Kanzenbach wrote:
>> Florian, Andrew and Vladimir suggested at some point to use devlink for
>> reporting tables, features and debugging counters instead of using debug=
fs and
>> printk.
>>=20
>> So, start by reporting the VLAN and FDB table sizes.
>
> I don't remember having suggested that, but nonetheless it doesn't seem
> like a bad idea.

If I remember correctly, you also mentioned to use devlink to dump the
databases via regions.

>
> By the way, your email landed in my spam folder, I just noticed the
> patches by accident on patchwork.
>
> Sorry, I am not competent enough in email headers to tell you the reason
> why gmail flagged you.
>
> 	Why is this message in spam?
> 	It is in violation of Google's recommended email sender guidelines.
>

Thanks. I'll look into my setup.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJKBAEBCAA0FiEEiQLjxJIQcNxwU7Bj249qgr3OILkFAmAYMqkWHGt1cnRAa21r
LWNvbXB1dGVycy5kZQAKCRDbj2qCvc4gubp3D/92siQoeP4kdcJuvOEswSguo2fN
Lqpo+LLCyI7j1Qq0F/fFF/PUFvfQc8qW9p9CcTuERMrqTkqdN/Ggfw8SOQ0P8ZFU
jyjtLZVlD8azrh2twIBeVMh2z76gwqP7XGGEDyWzE3b0/RA6wA+T2thCsMrdf/e8
YTvn54/s+ONkOShVXyK0NYZzSnhulF7MEvcFka+RXqXt7XSnUIZx8ZX82m3RbwP8
GOmnUyde7UPHY4QSJCFAW89unpgpbSg5TOHqDKzDRWjWnPogE5B/UcHXI3OEsbzI
RsEjF6/u02C7OgXtBwwdwhScg0deI3+M3ICPJlz587Y/69p7ee4aG+l0/BCoeIwQ
/HuWq3nwgl6/3wZKKJnOLmNIkMWCYqdAXxB13qwYOyV0Y4L2PPfve09xgRxaYJAQ
7+zQNRryYpS713QhqFagkbIN0P/TZdnXu67vMdhdaIy4a53Zib1AWwP/S2I0r5rv
qh+Q3zXUR9oLsWpON++1vkstVFNvLwbQmW75y0CdB4bttHbZTB+JnOvMlu9Pd8bK
9qQSAoWdkqrV/EUBXORHquES+vl0DYKtOnhlz1E5NqDKHHCcZSHe5cQaSkM8UnFz
Hpok8bXjFWLACQ5mDqRt0aVUhs3e0x6Mv8XlPdPKxSC791Ev3RFNALaBp34uwchM
qxoLL2GJmHL0G9N9hA==
=qkk1
-----END PGP SIGNATURE-----
--=-=-=--
