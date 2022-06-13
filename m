Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC4D54A2BC
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 01:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiFMXck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 19:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiFMXch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 19:32:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D427DBE7
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 16:32:35 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 86A7321ADC;
        Mon, 13 Jun 2022 23:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655163154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hBjFv4OgZIZtuMLLVTt1yyevhucfOp4K+fv724QM0J0=;
        b=0gR8vGMezqxfm913IaTAS1gzAQr6W14n18nlZRgb30e3gQ0bGqyLeJD3PjInRlOkIe1ODB
        FHQEmoeAYeHE1fJG9TYoLJu8fxrrzP5OaujkYIf0h5P87HRGRMj2LiTyCsewdJanMvlEnF
        O+ijgQC9gPQBTPzqg3DKAu8lIJgb6b4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655163154;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hBjFv4OgZIZtuMLLVTt1yyevhucfOp4K+fv724QM0J0=;
        b=OQFOgYfnkL9tYMQSBV7/azMT6cAV/QJaSLdI9n7s4EbUAwtD73MpD6WbkmM9QpW2ZlPGA1
        caDNyt7shmRc1iBw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6C89B2C141;
        Mon, 13 Jun 2022 23:32:34 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 047DA60901; Tue, 14 Jun 2022 01:32:34 +0200 (CEST)
Date:   Tue, 14 Jun 2022 01:32:34 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>
Subject: Re: [ethtool-next PATCH] rings: add support to set/get cqe size
Message-ID: <20220613233234.afupxxmcklr6lvbm@lion.mk-sys.cz>
References: <1653563925-21327-1-git-send-email-sbhatta@marvell.com>
 <CO1PR18MB4666A3447DA4C32A429D1C02A1A29@CO1PR18MB4666.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bykizq4xsh4vyepu"
Content-Disposition: inline
In-Reply-To: <CO1PR18MB4666A3447DA4C32A429D1C02A1A29@CO1PR18MB4666.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bykizq4xsh4vyepu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2022 at 10:24:58AM +0000, Subbaraya Sundeep Bhatta wrote:
> Hi Michal Kubecek,
>=20
> Any comments?

It's applied now, I just applied it to master before releasing 5.18
because the kernel counterpart is in v5.18.

Michal

>=20
> Thanks,
> Sundeep
>=20
> ________________________________________
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> Sent: Thursday, May 26, 2022 4:48 PM
> To: mkubecek@suse.cz; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; Sunil Kovvuri Goutham; Hariprasad Kelam; Geet=
hasowjanya Akula; Subbaraya Sundeep Bhatta
> Subject: [ethtool-next PATCH] rings: add support to set/get cqe size
>=20
> After a packet is sent or received by NIC then NIC posts
> a completion queue event which consists of transmission status
> (like send success or error) and received status(like
> pointers to packet fragments). These completion events may
> also use a ring similar to rx and tx rings. This patch
> introduces cqe-size ethtool parameter to modify the size
> of the completion queue event if NIC hardware has that capability.
> With this patch in place, cqe size can be set via
> "ethtool -G <dev> cqe-size xxx" and get via "ethtool -g <dev>".
>=20
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> ---
>  ethtool.8.in    | 4 ++++
>  ethtool.c       | 1 +
>  netlink/rings.c | 7 +++++++
>  3 files changed, 12 insertions(+)
>=20
> diff --git a/ethtool.8.in b/ethtool.8.in
> index cbfe9cf..92ba229 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -200,6 +200,7 @@ ethtool \- query or control network driver and hardwa=
re settings
>  .BN tx
>  .BN rx\-buf\-len
>  .BN tx\-push
> +.BN cqe\-size
>  .HP
>  .B ethtool \-i|\-\-driver
>  .I devname
> @@ -577,6 +578,9 @@ Changes the size of a buffer in the Rx ring.
>  .TP
>  .BI tx\-push \ on|off
>  Specifies whether TX push should be enabled.
> +.TP
> +.BI cqe\-size \ N
> +Changes the size of completion queue event.
>  .RE
>  .TP
>  .B \-i \-\-driver
> diff --git a/ethtool.c b/ethtool.c
> index c58c73b..ef4e4c6 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5734,6 +5734,7 @@ static const struct option args[] =3D {
>                           "             [ tx N ]\n"
>                           "             [ rx-buf-len N]\n"
>                           "             [ tx-push on|off]\n"
> +                         "             [ cqe-size N]\n"
>         },
>         {
>                 .opts   =3D "-k|--show-features|--show-offload",
> diff --git a/netlink/rings.c b/netlink/rings.c
> index 3718c10..5999247 100644
> --- a/netlink/rings.c
> +++ b/netlink/rings.c
> @@ -48,6 +48,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *=
data)
>         show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
>         show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");
>         show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH=
]);
> +       show_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE], "CQE Size:\t\t");
>=20
>         return MNL_CB_OK;
>  }
> @@ -112,6 +113,12 @@ static const struct param_parser sring_params[] =3D {
>                 .handler        =3D nl_parse_u8bool,
>                 .min_argc       =3D 1,
>         },
> +       {
> +               .arg            =3D "cqe-size",
> +               .type           =3D ETHTOOL_A_RINGS_CQE_SIZE,
> +               .handler        =3D nl_parse_direct_u32,
> +               .min_argc       =3D 1,
> +       },
>         {}
>  };
>=20
> --
> 2.7.4
>=20

--bykizq4xsh4vyepu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmKnyQkACgkQ538sG/LR
dpXbqwgAh2se7972y0rdrFUHzOatx/8JxOIrszTQCr5hZjn8NnKqAJGQOSt7bQMj
JxhxwLyqHosbjIQ4XUGyS1W9ANwJuZXgwhzvzZz/U5k3zmw3/ELAMf7WsxhvvKZk
ZGWFF0smc/ZIqcGX0eV/fGuW0Zz5sr5HoPgA33bDNnsniMVek6ah1ODqjw6AsqXS
X8fyBmuiH+by0VIt+ym5ec1u8mwTiQS5kxQVG3M22Z3MR3coBz+WzBaCEdzlQkbX
eWMddaqlmGih26fkkEirPScPbB0CSFRf5oxP0N/bFWIQvCETE5FrDXY213ULTELr
5UXlewzuCHWiYHwUVUhxWzxsdvd2Xw==
=kUhn
-----END PGP SIGNATURE-----

--bykizq4xsh4vyepu--
