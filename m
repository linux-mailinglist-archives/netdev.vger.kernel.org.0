Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D8B6B67B6
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 16:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCLP4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCLP4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 11:56:02 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC494608D;
        Sun, 12 Mar 2023 08:56:00 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1EB62860A7;
        Sun, 12 Mar 2023 16:55:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678636557;
        bh=Ujk/Bz6/hn5iWJ3v1Dyvino5y1cX5E2io2nrwXWHn58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c/8D5sQx2v4tL85FTuV49DLEgU8sK02IzeUBkKwYtWo5fOfQ3fq1zfw/Ghhxuzbe1
         1U+t0iVM9bz5on2ZDYoRO2lKEem4xuwkmiCXnlmdbdtSqkbonYYQi98uAa8sN2gSMi
         Mxd4YniU/Ax5O5RGm2JSgLRoU8gUGBUp9meuB0oCo8qS02DT+sBuT/bFeFWF55bWYO
         QHSIVAJXtj/gzIiMduntyki7UYMYtgnYjqbRDuQ0Lr+IOMnzanTUHnUe7zHcbrLVma
         xhpJGjrIecJurFkhUpP70L1A93NW6lc5wc6+EjWgjg4YYf1/eYwdrj+cml5vPktHDu
         4EStm/v0UIcTg==
Date:   Sun, 12 Mar 2023 16:55:50 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230312165550.6349a400@wsk>
In-Reply-To: <20230310154511.yqf3ykknnwe22b77@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-2-lukma@denx.de>
        <20230310120235.2cjxauvqxyei45li@skbuf>
        <20230310141719.7f691b45@wsk>
        <20230310154511.yqf3ykknnwe22b77@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EGWCjRQQoH.Nw0G8E.7IoZ9";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EGWCjRQQoH.Nw0G8E.7IoZ9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Fri, Mar 10, 2023 at 02:17:19PM +0100, Lukasz Majewski wrote:
> > This is the "patch 4" in the comment sent by Russel (to fix stuff
> > which is already broken, but it has been visible after running the
> > validation code):
> >=20
> > https://lists.openwall.net/netdev/2023/03/09/233 =20
>=20
> Ok, so nope, what I was talking about here (MTU 1492) is *not* what
> you have discussed with Russell in patch 4.

The patch 4 would be related to mv88e6220 and 6250 only. It would
provide correct size of MTU.

>=20
> What I was talking about is this:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230309125421.39009=
62-2-lukma@denx.de/#25245979
> and Russell now seems to agree with me that it should be addressed
> separately,

Ok.

> and prior to the extra development work done here.
>=20

Why? Up till mine patch set was introduced the problem was unnoticed.
Could this be fixed after it is applied?

> It looks like it will also need a bit of assistance from Andrew to
> untangle whether EDSA_HLEN should be included in the max_mtu
> calculations for some switch families only, rather than for all.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/EGWCjRQQoH.Nw0G8E.7IoZ9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQN9gYACgkQAR8vZIA0
zr1J5wf+IQzdbTlYu+ISsB/+nmWexSYlnfWNgOh7E7w4SUiI8nW5vv0SctfHpkFM
uJZABIA3Tt3TIA+J05HEB7AGN+dLhYu5rgFRutsJ77BpYa5I9Ogt/5FJgxRh+DzV
wadbqmkVVUVT8NY76YYlwWYJIRLZRwTsPFVQG2XU1Piori0InrfvnHdRzqFZSBq3
Bn7u2SUCK11woc5U54AHKT6Qv8TNxACMZzFxAZcdrKjF1hLT64ey0h3yZ3mkclbY
9N1n6GxPq8XtY9GDDVB6PG2dfLsXwzb2YMSYek+n0fzQnminnvMZamwXIFjthqCl
gxF5aXbROLYHLSBguHQvC1SD9myF7Q==
=aaIR
-----END PGP SIGNATURE-----

--Sig_/EGWCjRQQoH.Nw0G8E.7IoZ9--
