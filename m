Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D499E33C7C5
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhCOUeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbhCOUd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 16:33:59 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69303C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 13:33:59 -0700 (PDT)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lLtuU-0005dl-MJ; Mon, 15 Mar 2021 21:33:54 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Offload bridge port flags
In-Reply-To: <20210315200813.5ibjembguad2qnk7@skbuf>
References: <20210314125208.17378-1-kurt@kmk-computers.de>
 <20210315200813.5ibjembguad2qnk7@skbuf>
Date:   Mon, 15 Mar 2021 21:33:44 +0100
Message-ID: <87lfao88d3.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615840439;2fcda578;
X-HE-SMSGID: 1lLtuU-0005dl-MJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Mar 15 2021, Vladimir Oltean wrote:
> On Sun, Mar 14, 2021 at 01:52:08PM +0100, Kurt Kanzenbach wrote:
>> +	if (enable)
>> +		val &= ~HR_PTCFG_UUC_FLT;
>> +	else
>> +		val |= HR_PTCFG_UUC_FLT;
>
> What does 'unknown unicast filtering' mean/do, exactly?
> The semantics of BR_FLOOD are on egress: all unicast packets with an
> unknown destination that are received on ports from this bridging domain
> can be flooded towards port X if that port has flooding enabled.
> When I hear "filtering", I imagine an ingress setting, am I wrong?

It means that frames without matching fdb entries towards this port are
discarded. There's also ingress filtering which works based on VLANs and
is used already.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJKBAEBCAA0FiEEiQLjxJIQcNxwU7Bj249qgr3OILkFAmBPxKgWHGt1cnRAa21r
LWNvbXB1dGVycy5kZQAKCRDbj2qCvc4guVVpD/wPd0jFmp2+iq6gJQ3zA86IfIlT
sm6tneyr4GxCZqFlIUrA6G0XIYhKye6/f0ZFrCdITo5o7Wfp/VnBr/0U9YvsOxCj
7XAyCPjRR2/FLevjBpkJ5nWP8iqHi5pbR7nn8aTQRjuPKdxLaXLA6ttgI+2E3p1j
dgiv6Z1j0OXPfpaVRS8fuT05BuswO1l9TpWolO347/KWb/CiFnHOmRuriOAkqj0f
cAu6F5z+oicdqbLba+VeIRcH3xDhcfZslLEn+JS0ZhA87GwlSVCGJEv698ZXTqmU
K/tOfz/a4AFORHhrTaOymVeEKBVpz51mCL7A3V+yol7wrIf1We3y3Db0eU/0uf/e
z/cZ/F0wHC3nTrmZoIyXGaKxtbd0vGV/UaqxuCBiun8TL0PboEPlMSK788PRQC4F
y4/scdtq2B6NxVY9POw32GC34mqgH2Zw85A8QXqOXrsQDBn5bDD/xarZ2Yv3AlxH
Di/iqyKbOPpdHhan5ChBqQYfXBiGU+jNItagT+8ERnZkHpYVXlD0SR43F0f0ecjS
1RohFt1oXzJOpBnj1PuJ+At/GYOzGn5gZXN2hIabZn0tCf/f7MKta/fCt1/hGAg9
sJM1Yg1x6I5HfxCEaWP4PBsnhxvI6pvmOfIQdpV3Q/2YXYJxzlYzPv6vLfMtu/LX
bcVwiflKmXLUlcjtiw==
=dvcH
-----END PGP SIGNATURE-----
--=-=-=--
