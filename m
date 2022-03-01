Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF54C8779
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiCAJOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiCAJOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:14:23 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E22532C9;
        Tue,  1 Mar 2022 01:13:40 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K7BPW0qVKz4xvG;
        Tue,  1 Mar 2022 20:13:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646126015;
        bh=kH5Az8nLG1r0nm1SJtuCqNeFma4huv13M9kq5mtEtQ4=;
        h=Date:From:To:Cc:Subject:From;
        b=ZdSJAtzipY9ys6I+e5lQEL+ebInyVtUq3upC83kxZJ4ehml4FKchrbg1u7ewugj6G
         Y0n/dKE8JE3GHGMpmLEvxy6JULlMtmxWd9zcYzO/oHKaxOhl84xUJAEM2bAlZU7V1s
         ExTWguMD+8BzdXX3C3/d/9UvNsXzKDnJWeVRUpQkkPjHtyI3YOftUkoSNtf/F90cml
         2xKprpkl8r0o+93G6Qgj+GJugUClwQgKNr+mVnKVjsG56+dMditmWpct6Ih+kekf5k
         Rs+w60X3APe4FTlGhMsyenYiM6DzTkdEhX4+BiguZTA5lwFo1ZUq4+CAUA93i+Il7S
         hw+dB0rWfUyow==
Date:   Tue, 1 Mar 2022 20:13:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20220301201321.3548a6dc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dsO6V2.3UXMYxicgNU9AJ6b";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/dsO6V2.3UXMYxicgNU9AJ6b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

include/linux/netdevice.h:2290: warning: Function parameter or member 'dm_p=
rivate' not described in 'net_device'

Introduced by commit

  b26ef81c46ed ("drop_monitor: remove quadratic behavior")

--=20
Cheers,
Stephen Rothwell

--Sig_/dsO6V2.3UXMYxicgNU9AJ6b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmId47EACgkQAVBC80lX
0GzdtQf/ZgdDG/hURZgXZWq/q2hZEYpxtykXExVEkRN8fd3g++l2GvXXk9jGRGTn
CLrCgY/NcebbrrBRl22FrBskjW3rVB6k/aWr69+EBTZN3rIqW6i53w87rxuDNJcb
kB0vU0SelXMEsYIlLwLv6gNIHnHJe+IFHB1eNJ7DM4kCnTrCDmrB0NldCcYRL62S
t5xfQcSKsE5Q27gfxEm96berkzu8fNv2OZL4uHq1CVxUS3oAy0TlP2N4iqyD0FMg
hOlhYbe9tLk3wjSQO2yKN8rJshkda17MUbAVJ2H5WPz+vrtAiEkaHv+0sK2Amemz
Djn5bey/dJFZCd+nNF7DLCF4XdJ/vg==
=qBVe
-----END PGP SIGNATURE-----

--Sig_/dsO6V2.3UXMYxicgNU9AJ6b--
