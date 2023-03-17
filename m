Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA66BE05C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 06:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCQFAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 01:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCQFAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 01:00:35 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629EA4DBF5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 22:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=XqB12is+kKUQInBlIS2SuiteZwZo
        5y3HKbz0OXT3cB8=; b=Nw7+UxfHAqvfkzXwnvjFT20v507LE2gl58Ld0oEBasXz
        oUVbde5VlPSewH55So9G2xcWSPkr6zFJ0FvvB8G+O21omvXna9ZcYtf5fjSeFLYk
        fyEilLpwA4kcDr3G99bXcV0K/t09bDFkByMpTsnxFDL0E82DxVHh17nNm889d9I=
Received: (qmail 4104850 invoked from network); 17 Mar 2023 06:00:27 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 17 Mar 2023 06:00:27 +0100
X-UD-Smtp-Session: l3s3148p1@KwmDdBH33ogujnvb
Date:   Fri, 17 Mar 2023 06:00:24 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "net: smsc911x: Make Runtime PM handling more
 fine-grained"
Message-ID: <ZBPz6Ads0dOT8ceT@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230316074558.15268-1-wsa+renesas@sang-engineering.com>
 <20230316074558.15268-2-wsa+renesas@sang-engineering.com>
 <CAMuHMdURZ-nC-yZua1wGCcW++fDhgd-U93KP3PT5v6cbm8305A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SS7CshjXnRjbyo7D"
Content-Disposition: inline
In-Reply-To: <CAMuHMdURZ-nC-yZua1wGCcW++fDhgd-U93KP3PT5v6cbm8305A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SS7CshjXnRjbyo7D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

> In sh_eth this was fixed differently, by adding a check for
> mdp->is_opened to sh_eth_get_stats() [1].
> I believe the modern way would be to add a check for netif_running()
> instead.
>=20
> Would adding such a check to smsc911x_get_stats() work for you, too?

Yeah, that worked. Thank you! I'll send v2 soon.

Happy hacking,

   Wolfram


--SS7CshjXnRjbyo7D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQT8+QACgkQFA3kzBSg
KbZ0JBAAkAPwb+0C+ARVJB1Al8Hhln5uG1ezKfroDEoHiiUQCE+RgLbnfd5r7PLc
XU30ZgvwuS5/G7fVphgY3hPIp8oO3sI6Hms1wkvb/lcHvheyeejZB0HHxLcaebdJ
FgqkC7UUZ3ltC6xHgjVgJDPrI2tZH0sNPtzNRLmQ3vvD2YMeU6NZWSuHNIt82YFM
EPUdVOwBFm3V/M0PF6MkCrCA6e/R93wHvSeYjJbNdxQ840bWieTCTRTrbLtMVkjz
Gk4BnMElJcOPVyE9wpcdMgoU8DJ6H55wUpq2ACc9nY6d225VQU/z+Du70vpPZSlD
/of0x6ScFRigLQ2NDJTiWWKIzDh/bA/yKa482UZVimmQeUySnMCcyB/IM9cFWPnT
4znt9odurbULOtS9uBY8VgL0LZYdlHSJwQExYus7w8yuKXZW+iMWLC1bhOIto7GN
MZCX3NSo3RLYRTp/lM4Px3xNdJoTqhSuozGfjqB/mGuyGAthdeR8uzucb+p7R/U4
vPKgIXgMb1QNdURHTMnjVLB/oXCYahGPxbd1dEfJkiJCIVmHXANYXaloZz5G2hD5
Mjbo87rMguJM61xK6j1WrkUXalGGl5a9uMUZyJUVU0x5SNOsR1pAVq8rqmc2XCK6
2HqoU2JCy7JL2uzMNu89Sz1SatUoEjTgs0Y0vxfxUil3cBbHpeg=
=aRKd
-----END PGP SIGNATURE-----

--SS7CshjXnRjbyo7D--
