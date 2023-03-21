Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E76C3471
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjCUOij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCUOih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:38:37 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE7915566
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 07:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=y3JoVdCj3jgvJHWV3eVK6+pPUYGP
        NrH7su41rVd9VU4=; b=SZD3pHaRNRgFZ4bz44WbSkcTIr1qgp9kVdc7IC+QVaGb
        6gmnZ/gl95i8LInnaJSqZHiewsq5t/pxeqkNapAcIhOY5ItOuISvrM9Xi6N2OAVb
        I5wtLwQgyUDj3iDVed/ktt5YPDKJXBJyCJNT7qBZ9HjNzHS19fP+iUSPVRixIFI=
Received: (qmail 1315219 invoked from network); 21 Mar 2023 15:38:31 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2023 15:38:31 +0100
X-UD-Smtp-Session: l3s3148p1@zrdX/2n3woEujnv6
Date:   Tue, 21 Mar 2023 15:38:31 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] smsc911x: remove superfluous variable init
Message-ID: <ZBnBZwC9WEoNK0Gp@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230321114721.20531-1-wsa+renesas@sang-engineering.com>
 <CAMuHMdXrvdUPTs=ExXJo-WM+=A=WgyCQM_0mGKZxQOrVFePbwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yeGyJMCzGsHhRqcP"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXrvdUPTs=ExXJo-WM+=A=WgyCQM_0mGKZxQOrVFePbwA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yeGyJMCzGsHhRqcP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >         struct smsc911x_data *pdata =3D netdev_priv(dev);
> > -       struct phy_device *phydev =3D NULL;
> > +       struct phy_device *phydev;
> >         int ret;
> >
> >         phydev =3D phy_find_first(pdata->mii_bus);
>=20
> Nit: perhaps combine this assignment with the variable declaration?

I thought about it but found this version to be easier readable.

Thanks!


--yeGyJMCzGsHhRqcP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQZwWMACgkQFA3kzBSg
KbYiwBAAqnubm1w+d7LQWNl1dqHHUTELBpi6H5Ot31Z7bS1TlKklHYNt0VJ8q5n2
C4hQV0ZILhczZpWE/9e2zdIzjAQXf03W62XzIiQNl6Pv5kjQtdp5ba/9GsoUsGfH
2f3jIpocaNMxZ87IeEx7UhnA3Nwl648ihoHrMIEf+wgBpzg/l19nqRr/JQ81WW/a
1yGea8VR0HPnVdokwIHuEX8Xm7emrJQWC1IXazBtzyTOPzYcC08YgqBzhQh7DH+k
51OVx3eK+uNNkB5j09q6RjqS07uRisIxa6HbDPYK/+0Zwd10LVI8t8vrcL8v8DEl
gtjP+a4V92hAmQltBPFmNk7FqQPGyU+KbHlb03OEOaBs+Co4faCfOlC7eWAGzeGx
e1dQ/G//6uNhMoxckhganan3yxCWzLgbBpKgYI7F9D45b5sevoyKgEBrTRb0jKJA
/rl9BMXLuqop4yQZOc81PzI2ep1mBBdhHWGPHarOsAN8o3A3no/t1kZuJU6hlqzz
I9TviWeSvNJ2qx95C6ErImP8cMt7EdIEkynEWufCLC53Xjhm6Q9/Q6bBcupzXtDu
w8M9xoydJ81qYWJM8jer8wbPv731/VOFHg4HmX0LFRBQLEk0zLwANvs87/0JHrFe
4V8p0QtqcvlCjNPfz2iDHbVptglTzhH3aRcx74v1Sb6Q1wvVAvA=
=enyV
-----END PGP SIGNATURE-----

--yeGyJMCzGsHhRqcP--
