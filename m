Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAD06499BE
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiLLHva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiLLHv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:51:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540C5B86B;
        Sun, 11 Dec 2022 23:51:24 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670831481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R/b1PEiCv1fKzGOxSbiyZDN0HigW/1OSYfLKLOqVpx0=;
        b=A+bB8E2vvc9wH5nBPnOfRvzsuOmo8YLVrfpEkRY/Y1UU8n/LROf5FE9OgCV3AbYiIsqgUe
        Y1MBqpFp5qPoL5uIplUrEhPendybXGWyHXW+5PVyfta7HnCKh/BOOQAS2ZzQ/gR7zzBx9Z
        a1phKjPd68JtJK6hUbIKn24CO5nfd9h0GaujfOCql84PTUDbmPwiE6Buq+YqJw8X//+WAA
        sVv8/PE2Lh3ZNZIc7XhT+pQ4Z4c1LAz03px2YUCjWQcLW4Iivu2MC6wmrXWcJUv7avV0qC
        vX0GsZ+Z2N6U4lTVh8KT0+cMORdUPPgddMR9QTOcJkzBMUQiHg2Y+9Lh7p8CyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670831481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R/b1PEiCv1fKzGOxSbiyZDN0HigW/1OSYfLKLOqVpx0=;
        b=fkBD4w8mCeUebYSbNeQAEZiKPII2aGaB6deOItFKlIwrAdc0TG+AJu3jR3ToVmUFFDw4Ta
        HtfebAc/G83RbSBg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 01/10] dt-bindings: dsa: sync with maintainers
In-Reply-To: <20221211225823.nde77nlfriok4q6x@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-2-colin.foster@in-advantage.com>
 <87o7sbh896.fsf@kurt> <20221211225823.nde77nlfriok4q6x@skbuf>
Date:   Mon, 12 Dec 2022 08:51:19 +0100
Message-ID: <87mt7tt5zc.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Dec 12 2022, Vladimir Oltean wrote:
> On Sat, Dec 10, 2022 at 11:18:29AM +0100, Kurt Kanzenbach wrote:
>> You can update the hellcreek binding as well. Thanks.
>>=20
>> diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcr=
eek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.y=
aml
>> index 73b774eadd0b..1d7dab31457d 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
>> @@ -12,7 +12,7 @@ allOf:
>>  maintainers:
>>    - Andrew Lunn <andrew@lunn.ch>
>>    - Florian Fainelli <f.fainelli@gmail.com>
>> -  - Vivien Didelot <vivien.didelot@gmail.com>
>> +  - Vladimir Oltean <olteanv@gmail.com>
>>    - Kurt Kanzenbach <kurt@linutronix.de>
>>=20=20
>>  description:
>
> Good observation. If there are no other comments on this patch series
> (which otherwise looks reasonable to me), I suppose that could be
> accomplished via a parallel patch as well? The diff you're proposing
> does not seem to conflict with something else that Colin is touching in
> this patch set.

Sure, it shouldn't conflict. I'll send a patch to update this
separately.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmOW3XcTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzguuMD/92WZk+2aqc2j0T+MK9KJHhGJ1tCGkp
XuowkXMdvKL85HUq/E4MD8Sek6H8QtzHw8tKFTkku2Vhszo2bV6cr65bajQGVmr/
uCwP5WqsHXzbjWiZcv4f+0/yZ2/Pvif0DMNHvGsI+GvZurrwvZLZdQBvQ/tw0CyC
/6S78qGSxcB15Fwyd/My0oS04qLr1yYG9rZTuV8mQiGwTPu+1iv8lAQNarMWhRx+
a9rE7roZqUDO7OeBfNmz4gzHPTkadG9jUCpy3U9YQOq8k+rdLmuEN6kt+Mh/DFVv
QgX8b0/hCVt0io9vq3Z1wrkM8xXuQ+54z1Yq/E0VJ6+RnngnkmSUwGso5/JLI+p4
+g1BCFw6MciOaEtinHKYZTjUQ++KakbaS4TiYlnNuW4HIEJ8EGOad1PJzBNuvd7g
9Hc+xx8DiRwjzZ54ME4OfsKIvb461+uZvpNgTg/A/QVtz+TweTFEa7zXagGxgshs
mNotZdRcqAMIUrX+4pvuf5iLV98eTK7QLvIorPhPhfnLRTNKewXuxyC/iUDsDtf5
c/iJPpOalSER1hDHakNs35E0I1OHgK4VxbbTpiJGv0NS7h6JzoTJ7dMnluBSnSPe
7hUmGbffICETV4LW+Qv0BznRKWBwJEdhfTccr+V2EJEsNmAVQYLcv7mrg3P/Ew+J
U6K/Q1zEc+X79A==
=xWGZ
-----END PGP SIGNATURE-----
--=-=-=--
