Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AAE68013C
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 20:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbjA2Trp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 14:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjA2Tro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 14:47:44 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E831ABE0;
        Sun, 29 Jan 2023 11:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1675021645; bh=MTLyX3h+NXGuXbdJfDx1U1pqVOBOerCWgDGIhuixFmY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=gaPne94TS8cajMOL9DvUc7eYbLUewCNlvyQ7KsGv0rcW2buI+KS8WHbInXRC484uw
         4Qrj25lXKntOKr6JESYNZTuh5/S7Q6cn8QtXaHBnApYge8+WLHkBw4PPGx0jgq6NDm
         VJ2zd3mLO0kLY8tswdJ9PqkiJXcinDyt2DlaRgTSpUdQe0mhVca0U5X/ti5NQ4Js3I
         qNEmsAJBtDD9POlHiPgZ9j23+dYaWRNE3XXNs9nQP9wLclesivp3bgeZySmOCyY8vZ
         rrfdMz09T+j56WAJHO8fEIeltwF2mdpNnVdsZPU5HgxzdcqiBdwygRl3GQCP2sYpfE
         ZrqsNpZeNbxXQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([95.223.44.193]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MQMyf-1p0RVV3Tzl-00MKcG; Sun, 29
 Jan 2023 20:47:24 +0100
Date:   Sun, 29 Jan 2023 20:47:23 +0100
From:   Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: Fix a typo ("defualt")
Message-ID: <Y9bNS6DajwdciwAI@probook>
References: <20230129154005.1567160-1-j.neuschaefer@gmx.net>
 <Y9a8Y7BZ7wIIZFbm@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oPejS3AcJFQL0c7w"
Content-Disposition: inline
In-Reply-To: <Y9a8Y7BZ7wIIZFbm@corigine.com>
X-Provags-ID: V03:K1:eeEc9/orxXgSm+yZ3CkNqJOMXaWFaFKJxWGIFeEI+UChJqEdXgF
 skqCoJixG+jKT6V5lQcDTIhsbugQvYR/j7BIHyLoDjPcTEFdgq2F7WaHvMsBSTxggnhnMnT
 fXhBY2IlkS53SHsVXFJRd3wHpq67OJkxT8K9pXw9udybORWZ+OD4xB44EvAjr/cfcZCtMkj
 sb1KQvXPEfdkvHM04wEfQ==
UI-OutboundReport: notjunk:1;M01:P0:qaoj20F4uLU=;PJ/GdILnqNI2Uehk9uTgTCLVrYx
 2pvy447x4er0pdym72qRZ+HSCc1G9zZHz3UGCgVUn4stFE8T82ARcJf+qQzomt/mGSHPsbq/e
 8Ye6fFev2Xvx5fnFz0EkuMyOJu6YfHgFL7tRzKsXB+8/vSsgFZA7SYoAYkSnmC/lOQciV+mCR
 8irQxYhwIJ3Q09XUXy4wqtIM/0EKtOtzvhYVGQ9onI8O9QOv69kXat3mHF+PZHgIkpT+46mk9
 Hq8fq0DLqQVt8lu4awZECi/M7O95COyXX+tnwBkDulfka6irisCmGjpNfu70DiFyax+BkJ3rt
 oEcUsg6k79Kcmg0niwEoND/Q4gt6ndAWcWzWH1DKGfKg83Dt/crPkrZAeVuGi2j3DXTogKodM
 TsskU/YPPFOZ7o0Zr+3J5iSC2cfJYR8QQ5mk7w6sd82SylaUXmHriZSaaXh0LLQ3kJZi09hxc
 qu9qcmdlBrbrI5WMP9FMg8vCOV5sR4/Koh8n4TH06OdYKzbupf0rVpbZGE8S3F52p3X3pYmzo
 u/4oJqZ+n1tE/RIv+JuLGhAPX1bOypbiLwo8pn6fZxSYDdFzRseSNES3N/YjrL5mWIpwdmetd
 KTzc+Txc8iV6w2LvCPBYcn6oUIPeVuE5pTO0f6uvjSLj2BQsBqq7/XRmNJ8MnzjPv2bdMUIrj
 9ETJ/95Ruk9ped5K0xBUoJBwgP78HOfl7WJF9k3/ftWNA4w77ctTHlecLJh7zpeiTK06xXTAp
 /6jFKn8vqIj4PHf6XVb1WC6lSCqSr8RMCoX6wdZdCcYVDqqG69Jv/cfca5IMIkkOol+FxzcQl
 uqJUwtPi1XhuUMpf19qEXWGgvnn+uox0IOxOhw7/uRtv7fgnddynr10ioXg0zYWeuxCYANiDC
 DzHZGZxSmncS0Ddp1h3DL6GxUf2uSWwilOtNfagnFqv/e8EVHftB0noAMdTLNoLjq0/Mq9o9d
 DEdkRXQ/3yLTqhqjw7jlzqdCzMI=
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oPejS3AcJFQL0c7w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 29, 2023 at 07:35:15PM +0100, Simon Horman wrote:
> On Sun, Jan 29, 2023 at 04:40:05PM +0100, Jonathan Neusch=C3=A4fer wrote:
> > Spell it as "default".
> >=20
> > Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
>=20
> Looks good :)
>=20
> There also seems to be a misspelling of heartbeat (as hearbeat) on line 2=
77.
> Perhaps it would be good to fix that at the same time?

Sounds good, I'll spin a v2.


Jonathan

--oPejS3AcJFQL0c7w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAmPWzSoACgkQCDBEmo7z
X9sh9Q/+I1ZIysq8Wfq51Asb7+cvgUBd7R2Uiu9xFLQV4piJmcNi8/IAzvUHYQMQ
rub9Rbyw+zJikGugGO002s9X+TQc+6mKOlT1Hrzbz7V2XkLzqTD4E1VB23iXqku8
y9YBohx+m99CTJT4S8rNRci06T8oGg0RqJ26FlkF1CnlJBgGGWYaQosFbxPSNlbX
NtQHYWYEEzCiBJ8C3/CZXjopyL0IL05YqhtslERO00/G6vhnne1lO1qZz2Hb1dKg
U6XX7EZUMQI02JZ93v+RbV/w9HxJHG3SEXje2lo6iIo/Tei1e42iVqyc9QwSOK5e
SDm9YoQQH97NI1wBm2XWKMCMg5+WT6QYbo5KvbIvcqzlKKKvrU4zX10lapQM0dxT
9CYiVJZXX8jUq3V6DoF69TgSutNPkJ0N/uZKf0DoZdf2T+eI1t66DTwZo8FhBuoQ
PK1BCmjYvw/sfJowuvl2LS1B3baehtqYUN17tJWWR6ybAPORhqxntjRLhQ34TrJJ
Iwgp4BuaZ4sxCKrG3KM5ecU1yIMOj0jIHThBYrHpL+kLjbE+K4fOUsdQa56Zk+QW
JWoSr+/iKVC0+mnyeC/IrTn85RCLN38x+96NogZkW8A9pFBpph32DdEA5kme5E/t
/+Y4cZbYSDaF18aGn7v72JG8JHrXQbBF1radhn6xWYxDW7afX1Y=
=gZkC
-----END PGP SIGNATURE-----

--oPejS3AcJFQL0c7w--
