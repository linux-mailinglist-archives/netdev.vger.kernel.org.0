Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BC9641FD1
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 22:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiLDVZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 16:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLDVZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 16:25:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA1712D34;
        Sun,  4 Dec 2022 13:25:26 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 88E6A1FD77;
        Sun,  4 Dec 2022 21:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670189125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bsz01VJIuUQ0mC3I2VX+QCIPQRKPDYB/XAPjTNya8AY=;
        b=AFXqTzENJfRnmjWK7r3VV2zsuECch1Ho9LTVtZ5MjAQgqjRajbuqCj6AeRuqwtHFrqYsVI
        pBDm6rAgCjvPijukD7IyelDN1U9P1KFCb7Vs+UoB8jRzc/ByxmmfT/eCYWbVCGMQroBZRK
        pFJGnuWxlCA0yZWVO6faivcvLyW01zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670189125;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bsz01VJIuUQ0mC3I2VX+QCIPQRKPDYB/XAPjTNya8AY=;
        b=rU5udh2hX5ynJUTMHrfmI9oeCf8+p7xtG1V9xKwI+Ijt9lSL9Z/qOuUGZ1OBZEovFgD28q
        MGNc1axXry6SbIDg==
Received: from lion.mk-sys.cz (unknown [10.100.225.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D23212C141;
        Sun,  4 Dec 2022 21:25:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A2E776032F; Sun,  4 Dec 2022 22:25:21 +0100 (CET)
Date:   Sun, 4 Dec 2022 22:25:21 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 1/2] ethtool: update UAPI files
Message-ID: <20221204212521.rjo5hgkmsq3spxzv@lion.mk-sys.cz>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
 <0f7042bc6bcd59b37969d10a40e65d705940bee0.1670121214.git.piergiorgio.beruto@gmail.com>
 <Y4zVMj7rOkyA12uA@shell.armlinux.org.uk>
 <Y4zduT5aHd4vxQZL@lunn.ch>
 <Y40OEbeI3AuZ5hH2@gvm01>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="axjmhhdgc3jec5yx"
Content-Disposition: inline
In-Reply-To: <Y40OEbeI3AuZ5hH2@gvm01>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--axjmhhdgc3jec5yx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 04, 2022 at 10:16:01PM +0100, Piergiorgio Beruto wrote:
> Hello Michal,
> I was wondering if you could help me with the issue below.
>=20
> In short, I'm trying to add a new feature to netlink / ethtool that
> requires changes to the UAPI headers. I therefore need to update these
> headers in the ethtool userland program as well.
>=20
> The problem I'm having is that I don't know the procedure for updating
> the headers, which is something I need to build my patch to ethtool on.
>=20
> I understand now this is not a straight copy of the kernel headers to
> the ethtool repository.
>=20
> Should I use some script / procedure / else?
> Or should I just post my patch without the headers? (I wonder how we can
> verify it though?)
>=20
> Any help on the matter would be very appreciated.

See https://www.kernel.org/pub/software/network/ethtool/devel.html for
guidelines (section "Submitting patches"). What we need are so-called
sanitized kernel headers, created by "make headers_install". The easiest
way to update them is using the ethtool-import-uapi script linked from
that page, usually "master" or "net-next" is the most appropriate
argument, depending on your target branch.

Michal

--axjmhhdgc3jec5yx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmONED0ACgkQ538sG/LR
dpVK9wf9HCOgTQG+DztE/vCAYnl0fxpxkyGH6oyG37Ks1/5zOZ2FNPBRYQ6HbGoy
JMendxXW/t4bK0TopPSe0do10cLQaKGR3+IEdlK7YPvaeNRuFgByCQjApj0/PYOX
+Oa65uk+iL5NHyaDScoyxmjeE2zBOTv1ZcENRWkVOifzVS2/R8BVP5MSC3ytLAow
NTopGuMT8VJxUdYHM/3cybp6ivGERFpw4kEGNIaS2ADwsyTHTIm7VGcES9Xtzmlf
PDZ5I4mXi978suQG5mq3G5anowQpVDvoV/18BGG5QE9E3kiz0xwu3ywX78J1WcNz
701bPaZNdaSU0RRfE9GiOgtHQdnOJg==
=AoLx
-----END PGP SIGNATURE-----

--axjmhhdgc3jec5yx--
