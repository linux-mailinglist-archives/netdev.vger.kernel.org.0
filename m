Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61885A9DAB
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 19:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbiIAREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 13:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiIARD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 13:03:59 -0400
Received: from smtprelay08.ispgateway.de (smtprelay08.ispgateway.de [134.119.228.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ECD8E0D8;
        Thu,  1 Sep 2022 10:03:58 -0700 (PDT)
Received: from [92.206.161.29] (helo=note-book.lan)
        by smtprelay08.ispgateway.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <git@apitzsch.eu>)
        id 1oTnbj-0000Tj-6m; Thu, 01 Sep 2022 19:03:59 +0200
Message-ID: <fda5ff0efb44da0771f24f8031632962d023924f.camel@apitzsch.eu>
Subject: Re: [PATCH] r8152: Add MAC passthrough support for Lenovo Travel Hub
From:   =?ISO-8859-1?Q?Andr=E9?= Apitzsch <git@apitzsch.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Aaron Ma <aaron.ma@canonical.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 19:03:55 +0200
In-Reply-To: <20220831121840.293837df@kernel.org>
References: <20220827184729.15121-1-git@apitzsch.eu>
         <20220831121840.293837df@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-MuvW9aafS2qhBjNHjPAr"
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Df-Sender: YW5kcmVAYXBpdHpzY2guZXU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-MuvW9aafS2qhBjNHjPAr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, dem 31.08.2022 um 12:18 -0700 schrieb Jakub Kicinski:
> On Sat, 27 Aug 2022 20:47:29 +0200 Andr=C3=A9 Apitzsch wrote:
> > The Lenovo USB-C Travel Hub supports MAC passthrough.
> >=20
> > Signed-off-by: Andr=C3=A9 Apitzsch <git@apitzsch.eu>
>=20
> Which tree did you base this patch on?
>=20
> Please rebase on top of net-next [1] and repost with [PATCH net-next] in
> the subject.
>=20
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

The patch was based on
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/

Rebased and repost, see
https://lore.kernel.org/linux-usb/20220901170013.7975-1-git@apitzsch.eu/

Andr=C3=A9 Apitzsch

--=-MuvW9aafS2qhBjNHjPAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEazlg6L1sjNt+krNCgnfiFzZ+STsFAmMQ5fsACgkQgnfiFzZ+
STsFhA/8CehSN2Xk0Jsbd0Ny+Rbzp37l8a9PeqLjIEc55ZoBmVcKa0FxmrSGQetp
dvR+5L4tuy6e380l53ubvh7VcktN2vl99rIa2yYLG92O/OkWfL1erfXLyXILaKol
eQoZZY2Odkh4e6PTlpCydcNlT35jbDZboFYP+p1tuHUqVz2LLP47i6dpxwN3++4I
qxUs6nIi3NYSDvr/TYQiWMKW8k5wFlBMPWNZ6riXYj/QuBz0SvlUQ9jbwTwWSLjq
rVe4pgH4VCysin43b0Sd92M5Jp9nYxGNLmlacp2MuwRPd9k+oWnlbyyfVb/C/3lK
zPAgdvlyeGooKM+RFPfIliQ4akGLYUF+MB29je7POHT23YNZSMNgQhf9M7UdMPO2
FssL8kOlcsY0kMrr9kxHCI7FxOy/c0DKj0w+g2tPg+urUzHyNxhQe4bbQjBOEv1S
EpKXx7Epj/16eXB9Fij38dWH2KBIx0VoqpyM8dKKTcLs+KcSWlqIzeOpgsfQoJVM
UsD9NcyCbjl3tp9zUAhPSKmcQY4++OB6JZxDqGG0S7a0wAsTltGGhjSBLpSl873d
rMZp5oJ+s+lzPxoj5HH0D7iP/+Gv5YtyUc04ThEH2yjYU30YJQ+K/bsM5bwyTEGh
dj3WNZgZvyD/8SvfmAQgf1lyjnfNjvmFIG6Ene8xAF69ZrhyFPw=
=HF1e
-----END PGP SIGNATURE-----

--=-MuvW9aafS2qhBjNHjPAr--
