Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA4A6BA900
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjCOH0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCOH0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:26:41 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8FD5B5E2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=3Xdv1SPbFc/MN2Ud+h68Jqnms20u
        TaYbcPiPwRPC3OM=; b=YhPRDN7zgscr4r86aBuDgHCDy7jB6/NxmsCzY0ZXtGAq
        9ANttIHepX+qDY0HO9EJa8NXzN+ci/JEAYRGeHPXT2GHYBDLDk9hxt+srFoIv0Ch
        AeRjjNSiMYq7c908uOqERGiSflbY1y6QrVwsnqBfogUG3qkB73YzFNaezHlMgrg=
Received: (qmail 3356775 invoked from network); 15 Mar 2023 08:26:33 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 Mar 2023 08:26:33 +0100
X-UD-Smtp-Session: l3s3148p1@2Rx8Q+v2/K0ujnvb
Date:   Wed, 15 Mar 2023 08:26:33 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/4] net: set 'mac_managed_pm' at probe time
Message-ID: <ZBFzKatnFs7MraVn@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
 <ZBCjj6btYod38O7g@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0ST3wKXCq3p6447a"
Content-Disposition: inline
In-Reply-To: <ZBCjj6btYod38O7g@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0ST3wKXCq3p6447a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Simon!

> an initial comment is, and I know this is a bit of a pain,
> that 'net' and 'net-next' patches need to be split into separate serries.

Thanks for the heads up. I will refactor the series. First a part which
shall go into "net" and I will make the second part RFC with more
explanations how to reproduce the issue.

All the best,

   Wolfram


--0ST3wKXCq3p6447a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQRcyUACgkQFA3kzBSg
Kbb8MhAAoD66iQdGbZKz5RIMU4gpMkjw5rI7U0pE4DQJZncI/sPciVWOT495o20F
Z0+g9lrHUU93dyne3M3bvWMJ6eKZxh92L02qIaBvE0F+2+gSh50zgGiaGrxCa6mP
fq/n2g2+0uDk1b0PsaCN9F1ED+5EKpfvN5sNuHdK6Qn4qX7jPy/dVkj2CpyUCDRF
YCEBIp8w7My3xMxupdQvsEpf2JMEVOE2rFtZmQiaj1IMhNlS/de+vWLQVfhrCx5Y
886Zl0qEc3hwUR2rrp8tMsXD8TBvSpD9JfvHjQJivGhxlpWKyj/bYcgFo+4tVr/Y
uW6nzKT06bYcarHsPVHahXAzz+Pp4K2ec4w64fzn9nIl9tershKZTViuG0exNesL
Ct4TsLIHjDYen8PfdcVv+f0DErlT+1V2egaFa57Q3VhnJiZQmkFyf8skUp8G+RbM
/0qPYna9Leq4IjyAygBKZ/lRHuQ1hT1PkDLfqpSqD2CG3eoRuNGawetAEC0ZoBaX
2hYnrc7oCuVQo8PHAOGQmwLEEHxI5nQS8T81Izk0uyFBJgN9bn/eC7mHWYBKfMW5
lBRj+antcVgJvXC1t23GPeucPdreybqlNYTY6NPTp+qnk1ggR4t4qcAFV48RBMWa
MWSGy5sUbIw7vIPcObkcs1qy7iI4s5vKXh5gasUabiF6AYP/wLI=
=8+zk
-----END PGP SIGNATURE-----

--0ST3wKXCq3p6447a--
