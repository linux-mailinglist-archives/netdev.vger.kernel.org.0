Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0E7342C38
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCTLb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCTLbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:31:17 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633A1C0613E7
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 04:31:17 -0700 (PDT)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lNZp3-00043D-2A; Sat, 20 Mar 2021 12:31:13 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: dsa: hellcreek: Add devlink FDB
 region
In-Reply-To: <87pn01ga9p.fsf@kmk-computers.de>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-5-kurt@kmk-computers.de>
 <20210313114647.4njhja3qsquu225q@skbuf> <87pn01ga9p.fsf@kmk-computers.de>
Date:   Sat, 20 Mar 2021 12:31:04 +0100
Message-ID: <87h7l6kqo7.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1616239877;af5033e4;
X-HE-SMSGID: 1lNZp3-00043D-2A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun Mar 14 2021, Kurt Kanzenbach wrote:
> On Sat Mar 13 2021, Vladimir Oltean wrote:
>> On Sat, Mar 13, 2021 at 10:39:39AM +0100, Kurt Kanzenbach wrote:
>>> Allow to dump the FDB table via devlink. This is a useful debugging fea=
ture.
>>>=20
>>> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>> ---
>>
>> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>>
>> By the way, what user space program do you use to dump these? Did you
>> derive something from Andrew's mv88e6xxx_dump too? Maybe we should work
>> on something common?
>
> Actually there is no user space tooling, yet. My original approach to
> debugging was different using debugfs and tracing. I played a bit with
> mv88e6xxx_dump today. Having a common tool would be quite nice.

Thanks for the pointer to mv88e6xxx_dump. Just needed to implement
.devlink_info_get() callback, so that the tool can distinguish between
the Marvell and Hellcreek devices (and implement some hellcreek
specifics).

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJKBAEBCAA0FiEEiQLjxJIQcNxwU7Bj249qgr3OILkFAmBV3PgWHGt1cnRAa21r
LWNvbXB1dGVycy5kZQAKCRDbj2qCvc4guTPOEACsbiWMBfhyB5QHjf7n1lrIM4YN
jBIAoQs8lSNw40PebiK+LeK9Tjp+3ULygAOIy/kAqC/mXjUdH1+wCPUPNrpqvkRI
s7Dw/ZCQbpnTQdymmzc9UrWRalOfpYBylb+Zp/r4loVFbs/KQF/jA7woKNNr12rp
QibujYI17v9gCnUV0CouIj1BbaMuL0o+ID5TZ0HJ8DSUCmjDbJ3RZgL7240pgeqR
evWzzHkUAVLazS6okKZbCgy43bi61Udf5kO3IC+Nqy/bDNYLO4GTmMlwibL5IhnP
f4QUmZBuopdFUAdzJNDU7IGzQKB7khlLa+GVY2nH3pxY0sLeaWwYmhrKhfpaEnF2
oVrmSMWddKxukGIgHD9APTLGYABBntbo9j2gs7VKPH3+vrsxw8EXB+n4Fsk4RTr9
67Ljhe+Ev9ZQjMM/3yojx7nin8S1/km8zycEdQKDZfjEKIQ1S47pbp7ELQk0sDeH
xHXLP/mQ/60QTgzIrl84Jhuf5WRKdLBLkmdLHoapKnB0TLmgngDr3+avrD8Sf9H3
Vy9UtnCwsI79XK3SsGqs5CCvyXdQg39WDAfeE+aCNlQRFfr0UyoCiYb1DDu+u9gK
pW25Cj/DEuNUDTMXzDRCuz0IJ3TTRWB+yhRVhr9/To5ziB4w2mCzUjQ1PG8r6cRT
a1jgoSPJhocv7Qirag==
=WmWQ
-----END PGP SIGNATURE-----
--=-=-=--
