Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB395B6215
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 22:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiILUTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 16:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiILUTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 16:19:44 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5712862C9;
        Mon, 12 Sep 2022 13:19:40 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220912201926euoutp01a7ae25eeed7ec9a0399676e56d3c560a~UNmQet_Ic0050800508euoutp01M;
        Mon, 12 Sep 2022 20:19:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220912201926euoutp01a7ae25eeed7ec9a0399676e56d3c560a~UNmQet_Ic0050800508euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663013966;
        bh=PAg2N7X8jaPGoKnLvD79GTUX1mP+7/MpAHQxRGtNnl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSBw6kQzj7xr6FSNv3NDQfoGbgaF69W+etYNf/EvzvV3Ewh1b6uaOwcTFt6uI8Yy2
         3XAhYzaoZcRxszJ2P/fUlxqzd6opFff58NRqYcbwRgy23+A042MQ09/NEXOgrCFZrS
         1+GSFM79tiVBSxtynx0V4iveKbp8DjH7Wl5sDfcM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220912201920eucas1p26e83101f51203158b27d99d48f2d4bfc~UNmLoLDmz0921709217eucas1p2K;
        Mon, 12 Sep 2022 20:19:20 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 7D.09.29727.8449F136; Mon, 12
        Sep 2022 21:19:20 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220912201920eucas1p1ff844ab7a87a01fdb0ae98295e103147~UNmLHTMa61846118461eucas1p1P;
        Mon, 12 Sep 2022 20:19:20 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220912201920eusmtrp2a9f8331adc07e70a5307a157c4d9a3b7~UNmLGiYGZ3256832568eusmtrp2Z;
        Mon, 12 Sep 2022 20:19:20 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-a1-631f9448459a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 4B.73.07473.8449F136; Mon, 12
        Sep 2022 21:19:20 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220912201919eusmtip257af44bf31986d3fa034a1b0b057c18a~UNmK1zLTA0560305603eusmtip28;
        Mon, 12 Sep 2022 20:19:19 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ax88796c: Fix return type of ax88796c_start_xmit
Date:   Mon, 12 Sep 2022 22:19:07 +0200
In-Reply-To: <20220912194031.808425-1-nhuck@google.com> (Nathan
        Huckleberry's message of "Mon, 12 Sep 2022 12:40:30 -0700")
Message-ID: <dleftjo7vkfiro.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djPc7oeU+STDR581rGYc76FxeLpsUfs
        Fo+W+Vlc2NbHanF51xw2iydT9rNZtK98ymbxYcJ/JotjC8QsNh/+xGLx7fQbRotrX06zOPB4
        bFl5k8lj56y77B4LNpV6bFrVyebxYvNMRo/3+66yeXzeJBfAHsVlk5Kak1mWWqRvl8CV8Xnm
        F+aCjQIVWybvZWlgXMTXxcjJISFgInHl9FaWLkYuDiGBFYwSs77MZYRwvjBKrF/5hxnC+cwo
        cXTJYbYuRg6wlhPTgiDiyxklZu5ayw7hPGeUuHV/CwtIEZuAnsTatREgK0QENCW+n3rJClLD
        LNDILLH4/2FmkISwgJfEm3nPWUFsFgFViWdrtoDZnAK1Ei9OrwCbwytgLvH2Tj1IWFTAUuLP
        s4/sIDavgKDEyZlPWEBsZoFciZnn34BdLSGwmlNizYWD7BC/uUjseHaSDcIWlnh1fAtUXEbi
        /875TBAN7YwSTVcWskI4ExglPnc0MUFUWUvcOfcLqttRYuumh+wQ7/NJ3HgrCLGZT2LStunM
        EGFeiY42IYhqFYl1/XtYIGwpid5XKxghbA+JRav2QgOri1Fi3faPrBMYFWYheWgWkodmAY1l
        Bgbe+l36EGFtiWULXzND2LYS69a9Z1nAyLqKUTy1tDg3PbXYMC+1XK84Mbe4NC9dLzk/dxMj
        ML2d/nf80w7Gua8+6h1iZOJgPMSoAtT8aMPqC4xSLHn5ealKIrzbVeWThXhTEiurUovy44tK
        c1KLDzFKc7AoifMmZ25IFBJITyxJzU5NLUgtgskycXBKNTBZWhyasXvvX6OvCeu5TdkYFnx8
        1pB6XbhhWd0Eictb9gdtzolr7VpkO13Rd7q6HNvu5KN35zAfZHree97Zt7vnjj03k+nEqXH7
        axt2HJvZeLNqV1zuy+6josETX2qIHdm2+NR0v+X/+Qwt7sb8Zckv/ZFvfFe5Ylmo4d+N3/2Z
        Vz/M+ezEYiZeGsZ1aeLXSSfEa5ov+Kaq8VzJEoyz+boqyPTgIg6/J0rPmHYlG3x7uH6OqZzz
        E0XXa7N9t5+/fE0p8uz59MyWi0ZfZZV5E2eofTkck7HCb+aUlwkv2MsmfD949XBr72FLsw5H
        nwfO21evCRGJYnzuHdPCbjEt8/8+k9g0k8Rlf35lu11Y+/i2EktxRqKhFnNRcSIAJyv3OuoD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xe7oeU+STDdq2sFvMOd/CYvH02CN2
        i0fL/CwubOtjtbi8aw6bxZMp+9ks2lc+ZbP4MOE/k8WxBWIWmw9/YrH4dvoNo8W1L6dZHHg8
        tqy8yeSxc9Zddo8Fm0o9Nq3qZPN4sXkmo8f7fVfZPD5vkgtgj9KzKcovLUlVyMgvLrFVija0
        MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DL+DzzC3PBRoGKLZP3sjQwLuLrYuTg
        kBAwkTgxLaiLkYtDSGApo8SB/ouMEHEpiZVz07sYOYFMYYk/17rYIGqeMkq8mvqVFaSGTUBP
        Yu3aCJAaEQFNie+nXrKC1DALtDBL7Dh4mB0kISzgJfFm3nNWEFtIwEziwelmJhCbRUBV4tma
        LWBxToFaieeH37GBzOQVMJd4e6ceJCwqYCnx59lHsDG8AoISJ2c+YQGxmQWyJb6ufs48gVFg
        FpLULCSpWUCTmIFOWr9LHyKsLbFs4WtmCNtWYt269ywLGFlXMYqklhbnpucWG+oVJ+YWl+al
        6yXn525iBEbltmM/N+9gnPfqo94hRiYOxkOMKkCdjzasvsAoxZKXn5eqJMK7XVU+WYg3JbGy
        KrUoP76oNCe1+BCjKdBnE5mlRJPzgekiryTe0MzA1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7
        NbUgtQimj4mDU6qBaWO485MHHSn36zmzODZv7w0yEuX/fT9Lwenn4tMir1Oj2uanBNxJTMjI
        WPFg/+2MVdmGm988/Zbu9o1j8oqSLdX3r8y+90j829/0j8r8AbPTHDfVeu0S2PKTnZMtjWHS
        Yum82j9bxeO/n6r/9Wh/WuHyyaopSvPZmI2fu6hON7v04fSjd8duvBNWmLj9Ze/upLQco2Oq
        VvfePTg1p2XyxyvL/NJTwjxqloSondYJXTPnW+FZVfds5TyfhPrbWjk1y3hXzRS41jXhzA9n
        jUvzZtn/D6wLeV79qo37pOBTgdILQcdWd9Ve604MMv7YfqLxT+bWs3zFmqJiL9RuzJyS8XyO
        q49NquTxrj9eFxZs8VFiKc5INNRiLipOBABw2qlpXwMAAA==
X-CMS-MailID: 20220912201920eucas1p1ff844ab7a87a01fdb0ae98295e103147
X-Msg-Generator: CA
X-RootMTR: 20220912201920eucas1p1ff844ab7a87a01fdb0ae98295e103147
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912201920eucas1p1ff844ab7a87a01fdb0ae98295e103147
References: <20220912194031.808425-1-nhuck@google.com>
        <CGME20220912201920eucas1p1ff844ab7a87a01fdb0ae98295e103147@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2022-09-12 pon 12:40>, when Nathan Huckleberry wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev=
).
>
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>
> The return type of ax88796c_start_xmit should be changed from int to
> netdev_tx_t.
>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: [...]
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  drivers/net/ethernet/asix/ax88796c_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Lukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethe=
rnet/asix/ax88796c_main.c
> index 6ba5b024a7be..f1d610efd69e 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -381,7 +381,7 @@ static int ax88796c_hard_xmit(struct ax88796c_device =
*ax_local)
>  	return 1;
>  }
>=20=20
> -static int
> +static netdev_tx_t
>  ax88796c_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  {
>  	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmMflDwACgkQsK4enJil
gBCQAgf+JuMtztJB1UODPRAMGslnlVGtuSPkAD34lYD2XiYUtEqSTnE2AvS7zRl6
ciMUiYzMP3s00YwkM7wEwuGtIf93o/MmwlbkVV2fTQYAgh4hs74SVlgE7KR44FiT
B+NCDuBWB1qnkR22d+xkmZShAFqhpHUPFoBY/hSqmz8/t2LIi7MCBh6/EAJOoqXi
BQ4W8KlBpLqRwltkph2xvQxMTCc59l59IzXEIL5RE/fRaXfS+4SRxvTnhGHGaEKI
IsBcjQ0OpfEw74CY/ysO7LFhF6rkSLp+7BeJYVwXks2jaondpKUg8fvfIwMKUYpM
ODv8Xl5+ycmFhqzYZh901v5xPpvSEw==
=8cv3
-----END PGP SIGNATURE-----
--=-=-=--
