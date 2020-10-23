Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9892969B5
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 08:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372768AbgJWGaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 02:30:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54020 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369628AbgJWGaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 02:30:07 -0400
Received: from mail-ed1-f69.google.com ([209.85.208.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1kVqaS-0007aj-Gg
        for netdev@vger.kernel.org; Fri, 23 Oct 2020 06:30:04 +0000
Received: by mail-ed1-f69.google.com with SMTP id w24so193225edl.3
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 23:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version;
        bh=R+UPQ0SAC5WUEZ/WeOnQ4tTbzSomGSi7J0a/EeK94tk=;
        b=GM3WSIbnVwQA3lLzgNmy8W/r8aJCumb0JZ5oAIItzk9k8gcN+KafCkWFzXanBOFEas
         JC7A/GcBu6gSx+piWiOrg1y/kxTP9OShSGpzUOWQudl4GfygBZj/H+6wtmubSfeQ5mGK
         Jq9MM4l+cE0NdG3YGsIRTiSRmSTedEwcQdlmA0Ou1uXsUmZjHx7KkABQrZzk7zE8G0j9
         GHK+pv30mvKxWTJZGWn9RWa7f0Lc9jMsm4APjfANer+wMUkaL9WEyG4iFqdZ2o8Dj9c2
         Hudf7zMo02qVhinajzVQqq6jtos1MR0J35y+AXQaqQBXXKvdxipQxOd8QrvV3vaMAAhM
         TxOA==
X-Gm-Message-State: AOAM533AUs5WfD/id9o5GjyO3nZfYUo+0p/PqFNQSDtsHYzfyCCCSX4x
        bH91UxY3RviNRlZt0BVqTy5HelEO5K41b7w+j5xCWZBGvi/tZM1GRur4yp9hqa5meXCKbvtMaey
        i3hMKPGAA+7cueD6AyfXMH0Q+C+1qyphrAg==
X-Received: by 2002:a17:906:c094:: with SMTP id f20mr564930ejz.550.1603434603274;
        Thu, 22 Oct 2020 23:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxny7xCdywvvQFzJeu7Rg0+itD8Jdx8nCfOTcaDibTWjGQQ3eCJFbLJQxjKLVIZZutpTKmhhQ==
X-Received: by 2002:a17:906:c094:: with SMTP id f20mr564828ejz.550.1603434601826;
        Thu, 22 Oct 2020 23:30:01 -0700 (PDT)
Received: from gollum ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id qw1sm235780ejb.44.2020.10.22.23.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 23:30:00 -0700 (PDT)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
Date:   Fri, 23 Oct 2020 08:29:59 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Juerg Haefliger <juerg.haefliger@canonical.com>,
        netdev@vger.kernel.org, woojung.huh@microchip.com
Subject: Re: lan78xx: /sys/class/net/eth0/carrier stuck at 1
Message-ID: <20201023082959.496d4596@gollum>
In-Reply-To: <20201021193548.GU139700@lunn.ch>
References: <20201021170053.4832d1ad@gollum>
        <20201021193548.GU139700@lunn.ch>
Organization: Canonical Ltd
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kaxv=3M7LcEc4VvkzHwOJ9r";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Kaxv=3M7LcEc4VvkzHwOJ9r
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Oct 2020 21:35:48 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Oct 21, 2020 at 05:00:53PM +0200, Juerg Haefliger wrote:
> > Hi,
> >=20
> > If the lan78xx driver is compiled into the kernel and the network cable=
 is
> > plugged in at boot, /sys/class/net/eth0/carrier is stuck at 1 and doesn=
't
> > toggle if the cable is unplugged and replugged.
> >=20
> > If the network cable is *not* plugged in at boot, all seems to work fin=
e.
> > I.e., post-boot cable plugs and unplugs toggle the carrier flag.
> >=20
> > Also, everything seems to work fine if the driver is compiled as a modu=
le.
> >=20
> > There's an older ticket for the raspi kernel [1] but I've just tested t=
his
> > with a 5.8 kernel on a Pi 3B+ and still see that behavior. =20
>=20
> Hi J=C3=BCrg

Hi Andrew,


> Could you check if a different PHY driver is being used when it is
> built and broken vs module or built in and working.
>=20
> Look at /sys/class/net/eth0/phydev/driver

There's no such file.

=20
> I'm wondering if in the builtin case, it is using genphy, but with
> modules it uses a more specific vendor driver.

Given that all works fine as long as the cable is unplugged at boot points
more towards a race at boot or incorrect initialization sequence or somethi=
ng.


...Juerg
=20
> 	Andrew


--Sig_/Kaxv=3M7LcEc4VvkzHwOJ9r
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEhZfU96IuprviLdeLD9OLCQumQrcFAl+SeGcACgkQD9OLCQum
Qrcl4BAAkhZzuNj0yfXC6mvLOrIALs8ilIFX0EOz99Kw7ETCPr3d0LYiUbeNsbmr
Ut2nVVBsEVk61A0Kr9MHW2vvMOnNyetjK6l3n+nAx9EFKvN5eVyNG9ezWQv2mbXS
Ma10hI9OE55TAQYCsoh+O1DsRNaCTihQJTczK8YLRzq39FEIrk/vobRVenRQLLTA
OuwH4ElocL11sYOzXh8Ym/hJ0GiTzMjXPvYiXJKxKghEy1Dnl/ODf3H1BUkEFhzl
hIKdHuyDudkTXO+nOTGE2O4nvTz6l2UusEiq4UitFqvQF9gHWUUkqGY33xxFBdxZ
FUfSO1Wq9+zZV76NAyqPREd3RJJchS+XEfoqejFIfN8Apmdlh7lGYaiQi/8An5YZ
99WO00z103J29Dhj0HRyVqcMfds8He5dB9sSqpMcjRIsZl60I4H1aIflYBRJsK6m
rsPkqSuHL2GKKKPACOoZn1To01pEtHWd6PxvTIUCDMD/jmxXD061qdqufiu0EbcZ
67Hk48j0st43Hp+/+BywbwDKIJROdGstLWcUtOVs0zjFOYduMUlPXazJ2+20oElW
eTzhky5pYraCbR5UuBOzcoWx7iopro54nB10uHBZ2WIz+OuUiruNnhMIWhb8VbIF
sWNtI1AdW+WVyrx5XguPVwjDvautHKfaqg8yg7bOEUNC50hHl+o=
=mykk
-----END PGP SIGNATURE-----

--Sig_/Kaxv=3M7LcEc4VvkzHwOJ9r--
