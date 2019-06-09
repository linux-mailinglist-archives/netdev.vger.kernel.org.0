Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0892D3AC6D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 00:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfFIWbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 18:31:52 -0400
Received: from bues.ch ([80.190.117.144]:52170 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbfFIWbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 18:31:52 -0400
X-Greylist: delayed 2063 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jun 2019 18:31:50 EDT
Received: by bues.ch with esmtpsa (Exim 4.89)
        (envelope-from <m@bues.ch>)
        id 1ha5oX-0003kU-V0; Sun, 09 Jun 2019 23:57:21 +0200
Date:   Sun, 9 Jun 2019 23:57:11 +0200
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     H Buus <ubuntu@hbuus.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Should b44_init lead to WARN_ON in
 drivers/ssb/driver_gpio.c:464?
Message-ID: <20190609235711.481bbac9@wiggum>
In-Reply-To: <946c86bf-7e90-a981-b9fc-757adb98adfa@hbuus.com>
References: <946c86bf-7e90-a981-b9fc-757adb98adfa@hbuus.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/j1ztxFZ/t9QL4ize+KYtKmd"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/j1ztxFZ/t9QL4ize+KYtKmd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 9 Jun 2019 17:44:10 -0400
H Buus <ubuntu@hbuus.com> wrote:

> I have an old 32 bit laptop with a BCM4401-B0 100Base-TX ethernet
> controller. For every kernel from 4.19-rc1 going forward, I get a
> warning and call trace within a few seconds of start up (see dmesg
> snippet below). I have traced it to a specific commit (see commit
> below). On the face of it, I would think it is a regression, but it
> doesn't seem to cause a problem, since networking over ethernet is workin=
g.


This warning is not a problem. The commit just exposes a warning, that
has always been there.
I suggest we just remove the WARN_ON from ssb_gpio_init and
ssb_gpio_unregister.
I don't see a reason to throw a warning in that case.

--=20
Michael

--Sig_/j1ztxFZ/t9QL4ize+KYtKmd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlz9gLcACgkQ9TK+HZCN
iw4SdA//ckBMesNtmeE5ovBdzE4mhaRf4sSBmN2DP1ctMil/nhW5nH7jF5jtvqxL
1RMT7aS5TZ1B+h50Y4rxpG4DFeyQCobaDaoHhqcbmXQp/zVRCOSbyb10zd/GC1q4
pZyxwgOc58pCNseGB7PMTiAmZCdxbhUkdjFRwuadTdQ0QqFEzWhO5IN+YdT80T4W
4htUP8ZDcQoQkjWF/tt/0bGuMrQaloqRzLDLP9C/gvZT4R1Uc3csh4rdaRHZCKQ1
OHxj47DYID03hf3tYnxg4JptWUPuEsZQHSX3Tw/Y5IFf0LdznTKbSMfqvS0qkdxF
d3U/ium0zqibJkeDcIpdUtWPPO353SMkaxYHV2KrWOnykG0cw9jhXevU+ZnmnAdy
swLVoHwsr1HWzTcUAbEZoUeY//7X1JWlqE8VH47Fsk5f/lePhdfCsfuU3JKEdcCt
ofgjpZbqR+8CY/rPMUxZ113vqLarFNNX6qaHYW0M35U7yu1SKw1wqpIFqwR8eXhN
AKwX46sLv/VTTM4MUb55PqdU90hyQS03e5215d8OowqnIvPwLqCJh2nFKJq5disk
nu19j2tPqrAyY5Q+2ts+BS6W3/aqZVrnK4OnJ+vyeYzE70dKgZ6MDYVyD1SzQhkZ
VehX4/NZ4XHVXOxaRnfRdnq5uTl56j50VUDbBQFDIT5tyau8ZCU=
=Br6O
-----END PGP SIGNATURE-----

--Sig_/j1ztxFZ/t9QL4ize+KYtKmd--
