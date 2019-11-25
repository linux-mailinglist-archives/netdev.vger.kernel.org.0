Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CB4109487
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 21:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfKYULf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 15:11:35 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34070 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYULe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 15:11:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so7915267pff.1
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 12:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=ARYWqlkS9QHfZESyu1KBrBTXXqzp3nzYRz0JMjZfuDc=;
        b=wSBFCeelLA/gVNaD0m2jrt6AloUF1Ec+3Kq1ak0rzzT+olqIq5hIlkTY0NaASSjSLc
         FujfCAsJcHq5lcaiNFeAnNMaaloYH9PTS9asBeXpP8evFPOl9udVwdy7yc/+BYJ/zqKL
         z5qZK89mnA1SzeJ2OfEzHQsunEKJVjL8NO5OppOT1VoFLBFakb/GBb9lRSDz3ylxu5kt
         Ts7zo7z8xMv5olSIeeb0Bsln77d+ZqwcZ/hbbXXGTQfw5ZmP+MAN9p0CgVRoGd1QURsW
         qD5VzdemO4BEasqGc2+M0HJEHaoBgq0vQre18vyI6YPqdH/lojvREg2iQ6bv5DH96fMc
         87Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=ARYWqlkS9QHfZESyu1KBrBTXXqzp3nzYRz0JMjZfuDc=;
        b=QWwWtAYj5wRwlv5r3AxSXfOn5jE84Y365exv7MSJjj76Xr3I8Y7TRxI0jJVKQNXNGM
         dd6KkqxbYAwQyZMzpkB/4vmQSIIX/JvHKOUJwa7wpV3tgHRoHPQVyqL7mZMOI3Gmxr3m
         yPnJ1W9USpEKrm7yWVCQiftFRoeHdVv5gExZMONEi2WlPnlNI1ZbAYkG2pLCOPxzRRkI
         a/wQLyR5nfaH1O4OSz7ev50ae9TWZcSzqz88FSbIWWh2wdQmRALedIhTdpCPWhKPEVSb
         gAqk27PfRVLG7mj+81jklPeN72PaGPgDV7pMBjZWG1GDhM+sIVukT4K9+O7WOGC2a5Dk
         1Bpg==
X-Gm-Message-State: APjAAAVpiIb1jfV8lOeEwjlrQ2+hzH2BdY31MTQ0qIhskTnrmFqt0vXn
        uhMnobFNVXvEpZIQpKlcV/EKiQ==
X-Google-Smtp-Source: APXvYqwNDyR3cGe0rgNGztXiGOxKRK+T2MMJkWz6tPY/v+T/qJgtZdZJYImHD6MDMVXfsTkvCBXZvg==
X-Received: by 2002:a65:47c1:: with SMTP id f1mr33469573pgs.393.1574712693905;
        Mon, 25 Nov 2019 12:11:33 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v3sm9617299pfi.26.2019.11.25.12.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 12:11:33 -0800 (PST)
Date:   Mon, 25 Nov 2019 12:11:25 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Christian Hesse <list@eworm.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute2 5.4
Message-ID: <20191125121125.3cae8724@hermes.lan>
In-Reply-To: <20191125202111.1bb32360@leda>
References: <20191125081737.2ff4a7ca@hermes.lan>
        <20191125202111.1bb32360@leda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wd7FgAUV4011kp3pA7M.Jkj"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wd7FgAUV4011kp3pA7M.Jkj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Nov 2019 20:21:11 +0100
Christian Hesse <list@eworm.de> wrote:

> Stephen Hemminger <stephen@networkplumber.org> on Mon, 2019/11/25 08:17:
> > The 5.4 kernel has been released, and the last patches have
> > been applied to iproute2.
> >=20
> > Not a lot of changes in this release, most are related to fixing output
> > formatting and documentation.
> >=20
> > Download:
> >     https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.4.0.=
tar.gz =20
>=20
> The file is not (yet) available. Did you miss to push it to the servers?

Repushed, original transfer failed.

--Sig_/wd7FgAUV4011kp3pA7M.Jkj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn2/DRbBb5+dmuDyPgKd/YJXN5H4FAl3cNW0ACgkQgKd/YJXN
5H5lxxAAkqUjT90wDMhnYDr+7XlQU0hqKUtHihqQyZViFD9+dhJ5RanQxP2wD0QC
wgBNpeqGYAq3E3HC3TSPd55BxkEE5FUyzpikon9qDLVXntp8XP+hu/lhdNEKbGGy
9bfGA+WyKD3nYVooW7A2SeX4Lm9NQZz7Gy/UfEe0rDT2zAF75vUP/Btkw0OMgYgu
p63QttAyOfvDmXbmsL64m1FCWnyQmswrEtElagylHa4ZDiuAIkOV4BII52OPtAVd
ZEtnbGQ073e6J+Gxxfa9B1FjaPz0HRs1EqcYM4bXsoiWZTJ6vD49Qk+YczjWe4MX
cWXIB+YweqQTS+HaZ6DCzYaVgaTYqzf/XEuOhgjOMv073He2uHQtSroB61rBssR3
KHnwAgZ125lX+Th9rJdu+OAFyPmxK+rbJhLzDYQ/iWQ4Z6INbuSQkE9rLlt1/tw8
x7/q7v0JU6mQmyTVmS757ejLbK7pa3MwNNEpy1kMMkk0mIziPeU3hJsUDr/7+On7
f0qLi+jC6xOOyyeAYdpDylHJD/BoaADT2Ewkb+0C1CxzIzMBYm2H0nmPyzdWtoV6
TxE0RdsYfvtxDBQS3PBeQ+KTs46q1r6mLKLK6o7+nEna8Wu/MNNlYZCABkJKCtsg
eNoFKjh7WSKMabppB1RRtD+NbjdqnZYlxT+hNjrJOG6JIEO7H2M=
=gLhG
-----END PGP SIGNATURE-----

--Sig_/wd7FgAUV4011kp3pA7M.Jkj--
