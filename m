Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405FD78FDC
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbfG2Pva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:51:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37150 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387496AbfG2Pva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:51:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so27694533plr.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 08:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=Sf0m7JEZMUUuDoL9U1xqF7CQ40WOkIEU+KrNM0j4H5Y=;
        b=gnpcRKVA/LWds4IEPAmXMViqA0s5eJpC6BTrArgD6qYibMDYNtZTFgdpAyN4lY4KDE
         PxxiqC2SaeDKyDxL/zRQDVEtWaA8nxy9aUVT8z2cbogwdrPoP2JER3t/Aid3bWu7Uk2z
         yzLiHCIfbhipnntrlMAKgITFDanA4gUGxMTs/WFdIiJmMy9iHAVUJsd8BEJ7xrV7yRv5
         X1XlM/fHAMyo239CE7fSmZQF0FutlqjWP2LL+SiPeaZvTykl7jLh1snp8HsjhlUxYwNE
         0mxI6veQ5C2jSOgVSxYzI4icgjsygf+fGPtMfy6KJClf773QplMCBptLd9+yEoEITQIw
         EeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=Sf0m7JEZMUUuDoL9U1xqF7CQ40WOkIEU+KrNM0j4H5Y=;
        b=eBRQj4RxBt+bERmOgVhD7Y1QTUXfkcWT8BGeTanAgiguSpP7ZV18UGPle7xI5aBv6w
         mak/JoStEDb4KqvC0juQEw3w1ezWOHUaGT8L4jk7OHEMx56vRukVFgT9sciObYFHwPt8
         bcv9YJcbILDcLK6jY8bxHiLefm8190eQwQAv43yluoQtwXV3tndj+iIpPpNoC6v/tZe0
         PVdmAMl8CAyK6vrAXkmfozmaglP2eLqOefTtPbVsoxGpVYjanL+TVS3h4Le6tkTdWvrM
         ZsGn7HtuXlYdCEjRAk8U1zmZMLzKBGjuYqdJIvJWoZUIWlhXLEKR56r49ewfpR52fb+i
         fNOg==
X-Gm-Message-State: APjAAAWksJirvylgYLcCD4oF8FX/qJ1+5lYQmjRqG7Go4/gbJWWPwslO
        /r0v0jJ6JR3Xavmuvkq6JuA=
X-Google-Smtp-Source: APXvYqyI2mE3NI5wtrvXieo4lb4+5FCoVQAW4BWDP8dAATd1lwW3WlrJRYHKGcNQYT3v4M5DDid82A==
X-Received: by 2002:a17:902:be12:: with SMTP id r18mr105484394pls.341.1564415489778;
        Mon, 29 Jul 2019 08:51:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t96sm56135003pjb.1.2019.07.29.08.51.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 08:51:29 -0700 (PDT)
Date:   Mon, 29 Jul 2019 08:51:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 0/1] Fix s64 argument parsing
Message-ID: <20190729085122.32d20033@hermes.lan>
In-Reply-To: <20190729110408.fi6xfhc2msg5elih@linutronix.de>
References: <20190704122427.22256-1-kurt@linutronix.de>
        <20190729110408.fi6xfhc2msg5elih@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.7A4CCzw_++3cjhR9lrV/L0"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.7A4CCzw_++3cjhR9lrV/L0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jul 2019 13:04:09 +0200
Kurt Kanzenbach <kurt.kanzenbach@linutronix.de> wrote:

> On Thu, Jul 04, 2019 at 02:24:26PM +0200, Kurt Kanzenbach wrote:
> > Hi,
> >
> > while using the TAPRIO Qdisc on ARM32 I've noticed that the base_time p=
arameter is
> > incorrectly configured. The problem is the utility function get_s64() u=
sed by
> > TAPRIO doesn't parse the value correctly. =20
>=20
> polite ping.
>=20
> >
> > Thanks,
> > Kurt
> >
> > Kurt Kanzenbach (1):
> >   utils: Fix get_s64() function
> >
> >  lib/utils.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --
> > 2.11.0
> > =20

Not sure why this got marked "Changes Requested"
Applied.

--Sig_/.7A4CCzw_++3cjhR9lrV/L0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn2/DRbBb5+dmuDyPgKd/YJXN5H4FAl0/FfoACgkQgKd/YJXN
5H4NtBAAr3GdkPs0OoNpzOKRN8UxB7FsmYCWfMqdmx8HVnsjrUE2yNaMorDeeKZb
2qo7wOGzExcBzDV940c/djNVCFHSJhZ8PxNGaEkEnB4ULqsVqzsmyfw8P3Vs9dw0
LQEyzpyLCOFE/F85HN79u6ehRh0ZTgaYqoYJewgpQMyBBkdl36ONjiaHNpYN5R90
DrQDjgzCIkW8b3KE8DxzCloE515T4QZS/JvVOllVsoaYy2vSXBENITjmf4NgzRFf
cYQQkIT6P/DiQ9DXKTYLKgOZKzKSjJ4teLU2LtwyGB6E/qHS42Dy/S+01lFHui1o
wIL1eV468lIY2R1Z+c1L/DB9krsgti4rpQhqDU/N11B/YBKiMqegD8NH5rVLD6m2
hw4DyJ1o+Tngsi55aCxh28Np1Ei6+VV60EPv1Tb1nP0j45k4E8z+rUhOvmHQrCKG
jQ7mFco+/xRtR+TBb0pFI/vF9BJQ2cMS4EMiA3x1r48l93u8/oTN/BD7uY0ZqL7U
Ip8hhU/MGrThC/VyPGRi4d0EPwn6Au1gQHg+uFLSQSRj5+rBGwju5FLGCfabY55J
AH1oG3p5EyH9leEpGmOXBqXoIIZuupoV+QSvzwFq+o75LC8Tk51cd7MXkD8vW/mT
tXx+9vB7IbtaoR1lHu8ZuaVz4o7Kp2MOe+7hxztD1iT2U7aGYZ8=
=2xPl
-----END PGP SIGNATURE-----

--Sig_/.7A4CCzw_++3cjhR9lrV/L0--
