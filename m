Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DEB6C14CE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 15:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCTOf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 10:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCTOfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 10:35:24 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4EE23658;
        Mon, 20 Mar 2023 07:35:19 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id o7so10574995wrg.5;
        Mon, 20 Mar 2023 07:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679322918;
        h=mime-version:user-agent:references:in-reply-to:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1BzpXV0y6te1zBYqcLNkghC0956cKZHajoibkxBlDw=;
        b=i1VrILvAC1Ef9ZbmvFHarwcrJ57CxRkBBamHUbbRbDpV/ihCgB2WDmImGBnb24fRH6
         qmc7irMmqtlKVwPbO/IwJFau+yGPXJefom6yJ4iF116yqW1gBwpuYPlOYnwlNL+0Nfxy
         DRqmhJ/u2sB9jv2+o7ST+9lQy6rBM6SJXmEFOmsgMgdMgacHwJg4GD+0dvbNYn4RJCVF
         xowEi24JXD/+1LjhcCz1oNZNLJBn2dumuXPoplhi+sG8QdQqKMVWL56ismPYkzj20g0g
         a2iVpZV8ZA3AJa+SG7Q+98+BGvhxAeRzF+StY3DBFGbkDmmlSdCwMWj2LeG3Q5//rIWH
         jaEw==
X-Gm-Message-State: AO0yUKVFhqas6wViFiA+dELIIuuVskEj/2ejFpXDEWU9mJIIzP01PxPj
        8JFgQKfosU9zPTN+TW0ki3Y=
X-Google-Smtp-Source: AK7set8/Cz6xju4k7BMBZp/msbyxb+nYsSmbOrYN9Ee0ZiQTLUIM37XnMB8HDLUUSUuDfwUsa7RbXA==
X-Received: by 2002:adf:e583:0:b0:2c7:bb13:e23f with SMTP id l3-20020adfe583000000b002c7bb13e23fmr14783687wrm.24.1679322917558;
        Mon, 20 Mar 2023 07:35:17 -0700 (PDT)
Received: from localhost ([2a01:4b00:d307:1000:f1d3:eb5e:11f4:a7d9])
        by smtp.gmail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm9075318wrt.20.2023.03.20.07.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:35:16 -0700 (PDT)
Message-ID: <7b4f8261bd3cc76c123ee7fbd176ca6a82387dce.camel@debian.org>
Subject: Re: [PATCH net-next 0/3] Add SCM_PIDFD and SO_PEERPIDFD
From:   Luca Boccassi <bluca@debian.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>, smcv@collabora.com
Date:   Mon, 20 Mar 2023 14:35:15 +0000
In-Reply-To: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-g+4MrqyDATbFKaUjggeo"
User-Agent: Evolution 3.38.3-1+plugin 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-g+4MrqyDATbFKaUjggeo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-03-16 at 14:15 +0100, Alexander Mikhalitsyn wrote:
> 1. Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENT=
IALS,
> but it contains pidfd instead of plain pid, which allows programmers not
> to care about PID reuse problem.
>=20
> 2. Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd=
.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
>=20
> 3. Add SCM_PIDFD / SO_PEERPIDFD kselftest
>=20
> Idea comes from UAPI kernel group:
> https://uapi-group.org/kernel-features/
>=20
> Big thanks to Christian Brauner and Lennart Poettering for productive
> discussions about this.
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
>=20
> Alexander Mikhalitsyn (3):
> =C2=A0=C2=A0scm: add SO_PASSPIDFD and SCM_PIDFD
> =C2=A0=C2=A0net: core: add getsockopt SO_PEERPIDFD
> =C2=A0=C2=A0selftests: net: add SCM_PIDFD / SO_PEERPIDFD test

I've implemented support for this in dbus-daemon:

https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/398

It's working very well. I am also working on the dbus-broker and polkit
side of things, will share the links here once they are in a reviewable
state. But the dbus-daemon implementation is enough to meaningfully
test this.

For the series:

Tested-by: Luca Boccassi <bluca@debian.org>

--=20
Kind regards,
Luca Boccassi

--=-g+4MrqyDATbFKaUjggeo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCSqx93EIPGOymuRKGv37813JB4FAmQYbyMACgkQKGv37813
JB6t4Q/+LGVA6D+WY1fJtevPmTYQLD8EETU5dViUGoPPOwDMl2RbZAbvZV5syoh7
Qp27XNLX8m0kL4j7oUCZCEae1kydxmUg2IW+urUZBLKaYlf6lO8aiwdWMJzdwTLg
QnQnFd667ToGX57ZCMe00qWc/FeIqMXbhYdvpJARuPQPctD6+nQTCGcfstX0UV2V
e90FgATPEVIG/4jn2gpq7Pi7G/YzCCZenrfQokftx3j62XkA+vvW5KL85HfNUh7s
W/QztIr+RgYssEaO1jd3dKaWqcOPuQjRqIxL0aRpwGV83nQptL2wzkoXgH/lU905
WOjPF7CZPARnZi+sISOA+nRNI4I19X3LaibfIUUypvTEutx/ejH3vEBTgZKGTx1v
fcJOMZ9srZU5Ap+/tLgJnmQ/MsksxhY7ddlecXdg0gIp6Yhdavc0gflNycfknXj9
OanmPcKc05q93784bH2By4ZDaKmgUb0hoykKbq+4dYF24ap38yP2MXxnevevZzNK
SXlyXKu2qz6jRcleQSu/AaAMbyadaa6lt5antKKiMrmgB0LU3D25b0HfXkcNk9q1
vIsSqChvtqIRp3KAZXZdADVO0nDjZWqkfnrNo59sJ3TBl+BaIflR95gxpLu/c5A/
H6CmAE2WTYQdqzYUvbacyeLABURr/EhDzYIobGZqiKNOiovTPE0=
=Mns1
-----END PGP SIGNATURE-----

--=-g+4MrqyDATbFKaUjggeo--
