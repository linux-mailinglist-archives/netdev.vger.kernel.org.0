Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D687D6470A9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 14:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiLHNST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 08:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiLHNSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 08:18:10 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C756934CC;
        Thu,  8 Dec 2022 05:18:09 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0174F218A8;
        Thu,  8 Dec 2022 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670505488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wse2LJJgdWjvOkMvyC2NWQsfPxc60hIu6ckyQbWIUi4=;
        b=E3AHLRZ0jRr5Hk/i+S8+raAEc7DYcRxFgLwL+YR1fHR7x9B64k05gvo45m9/hy53LVo4eZ
        hL5eRy4R4xabI2UCtINbJNB74rxgw3pYR2kHTCwtbq/lTfTEqn51D50AiTPUjDz/VKEBLF
        +eAw5eRfOsr1KZlH1a3RVMPfvkseb5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670505488;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wse2LJJgdWjvOkMvyC2NWQsfPxc60hIu6ckyQbWIUi4=;
        b=JfVozToRVZtE2zZSIm4PKS2X3vBiSCsAgX/D6GzPlfeLDjlOFnFS0hoDXs/iMKK2BXS5l7
        FvjnfV411pj/IhCw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D9BBE2C141;
        Thu,  8 Dec 2022 13:18:06 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6E7506045E; Thu,  8 Dec 2022 14:18:06 +0100 (CET)
Date:   Thu, 8 Dec 2022 14:18:06 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     yang.yang29@zte.com.cn
Cc:     salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, brianvv@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH linux-next] ethtool: use strscpy() to instead of strncpy()
Message-ID: <20221208131806.n6ahsirtkd2ivaru@lion.mk-sys.cz>
References: <202212081947418573438@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zjzpm4etpypm44o4"
Content-Disposition: inline
In-Reply-To: <202212081947418573438@zte.com.cn>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zjzpm4etpypm44o4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08, 2022 at 07:47:41PM +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
>=20
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL terminated strings.
>=20
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>

The patch looks good to me but the subject prefix should rather be
"hns:" to reflect its target code.

Michal

> ---
>  drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/n=
et/ethernet/hisilicon/hns/hns_ethtool.c
> index 54faf0f2d1d8..b54f3706fb97 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> @@ -644,18 +644,15 @@ static void hns_nic_get_drvinfo(struct net_device *=
net_dev,
>  {
>  	struct hns_nic_priv *priv =3D netdev_priv(net_dev);
>=20
> -	strncpy(drvinfo->version, HNAE_DRIVER_VERSION,
> +	strscpy(drvinfo->version, HNAE_DRIVER_VERSION,
>  		sizeof(drvinfo->version));
> -	drvinfo->version[sizeof(drvinfo->version) - 1] =3D '\0';
>=20
> -	strncpy(drvinfo->driver, HNAE_DRIVER_NAME, sizeof(drvinfo->driver));
> -	drvinfo->driver[sizeof(drvinfo->driver) - 1] =3D '\0';
> +	strscpy(drvinfo->driver, HNAE_DRIVER_NAME, sizeof(drvinfo->driver));
>=20
> -	strncpy(drvinfo->bus_info, priv->dev->bus->name,
> +	strscpy(drvinfo->bus_info, priv->dev->bus->name,
>  		sizeof(drvinfo->bus_info));
> -	drvinfo->bus_info[ETHTOOL_BUSINFO_LEN - 1] =3D '\0';
>=20
> -	strncpy(drvinfo->fw_version, "N/A", ETHTOOL_FWVERS_LEN);
> +	strscpy(drvinfo->fw_version, "N/A", ETHTOOL_FWVERS_LEN);
>  	drvinfo->eedump_len =3D 0;
>  }
>=20
> --=20
> 2.15.2

--zjzpm4etpypm44o4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmOR5AYACgkQ538sG/LR
dpWJLwgAk1ejDKpZghnAdrZdWOWzkF9cjpxPC0q1+Z1ZLpt0uUhrYxlDYeW2dy5n
S2O0Nfc80h3W3tqW5TcyIwxXWGmlB8Lz2PCi1tJCCo9rbft9eYuCQfh3WU08dZTE
4ODiYUhbiEM09JCVnaMvT7GIaJDdRHyi5T8ERvF4D+DgpjT7Uvm+qoSPAgkJKhg+
2vi2P5ic+UhFpQUYHgRJduIMBUjl+T7HpPnycurrr2sAM1xEaXx08o/DOJo6jm6k
tCRjmQQq1Pyb9+D7LP5YkIQFPahTe8H43llwoYXJDdAQhgp+dT08iKjHDvm9bFl6
KCSK9tuAIEu6VSsvSQNDDVO09Bu6Ow==
=TKfg
-----END PGP SIGNATURE-----

--zjzpm4etpypm44o4--
