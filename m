Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A6B3AF2B
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 08:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbfFJGvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 02:51:48 -0400
Received: from bues.ch ([80.190.117.144]:52420 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387582AbfFJGvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 02:51:48 -0400
Received: by bues.ch with esmtpsa (Exim 4.89)
        (envelope-from <m@bues.ch>)
        id 1haE9c-0006oL-7V; Mon, 10 Jun 2019 08:51:40 +0200
Date:   Mon, 10 Jun 2019 08:51:37 +0200
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     H Buus <ubuntu@hbuus.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Should b44_init lead to WARN_ON in
 drivers/ssb/driver_gpio.c:464?
Message-ID: <20190610085137.7d6117ae@wiggum>
In-Reply-To: <a7c07ad7-1ca2-c16d-4082-6ddc9325a20d@hbuus.com>
References: <946c86bf-7e90-a981-b9fc-757adb98adfa@hbuus.com>
        <20190609235711.481bbac9@wiggum>
        <4fdd3b06-f3f7-87e0-93be-c5d6f2bf5ab4@lwfinger.net>
        <a7c07ad7-1ca2-c16d-4082-6ddc9325a20d@hbuus.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/l9Y0pu4CIeTAhwtB9wtBkw7"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/l9Y0pu4CIeTAhwtB9wtBkw7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Jun 2019 01:40:17 -0400
H Buus <ubuntu@hbuus.com> wrote:

> Unless I get lucky and figure
> out what commit is making newer kernels unstable on this laptop.


You can use 'git bisect' to quickly find a commit that breaks something.

I'll prepare a patch to get rid of the warning asap.

--=20
Michael

--Sig_/l9Y0pu4CIeTAhwtB9wtBkw7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlz9/fkACgkQ9TK+HZCN
iw4law//U51RmVK3MkDonmyNK1pyXt8Jvqul3dai8jpHTU25GzPRbc97A77Jv1I1
ijjiniEJEvZJTgp0gKEYfv4xaK+uNBP/Zrj9PgB8taLuAiDkVO9yvmI9KAKuSCDd
PNcoB8BKkKNunVMBTgoAhIyPaNdxG2r+5W0xsgQ8rg29PU6EGrY192Gymm2uQ6h5
lIQtSq9rW7V+PO1EoJJ5ODmXE+U71f6JjjU8C1p46r1w78xBkNfnYrocMo23jRiA
qCRwJiUyYeNSPbOwvbloEEmqT9dJTPiXZDQUicft2Yui+XHr1YszJMQm6o5Mr7BR
2iKf51dy5XG0z+gFqrxxEIKm3mCOTX1glJSv2EGE5FEJZYQTjANQLZrlwHzzjdcN
cxH5ilKMYHAC88DagbqnScQXfFT/YWFfbmnYPt9miCa11CoEO801aHOVThB5fH5F
WZMwbxgWiaiRUFDtVkf7mcm2nIT93+sllemYoalgGcezZ5R2H2M7hoxCjP9E0S6f
T4gtOydKqV+yQHY/QU6q+aWAPm6VMMip1YngIC+Ccbu9CDHGoV0kt2PppRvoavvg
mXyNtrmB5/T+WnOgZ/xg6LVo6ZEzU7rbIGkZ4vA9yPa/p+ho0lViM2Vwp/oJfWJf
IVt/MirYDq612aFirRUmsnOvq3RE56Qf/krTzQm0Osvr1fiWNi4=
=5/7S
-----END PGP SIGNATURE-----

--Sig_/l9Y0pu4CIeTAhwtB9wtBkw7--
