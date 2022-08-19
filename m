Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD44B59984C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347244AbiHSJGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346731AbiHSJGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:06:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563C5EF030
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:06:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0057320741;
        Fri, 19 Aug 2022 09:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660899998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0BTDuYxghVuZdUvjvPdt1qWufMQeaYFGEF24vaXP9nY=;
        b=IiRXhkRytGAPc5tH76EOzgyHsj86jCVNdE3xNs8Sbj6r43Tf95mcQnqGJIslJ8r2outO6N
        IMB22vqtqjGQRUaiTopb9x34rGwE6/F9kgC0duHfO/fzzF0JcWfglTbmwP3va94u9/mTGR
        3ShrHgrxj9w00CylT7+U78+GWtZHNIc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660899998;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0BTDuYxghVuZdUvjvPdt1qWufMQeaYFGEF24vaXP9nY=;
        b=a3J8EHyyjVedYZKKUPdt5IcSZhyjmBEeOVVp1O4j0J0lplnSfCO6nDguxoUgUWIg+yGD0A
        dkwqUJRJvPxM7YCw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E8F032C141;
        Fri, 19 Aug 2022 09:06:37 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C32DB6094A; Fri, 19 Aug 2022 11:06:37 +0200 (CEST)
Date:   Fri, 19 Aug 2022 11:06:37 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Krzysztof =?utf-8?Q?Drobi=C5=84ski?= 
        <k.drobinski@camlintechnologies.com>
Subject: Re: [PATCH ethtool] ethtool: fix EEPROM byte write
Message-ID: <20220819090637.3u7o3xmuafftbzlf@lion.mk-sys.cz>
References: <20220819062933.1155112-1-tomasz.mon@camlingroup.com>
 <20220819082717.5w36vkp4jnsbdisg@lion.mk-sys.cz>
 <9c2c52a9de5fdcc1a3a76f564da4c20db098e9a2.camel@camlingroup.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lbeqia4ldz77ajul"
Content-Disposition: inline
In-Reply-To: <9c2c52a9de5fdcc1a3a76f564da4c20db098e9a2.camel@camlingroup.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lbeqia4ldz77ajul
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2022 at 10:58:19AM +0200, Tomasz Mo=F1 wrote:
> On Fri, 2022-08-19 at 10:27 +0200, Michal Kubecek wrote:
> > On Fri, Aug 19, 2022 at 08:29:33AM +0200, Tomasz Mo=F1 wrote:
> > > @@ -3531,8 +3531,7 @@ static int do_seeprom(struct cmd_context *ctx)
> > > =20
> > >  	if (seeprom_value_seen)
> > >  		seeprom_length =3D 1;
> > > -
> > > -	if (!seeprom_length_seen)
> > > +	else if (!seeprom_length_seen)
> > >  		seeprom_length =3D drvinfo.eedump_len;
> > > =20
> > >  	if (drvinfo.eedump_len < seeprom_offset + seeprom_length) {
> >=20
> > I don't like the idea of silently ignoring the length parameter if value
> > is used. We should rather issue an error for invalid combination of
> > parameters, i.e. value present and length different from 1.
>=20
> This patch simply restores the way ethtool 2.6.33 - 5.8 worked.

Right but when have to touch the code anyway, let's improve the
behaviour.

> Setting length to 1 matches ethtool man page description:
> > If value is specified, changes EEPROM byte for the specified network de=
vice.
> > offset and value specify which byte and it's new value.
>=20
> What about changing the code to default to length 1 if value is
> provided without length (so scripts relying on the way ethtool 1.8 up
> to 5.8 works without any change), but report error if user provides
> both value and length other than 1?

Yes, that's exactly what I meant. Using length 1 as default if length is
omitted and value present is perfectly fine, what I did not like was the
idea of silently adjusting invalid combinations of parameters (value
present and length different from 1).

Michal

--lbeqia4ldz77ajul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmL/UpgACgkQ538sG/LR
dpVJrgf6AhM4Ca6h2D/gUkjQybCB7rgNG7c9ha/pIwtAPAuAUE0iZNAs/OIaD7FP
OjfjJugI71O6xWlipQOPCdsnc1UB+XMUG17kUptG9mcCo/wl1/nz7bGiM7Ji7hDR
IbkW2DDAnjVGAafosm3rfKLFUuSxBHQqY89JchqENtBgg10IQB1qPSnyMiTM9jkg
MqspSjE2lPnfg7bC6E6lbjq5RZmlh2UxWGb+1ncjS4U5MVAFnA8DOCkodW/3f6Ax
XLQbnEkxBTOnG9/PoC2YmOiqyw7wbiDroer2lI+/X7xovUXmEjVIy9siQttPb3ow
2OoiwrP8HL+rIMFuwNWqLsRETDG7TA==
=wK/f
-----END PGP SIGNATURE-----

--lbeqia4ldz77ajul--
