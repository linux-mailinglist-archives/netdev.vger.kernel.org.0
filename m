Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1149D33A4EC
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 14:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbhCNNBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 09:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhCNNBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 09:01:07 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A84C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 06:01:06 -0700 (PDT)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lLQMi-0001Jp-1E; Sun, 14 Mar 2021 14:01:04 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: dsa: hellcreek: Add devlink FDB
 region
In-Reply-To: <20210313114647.4njhja3qsquu225q@skbuf>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-5-kurt@kmk-computers.de>
 <20210313114647.4njhja3qsquu225q@skbuf>
Date:   Sun, 14 Mar 2021 14:00:50 +0100
Message-ID: <87pn01ga9p.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615726866;b6ba479a;
X-HE-SMSGID: 1lLQMi-0001Jp-1E
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Mar 13 2021, Vladimir Oltean wrote:
> On Sat, Mar 13, 2021 at 10:39:39AM +0100, Kurt Kanzenbach wrote:
>> Allow to dump the FDB table via devlink. This is a useful debugging feat=
ure.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>> ---
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>
> By the way, what user space program do you use to dump these? Did you
> derive something from Andrew's mv88e6xxx_dump too? Maybe we should work
> on something common?

Actually there is no user space tooling, yet. My original approach to
debugging was different using debugfs and tracing. I played a bit with
mv88e6xxx_dump today. Having a common tool would be quite nice.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJKBAEBCAA0FiEEiQLjxJIQcNxwU7Bj249qgr3OILkFAmBOCQIWHGt1cnRAa21r
LWNvbXB1dGVycy5kZQAKCRDbj2qCvc4guUo3EACopinCmPWhn2p5k7WXSMBM75Hz
a8yzbDfwmE0UCswBE2AYhmwMdw40TIOgj/jbBjQQv6Oz29dQvSrplKRAVzxGgIZB
fxZ4lds9DCTnV34L68HqIQJx9qj+wpZkNG/LbHOgA8lbAEke4KDtPlZdNzyfP05v
xjUHvr/th+lwP0ZmFc+UxQxUpF7qKmNzzbGGJbN5B7YjGtZTRbGjH4YJabvxzqB8
EHlKwV2J8RKDo9oxSeca/1ehOfAdh0kOzfXX70U24Jpv1NbwMSB9TNGGx9cJRgib
XLY7LoC+tGMGWcce3j2BkasU3vmaV5h5sGoD4IovwdKTqjnQQF/+NXREayp+Felb
bhXK3To3iJHlP5waXfrty04KAt2xUMTEjFSiGNor2rID7WVMLBHdwydHgWUlYPh0
gfdNxI9YFi4gMN+SvasgXXu1ZTDpcKK3pjS2BxcNo3Xt/dQE7J7u5PIRY3r7JxZ6
eFoui+FdqrEbjTWKcaSOyvB3IEcHAsamxj34Frxu2i0EYDLrqn9WP9SBXtdVGwk2
Ep2Zs4cMaLL9Qqsfs3C7M7EbeCdi+VeMTVbZktWDRS71ZVZWBzPZxAtQ61zK8kNR
w9RS3TX2MWyiTrWDo1bE5gKvFob6spjHorD8wsjp41pirdc5GHrSVdKtuj6Ci0Ih
wcLME6Y16ivre4Ptog==
=3DJH
-----END PGP SIGNATURE-----
--=-=-=--
