Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7637B67933F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 09:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjAXIjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 03:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAXIjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 03:39:10 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F763A5A0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:39:09 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0C6FF21A1C;
        Tue, 24 Jan 2023 08:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674549548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jXpdjETorGM3+r22FTAZ7KeYShh9W1+1f0BTp9EaRoE=;
        b=esLc+tyFRyLcSM380E9EEBgUvITQt2sPT01bcBcUk3gGq+2yUFHmcxEnhMz5Nt1pg3UuLK
        7CXN+bR9TBMltvASr28eiLL4dzL65+4HX0R2RfUQqVefT+INxej6tomNQpEEfc39lBbpeR
        wTzQalCa/Bwkw8hoKlhPw2un7/2WqTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674549548;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jXpdjETorGM3+r22FTAZ7KeYShh9W1+1f0BTp9EaRoE=;
        b=bfA0YSY8DrMktbzJihvYLwatkeNVIRDZ8nePECeQNV6w7xN0Ho8zj92ZMueZZQv3TmSomL
        6pj5/nXh+Zuz1MCw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F09752C141;
        Tue, 24 Jan 2023 08:39:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C73F760488; Tue, 24 Jan 2023 09:39:07 +0100 (CET)
Date:   Tue, 24 Jan 2023 09:39:07 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH ethtool v2 0/3] Build fixes for older kernel headers and
 musl
Message-ID: <20230124083907.w7h6rbvh7fsq334y@lion.mk-sys.cz>
References: <20230114163411.3290201-1-f.fainelli@gmail.com>
 <20554c4c-bafa-569a-bdec-fc55445531f7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6rtfffon5ofb6a3a"
Content-Disposition: inline
In-Reply-To: <20554c4c-bafa-569a-bdec-fc55445531f7@gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6rtfffon5ofb6a3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2023 at 02:01:16PM -0800, Florian Fainelli wrote:
> Hi Michal,
>=20
> On 1/14/23 08:34, Florian Fainelli wrote:
> > Hi Michal,
> >=20
> > These 3 patches fix build issues encountered in the 6.1 release with
> > either older kernel headers (pre v4.11) or with musl-libc.
> >=20
> > In case you want to add a prebuilt toolchain with your release procedure
> > you can use those binaries:
> >=20
> > https://github.com/Broadcom/stbgcc-8.3/releases/tag/stbgcc-8.3-0.4
> >=20
> > Changes in v2:
> >=20
> > - reworked the first commit to bring in if.h, this is a more invasive
> >    change but it allows us to drop the ALTIFNAMSIZ override and it might
> >    be easier to maintain moving forward
> >=20
> > - reworked the third commit to avoid using non standard integer types
>=20
> Any feedback on whether you prefer this version versus the v1?

I like v2 more and unless I run into some trouble with it, I'm going to
merge it this week with the rest of the backlog.

Michal

--6rtfffon5ofb6a3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmPPmSYACgkQ538sG/LR
dpWJXwgApcPtiQzg+XecNUPUMX9jJLwAK01WZhfwH4qQoHXr8GdI7Y5Df6FpEJ8x
4VJr6o75gGHYiceE4xZphio5z8ld7F24xpRn6fnSa2Qi5YNd3s1nLBdT5CXbDxv0
gsUwhgTTFa3L7hCkiAXH0uihazilPrUECeBjpUDy91uFMP6HDZ4WdBbS6O2T4QzV
Vy+0rXJ7NgTbI0ZI1WJiznw5kdeEulb9NAEeFI6gHYAkwLJjjsH/xzk8PmZHOTba
CeGPeGfYnSJ0HZsQWfxhmfVQT1h3fFO0fetYkUPfyyDvGV6vCXJupzl4DMhO5NJF
M85fYSbyBcOxjzRGFbnnsQGd+Nkk5g==
=7wBK
-----END PGP SIGNATURE-----

--6rtfffon5ofb6a3a--
