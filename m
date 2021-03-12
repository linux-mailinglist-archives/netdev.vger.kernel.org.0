Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D318D3392CF
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhCLQLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbhCLQLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:11:12 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6A4C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:11:11 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lKkNY-00050P-NA; Fri, 12 Mar 2021 17:11:08 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: dsa: hellcreek: Report META data usage
In-Reply-To: <20210311231730.23wcckyzihmp6elk@skbuf>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
 <20210311175344.3084-3-kurt@kmk-computers.de> <YEqfOc3Wii7UTH8g@lunn.ch>
 <20210311231730.23wcckyzihmp6elk@skbuf>
Date:   Fri, 12 Mar 2021 17:11:07 +0100
Message-ID: <87h7lgcpyc.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615565471;82d84dd2;
X-HE-SMSGID: 1lKkNY-00050P-NA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri Mar 12 2021, Vladimir Oltean wrote:
> On Thu, Mar 11, 2021 at 11:52:41PM +0100, Andrew Lunn wrote:
>> On Thu, Mar 11, 2021 at 06:53:40PM +0100, Kurt Kanzenbach wrote:
>> > Report the META data descriptor usage via devlink.
>>=20
>> Jakubs question is also relevant here. Please could you give a bit
>> more background about what the meta data is?
>
> Not having seen any documentation for this device, my guess is that
> metadata descriptors are frame references, and the RAM page count is
> for packet memory buffers. Nonetheless, I would still like to hear it
> from Kurt.

Yes, exactly.

> There is still a lot unknown even if I am correct. For example, if
> the frame references or buffers can be partitioned, or if watermarks for
> things like congestion/flow control can be set, then maybe devlink-sb is
> a better choice (as that has an occupancy facility as well)?
> Fully understand that it is not as trivial as exposing a devlink
> resource, but on Ocelot/Felix I quite appreciate having the feature
> (drivers/net/ethernet/mscc/ocelot_devlink.c). And knowing that this is a
> TSN switch, I expect that sooner or later, the need to have control over
> resource partitioning per traffic class will arise anyway.
>

True. The switch can actually distinguish between critical and
background traffic. Multiple limits can be configured: Maximum memory,
reserved memory for critical traffic, background traffic rates and queue
depths. I'll take a look at devlink-sb for that.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJKBAEBCAA0FiEEiQLjxJIQcNxwU7Bj249qgr3OILkFAmBLkpsWHGt1cnRAa21r
LWNvbXB1dGVycy5kZQAKCRDbj2qCvc4guQxOD/0dc5ihNzB806o/MforbRMYWN0w
Yhl9K8ABCKJ8PkL75huWpqXpExT6QUmqsS59+ljY/j4jWEovBKxY6VULFh5iLqip
Z7lLtULJ60FE9hh2D9ao1K1kXklMPrcbBxAJrurANC4f5NTX2AH6WnRcyA5DYDOp
Imlmix8r76Pu4bP+pTT/jpT8Moysxa6jWvlYHHcRosGCAT/jG5v8RkTblBJLMcIi
zIHirgb5EPKlkSKvd4SfFMamFZeVH2WvJvE0P3kXLwVMBIc7iZBChHTSd2VBaeYR
qgDDhSucPptC2mhX5+sLxiCGy7it2DDo/RBAfXi7zCTPIyPjM/QvHgQnOCtY1Abl
I77kOW3UeV2q32kAY3TWG+ASfEk0uqtO1kzu2xNYMFtc+DuIcTou7yZ2vGBiLLKa
v3+nBXKfV3ylc0EmyIlqQ1bqXfgn6Hkt5XbQ2ZpcHBT+owIe2wMx8QNDpc6f4zmd
2L6++6Ux9d4tKp/t/PGvnAar6+ToYSebxbSieqeA5PR8OponYynWtjy7bHcDzdev
RYfAh7maPz/oBkJjLhV+VJzdFZY6EgRaY8ONxOAd36k292+aFrpEKuRy1lB6tqi3
qIZmb/i0wOxx8KHpMZOM35DOW8T0viDRam/3lcuNMYIfQqzaEkKMRb/JlvDw6EcF
ih4tZ6ynAiy6IKBJ3w==
=e9tG
-----END PGP SIGNATURE-----
--=-=-=--
