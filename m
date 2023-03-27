Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0976C9E15
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjC0Iih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbjC0IiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:38:19 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C157AAC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=aVuvyhKAC3iN4VeKP3wIsTfoGjND
        VWqpZy+lP5v9nwg=; b=LBAqKoHbd85YMHIc+gavwB2Zv/he9yP5vn2JxkwA76Tg
        +sZAVRMv2DX7xp120nCvawyFcskviiSPpyIF2HDt884shCM/koeTOsAjiFqJiozS
        V3PuR9kfonZb3uroczdskE869m4pFN00vJf6S4cCpqY0A2uz7R8vz0dVVUVPluQ=
Received: (qmail 3064472 invoked from network); 27 Mar 2023 10:32:22 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 27 Mar 2023 10:32:22 +0200
X-UD-Smtp-Session: l3s3148p1@iKzzlN33lrAujnv6
Date:   Mon, 27 Mar 2023 10:32:22 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "sh_eth: remove open coded netif_running()"
Message-ID: <ZCFUljNn2oclk3nK@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230327081933.5460-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8eJdQj0TMrNOHpom"
Content-Disposition: inline
In-Reply-To: <20230327081933.5460-1-wsa+renesas@sang-engineering.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8eJdQj0TMrNOHpom
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27, 2023 at 10:19:33AM +0200, Wolfram Sang wrote:
> This reverts commit ce1fdb065695f49ef6f126d35c1abbfe645d62d5. It turned
> out this actually introduces a race condition. netif_running() is not a
> suitable check for get_stats.
>=20
> Reported-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Geez, I forgot 'net-next' in $subject. I need to script that somehow...


--8eJdQj0TMrNOHpom
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQhVJYACgkQFA3kzBSg
KbZ9xg//cBklNc7gsUajNoqwrDg7VlssJEu1Ka/JqsPRnG2UZhIUABFVopXhb/R4
TbD0NheilEIt3AzPYTXqUuygAiMDfWCMKupHYbSXarHb0tJzk+FcO+MDNejFjyUC
Wt43BuyVJLEopf6C6XVwXmEBc7s+9WQ66yULyzAtJZQK0b3WfFESvT3HRyleNLzN
qn1G+vhw3r10EcsNzK7DyY2XJZCehrT0rNoWh5GDzNTodnOv0yIf+2M3mYnjupF+
lD9bgJDHnQvtu9clwa0lyoTavB9r6ck6GC0iu1CpzvJAp4YUgg6pZMu1pRSgxOx5
9do6k+kC0C3MpVi1LXJ0uBgWZ+ygZqL/Zkjc0Ji3hBQf6CXpHG8ofP6CVZI1UXES
NCLIEoP9MKAnMRcaSSxmbzNuFd3LICzL+49nj8jZynj/Q0JX2e9kfPviwlqmnJP3
QqCPf6NwWg+Y2F4iecThuVDuC/2gIS98Y2/GI0ACg0V81dDcIR8lriAHQ71V6TIw
r/fBgBR16N5CtibD/GNhtCOtGkqHgRbGHl1L6zn2abn/WlABQwERyvX/db1usn6o
QVqwbpkBB5k3fzYWxlFERmj6opbPhwKS0J+swR9e7UaYMNqbqpLApIElHGR4HwYJ
MomhZLZFF28w1W9TfSBaeYaDRL+2HJ4p3PEdtlD9YAlF5IyYvAQ=
=L1kA
-----END PGP SIGNATURE-----

--8eJdQj0TMrNOHpom--
