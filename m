Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196136BAB2D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjCOIwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjCOIwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:52:37 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7298861329
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=p9WY1RdyYLmbwG3tcnjinpq3FolR
        mCwaBad4ZRar/TI=; b=qrQE9RiARpW/Xu8+C1eTs85kTQrtWuSkRVP4yjSapswG
        2U+CWP7JyfMQNSCGdnUVm1S2jcN2WNRc9IuwFoMRG2Q/066Ztc0A6Sw3TFdiQD1A
        +Mf0y88OA1SVVwzMLyJBbQYjbZHo2MO0pUfhZitkc7cTLYuJIrrYQydZtYu5Ifs=
Received: (qmail 3381861 invoked from network); 15 Mar 2023 09:52:02 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 Mar 2023 09:52:02 +0100
X-UD-Smtp-Session: l3s3148p1@Gc80dez2oN4ujnvb
Date:   Wed, 15 Mar 2023 09:52:02 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel@pengutronix.de,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] smsc911x: add FIXME to move
 'mac_managed_pm' to probe
Message-ID: <ZBGHMn6xX5giT6fH@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kernel@pengutronix.de,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
 <20230314131443.46342-5-wsa+renesas@sang-engineering.com>
 <CAMuHMdWhKfw93Fyukr=kguMAmZCnynk=-96+BKBPB8PDZkE9gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uxTA4kgouIK70B4O"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWhKfw93Fyukr=kguMAmZCnynk=-96+BKBPB8PDZkE9gg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uxTA4kgouIK70B4O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > On Renesas hardware, we had issues because the above flag was set during
> > 'open'. It was concluded that it needs to be set during 'probe'. It
> > looks like SMS911x needs the same fix but I can't test it because I
> > don't have the hardware. At least, leave a note about the issue.
>=20
> You no longer have the APE6-EVM?

I should have it somewhere. Cool, thanks for the pointer!


--uxTA4kgouIK70B4O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQRhy4ACgkQFA3kzBSg
KbZ15xAAouD2VI/VKsM6jupar4Qy8yGfcrEdu6sCD4tmq9DwZWSoBPlELQiqLKd1
+CSYrH5rMJHCGqcjefz7VWiGUvxXr8DpJu5bpbV69jUXfaWrN3HPusmuPXMtVhMd
1p2TAT7kotFtO89LuI+PEkVvZWYHZRfTdLuiwDTMn6YDOWtOY7K8ufcvWfs2EwdG
8Iq3ZMhCznrNTeh337suwBfvjiVAlF0qptwU714ZxcIwPUc63+xrSFMJmSF6NuCG
qby0dGUG0hJGnriDQsM8NUeS3ihg61GC4Tp8myeLDuSNTyzkyhKJ0FMu+gf4PQIx
wgISxEAwMoYQ1YcgLKF3QRQXyr00Xve+c448e/3hZ37OVF4xYOQfFclH2f7rA5Zy
lWw6QhvNuq4U6GlWECHdd0PDHJMZ4iT1ajGnh55XqlYHkbt63pleJ19UMRVE4J9H
/+TzMsqLmVqygeQT76LQPtp1xjpXgZRTx3556qvdUBW/+jnQb/438S8Qs6y7aPal
yMcJkl87t8ZuKyX/GeIpoFsnPIS1oLktEBgw/ojD+Ao9PK3491vs68tSvucvrLPo
5qRlCyreE4KJdQu64QrhZW0FdG3Rmm6wWZXuu2CqKzNseWlESXp63GUw1b1o0kO0
/my7ygULjALOA8zY516ztjDNE9IdXrhWrZQ16vzRcXIdMZ2ZKeY=
=Ukni
-----END PGP SIGNATURE-----

--uxTA4kgouIK70B4O--
