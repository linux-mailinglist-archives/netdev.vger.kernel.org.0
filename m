Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39716A0419
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 09:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbjBWIon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 03:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbjBWIol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 03:44:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E33E0B9
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 00:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2820761607
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 08:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C881C4339B;
        Thu, 23 Feb 2023 08:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677141847;
        bh=k92dqcW0pOMN+6vOMm4IzA8jnIOOBqBNZEhTVeEy6Ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JKXi1br+41T8xEOdxJvZtwHn2OicqVtZlPy3jYC3DJSDSjyQqxbEEzEqlRB5XfcWI
         +dM5Y6V9dCH38PW21jTKdVP+xSRW+QgfzJG1yIQYHu1cyENRO9xIVa6PEEyqRbfmPT
         Jg0OwoQn6r9SBn5J42cke6F+SCufX7lS5tyYpyEB/oDQ+uAlATuHIFUkFu9LvYNggm
         wqENg4NTtrzjUEBVGcE1TAZ19ITV2PyZIkaygc5EcLXceDBFEypINUQSAODLZhF5It
         XB94+P3Oo1n66kCF9lbsKr+Me9xR1ruFOLPR5KGN/JEqoKQejBQnRKWx8nK5fgk7OR
         /m16jdbmLKWbg==
Date:   Thu, 23 Feb 2023 09:44:04 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net] netdev-genl: fix repeated typo oflloading ->
 offloading
Message-ID: <Y/cnVNRcnd130tDm@lore-desk>
References: <20230223072656.1525196-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="INRpe+1UZq0kURbA"
Content-Disposition: inline
In-Reply-To: <20230223072656.1525196-1-tariqt@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--INRpe+1UZq0kURbA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Fix a repeated copy/paste typo.
>=20
> Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuf=
f")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  Documentation/netlink/specs/netdev.yaml | 2 +-
>  include/uapi/linux/netdev.h             | 2 +-
>  tools/include/uapi/linux/netdev.h       | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netl=
ink/specs/netdev.yaml
> index b4dcdae54ffd..cffef09729f1 100644
> --- a/Documentation/netlink/specs/netdev.yaml
> +++ b/Documentation/netlink/specs/netdev.yaml
> @@ -28,7 +28,7 @@ definitions:
>        -
>          name: hw-offload
>          doc:
> -         This feature informs if netdev supports XDP hw oflloading.
> +         This feature informs if netdev supports XDP hw offloading.
>        -
>          name: rx-sg
>          doc:
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index 9ee459872600..588391447bfb 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -19,7 +19,7 @@
>   * @NETDEV_XDP_ACT_XSK_ZEROCOPY: This feature informs if netdev supports=
 AF_XDP
>   *   in zero copy mode.
>   * @NETDEV_XDP_ACT_HW_OFFLOAD: This feature informs if netdev supports X=
DP hw
> - *   oflloading.
> + *   offloading.
>   * @NETDEV_XDP_ACT_RX_SG: This feature informs if netdev implements non-=
linear
>   *   XDP buffer support in the driver napi callback.
>   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
> diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux=
/netdev.h
> index 9ee459872600..588391447bfb 100644
> --- a/tools/include/uapi/linux/netdev.h
> +++ b/tools/include/uapi/linux/netdev.h
> @@ -19,7 +19,7 @@
>   * @NETDEV_XDP_ACT_XSK_ZEROCOPY: This feature informs if netdev supports=
 AF_XDP
>   *   in zero copy mode.
>   * @NETDEV_XDP_ACT_HW_OFFLOAD: This feature informs if netdev supports X=
DP hw
> - *   oflloading.
> + *   offloading.
>   * @NETDEV_XDP_ACT_RX_SG: This feature informs if netdev implements non-=
linear
>   *   XDP buffer support in the driver napi callback.
>   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
> --=20
> 2.34.1
>=20

--INRpe+1UZq0kURbA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY/cnVAAKCRA6cBh0uS2t
rJUqAP4z9yhRrq3X9cCcuNl5rTWcntuF+nsayZaA4Ma71xgfLwEAuPO8MvvT7E6K
MP4ZlfIlEUG7+/oHElKcc4oZlLIu/Ao=
=7R9W
-----END PGP SIGNATURE-----

--INRpe+1UZq0kURbA--
