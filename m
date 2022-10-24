Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59515609FC7
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 13:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJXLIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 07:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJXLIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 07:08:51 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD515224;
        Mon, 24 Oct 2022 04:08:50 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 11DC81C0016; Mon, 24 Oct 2022 13:08:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1666609728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3U7rOwKyfKhH/Zh959FbPKXfLe/jf9CIDsItUTegGY=;
        b=L/G1kfGakZdrdkinlnqlx5+DHnDHjDXT4oCQTBQN1cXleYoY5QveqWzFHR3dc+eXzIHK0l
        cnFzRK36DLxoTF7mrOgVKOsL7p4iKpDAisRW0i3EZqpaQnUX3fPBP/EFVcrSCbM/qoZ9k3
        AginmJdz4PrwWY6JnCXR4SvcoYPFgI4=
Date:   Mon, 24 Oct 2022 13:08:47 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFE net-next] net: tun: 1000x speed up
Message-ID: <20221024110847.GA527@duo.ucw.cz>
References: <20221021114921.3705550-1-i.maximets@ovn.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20221021114921.3705550-1-i.maximets@ovn.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Bump the advertised speed to at least match the veth.  10Gbps also
> seems like a more or less fair assumption these days, even though
> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
> and let the application/user decide on a right value for them.
>=20
> Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-July/051958=
=2Ehtml
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>=20
> Sorry for the clickbait subject line.  Can change it to something more
> sensible while posting non-RFE patch.  Something like:
>=20
>   'net: tun: bump the link speed from 10Mbps to 10Gbps'
>=20
> This patch is RFE just to start a conversation.

Yeah, well, it seems that internet already fallen for your clickbait
:-(.

https://www.phoronix.com/news/Linux-TUN-Driver-1000x
										Pavel
									=09
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1ZyPwAKCRAw5/Bqldv6
8kDvAKC1T7nrxzlUFKI57eohY3LL+ITapQCgrs9BP5sEaTveznAOlyOTy3QG9kI=
=EE+4
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
